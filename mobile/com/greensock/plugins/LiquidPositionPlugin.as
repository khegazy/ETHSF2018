/**
 * VERSION: 12.0
 * DATE: 2012-01-14
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.TweenLite;
	import com.greensock.layout.LiquidStage;
	import com.greensock.layout.PinPoint;
	import com.greensock.layout.core.LiquidData;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
/**
 * [AS3 only] If you're using <a href="http://www.greensock.com/liquidstage/">LiquidStage</a> and you'd like to tween 
 * a DisplayObject to coordinates that are relative to a particular <code>PinPoint</code> (like the <code>CENTER</code>)
 * whose position may change at any time, <code>LiquidPositionPlugin</code> makes it easy by dynamically updating the 
 * destination values accordingly. For example, let's say you have an "mc" Sprite that should tween to the center of
 * the screen, you could do:
 * 
 * <listing version="3.0">
import com.greensock.TweenLite;
import com.greensock.layout.~~; 
import com.greensock.plugins.~~; 
TweenPlugin.activate([LiquidPositionPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

var ls:LiquidStage = new LiquidStage(this.stage, 550, 400, 550, 400);

TweenLite.to(mc, 2, {liquidPosition:{pin:ls.CENTER}});
</listing>
 * 
 * <p>Or to tween to exactly x:100, y:200 but have that position move with the <code>TOP_RIGHT</code> PinPoint 
 * whenever it repositions (so they retain their relative distance from each other), the tween would look like this:</p>
 * 
 * <listing version="3.0">
TweenLite.to(mc, 2, {liquidPosition:{x:100, y:200, pin:ls.TOP_RIGHT}});
</listing>
 * 
 * <p>To prevent the <code>LiquidPositionPlugin</code> from controlling the object's y property, 
 * simply pass <code>ignoreY:true</code> in the vars object. The same goes for the x position: 
 * <code>ignoreX:true</code>.</p>
 * 
 * <p>By default, <code>LiquidPositionPlugin</code> will reconcile the position which means it will 
 * act as though the coordinates were defined before the stage was resized (so they'd be according 
 * to the original size at which the swf was built in the IDE). If you don't want it to reconcile,
 * simply pass <code>reconcile:false</code> through the vars object. </p>
 * 
 * <p>LiquidPositionPlugin is a Club GreenSock membership benefit and requires <a href="http://www.greensock.com/liquidstage/">LiquidStage</a>. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> 
 * to sign up or get more details.</p>
 * 
 * <p><strong>Copyright 2008-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class LiquidPositionPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _tween:TweenLite;
		/** @private **/
		protected var _target:DisplayObject;
		/** @private **/
		protected var _prevFactor:Number;
		/** @private **/
		protected var _prevTime:Number;
		/** @private **/
		protected var _xStart:Number;
		/** @private **/
		protected var _yStart:Number;
		/** @private **/
		protected var _xOffset:Number;
		/** @private **/
		protected var _yOffset:Number;
		/** @private **/
		protected var _data:LiquidData;
		/** @private **/
		protected var _ignoreX:Boolean;
		/** @private **/
		protected var _ignoreY:Boolean;
		
		
		/** Constructor **/
		public function LiquidPositionPlugin() {
			super("liquidPosition");
			_overwriteProps = [];
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!(target is DisplayObject)) {
				throw Error("Tween Error: liquidPosition requires that the target be a DisplayObject.");
				return false;
			} else if (!("pin" in value) || !(value.pin is PinPoint)) {
				throw Error("Tween Error: liquidPosition requires a valid 'pin' property which must be a PinPoint.");
				return false;
			}
			_target = DisplayObject(target);
			_tween = tween;
			_prevFactor = _tween.ratio;
			_prevTime = _tween._time;
			_ignoreX = Boolean(value.ignoreX == true);
			_ignoreY = Boolean(value.ignoreY == true);
			_data = PinPoint(value.pin).data;
			_xStart = _target.x;
			_yStart = _target.y;
			
			var ls:LiquidStage = _data.liquidStage;
			var reconcile:Boolean = Boolean(value.reconcile != false);
			if (reconcile) {
				ls.retroMode = true;
			}
			var local:Point = _target.parent.globalToLocal(_data.global);
			
			_xOffset = ("x" in value) ? value.x - local.x : 0;
			if (!_ignoreX) {
				_overwriteProps[_overwriteProps.length] = "x";
			} 
			_yOffset = ("y" in value) ? value.y - local.y : 0;
			if (!_ignoreY) {
				_overwriteProps[_overwriteProps.length] = "y";
			}
			
			if (reconcile) {
				ls.retroMode = false;
			}
			return true;
		}
		
		/** @private **/
		override public function _kill(lookup:Object):Boolean {
			if ("x" in lookup) {
				_ignoreX = true;
			}
			if ("y" in lookup) {
				_ignoreY = true;
			}
			return super._kill(lookup);
		}
		
		/** @private **/
		override public function setRatio(v:Number):void {
			if (v != _prevFactor) {
				var local:Point = _target.parent.globalToLocal(_data.global),ratio:Number;
				local.x += _xOffset;
				local.y += _yOffset;
				
				//going forwards towards the end
				if (_tween._time > _prevTime) {
					ratio = (v == 1 || _prevFactor == 1) ? 0 : 1 - ((v - _prevFactor) / (1 - _prevFactor));
					
					if (!_ignoreX) {
						_target.x = local.x - ((local.x - _target.x) * ratio);
					}
					if (!_ignoreY) {
						_target.y = local.y - ((local.y - _target.y) * ratio);
					}
					
				//going backwards towards the start
				} else {
					ratio = (v == 0 || _prevFactor == 0) ? 0 : 1 - ((v - _prevFactor) / -_prevFactor);
					
					if (!_ignoreX) {
						_target.x = _xStart + ((_target.x - _xStart) * ratio);
					}
					if (!_ignoreY) {
						_target.y = _yStart + ((_target.y - _yStart) * ratio);
					}
				}
				
				_prevFactor = v;
			}
			_prevTime = _tween._time;
		}
		
	}
}