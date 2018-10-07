/**
 * VERSION: 12.1.1
 * DATE: 2013-07-02
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
/**
 * [AS3/AS2 only] Normally, all transformations (scale, rotation, and position) are based on the DisplayObject's registration
 * point (most often its upper left corner), but TransformAroundPoint allows you to define ANY point around which
 * 2D transformations will occur during the tween. For example, you may have a dynamically-loaded image that you 
 * want to scale from its center or rotate around a particular point on the stage. <br /><br />
 * 
 * <p>If you define an x or y value in the transformAroundPoint object, it will correspond to the custom registration
 * point which makes it easy to position (as opposed to having to figure out where the original registration point 
 * should tween to). If you prefer to define the x/y in relation to the original registration point, do so outside 
 * the transformAroundPoint object, like: </p><p><code>
 * 
 * TweenLite.to(mc, 3, {x:50, y:40, transformAroundPoint:{point:new Point(200, 300), scale:0.5, rotation:30}});</code></p>
 * 
 * <p>To define the <code>point</code> according to the target's local coordinates (as though it is inside the target),
 * simply pass <code>pointIsLocal:true</code> in the transformAroundPoint object, like:</p><p><code>
 * 
 * TweenLite.to(mc, 3, {transformAroundPoint:{point:new Point(200, 300), pointIsLocal:true, scale:0.5, rotation:30}});</code></p>
 * 
 * <p>TransformAroundPointPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get more details. </p>
 * 
 * <p><b>USAGE:</b></p>
 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.plugins.TweenPlugin; 
import com.greensock.plugins.TransformAroundPointPlugin; 
TweenPlugin.activate([TransformAroundPointPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, {transformAroundPoint:{point:new Point(100, 300), scaleX:2, scaleY:1.5, rotation:150}}); 
</listing>
 * 
 * <p><b>Copyright 2008-2013, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class TransformAroundPointPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		private static var _classInitted:Boolean;
		/** @private **/
		private static var _isFlex:Boolean;
		
		/** @private **/
		protected var _target:DisplayObject;
		/** @private **/
		protected var _local:Point;
		/** @private **/
		protected var _point:Point;
		/** @private **/
		protected var _shortRotation:ShortRotationPlugin;
		/** @private **/
		protected var _pointIsLocal:Boolean;
		
		/** @private **/
		protected var _proxy:DisplayObject;
		/** @private **/
		protected var _proxySizeData:Object;
		/** @private **/
		protected var _useAddElement:Boolean;
		/** @private **/
		protected var _xRound:Boolean;
		/** @private **/
		protected var _yRound:Boolean;
		
		/** @private **/
		public function TransformAroundPointPlugin() {
			super("transformAroundPoint,transformAroundCenter,x,y", -1); // lower priority so that the x/y tweens occur BEFORE the transformAroundPoint is applied
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!(value.point is Point)) {
				return false;
			}
			_target = target as DisplayObject;
			if (value.pointIsLocal == true) {
				_pointIsLocal = true;
				_local = value.point.clone();
				_point = _target.parent.globalToLocal(_target.localToGlobal(_local));
			} else {
				_point = value.point.clone();
				_local = _target.globalToLocal(_target.parent.localToGlobal(_point));
			}
			
			if (!_classInitted) {
				try {
					_isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager")); // SystemManager is the first display class created within a Flex application
				} catch (e:Error) {
					_isFlex = false;
				}
				_classInitted = true;
			}
			
			if ((!isNaN(value.width) || !isNaN(value.height)) && _target.parent != null) {
				var m:Matrix = _target.transform.matrix;
				var point:Point = _target.parent.globalToLocal(_target.localToGlobal(new Point(100, 100)));
				_target.width *= 2;
				if (point.x == _target.parent.globalToLocal(_target.localToGlobal(new Point(100, 100))).x) { //checks to see if the width change also alters where the 100,100 point is in the parent, essentially telling us whether or not the width change also effectively changed the scale, but we can't just check the scaleX because rotation would affect it and there are some inconsistencies in the way Adobe's classes/components work.
					_proxy = _target;
					_target.rotation = 0;
					_proxySizeData = {};
					if (!isNaN(value.width)) {
						_addTween(_proxySizeData, "width", _target.width / 2, value.width, "width"); //Components that alter their width without scaling will treat their width/height setters as though they were applied without any rotation, so we must handle these separately. If we just allow the width/height tweens to affect the Sprite and copy those values over to the _proxy, it won't behave properly.
					}
					if (!isNaN(value.height)) {
						_addTween(_proxySizeData, "height", _target.height, value.height, "height");
					}
					var b:Rectangle = _target.getBounds(_target);
					var s:Sprite = new Sprite();
					var container:Sprite = _isFlex ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite(); //in Flex, any thing we addChild() must be a UIComponent so we wrap our Sprite in one.
					container.addChild(s);
					container.visible = false;
					_useAddElement = Boolean(_isFlex && _proxy.parent.hasOwnProperty("addElement"));
					if (_useAddElement) {
						Object(_proxy.parent).addElement(container);
					} else {
						_proxy.parent.addChild(container);
					}
					_target = s;
					s.graphics.beginFill(0x0000FF, 0.4);
					s.graphics.drawRect(b.x, b.y, b.width, b.height);
					s.graphics.endFill();
					_proxy.width /= 2; //we must reset the width even though we're applying the transform.matrix after this because some components don't flow the transform.matrix values through to the width value (bug/inconsistency in Adobe's stuff)
					s.transform.matrix = _target.transform.matrix = m;
				} else {
					_target.width /= 2; //we must reset the width even though we're applying the transform.matrix after this because some components don't flow the transform.matrix values through to the width value (bug/inconsistency in Adobe's stuff)
					_target.transform.matrix = m;
				}
			}
			
			var p:String, short:ShortRotationPlugin, sp:String;
			for (p in value) {
				if (p == "point" || p == "pointIsLocal") {
					//ignore - we already set it above
				} else if (p == "shortRotation") {
					_shortRotation = new ShortRotationPlugin();
					_shortRotation._onInitTween(_target, value[p], tween);
					_addTween(_shortRotation, "setRatio", 0, 1, "shortRotation");
					for (sp in value[p]) {
						_overwriteProps[_overwriteProps.length] = sp;
					}
				} else if (p == "x" || p == "y") {
					_addTween(_point, p, _point[p], value[p], p);
				} else if (p == "scale") {
					_addTween(_target, "scaleX", _target.scaleX, value.scale, "scaleX");
					_addTween(_target, "scaleY", _target.scaleY, value.scale, "scaleY");
					_overwriteProps[_overwriteProps.length] = "scaleX";
					_overwriteProps[_overwriteProps.length] = "scaleY";
				} else if ((p == "width" || p == "height") && _proxy != null) {
					//let the proxy handle width/height
				} else {
					_addTween(_target, p, _target[p], value[p], p);
					_overwriteProps[_overwriteProps.length] = p;
				}
			}
			
			if (tween != null) {
				var enumerables:Object = tween.vars; 
				if ("x" in enumerables || "y" in enumerables) { //if the tween is supposed to affect x and y based on the original registration point, we need to make special adjustments here...
					var endX:Number, endY:Number;
					if ("x" in enumerables) {
						endX = (typeof(enumerables.x) == "number") ? enumerables.x : _target.x + Number(enumerables.x.split("=").join(""));
					}
					if ("y" in enumerables) {
						endY = (typeof(enumerables.y) == "number") ? enumerables.y : _target.y + Number(enumerables.y.split("=").join(""));
					}
					tween._kill({x:true, y:true, _tempKill:true}, _target); //we're taking over.
					this.setRatio(1);
					if (!isNaN(endX)) {
						_addTween(_point, "x", _point.x, _point.x + (endX - _target.x), "x");
					}
					if (!isNaN(endY)) {
						_addTween(_point, "y", _point.y, _point.y + (endY - _target.y), "y");
					}
					this.setRatio(0);
				}
			}
			
			return true;
		}
		
		/** @private **/
		override public function _kill(lookup:Object):Boolean {
			if (_shortRotation != null) {
				_shortRotation._kill(lookup);
				if (_shortRotation._overwriteProps.length == 0) {
					lookup.shortRotation = true;
				}
			}
			return super._kill(lookup);
		}
		
		/** @private **/
		override public function _roundProps(lookup:Object, value:Boolean=true):void {
			if ("transformAroundPoint" in lookup) {
				_xRound = _yRound = value;
			} else if ("x" in lookup) {
				_xRound = value;
			} else if ("y" in lookup) {
				_yRound = value;
			}
		}
		
		/** @private **/
		override public function setRatio(v:Number):void {
			var p:Point, val:Number;
			if (_proxy != null && _proxy.parent != null) {
				if (_useAddElement) {
					Object(_proxy.parent).addElement(_target.parent);
				} else {
					_proxy.parent.addChild(_target.parent);
				}
			}
			if (_pointIsLocal && _target.parent) {
				p = _target.parent.globalToLocal(_target.localToGlobal(_local));
				if (Math.abs(p.x - _point.x) > 0.5 || Math.abs(p.y - _point.y) > 0.5) {  //works around some rounding errors in Flash
					_point = p;
				}
			}
			super.setRatio(v);
			if (_target.parent) {
				p = _target.parent.globalToLocal(_target.localToGlobal(_local));
				_target.x = (!_xRound) ? _target.x + _point.x - p.x : ((val = _target.x + _point.x - p.x) > 0) ? (val + 0.5) >> 0 : (val - 0.5) >> 0;
				_target.y = (!_yRound) ? _target.y + _point.y - p.y : ((val = _target.y + _point.y - p.y) > 0) ? (val + 0.5) >> 0 : (val - 0.5) >> 0;
			}
			
			if (_proxy != null && _proxy.parent != null) {
				var r:Number = _target.rotation;
				_proxy.rotation = _target.rotation = 0;
				if (_proxySizeData.width != null) {
					_proxy.width = _target.width = _proxySizeData.width;
				}
				if (_proxySizeData.height != null) {
					_proxy.height = _target.height = _proxySizeData.height;
				}
				_proxy.rotation = _target.rotation = r;
				
				p = _target.parent.globalToLocal(_target.localToGlobal(_local));
				_proxy.x = (!_xRound) ? _target.x + _point.x - p.x : ((val = _target.x + _point.x - p.x) > 0) ? (val + 0.5) >> 0 : (val - 0.5) >> 0;
				_proxy.y = (!_yRound) ? _target.y + _point.y - p.y : ((val = _target.y + _point.y - p.y) > 0) ? (val + 0.5) >> 0 : (val - 0.5) >> 0;
				
				if (_useAddElement) {
					Object(_proxy.parent).removeElement(_target.parent);
				} else {
					_proxy.parent.removeChild(_target.parent);
				}
			}
		}

	}
}