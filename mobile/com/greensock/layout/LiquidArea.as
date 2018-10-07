/**
 * VERSION: 2.53
 * DATE: 2011-02-21
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com/liquidstage/
 **/
package com.greensock.layout {
	import com.greensock.TweenLite;
	import com.greensock.layout.core.LiquidData;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
/**
 * <code>LiquidArea</code> is an <code>AutoFitArea</code> that integrates with <code>LiquidStage</code>,
 * automatically adjusting its size whenever the stage is resized. Like AutoFitArea, it allows you to define a 
 * rectangular area and then <code>attach()</code> DisplayObjects so that they automatically fill 
 * the area, scaling/stretching in any of the following modes: <code>STRETCH, PROPORTIONAL_INSIDE, 
 * PROPORTIONAL_OUTSIDE, NONE, WIDTH_ONLY,</code> or <code>HEIGHT_ONLY</code>. Horizontally align
 * the attached DisplayObjects left, center, or right. Vertically align them top, center, or bottom.
 * Since LiquidArea inherits from the <code>Shape</code> class, so you can alter its <code>width, 
 * height, scaleX, scaleY, x,</code>, or <code>y</code> properties and then all of the attached 
 * objects will automatically be adjusted accordingly. Attach as many DisplayObjects as you want. 
 * To make visualization easy, you can choose a <code>previewColor</code>
 * and set the <code>preview</code> property to <code>true</code> in order to see the area on the stage
 * (or simply use it like a regular Shape by adding it to the display list with <code>addChild()</code>, but the 
 * <code>preview</code> property makes it simpler because it automatically ensures that it is behind 
 * all of its attached DisplayObjects in the stacking order).
 * 
 * <p>You can set minimum and maximum width/height constraints on a LiquidArea so that stage
 * resizes don't expand or contract it beyond certain values.</p>
 * 
 * <p>With LiquidArea, it's simple to create things like a background that proportionally 
 * fills the stage or a bar that always stretches horizontally to fill the stage but stays stuck 
 * to the bottom, etc.</p>
 * 
 * <listing version="3.0">
import com.greensock.layout.~~;

//create a LiquidStage instance for the current stage which was built at an original size of 550x400
//don't allow the stage to collapse smaller than 550x400 either.
var ls:LiquidStage = new LiquidStage(this.stage, 550, 400, 550, 400);

//create a 300x100 rectangular area at x:50, y:70 that stretches when the stage resizes (as though its top left and bottom right corners are pinned to their corresponding PinPoints on the stage)
var area:LiquidArea = new LiquidArea(this, 50, 70, 300, 100);

//attach a "myImage" Sprite to the area and set its ScaleMode to PROPORTIONAL_OUTSIDE and crops the extra content that spills over the edges
area.attach(myImage, {scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, crop:true});

//if you'd like to preview the area visually (by default previewColor is red), set preview to true
area.preview = true;
 
//attach a CHANGE event listener to the LiquidArea instance
ls.addEventListener(Event.CHANGE, onAreaUpdate);
function onAreaUpdate(event:Event):void {
	trace("updated LiquidArea");
}
</listing>
 * 
 * <p>LiquidArea is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get more details.</p>
 * 
 * <p><strong>Copyright 2010-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class LiquidArea extends AutoFitArea {
		/** @private **/
		public static const version:Number = 2.53;
		
		/** @private **/
		protected var _liquidStage:LiquidStage;
		/** @private **/
		protected var _topLeftPin:PinPoint;
		/** @private **/
		protected var _bottomRightPin:PinPoint;
		/** @private **/
		protected var _tlData:LiquidData;
		/** @private **/
		protected var _brData:LiquidData;
		/** @private **/
		protected var _tlPrev:Point;
		/** @private **/
		protected var _brPrev:Point;
		/** @private **/
		protected var _tween:TweenLite;
		/** @private we allow this to be temporarily swapped out using dynamicTween() **/
		protected var _originalTween:TweenLite; 
		/** @private used to enforce min/max width/height in a way that allows the window to be dragged bigger and then smaller again without it making the LiquidArea smaller until the window size gets back to the point where it exceeded the max width/height.  **/
		protected var _wOffset:Number;
		/** @private **/
		protected var _hOffset:Number;
		/** @private **/
		protected var _data:LiquidData;
		/** @private **/
		protected var _strictMode:Boolean;
		/** @private **/
		protected var _strictDifTL:Point;
		/** @private **/
		protected var _strictDifBR:Point;
		
		/** Minimum width that a LiquidStage resize is allowed to make the LiquidArea (only affects stage resizes, not when you manually set the width property) **/
		public var minWidth:Number;
		/** Minimum height that a LiquidStage resize is allowed to make the LiquidArea (only affects stage resizes, not when you manually set the height property) **/
		public var minHeight:Number;
		/** Maximum width that a LiquidStage resize is allowed to make the LiquidArea (only affects stage resizes, not when you manually set the width property) **/
		public var maxWidth:Number;
		/** Maximum height that a LiquidStage resize is allowed to make the LiquidArea (only affects stage resizes, not when you manually set the height property) **/
		public var maxHeight:Number;
		
		/**
		 * Constructor
		 * 
		 * @param parent The parent DisplayObjectContainer in which the LiquidArea should be created. All objects that get attached must share the same parent.
		 * @param x x coordinate of the LiquidArea's upper left corner
		 * @param y y coordinate of the LiquidArea's upper left corner
		 * @param width width of the LiquidArea
		 * @param height height of the LiquidArea
		 * @param previewColor color of the LiquidArea (which won't be seen unless you set preview to true or manually add it to the display list with addChild())
		 * @param minWidth Minimum width that a LiquidStage resize is allowed to make the LiquidArea (only affects stage resizes, not when you manually set the width property)
		 * @param minHeight Minimum height that a LiquidStage resize is allowed to make the LiquidArea (only affects stage resizes, not when you manually set the height property)
		 * @param maxWidth Maximum width that a LiquidStage resize is allowed to make the LiquidArea (only affects stage resizes, not when you manually set the width property)
		 * @param maxHeight Maximum height that a LiquidStage resize is allowed to make the LiquidArea (only affects stage resizes, not when you manually set the height property)
		 * @param autoPinCorners By default, the LiquidArea's upper left corner is pinned to the LiquidStage's <code>TOP_LEFT</code> PinPoint, and its lower right corner is pinned to the LiquidStage's <code>BOTTOM_RIGHT</code> PinPoint, but to skip the pinning, set autoPinCorners to false.
		 * @param liquidStage Optionally declare the LiquidStage instance to which this LiquidArea should be associated. If none is defined, the class will try to determine the LiquidStage instance based on the parent's <code>stage</code> property (<code>LiquidStage.getByStage()</code>). The only time it is useful to specifically declare the LiquidStage instance is when you plan to subload a swf that uses LiquidStage into another swf that also has a LiquidStage instance (thus they share the same stage).
		 * @param strict If <code>strict</code> is <code>true</code>, the top left and bottom right corners will always retain their absolute distance from the PinPoints that are used in <code>pinCorners()</code> (the LiquidStage's <code>TOP_LEFT</code> and <code>BOTTOM_RIGHT</code> by default) instead of adjusting themselves in a relative fashion. If they are <strong>not</strong> strict, you could alter the position/size of the LiquidArea independently and then when the stage is resized, the corners would only move by however much the stage changed (more flexible). 
		 */
		public function LiquidArea(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, previewColor:uint=0xFF0000, minWidth:Number=0, minHeight:Number=0, maxWidth:Number=99999999, maxHeight:Number=99999999, autoPinCorners:Boolean=true, liquidStage:LiquidStage=null, strict:Boolean=false) {
			super(parent, x, y, width, height, previewColor);
			_wOffset = _hOffset = 0;
			this.minWidth = minWidth;
			this.minHeight = minHeight;
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			_liquidStage = liquidStage;
			_strictMode = strict;
			
			if (autoPinCorners) {
				if (_parent.stage) {
					this.autoPinCorners(null);
				} else {
					_parent.addEventListener(Event.ADDED_TO_STAGE, this.autoPinCorners);
				}
			}
		}
		
		/**
		 * Creates an LiquidArea with its initial dimensions fit precisely around a target DisplayObject. 
		 * It also attaches the target DisplayObject immediately.
		 * 
		 * @param target The target DisplayObject whose position and dimensions the LiquidArea should match initially.
		 * @param vars An object used for defining various optional parameters (see below for list) - this is more readable and concise than defining 11 or more normal arguments. 
		 * 			   For example, <code>createAround(mc, {scaleMode:"proportionalOutside", crop:true});</code> instead of <code>createAround(mc, "proportionalOutside", "center", "center", true, 0, 99999999, 0, 99999999, false, NaN, false);</code>.
		 * 			   The following optional parameters are recognized:
		 * 				<ul>
		 * 					<li><b>scaleMode : String</b> - Determines how the target should be scaled to fit the area. Use the ScaleMode class constants: <code>STRETCH, PROPORTIONAL_INSIDE, PROPORTIONAL_OUTSIDE, NONE, WIDTH_ONLY,</code> or <code>HEIGHT_ONLY</code></li>
		 * 					<li><b>hAlign : String</b> - Horizontal alignment of the target inside the area. Use the AlignMode class constants: <code>LEFT</code>, <code>CENTER</code>, and <code>RIGHT</code>.</li>
		 * 					<li><b>vAlign : String</b> - Vertical alignment of the target inside the area. Use the AlignMode class constants: <code>TOP</code>, <code>CENTER</code>, and <code>BOTTOM</code>.</li>
		 * 					<li><b>crop : Boolean</b> - If true, a mask will be created and added to the display list so that the target will be cropped wherever it exceeds the bounds of the AutoFitArea.</li>
		 * 					<li><b>roundPosition : Boolean</b> - To force the target's x/y position to snap to whole pixel values, set <code>roundPosition</code> to <code>true</code> (it is <code>false</code> by default).</li>
		 * 					<li><b>customBoundsTarget : DisplayObject</b> - A DisplayObject that AutoFitArea/LiquidArea should use when measuring bounds instead of the <code>target</code>. For example, maybe the target contains 3 boxes arranged next to each other, left-to-right and instead of fitting ALL of those boxes into the area, you only want the center one fit into the area. In this case, you can define the customBoundsTarget as that center box so that the AutoFitArea/LiquidArea only uses it when calculating bounds. Make sure that the object is in the display list (its <code>visible</code> property can be set to false if you want to use an invisible object to define custom bounds).</li>
		 * 					<li><b>minWidth : Number</b> - Minimum width to which the target is allowed to scale</li>
		 * 					<li><b>maxWidth : Number</b> - Maximum width to which the target is allowed to scale</li>
		 * 					<li><b>minHeight : Number</b> - Minimum height to which the target is allowed to scale</li>
		 * 					<li><b>maxHeight : Number</b> - Maximum height to which the target is allowed to scale</li>
		 * 					<li><b>calculateVisible : Boolean</b> - If true, only the visible portions of the target will be taken into account when determining its position and scale which can be useful for objects that have masks applied (otherwise, Flash reports their width/height and getBounds() values including the masked portions). Setting <code>calculateVisible</code> to <code>true</code> degrades performance, so only use it when absolutely necessary.</li>
		 * 					<li><b>customAspectRatio : Number</b> - Normally if you set the <code>scaleMode</code> to <code>PROPORTIONAL_INSIDE</code> or <code>PROPORTIONAL_OUTSIDE</code>, its native (unscaled) dimensions will be used to determine the proportions (aspect ratio), but if you prefer to define a custom width-to-height ratio, use <code>customAspectRatio</code>. For example, if an item is 100 pixels wide and 50 pixels tall at its native size, the aspect ratio would be 100/50 or 2. If, however, you want it to be square (a 1-to-1 ratio), the <code>customAspectRatio</code> would be 1. </li>
		 * 					<li><b>previewColor : uint</b> - The preview color of the AutoFitArea (default is 0xFF0000). To preview, you must set the AutoFitArea's <code>visible</code> property to true (it is false by default).</li>
		 * 					<li><b>reconcile : Boolean</b> - If true, LiquidStage will be reverted to <code>retroMode</code> (briefly forcing the stage to the base width/height) before creating the LiquidArea. This effectively acts as though the target was attached BEFORE the stage was scaled. If you create the LiquidArea after the stage has been scaled and you don't want it to reconcile with the initial base stage size initially, set <code>reconcile</code> to <code>false</code>.</li>
		 * 					<li><b>autoPinCorners : Boolean</b> - By default, the LiquidArea's upper left corner is pinned to the LiquidStage's <code>TOP_LEFT</code> PinPoint, and its lower right corner is pinned to the LiquidStage's <code>BOTTOM_RIGHT</code> PinPoint, but to skip the pinning, set autoPinCorners to false.</li>
		 * 					<li><b>strict : Boolean</b> - If <code>strict</code> is <code>true</code>, the top left and bottom right corners will always retain their absolute distance from the PinPoints that are used in <code>pinCorners()</code> (the LiquidStage's <code>TOP_LEFT</code> and <code>BOTTOM_RIGHT</code> by default) instead of adjusting themselves in a relative fashion. If they are <strong>not</strong> strict, you could alter the position/size of the LiquidArea independently and then when the stage is resized, the corners would only move by however much the stage changed (more flexible). </li>
		 * 					<li><b>liquidStage : LiquidStage</b> - Optionally declare the LiquidStage instance to which this LiquidArea should be associated. If none is defined, the class will try to determine the LiquidStage instance based on the parent's <code>stage</code> property (<code>LiquidStage.getByStage()</code>). The only time it is useful to specifically declare the LiquidStage instance is when you plan to subload a swf that uses LiquidStage into another swf that also has a LiquidStage instance (thus they share the same stage). </li>
		 * 				</ul>
		 * @return An LiquidArea instance
		 */
		public static function createAround(target:DisplayObject, vars:Object=null, ...args):LiquidArea {
			if (vars == null || typeof(vars) == "string") {
				//sensed old method - parse the params for backwards compatibility
				vars = {scaleMode:vars || "proportionalInside",
						hAlign:args[0] || "center",
						vAlign:args[1] || "center",
						crop:Boolean(args[2]),
						minWidth:args[4] || 0,
						minHeight:args[5] || 0,
						maxWidth:(isNaN(args[6]) ? 999999999 : args[6]),
						maxHeight:(isNaN(args[7]) ? 999999999 : args[7]),
						autoPinCorners:Boolean(args[8] != false),
						calculateVisible:Boolean(args[9]),
						liquidStage:args[10] || LiquidStage.getByStage(target.stage),
						reconcile:Boolean(args[11] != false),
						strict:Boolean(args[12])};
			}
			
			var ls:LiquidStage = vars.liquidStage || LiquidStage.getByStage(target.stage);
			var tempRetro:Boolean = Boolean(vars.reconcile != false && !ls.isBaseSize && !ls.retroMode);
			if (tempRetro) {
				ls.retroMode = true;
			}
			var boundsTarget:DisplayObject = (vars.customBoundsTarget is DisplayObject) ? vars.customBoundsTarget : target;
			var bounds:Rectangle = (vars.calculateVisible == true) ? getVisibleBounds(boundsTarget, target.parent) : boundsTarget.getBounds(target.parent);
			var previewColor:uint = isNaN(args[3]) ? (("previewColor" in vars) ? uint(vars.previewColor) : 0xFF0000) : args[3];
			var la:LiquidArea = new LiquidArea(target.parent, bounds.x, bounds.y, bounds.width, bounds.height, previewColor, vars.minWidth || 0, vars.minHeight || 0, (("maxWidth" in vars) ? vars.maxWidth : 999999999), (("maxHeight" in vars) ? vars.maxHeight : 999999999), Boolean(vars.autoPinCorners != false), ls, Boolean(vars.strict));
			
			la.attach(target, vars);
			if (tempRetro) {
				ls.retroMode = false;
			}
			return la;
		}
		
		/** @private **/
		protected function autoPinCorners(event:Event=null):void {
			if (event) {
				_parent.removeEventListener(Event.ADDED_TO_STAGE, this.autoPinCorners);
			}
			if (_liquidStage == null) {
				_liquidStage = LiquidStage.getByStage(_parent.stage);
			}
			if (_liquidStage && _topLeftPin == null) {
				pinCorners(_liquidStage.TOP_LEFT, _liquidStage.BOTTOM_RIGHT, true, 0, null, _strictMode);
			}
		}
		
		/**
		 * By default, a LiquidArea pins itself to the <code>TOP_LEFT</code> and <code>BOTTOM_RIGHT</code> PinPoints of the LiquidStage, but
		 * this method allows you to pin the corners to different PinPoints if you prefer. 
		 * 
		 * @param topLeft The PinPoint to which the top left corner of the LiquidArea should be pinned.
		 * @param bottomRight The PinPoint to which the bottom right corner of the LiquidArea should be pinned.
		 * @param reconcile If true, the LiquidArea's position and dimensions will immediately be adjusted as though it was attached BEFORE the stage was scaled. If you create the LiquidArea after the stage has been scaled and you don't want it to reconcile with the PinPoint initially, set <code>reconcile</code> to <code>false</code>.
		 * @param tweenDuration To make the LiquidArea tween to its new position and dimensions instead of immediately moving/resizing, set the tween duration (in seconds) to a non-zero value. A <code>TweenLite</code> instance will be used for the tween.
		 * @param tweenVars To control other aspects of the tween (like ease, onComplete, delay, etc.), use an object just like the one you'd pass into a <code>TweenLite</code> instance as the 3rd parameter (like <code>{ease:Elastic.easeOut, delay:0.2}</code>)
		 * @param strict If <code>strict</code> is <code>true</code>, the top left and bottom right corners will always retain their absolute distance from the PinPoints that are used in <code>pinCorners()</code> (the LiquidStage's <code>TOP_LEFT</code> and <code>BOTTOM_RIGHT</code> by default) instead of adjusting themselves in a relative fashion. If they are <strong>not</strong> strict, you could alter the position/size of the LiquidArea independently and then when the stage is resized, the corners would only move by however much the stage changed (more flexible). 
		 */
		public function pinCorners(topLeft:PinPoint, bottomRight:PinPoint, reconcile:Boolean=true, tweenDuration:Number=0, tweenVars:Object=null, strict:Boolean=false):void {
			if (_liquidStage == null) {
				_liquidStage = LiquidStage.getByStage(_parent.stage);
			}
			var tempRetro:Boolean = Boolean(reconcile && !_liquidStage.isBaseSize && !_liquidStage.retroMode);
			if (tempRetro) {
				_liquidStage.retroMode = true;
			}
			if (_topLeftPin != null) {
				_data.destroy(false);
				if (_tweenMode) {
					_tween.kill();
				}
			}
			if (tweenDuration > 0) {
				_tween = _originalTween = dynamicTween(tweenDuration, tweenVars || {});
				_tween._enabled(false, false);
			}
			_strictMode = strict;
			_topLeftPin = topLeft;
			_bottomRightPin = bottomRight;
			_liquidStage = _topLeftPin.data.liquidStage;
			
			_tlData = _topLeftPin.data;
			_brData = _bottomRightPin.data;
			capturePinData();
			
			_data = new LiquidData(_topLeftPin, this, 3, _liquidStage, false, 0, null, false);
			LiquidData.addCacheData(_liquidStage, _data);
			
			if (_strictMode) {
				var local:Point = _topLeftPin.toLocal(_parent);
				_strictDifTL = new Point(this.x - local.x, this.y - local.y);
				local = _bottomRightPin.toLocal(_parent);
				_strictDifBR = new Point((this.x + this.width) - local.x, (this.y + this.height) - local.y);
			}
			
			if (tempRetro) {
				_liquidStage.retroMode = false;
			}
		}
		
		/** @inheritDoc **/
		override public function destroy():void {
			if (_topLeftPin) {
				_data.destroy(false);
				_topLeftPin = _bottomRightPin = null;
			}
			_liquidStage = null;
			super.destroy();
		}
		
		/** @private Used by LiquidStage to capture the current positions of the top left and bottom right PinPoints before doing an update so that the relative change can be determined. **/
		public function capturePinData():void {
			_tlPrev = _parent.globalToLocal(_tlData.global);
			_brPrev = _parent.globalToLocal(_brData.global);
		}
		
		/** @private Used by LiquidStage to resize the LiquidArea after the top left and bottom right PinPoints have been updated. **/
		public function updatePins():void {
			var xDif:Number, yDif:Number, widthDif:Number, heightDif:Number;
			var p:Point = _parent.globalToLocal(_tlData.global);
			if (_strictMode) {
				xDif = int(p.x + _strictDifTL.x) - int(this.x);
				yDif = int(p.y + _strictDifTL.y) - int(this.y);
				
				p = _parent.globalToLocal(_brData.global);
				widthDif = int(p.x + _strictDifBR.x) - int(this.x + this.width) - xDif;
				heightDif = int(p.y + _strictDifBR.y) - int(this.y + this.height) - yDif;
			} else {
				xDif = int(p.x) - int(_tlPrev.x);
				yDif = int(p.y) - int(_tlPrev.y);
				
				p = _parent.globalToLocal(_brData.global);
				widthDif = int(p.x) - int(_brPrev.x) - xDif - _wOffset;
				heightDif = int(p.y) - int(_brPrev.y) - yDif - _hOffset;
			}
			var w:Number = _tweenMode ? _tween.vars.width + widthDif : this.width + widthDif;
			if (w < this.minWidth) {
				_wOffset = this.minWidth - w;
			} else if (w > this.maxWidth) {
				_wOffset = this.maxWidth - w;
			} else {
				_wOffset = 0;
			}
			w += _wOffset;
			
			var h:Number = _tweenMode ? _tween.vars.height + heightDif : this.height + heightDif;
			if (h < this.minHeight) {
				_hOffset = this.minHeight - h;
			} else if (h > this.maxHeight) {
				_hOffset = this.maxHeight - h;
			} else {
				_hOffset = 0;
			}
			h += _hOffset;
			
			if (xDif == 0 && yDif == 0 && widthDif == 0 && heightDif == 0) {
				//do nothing
				
			} else if (_tween) {
				if (_tweenMode) {
					_tween.vars.x += xDif;
					_tween.vars.y += yDif;
				} else {
					_tween.vars.x = this.x + xDif;
					_tween.vars.y = this.y + yDif;
				}
				_tween.vars.width = w;
				_tween.vars.height = h;
				
				if (_tween == _originalTween) {
					_tween.invalidate();
					_tween.restart(true, true);
				} else {
					var oldTime:Number = _tween.time();
					_tween.restart(false, true);
					_tween.invalidate();
					_tween.time( oldTime );
				}
				_tweenMode = true;
				
			} else {
				var oldTweenMode:Boolean = _tweenMode;
				_tweenMode = true;
				this.x += xDif;
				this.y += yDif;
				this.width = w;
				this.height = h;
				_tweenMode = oldTweenMode;
				
				update();
			}
			
		}
		
		/** @private **/
		protected function onTweenStart(vars:Object, tween:TweenLite):void {
			_tweenMode = true;
			_tween = tween;
			if (vars.onStart) {
				vars.onStart.apply(null, vars.onStartParams);
			}
		}
		
		/** @private **/
		protected function onTweenUpdate(vars:Object, tween:TweenLite):void {
			update();
			if (vars.onUpdate) {
				vars.onUpdate.apply(null, vars.onUpdateParams);
			}
		}
		
		/** @private **/
		protected function onTweenComplete(vars:Object, tween:TweenLite):void {
			_tweenMode = false;
			_tween = _originalTween;
			if (vars.onComplete) {
				vars.onComplete.apply(null, vars.onCompleteParams);
			}
		}
		
		/**
		 * If you want to tween a LiquidArea's transform properties (like <code>x, y, width, height, 
		 * scaleX,</code> or <code>scaleY</code>), you may want the destination values to be 
		 * dynamically affected by LiquidStage resizes and that's exactly what <code>dynamicTween()</code>
		 * allows. For example, maybe you start tweening to a width of 100 but in the middle of the 
		 * tween, the user widens the stage by 50 pixels - with a tween generated by 
		 * <code>dynamicTween()</code>, the width will end up being 150 instead of 100. Only one
		 * dynamic tween can be in effect at any given time. 
		 * 
		 * @param duration The duration of the tween in seconds (unless useFrames:true is passed in through the vars object in which case the duration is described in terms of frames)
		 * @param vars The tween vars object that defines the destination values, ease, etc. For example <code>{width:100, height:200, ease:Elastic.easeOut}</code>
		 * @return A TweenLite instance
		 */
		public function dynamicTween(duration:Number, vars:Object):TweenLite {
			var tv:Object = {};
			for (var p:String in vars) {
				tv[p] = vars[p];
			}
			if (!("x" in tv)) {
				tv.x = this.x;
			}
			if (!("y" in tv)) {
				tv.y = this.y;
			}
			if (!("width" in tv)) {
				tv.width = this.width;
			}
			if (!("height" in tv)) {
				tv.height = this.height;
			}
			tv.overwrite = false;
			tv.onStart = onTweenStart;
			tv.onUpdate = onTweenUpdate;
			tv.onComplete = onTweenComplete;
			tv.onStartParams = tv.onUpdateParams = tv.onCompleteParams = [vars];
			var tl:TweenLite = new TweenLite(this, duration, tv);
			tv.onStartParams[1] = tl;
			return tl;
		}
		
	}
}