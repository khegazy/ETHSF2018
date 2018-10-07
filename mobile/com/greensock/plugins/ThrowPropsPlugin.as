/**
 * VERSION: 12.0.9
 * DATE: 2013-06-25
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.TweenLite;
	import com.greensock.utils.VelocityTracker;
	import com.greensock.easing.Ease;
/**
 * <code>ThrowPropsPlugin</code> allows you to smoothly glide any property to a stop, honoring
 * an initial velocity as well as applying optional restrictions on the end value. You can define
 * a specific end value or allow it to be chosen automatically based on the initial velocity and ease
 * or you can define a max/min range or even an array of snap-to values that act as notches.  
 * <code>ThrowPropsPlugin</code> even integrates <code>VelocityTracker</code> so that you can 
 * have it "watch" certain properties to keep track of their velocities for you and then use
 * them automatically when you do a <code>throwProps</code> tween. This is perfect
 * for flick-scrolling or animating things as though they are being thrown (where momentum 
 * factors into the tween). 
 * 
 * <p>For example, let's say a user clicks and drags a ball and and then when released, the ball
 * should continue flying at the same velocity as it was just moving (so that it appears seamless), 
 * and then glide to a rest. You can't do a normal tween because you don't know exactly where it should 
 * land or how long the tween should last (faster initial velocity would usually mean a longer duration). 
 * You'd like it to decelerate based on whatever ease you define in your tween (always use 
 * some sort of easeOut, like <code>Power1.easeOut, Strong.easeOut</code>, etc.). </p>
 * 
 * <p>Maybe you want the final resting value to always land within a 
 * particular range so that the ball doesn't fly off the edge of the screen. But you don't want 
 * it to suddenly jerk to a stop when it hits the edge of the screen either; instead, you want it 
 * to ease gently into place even if that means going past the landing spot briefly and easing back 
 * (if the initial velocity is fast enough to require that). The whole point is to make it look 
 * <strong>smooth</strong>.</p>
 * 
 * <p><strong>No problem.</strong></p>
 * 
 * <p>In its simplest form, you can pass just the initial velocity for each property like this:</p><p><code>
 * 
 * TweenLite.to(mc, 2, {throwProps:{x:500, y:-300}});</code></p>
 * 
 * <p>In the above example, <code>mc.x</code> will animate at 500 pixels per second initially and 
 * <code>mc.y</code> will animate at -300 pixels per second. Both will decelerate smoothly 
 * until they come to rest 2 seconds later (because the tween's duration is 2 seconds). </p>
 * 
 * <p>To use the <code>Strong.easeOut</code> easing equation and impose maximum and minimum boundaries on 
 * the end values, use the object syntax with the <code>max</code> and <code>min</code> special 
 * properties like this:</p><p><code>
 * 
 * TweenLite.to(mc, 2, {throwProps:{x:{velocity:500, max:1024, min:0}, y:{velocity:-300, max:720, min:0}}, ease:Strong.easeOut});
 * </code></p>
 * 
 * <p>Notice the nesting of the objects ({}). The <code>max</code> and <code>min</code> values refer
 * to the range for the final resting position (coordinates in this case), <strong>not</strong> the velocity. 
 * So <code>mc.x</code> would always land between 0 and 1024 in this case, and <code>mc.y</code> 
 * would always land between 0 and 720. If you want the target object to land on a specific value 
 * rather than within a range, simply set <code>max</code> and <code>min</code> to identical values
 * or just use the <code>"end"</code> property. 
 * Also notice that you must define a <code>velocity</code> value for each property 
 * (unless you're using <code><a href="ThrowPropsPlugin.html#track()">track()</a></code> - see below for details).</p>
 * 
 * <p><strong>Valid properties for object syntax</strong></p>
 * <ul>
 * 	<li><strong>velocity</strong> : Number or <code>"auto"</code> - the initial velocity, measured in units per second (or per 
 * 					frame for frames-based tweens). You may omit velocity or just use "auto" for 
 * 					properties that are being tracked automatically using the <code><a href="ThrowPropsPlugin.html#track()">track()</a></code> method.</li>
 * 	<li><strong>min</strong> : Number - the minimum end value of the property. For example, if you don't want 
 * 					<code>x</code> to land at a value below 0, your throwProps may look like <code>{x:{velocity:-500, min:0}}</code></li>
 * 	<li><strong>max</strong> : Number - the maximum end value of the property. For example, if you don't want 
 * 					<code>x</code> to exceed 1024, your throwProps may look like <code>{x:{velocity:500, max:1024}}</code></li>
 * 	<li><strong>end</strong> : [Number | Array | Function] - if <code>end</code> is defined as a <strong>Number</strong>, the 
 * 					target will land EXACTLY there (just as if you set both the <code>max</code> and <code>min</code> to identical values). 
 * 					If <code>end</code> is defined as a numeric <strong>Array</strong>, those values will be treated like "notches" or 
 * 					"snap-to" values so that the closest one to the natural landing spot will be selected. For example, 
 * 					if <code>[0,100,200]</code> is used, and the value would have naturally landed at 141, it will use the 
 * 					closest number (100 in this case) and land there instead. If <code>end</code> is defined as a
 * 					<strong>Function</strong>, that function will be called and passed the natural landing value
 * 					as the only parameter, and your function can run whatever logic you want, and then return the 
 * 					number at which it should land. This can be useful if, for example, you have a rotational tween
 * 					and you want it to snap to 10-degree increments no matter how big or small, you could use
 * 					a function that just rounds the natural value to the closest 10-degree increment. 
 * 					So any of these are valid: <code>end:100</code> or <code>end:[0,100,200,300]</code>
 * 					or <code>end:function(n:Number):Number { return Math.round(n / 10) ~~ 10; }</code></li>
 * </ul>
 * 
 * <p>ThrowPropsPlugin isn't just for tweening x and y coordinates. It works with any numeric property,
 * so you could use it for spinning the <code>rotation</code> of an object as well. Or the 
 * <code>scaleX</code>/<code>scaleY</code> properties. Maybe the user drags to spin a wheel and
 * lets go and you want it to continue increasing the <code>rotation</code> at that velocity, 
 * decelerating smoothly until it stops. It even works with method-based getters/setters.</p>
 *  
 * <p><strong>Automatically determine duration</strong></p>
 * <p>One of the trickiest parts of creating a <code>throwProps</code> tween that looks fluid and natural 
 * (particularly if you're applying maximum and/or minimum values) is determining its duration. 
 * Typically it's best to have a relatively consistent level of resistance so that if the 
 * initial velocity is very fast, it takes longer for the object to come to rest compared to 
 * when the initial velocity is slower. You also may want to impose some restrictions on how long
 * a tween can last (if the user drags incredibly fast, you might not want the tween to last 200
 * seconds). The duration will also affect how far past a max/min boundary the property may
 * go, so you might want to only allow a certain amount of overshoot tolerance. That's why <code>ThrowPropsPlugin</code>
 * has a few static helper methods that make managing all these variables much easier. The one you'll 
 * probably use most often is the <a href="ThrowPropsPlugin.html#to()"><code>to()</code></a> method which is very similar 
 * to <code>TweenLite.to()</code> except that it doesn't have a <code>duration</code> parameter and 
 * it adds several other optional parameters. Read the <a href="ThrowPropsPlugin.html#to()">docs below</a> for details.</p><p><code>
 * 
 * ThrowPropsPlugin.to(mc, {throwProps:{x:"auto", y:{velocity:"auto", max:1000, min:0}}, ease:Strong.easeOut});</code></p>
 * 
 * <p>Feel free to experiment with using different easing equations to control how the values ease into
 * place at the end. You don't need to put the "ease" special property inside the 
 * <code>throwProps</code> object. Just keep it in the same place it has always been, like:</p><p><code>
 * 
 * TweenLite.to(mc, 1, {throwProps:{x:500, y:-300}, ease:Strong.easeOut});</code></p>
 * 
 * <p><strong>Automatically track velocity</strong></p>
 * <p>Another tricky aspect of smoothly transitioning from a particular velocity is tracking 
 * the property's velocity in the first place! So we've made that easier too - you can use the
 * <code><a href="ThrowPropsPlugin.html#track()">ThrowPropsPlugin.track()</a></code> method to have the 
 * velocity (rate of change) of certain properties tracked and then <code>throwProps</code> tweens 
 * will automatically grab the appropriate tracked value internally, allowing you to omit the 
 * <code>velocity</code> values in your tweens altogether. See the <code><a href="ThrowPropsPlugin.html#track()">track()</a></code> 
 * method's description for details. And make sure you start tracking velocity at least a half-second
 * before you need to tween because it takes a small amount of time to guage how fast something is going.</p>
 * 
 * <p>A unique convenience of ThrowPropsPlugin compared to most other solutions out there that use 
 * frame-based loops is that everything is reverseable and you can jump to any spot 
 * in the tween immediately. So if you create several <code>throwProps</code> tweens, for example, and 
 * dump them into a TimelineLite, you could simply call <code>reverse()</code> on the timeline 
 * to watch the objects retrace their steps right back to the beginning! </p>
 * 
 * <p>The following example creates a Sprite (<code>mc</code>), populates it with a long TextField
 * and makes it vertically draggable. Then it tracks its velocity and allows it to be thrown 
 * within the bounds defined by the <code>bounds</code> rectangle, smoothly easing into place 
 * regardless of where and how fast it is thrown:</p>
 * 
 * <listing version="3.0">
import com.greensock.~~;
import flash.events.MouseEvent;
import com.greensock.plugins.~~;
import com.greensock.easing.~~;
import flash.geom.Rectangle;
import flash.utils.getTimer;
import flash.text.~~;
import flash.display.~~;
 
TweenPlugin.activate([ThrowPropsPlugin]);
 
var bounds:Rectangle = new Rectangle(30, 30, 250, 230);
var mc:Sprite = new Sprite();
addChild(mc);
setupTextField(mc, bounds, 20);
 
//track the "y" property's velocity automatically:
ThrowPropsPlugin.track(mc, "y");
 
mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
 
function mouseDownHandler(event:MouseEvent):void {
	TweenLite.killTweensOf(mc);
	mc.startDrag(false, new Rectangle(bounds.x, -99999, 0, 99999999));
	mc.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
}
 
function mouseUpHandler(event:MouseEvent):void {
	mc.stopDrag();
	mc.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
	var yOverlap:Number = Math.max(0, mc.height - bounds.height);
	ThrowPropsPlugin.to(mc, {ease:Strong.easeOut, throwProps:{y:{max:bounds.top, min:bounds.top - yOverlap, resistance:200}}}, 10, 0.25, 1);
}
 
function setupTextField(container:Sprite, bounds:Rectangle, padding:Number=20):void {
	var tf:TextField = new TextField();
	tf.width = bounds.width - padding;
	tf.x = tf.y = padding / 2;
	tf.defaultTextFormat = new TextFormat("_sans", 12);
	tf.text = "Click and drag this content and then let go as you're dragging to throw it. Notice how it smoothly glides into place, respecting the initial velocity and the maximum/minimum coordinates.\n\nThrowPropsPlugin allows you to simply define an initial velocity for a property (or multiple properties) as well as optional maximum and/or minimum end values and then it will calculate the appropriate landing position and plot a smooth course based on the easing equation you define (Quad.easeOut by default, as set in TweenLite). This is perfect for flick-scrolling or animating things as though they are being thrown.\n\nFor example, let's say a user clicks and drags a ball and you track its velocity using an ENTER_FRAME handler and then when the user releases the mouse button, you'd determine the velocity but you can't do a normal tween because you don't know exactly where it should land or how long the tween should last (faster initial velocity would mean a longer duration). You need the tween to pick up exactly where the user left off so that it appears to smoothly continue moving at the same velocity they were dragging and then decelerate based on whatever ease you define in your tween.\n\nAs demonstrated here, maybe the final resting value needs to lie within a particular range so that the content doesn't land outside a particular area. But you don't want it to suddenly jerk to a stop when it hits the edge; instead, you want it to ease gently into place even if that means going past the landing spot briefly and curving back (if the initial velocity is fast enough to require that). The whole point is to make it look smooth.";
	tf.multiline = tf.wordWrap = true;
	tf.selectable = false;
	tf.autoSize = TextFieldAutoSize.LEFT;
	container.addChild(tf);
	
	container.graphics.beginFill(0xFFFFFF, 1);
	container.graphics.drawRect(0, 0, tf.width + padding, tf.textHeight + padding);
	container.graphics.endFill();
	container.x = bounds.x;
	container.y = bounds.y;
	
	var crop:Shape = new Shape();
	crop.graphics.beginFill(0xFF0000, 1);
	crop.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
	crop.graphics.endFill();
	container.parent.addChild(crop);
	container.mask = crop;
}
 </listing>
 * 
 * <p>ThrowPropsPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get more details.</p>
 * 
 * <p><strong>Copyright 2008-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class ThrowPropsPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** 
		 * The default <code>resistance</code> that is used to calculate how long it will take 
		 * for the tweening property (or properties) to come to rest by the static <code>ThrowPropsPlugin.to()</code>
		 * and <code>ThrowPropsPlugin.calculateTweenDuration()</code> methods. Keep in mind that you can define
		 * a <code>resistance</code> value either for each individual property in the <code>throwProps</code> tween
		 * like this:<p><code>
		 * 
		 * ThrowPropsPlugin.to(mc, {throwProps:{x:{velocity:500, resistance:150}, y:{velocity:-300, resistance:50}}});
		 * </code></p>
		 * 
		 * <p><strong>OR</strong> you can define a single <code>resistance</code> value that will be used for all of the 
		 * properties in that particular <code>throwProps</code> tween like this:</p>
		 * 
		 * <listing version="3.0">
ThrowPropsPlugin.to(mc, {throwProps:{x:500, y:-300, resistance:150}});
 
 //-OR- 
 
ThrowPropsPlugin.to(mc, {throwProps:{x:{velocity:500, max:800, min:0}, y:{velocity:-300, max:800, min:100}, resistance:150}});
</listing>
		 **/
		public static var defaultResistance:Number = 100;
		
		/** @private **/
		protected var _target:Object;
		/** @private **/
		protected var _props:Array;
		/** @private **/
		protected var _tween:TweenLite;
		/** @private **/
		protected var _invertEase:Boolean;
		/** @private **/
		private static var _max:Number = 999999999999999;
		
		/** @private **/
		public function ThrowPropsPlugin() {
			super("throwProps");
			_overwriteProps.length = 0;
		}
		
		/**
		 * Allows you to have the velocity of particular properties automatically tracked for you
		 * so that ThrowPropsPlugin tweens can access that data internally instead of manually calculating it
		 * and feeding it into each tween. For example, let's say there's an object that the 
		 * user interacts with by dragging it or maybe it is being tweened and then at some point you want
		 * to create a <code>throwProps</code> tween that smoothly continues that motion and glides to
		 * a rest. Normally, you'd need to write your own tracking code that records that object's <code>x</code>
		 * and <code>y</code> properties and the time stamps so that when it comes time to feed the 
		 * <code>velocity</code> into the <code>throwProps</code> tween, you'd have the necessary data to 
		 * calculate it. But let's face it: that can be cumbersome to do manually, and that's precisely why
		 * the <code>track()</code> method exists. 
		 * 
		 * <p>Just feed in the <code>target</code> and a comma-delimited list of its properties that you want
		 * tracked like this:</p><p><code>
		 * 
		 * ThrowPropsPlugin.track(obj, "x,y");</code></p>
		 * 
		 * <p>Then every time the core tweening engine updates (at whatever frame rate you're running), 
		 * the <code>x</code> and <code>y</code> values (or whichever properties you define) will be recorded 
		 * along with time stamps (it keeps a maximum of 2 of these values and continually writes over the previous
		 * ones, so don't worry about memory buildup). This even works with function-based properties like 
		 * getters and setters.</p>
		 * 
		 * <p>Then, after at least 100ms and 2 "ticks" of the core engine have elapsed (so that some data has been recorded),
		 * you can create <code>throwProps</code> tweens for those properties and omit the <code>"velocity"</code> 
		 * values and it will automatically populate them for you internally. For example:</p>
		 * 
		 * <listing version="3.0">
//first, start tracking "x" and "y":
ThrowPropsPlugin.track(obj, "x,y");
 
//then, after at least 100ms, let's smoothly tween to EXACTLY x:200, y:300
TweenLite.to(obj, 2, {throwProps:{x:{end:200}, y:{end:300}}, ease:Strong.easeOut});
 
//and if you want things to use the defaults and have obj.x and obj.y glide to a stop based on the velocity rather than setting any destination values, just use "auto":
TweenLite.to(obj, 2, {throwProps:{x:"auto", y:"auto"}, ease:Strong.easeOut});
</listing>
		 * <p>Notice that <code>"auto"</code> is a valid option when you're tracking the properties too, but 
		 * <strong>only</strong> for tracked properties.</p>
		 * 
		 * <p><strong>What kinds of properties can be tracked?</strong></p>
		 * <p>Pretty much any numeric property of any object can be tracked, including function-based ones. 
		 * For example, <code>obj.x</code> or <code>obj.rotation</code> or even <code>obj.myCustomProp()</code>. 
		 * In fact, for getters and setters that start with the 
		 * word "get" or "set" (like <code>getCustomProp()</code> and <code>setCustomProp()</code>), it will 
		 * automatically find the matching counterpart method and use the getter appropriately, so you can track
		 * the getter or setter and it'll work. You <strong>cannot</strong>, however, track custom plugin-related 
		 * values like "directionalRotation" or "autoAlpha" or "physics2D" because those aren't real properties
		 * of the object. You should instead track the real properties that those plugins affect, like "rotation" or
		 * "alpha" or "x" or "y".</p>
		 * 
		 * <p><strong>IMPORTANT:</strong> you should <code>untrack()</code> properties when you no longer 
		 * need them tracked in order to maximize performance and ensure things are released for garbage collection. 
		 * To untrack, simply use the <code>untrack()</code> method:</p>
		 * 
		 * <listing version="3.0">
//stop tracking all properties of obj:
ThrowPropsPlugin.untrack(obj);
 
//stop tracking only the "x" property: 
ThrowPropsPlugin.untrack(obj, "x");
 
//stop tracking "x" and "y":
ThrowPropsPlugin.untrack(obj, "x,y");
</listing>
		 * 
		 * @param target the target object whose properties will be tracked
		 * @param props a comma-delimited list of property names, like <code>"y"</code> or <code>"x,y"</code>
		 * @param types a comma-delimited list of property types (only helpful if they are rotation-based), <code>"rad"</code> for radian-based rotation or <code>"deg"</code> for degree-based rotation - this is only useful you'd like to have VelocityTracker compensate for artificial jumps in rotational values when the rotational midline is crossed, like when rotation goes from 179 to -178 degrees it would interpret that as a change of 3 instead of 357 degrees. Leave this blank unless you want the rotational compensation. You can use <code>"num"</code> to indicate normal numeric behavior (or leave it blank). 
		 * @return a VelocityTracker object that's responsible for doing the tracking. You can use this if you want - the most useful method is its <code>getVelocity()</code> method that you feed the property name to like <code>myTracker.getVelocity("y")</code> to get the target's <code>y</code> velocity anytime. Normally, however, you don't need to keep track of this VelocityTracker object at all because the work is done internally and ThrowPropsPlugin knows how to find it. 
		 * @see #untrack()
		 * @see #isTracking()
		 */
		public static function track(target:Object, props:String, types:String=""):VelocityTracker {
			return VelocityTracker.track(target, props);
		}
		
		/**
		 * Stops tracking the velocity of certain properties (or all properties of an object), like ones initiated with
		 * the <code><a href="ThrowPropsPlugin.html#track()">track()</a></code> method.
		 * 
		 * <listing version="3.0">
//starts tracking "x" and "y":
ThrowPropsPlugin.track(obj, "x,y");
 
//stops tracking only the "x" property: 
ThrowPropsPlugin.untrack(obj, "x");
 
//stops tracking "x" and "y":
ThrowPropsPlugin.untrack(obj, "x,y");
 
//stops tracking all properties of obj:
ThrowPropsPlugin.untrack(obj);
</listing>
		 * 
		 * @param target the target object whose properties should stop being tracked
		 * @param props a comma-delimited list of properties to stop tracking. If <code>null</code>, ALL properties of the <code>target</code> will stop being tracked. 
		 * @see #track()
		 * @see #isTracking()
		 */
		public static function untrack(target:Object, props:String=null):void {
			VelocityTracker.untrack(target, props);
		}
		
		/**
		 * Allows you to discern whether the velocity of a particular target or one of its properties is being tracked 
		 * (typically initiated using the <code><a href="ThrowPropsPlugin.html#track()">track()</a></code> method). 
		 * 
		 * @param target The target object
		 * @param prop the name of the property to check, like <code>"x"</code> or <code>"y"</code>. 
		 * @return <code>true</code> if the target/property is being tracked, <code>false</code> if not.
		 * @see #track()
		 * @see #untrack()
		 */
		public static function isTracking(target:Object, prop:String=null):Boolean {
			return VelocityTracker.isTracking(target, prop);
		}
		
		/**
		 * Returns the current velocity of the given property and target object (only works
		 * if you started tracking the property using the <a href="ThrowPropsPlugin.html#track()">ThrowPropsPlugin.track()</a>
		 * or <code>VelocityTracker.track()</code> method). 
		 * 
		 * @param target The object whose property is being tracked. 
		 * @param prop The property name, like <code>"x"</code>. 
		 * @return The current velocity 
		 * @see #isTracking()
		 * @see #track()
		 * @see #untrack()
		 */
		public static function getVelocity(target:Object, prop:String):Number {
			var vt:VelocityTracker = VelocityTracker.getByTarget(target);
			return (vt != null) ? vt.getVelocity(prop) : NaN;
		}
		
		/** @private looks through an numeric array and finds the closest value to the number supplied. **/
		protected static function _getClosest(n:Number, values:Array, max:Number, min:Number):Number {
			var i:int = values.length,
				closest:int = 0,
				absDif:Number = _max,
				val:Number, dif:Number;
			while (--i > -1) {
				val = values[i];
				dif = val - n;
				if (dif < 0) {
					dif = -dif;
				}
				if (dif < absDif && val >= min && val <= max) {
					closest = i;
					absDif = dif;
				}
			}
			return values[closest];
		}
		
		/** @private takes and "end" value and if it's a function, it'll call the function and get the result. If it's an array, it'll find the closest match to the current end value. If it's a number, it'll just use that. Then, it'll return an object with "max" and "min" values set identically to the parsed end value.  **/
		protected static function _parseEnd(curProp:Object, end:Number, max:Number, min:Number):Object {
			if (curProp.end === "auto") {
				return curProp;
			}
			max = isNaN(max) ? _max : max;
			min = isNaN(min) ? -_max : min;
			var adjustedEnd:Number = (typeof(curProp.end) === "function") ? curProp.end(end) : (curProp.end is Array) ? _getClosest(end, curProp.end, max, min) : Number(curProp.end);
			return {max:adjustedEnd, min:adjustedEnd};
		}
		
		
		
		/**
		 * Automatically analyzes various throwProps variables (like <code>velocity</code>, <code>max</code>, <code>min</code>, 
		 * and <code>resistance</code>) and creates a TweenLite instance with the appropriate duration. You can use
		 * <code>ThrowPropsPlugin.to()</code> instead of <code>TweenLite.to()</code> to create
		 * a tween - they're identical except that <code>ThrowPropsPlugin.to()</code> doesn't have a 
		 * <code>duration</code> parameter (it figures it out for you) and it adds a few extra parameters
		 * to the end that can optionally be used to affect the duration.
		 * 
		 * <p>Another key difference is that <code>ThrowPropsPlugin.to()</code> will recognize the 
		 * <code>resistance</code> special property which basically controls how quickly each 
		 * property's velocity decelerates (and consequently influences the duration of the tween). 
		 * For example, if the initial <code>velocity</code> is 500 and the <code>resistance</code> 
		 * is 300, it will decelerate much faster than if the resistance was 20. You can define
		 * a <code>resistance</code> value either for each individual property in the <code>throwProps</code> 
		 * tween like this:</p><p><code>
		 * 
		 * ThrowPropsPlugin.to(mc, {throwProps:{x:{velocity:500, resistance:150}, y:{velocity:-300, resistance:50}}});
		 * </code></p>
		 * 
		 * <p><strong>OR</strong> you can define a single <code>resistance</code> value that will be used for all of the 
		 * properties in that particular <code>throwProps</code> tween like this:</p>
		 * 
		 * <listing version="3.0">
ThrowPropsPlugin.to(mc, {throwProps:{x:500, y:-300, resistance:150}});

//-OR- 

ThrowPropsPlugin.to(mc, {throwProps:{x:{velocity:500, max:800, min:0}, y:{velocity:-300, max:700, min:100}, resistance:150}});
</listing>
		 * 
		 * <p><code>resistance</code> should always be a positive value, although <code>velocity</code> can be negative. 
		 * <code>resistance</code> always works against <code>velocity</code>. If no <code>resistance</code> value is 
		 * found, the <code>ThrowPropsPlugin.defaultResistance</code> value will be used. The <code>resistance</code>
		 * values merely affect the duration of the tween and can be overriden by the <code>maxDuration</code> and 
		 * <code>minDuration</code> parameters. Think of the <code>resistance</code> as more of a suggestion that 
		 * ThrowPropsPlugin uses in its calculations rather than an absolute set-in-stone value. When there are multiple
		 * properties in one throwProps tween (like <code>x</code> and <code>y</code>) and the calculated duration
		 * for each one is different, the longer duration is always preferred in order to make things animate more 
		 * smoothly.</p>
		 * 
		 * <p>You also may want to impose some restrictions on the tween's duration (if the user drags incredibly 
		 * fast, for example, you might not want the tween to last 200 seconds). Use <code>maxDuration</code> and 
		 * <code>minDuration</code> parameters for that. You can use the <code>overshootTolerance</code>
		 * parameter to set a maximum number of seconds that can be added to the tween's duration (if necessary) to 
		 * accommodate temporarily overshooting the end value before smoothly returning to it at the end of the tween. 
		 * This can happen in situations where the initial velocity would normally cause it to exceed the <code>max</code> 
		 * or <code>min</code> values. An example of this would be in the iOS (iPhone or iPad) when you flick-scroll 
		 * so quickly that the content would shoot past the end of the scroll area. Instead of jerking to a sudden stop
		 * when it reaches the edge, the content briefly glides past the max/min position and gently eases back into place. 
		 * The larger the <code>overshootTolerance</code> the more leeway the tween has to temporarily shoot past the 
		 * max/min if necessary. </p>
		 * 
		 * <p>If you'd like to have ThrowPropsPlugin automatically track the velocity of certain properties for you
		 * and auto-populate them internally so that you don't have to pass <code>velocity</code> values in, 
		 * use the <code><a href="ThrowPropsPlugin.html#track()">track()</a></code> method.</p>
		 * 
		 * <p><strong>Valid properties for object syntax</strong></p>
		 * <ul>
		 * 	<li><strong>velocity</strong> : Number or <code>"auto"</code> - the initial velocity, measured in units per second (or per 
		 * 					frame for frames-based tweens). You may omit velocity or just use "auto" for 
		 * 					properties that are being tracked automatically using the <code><a href="ThrowPropsPlugin.html#track()">track()</a></code> method.</li>
		 * 	<li><strong>min</strong> : Number - the minimum end value of the property. For example, if you don't want 
		 * 					<code>x</code> to land at a value below 0, your throwProps may look like <code>{x:{velocity:-500, min:0}}</code></li>
		 * 	<li><strong>max</strong> : Number - the maximum end value of the property. For example, if you don't want 
		 * 					<code>x</code> to exceed 1024, your throwProps may look like <code>{x:{velocity:500, max:1024}}</code></li>
		 * 	<li><strong>end</strong> : [Number | Array | Function] - if <code>end</code> is defined as a <strong>Number</strong>, the 
		 * 					target will land EXACTLY there (just as if you set both the <code>max</code> and <code>min</code> to identical values). 
		 * 					If <code>end</code> is defined as a numeric <strong>Array</strong>, those values will be treated like "notches" or 
		 * 					"snap-to" values so that the closest one to the natural landing spot will be selected. For example, 
		 * 					if <code>[0,100,200]</code> is used, and the value would have naturally landed at 141, it will use the 
		 * 					closest number (100 in this case) and land there instead. If <code>end</code> is defined as a
		 * 					<strong>Function</strong>, that function will be called and passed the natural landing value
		 * 					as the only parameter, and your function can run whatever logic you want, and then return the 
		 * 					number at which it should land. This can be useful if, for example, you have a rotational tween
		 * 					and you want it to snap to 10-degree increments no matter how big or small, you could use
		 * 					a function that just rounds the natural value to the closest 10-degree increment. 
		 * 					So any of these are valid: <code>end:100</code> or <code>end:[0,100,200,300]</code>
		 * 					or <code>end:function(n:Number):Number { return Math.round(n / 10) ~~ 10; }</code></li>
		 *	<li><strong>resistance</strong> : Number - think of resistance like the rate of velocity decay. 
		 * 					If no <code>resistance</code> value is found, the <code>ThrowPropsPlugin.defaultResistance</code> 
		 * 					value will be used. The <code>resistance</code> values merely affect the duration of the tween 
		 * 					and can be overriden by the <code>maxDuration</code> and <code>minDuration</code> parameters.</li>
		 * </ul>
		 * 
		 * 
		 * @param target Target object whose properties the tween affects. This can be ANY object, not just a DisplayObject. 
		 * @param vars An object containing the end values of the properties you're tweening, and it must also contain a <code>throwProps</code> object. For example, to create a tween that tweens <code>mc.x</code> at an initial velocity of 500 and <code>mc.y</code> at an initial velocity of -300 and applies a <code>resistance</code> of 80 and uses the <code>Strong.easeOut</code> easing equation and calls the method <code>tweenCompleteHandler</code> when it is done, the <code>vars</code> object would look like: <code>{throwProps:{x:500, y:-300, resistance:80}, ease:Strong.easeOut, onComplete:tweenCompleteHandler}</code>.
		 * @param maxDuration Maximum duration of the tween
		 * @param minDuration Minimum duration of the tween
		 * @param overshootTolerance sets a maximum number of seconds that can be added to the tween's duration (if necessary) to 
		 * accommodate temporarily overshooting the end value before smoothly returning to it at the end of the tween. 
		 * This can happen in situations where the initial velocity would normally cause it to exceed the <code>max</code> 
		 * or <code>min</code> values. An example of this would be in the iOS (iPhone or iPad) when you flick-scroll 
		 * so quickly that the content would shoot past the end of the scroll area. Instead of jerking to a sudden stop
		 * when it reaches the edge, the content briefly glides past the max/min position and gently eases back into place. 
		 * The larger the <code>overshootTolerance</code> the more leeway the tween has to temporarily shoot past the 
		 * max/min if necessary.
		 * @return TweenLite instance
		 * 
		 * @see #track()
		 * @see #untrack()
		 * @see #isTracking()
		 * @see #defaultResistance
		 */
		static public function to(target:Object, vars:Object, maxDuration:Number=100, minDuration:Number=0.25, overshootTolerance:Number=1):TweenLite {
			if (!("throwProps" in vars)) {
				vars = {throwProps:vars};
			}
			return new TweenLite(target, calculateTweenDuration(target, vars, maxDuration, minDuration, overshootTolerance), vars);
		}
		
		/**
		 * Determines the amount of change given a particular velocity, an easing equation, 
		 * and the duration that the tween will last. This is useful for plotting the resting position
		 * of an object that starts out at a certain velocity and decelerates based on an ease (like 
		 * <code>Strong.easeOut</code>). 
		 * 
		 * @param velocity The initial velocity
		 * @param ease The easing equation (like <code>Strong.easeOut</code> or <code>Power2.easeOut</code>).
		 * @param duration The duration (in seconds) of the tween
		 * @param checkpoint A value between 0 and 1 (typically 0.05) that is used to measure an easing equation's initial strength. The goal is for the value to have moved at the initial velocity through that point in the ease. So 0.05 represents 5%. If the initial velocity is 500, for example, and the ease is <code>Strong.easeOut</code> and <code>checkpoint</code> is 0.05, it will measure 5% into that ease and plot the position that would represent where the value would be if it was moving 500 units per second for the first 5% of the tween. If you notice that your tween appears to start off too fast or too slow, try adjusting the <code>checkpoint</code> higher or lower slightly. Typically 0.05 works great. 
		 * @return The amount of change (can be positive or negative based on the velocity)
		 */
		public static function calculateChange(velocity:Number, ease:*, duration:Number, checkpoint:Number=0.05):Number {
			var e:Ease = (ease is Ease) ? Ease(ease) : (ease is Function) ? new Ease(Function(ease)) : TweenLite.defaultEase;
			return (duration * checkpoint * velocity) / e.getRatio(checkpoint);
		}
		
		/**
		 * Calculates the duration (in seconds) that it would take to move from a particular start value
		 * to an end value at the given initial velocity, decelerating according to a certain easing 
		 * equation (like <code>Strong.easeOut</code>). 
		 * 
		 * @param start Starting value
		 * @param end Ending value
		 * @param velocity the initial velocity at which the starting value is changing
		 * @param ease The easing equation used for deceleration (like <code>Strong.easeOut</code> or <code>Power2.easeOut</code>).
		 * @param checkpoint A value between 0 and 1 (typically 0.05) that is used to measure an easing equation's initial strength. The goal is for the value to have moved at the initial velocity through that point in the ease. So 0.05 represents 5%. If the initial velocity is 500, for example, and the ease is <code>Strong.easeOut</code> and <code>checkpoint</code> is 0.05, it will measure 5% into that ease and plot the position that would represent where the value would be if it was moving 500 units per second for the first 5% of the tween. If you notice that your tween appears to start off too fast or too slow, try adjusting the <code>checkpoint</code> higher or lower slightly. Typically 0.05 works great. 
		 * @return The duration (in seconds) that it would take to move from the start value to the end value at the initial velocity provided, decelerating according to the ease. 
		 */
		public static function calculateDuration(start:Number, end:Number, velocity:Number, ease:*, checkpoint:Number=0.05):Number {
			var e:Ease = (ease is Ease) ? Ease(ease) : (ease is Function) ? new Ease((ease as Function)) : TweenLite.defaultEase;
			return Math.abs( (end - start) * e.getRatio(checkpoint) / velocity / checkpoint );
		}
		
		/**
		 * Analyzes various throwProps variables (like initial velocities, max/min values, 
		 * and resistance) and determines the appropriate duration. Typically it is best to 
		 * use the <code>ThrowPropsPlugin.to()</code> method for this, but <code>calculateTweenDuration()</code>
		 * could be convenient if you want to create a TweenMax instance instead of a TweenLite instance
		 * (which is what <code>throwPropsPlugin.to()</code> returns).
		 * 
		 * @param target Target object whose properties the tween affects. This can be ANY object, not just a DisplayObject. 
		 * @param vars An object containing the end values of the properties you're tweening, and it must also contain a <code>throwProps</code> object. For example, to create a tween that tweens <code>mc.x</code> at an initial velocity of 500 and <code>mc.y</code> at an initial velocity of -300 and applies a <code>resistance</code> of 80 and uses the <code>Strong.easeOut</code> easing equation and calls the method <code>tweenCompleteHandler</code> when it is done, the <code>vars</code> object would look like: <code>{throwProps:{x:500, y:-300, resistance:80}, ease:Strong.easeOut, onComplete:tweenCompleteHandler}</code>.
		 * @param maxDuration Maximum duration (in seconds)
		 * @param minDuration Minimum duration (in seconds)
		 * @param overshootTolerance sets a maximum number of seconds that can be added to the tween's duration (if necessary) to 
		 * accommodate temporarily overshooting the end value before smoothly returning to it at the end of the tween. 
		 * This can happen in situations where the initial velocity would normally cause it to exceed the <code>max</code> 
		 * or <code>min</code> values. An example of this would be in the iOS (iPhone or iPad) when you flick-scroll 
		 * so quickly that the content would shoot past the end of the scroll area. Instead of jerking to a sudden stop
		 * when it reaches the edge, the content briefly glides past the max/min position and gently eases back into place. 
		 * The larger the <code>overshootTolerance</code> the more leeway the tween has to temporarily shoot past the 
		 * max/min if necessary.
		 * @return The duration (in seconds) that the tween should use. 
		 */
		public static function calculateTweenDuration(target:Object, vars:Object, maxDuration:Number=10, minDuration:Number=0.2, overshootTolerance:Number=1):Number {
			var duration:Number = 0,
				clippedDuration:Number = 9999999999,
				throwPropsVars:Object = ("throwProps" in vars) ? vars.throwProps : vars,
				ease:Ease = (vars.ease is Ease) ? Ease(vars.ease) : (vars.ease is Function) ? new Ease((vars.ease as Function)) : TweenLite.defaultEase,
				checkpoint:Number = ("checkpoint" in throwPropsVars) ? Number(throwPropsVars.checkpoint) : 0.05,
				resistance:Number = ("resistance" in throwPropsVars) ? Number(throwPropsVars.resistance) : defaultResistance,
				curProp:Object, curDuration:Number, curVelocity:Number, curResistance:Number, curVal:Number, end:Number, curClippedDuration:Number, tracker:VelocityTracker, p:String;
			for (p in throwPropsVars) {
				
				if (p != "resistance" && p != "checkpoint") {
					curProp = throwPropsVars[p];
					if (typeof(curProp) !== "object") {
						tracker = tracker || VelocityTracker.getByTarget(target);
						if (tracker && tracker.isTrackingProp(p)) {
							curProp = (typeof(curProp) === "number") ? {velocity:curProp} : {velocity:tracker.getVelocity(p)}; //if we're tracking this property, we should use the tracking velocity and then use the numeric value that was passed in as the min and max so that it tweens exactly there.
						} else {
							curVelocity = Number(curProp) || 0;
							curDuration = (curVelocity * resistance > 0) ? curVelocity / resistance : curVelocity / -resistance;
						}
					}
					if (typeof(curProp) === "object") {
						if ("velocity" in curProp) {
							curVelocity = Number(curProp.velocity) || 0;
						} else {
							tracker = tracker || VelocityTracker.getByTarget(target);
							curVelocity =  (tracker && tracker.isTrackingProp(p)) ? tracker.getVelocity(p) : 0;
						}
						curResistance = ("resistance" in curProp) ? Number(curProp.resistance) : resistance;
						curDuration = (curVelocity * curResistance > 0) ? curVelocity / curResistance : curVelocity / -curResistance;
						curVal = (target[p] is Function) ? target[ ((p.indexOf("set") || !("get" + p.substr(3) in target)) ? p : "get" + p.substr(3)) ]() : target[p];
						end = curVal + calculateChange(curVelocity, ease, curDuration, checkpoint);
						if ("end" in curProp) {
							curProp = _parseEnd(curProp, end, curProp.max, curProp.min);
						}
						if ("max" in curProp && end > Number(curProp.max)) {
							//if the value is already exceeding the max or the velocity is too low, the duration can end up being uncomfortably long but in most situations, users want the snapping to occur relatively quickly (0.75 seconds), so we implement a cap here to make things more intuitive.
							curClippedDuration = (curVal > curProp.max || (curVelocity > -15 && curVelocity < 45)) ? (minDuration + (maxDuration - minDuration) * 0.1) : calculateDuration(curVal, curProp.max, curVelocity, ease, checkpoint);
							if (curClippedDuration + overshootTolerance < clippedDuration) {
								clippedDuration = curClippedDuration + overshootTolerance;
							}
							
						} else if ("min" in curProp && end < Number(curProp.min)) {
							//if the value is already exceeding the min or if the velocity is too low, the duration can end up being uncomfortably long but in most situations, users want the snapping to occur relatively quickly (0.75 seconds), so we implement a cap here to make things more intuitive.
							curClippedDuration = (curVal < curProp.min || (curVelocity > -45 && curVelocity < 15)) ? (minDuration + (maxDuration - minDuration) * 0.1) : calculateDuration(curVal, curProp.min, curVelocity, ease, checkpoint);
							if (curClippedDuration + overshootTolerance < clippedDuration) {
								clippedDuration = curClippedDuration + overshootTolerance;
							}
						}
						
						if (curClippedDuration > duration) {
							duration = curClippedDuration;
						}
					}
					
					if (curDuration > duration) {
						duration = curDuration;
					}
					
				}
			}
			if (duration > clippedDuration) {
				duration = clippedDuration;
			}
			if (duration > maxDuration) {
				return maxDuration;
			} else if (duration < minDuration) {
				return minDuration;
			}
			return duration;
		}
	
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			_target = target;
			_props = [];
			var ease:Ease = tween._ease,
				checkpoint:Number = Number(value.checkpoint) || 0.05, 
				duration:Number = tween._duration, 
				cnt:uint = 0,
				p:String, curProp:Object, velocity:Number, change1:Number, curVal:Number, isFunc:Boolean, end:Number, change2:Number, tracker:VelocityTracker;
			for (p in value) {
				if (p != "resistance" && p != "checkpoint") {
					curProp = value[p];					
					if (typeof(curProp) === "number") {
						velocity = Number(curProp) || 0;
					} else if (("velocity" in curProp) && curProp.velocity !== "auto") {
						velocity = Number(curProp.velocity) || 0;
					} else {
						tracker = tracker || VelocityTracker.getByTarget(target);
						if (tracker && tracker.isTrackingProp(p)) {
							velocity = tracker.getVelocity(p);
						} else {
							trace("ERROR: No velocity was defined in the throwProps tween of " + target + " property: " + p);
							velocity = 0;
						}
					}
					change1 = calculateChange(velocity, ease, duration, checkpoint);
					change2 = 0;
					isFunc = (_target[p] is Function);
					curVal = (isFunc) ? _target[ ((p.indexOf("set") || !("get" + p.substr(3) in _target)) ? p : "get" + p.substr(3)) ]() : _target[p];
					if (typeof(curProp) != "number") {
						end = curVal + change1;
						if ("end" in curProp) {
							curProp = _parseEnd(curProp, end, curProp.max, curProp.min);
						}
						if ("max" in curProp && Number(curProp.max) < end) {
							change2 = (curProp.max - curVal) - change1;
							
						} else if ("min" in curProp && Number(curProp.min) > end) {							
							change2 = (curProp.min - curVal) - change1;
						}
					}
					_props[cnt++] = new ThrowProp(p, curVal, change1, change2, isFunc);
					_overwriteProps[cnt] = p;
				}
			}
			return true;
		}
				
		/** @private **/
		override public function _kill(lookup:Object):Boolean {
			var i:int = _props.length;
			while (--i > -1) {
				if (lookup[_props[i].p] != null) {
					_props.splice(i, 1);
				}
			}
			return super._kill(lookup);
		}
		
		/** @private **/
		override public function _roundProps(lookup:Object, value:Boolean=true):void {
			var i:int = _props.length;
			while (--i > -1) {
				if ("throwProps" in lookup || _props[i].p in lookup) {
					_props[i].r = value;
				}
			}
		}
		
		/** @private **/
		override public function setRatio(v:Number):void {
			var i:int = _props.length, 
				cp:ThrowProp, val:Number;
			while (--i > -1) {
				cp = _props[i];
				val = cp.s + cp.c1 * v + cp.c2 * v * v;
				if (cp.r) {
					val = (val + ((val > 0) ? 0.5 : -0.5)) | 0;
				}
				if (cp.f) {
					_target[cp.p](val);
				} else {
					_target[cp.p] = val;
				}
			}	
		}
		
	}
}

/** @private **/
internal class ThrowProp {
	public var p:String;
	public var s:Number;
	public var c1:Number;
	public var c2:Number;
	public var f:Boolean;
	public var r:Boolean;
	
	public function ThrowProp(property:String, start:Number, change1:Number, change2:Number, isFunc:Boolean) {
		this.p = property;
		this.s = start;
		this.c1 = change1;
		this.c2 = change2;
		this.f = isFunc;
	}	
	
}