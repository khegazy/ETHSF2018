/**
 * VERSION: 0.1.1
 * DATE: 2012-07-01
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.utils {
	import flash.events.Event;
	import flash.utils.getTimer;
	import com.greensock.core.Animation;
/**
 * Allows you to have the velocity of particular properties automatically tracked for you
 * so that you can access them anytime using the VelocityTracker's <code>getVelocity()</code> 
 * method, like <code>myTracker.getVelocity("y")</code>. For example, let's say there's an object that the 
 * user interacts with by dragging it or maybe it is being tweened and then at some point you want
 * to create a tween based on that velocity. Normally, you'd need to write your own tracking code 
 * that records that object's <code>x</code> and <code>y</code> properties (as well as time stamps) 
 * so that when it comes time to feed the <code>velocity</code> into whatever other code you need to run, 
 * you'd have the necessary data to calculate it. But let's face it: that can be cumbersome to do manually, 
 * and that's precisely why VelocityTracker exists.
 * 
 * <p>Use the static <code>VelocityTracker.track()</code> method to start tracking properties. <i>You generally 
 * should <strong>not</strong> use the VelocityTracker's constructor because there needs to only be one 
 * VelocityTracker instance associated with any particular object.</i> The <code>track()</code> method will 
 * return the instance that you can then use to <code>getVelocity()</code> like:</p>
 * 
 * <listing version="3.0">
//first, start tracking "x" and "y":
var tracker:VelocityTracker = VelocityTracker.track(obj, "x,y");
 
//then, after at least 100ms and 2 "ticks", we can get the velocity of each property:
var vx:Number = tracker.getVelocity("x");
var vy:Number = tracker.getVelocity("y");
 </listing>
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
 * <p>This class is used in <code>ThrowPropsPlugin</code> to make it easy to create velocity-based tweens
 * that smoothly transition an object's movement (or rotation or whatever) and glide to a stop.</p>
 * 
 * <p>Note: In order to report accurately, at least 100ms and 2 ticks of the core tweening engine must have been elapsed before you check velocity.</p>
 * 
 * <p><strong>Copyright 2008-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	final public class VelocityTracker {
		/** @private **/
		public static var _first:VelocityTracker;
		/** @private **/
		public static var _initted:Boolean;
		/** @private **/
		public static var _time1:Number;
		/** @private **/
		public static var _time2:Number;
		/** Returns the target object with which the VelocityTracker is associated. **/
		public var target:Object;
		/** @private **/
		public var _firstVP:VelocityProp;
		/** @private **/
		public var _next:VelocityTracker;
		/** @private **/
		public var _prev:VelocityTracker;
		/** @private **/
		public var _lookup:Object;
		
		/**
		 * @private
		 * Constructor. Don't use this directly - instead, use the static <code>VelocityTracker.track()</code> 
		 * method because there needs to only be one VelocityTracker instance associated with any particular object.
		 * 
		 * @param target Target object
		 */
		public function VelocityTracker(target:Object) {
			_lookup = {};
			this.target = target;
			if (!_initted) {
				Animation.ticker.addEventListener(Event.ENTER_FRAME, _update, false, -100, true);
				_time1 = _time2 = getTimer();
				_initted = true;
			}
			if (_first) {
				_next = _first;
				_first._prev = this;
			}
			_first = this;
		}
		
		/**
		 * Adds a property to track
		 * 
		 * @param type <code>"rad"</code> for radian-based rotation or <code>"deg"</code> for degree-based rotation - this is only useful to define if the property is rotation-related and you'd like to have VelocityTracker compensate for artificial jumps in the value when the rotational midline is crossed, like when rotation goes from 179 to -178 degrees it would interpret that as a change of 3 instead of 357 degrees. Leave this blank unless you want the rotational compensation.
		 */
		public function addProp(prop:String, type:String="num"):void {
			if (!_lookup[prop]) {
				var isFunc:Boolean = (typeof(this.target[prop]) === "function"),
					alt:String = isFunc ? _altProp(prop) : prop;
				_firstVP = _lookup[prop] = _lookup[alt] = new VelocityProp((alt !== prop && prop.indexOf("set") === 0) ? alt : prop, isFunc, _firstVP);
				_firstVP.v1 = _firstVP.v2 = isFunc ? this.target[_firstVP.p]() : this.target[_firstVP.p];
				_firstVP.type = type;
			}
		}
		
		/**
		 * Stops tracking a particular property
		 * 
		 * @param prop the property name to stop tracking
		 */
		public function removeProp(prop:String):void {
			var vp:VelocityProp = _lookup[prop];
			if (vp != null) {
				if (vp._prev) {
					vp._prev._next = vp._next;
				} else if (vp === _firstVP) {
					_firstVP = vp._next;
				}
				if (vp._next) {
					vp._next._prev = vp._prev;
				}
				_lookup[prop] = 0;
				if (vp.f) {
					_lookup[_altProp(prop)] = 0;
				}
			}
		}
		
		private function _altProp(p:String):String {
			var pre:String = p.substr(0, 3),
				alt:String = ((pre === "get") ? "set" : (pre === "set") ? "get" : pre) + p.substr(3);
			return (typeof(this.target[alt]) === "function") ? alt : p;
		}
		
		/**
		 * Allows you to discern whether the velocity of a particular property is being tracked.
		 * 
		 * @param prop the name of the property to check, like <code>"x"</code> or <code>"y"</code>. 
		 * @return <code>true</code> if the target/property is being tracked, <code>false</code> if not.
		 * @see #addProp()
		 * @see #removeProp()
		 */
		public function isTrackingProp(prop:String):Boolean {
			return (_lookup[prop] is VelocityProp);
		}
		
		/** @private **/
		private static function _update(event:Event):void {
			var vt:VelocityTracker = _first,
				t:uint = getTimer(),
				vp:VelocityProp;
			//if the frame rate is too high, we won't be able to track the velocity as well, so only update the values 33 times per second
			if (t - _time1 >= 30) {
				_time2 = _time1;
				_time1 = t;
				while (vt) {
					vp = vt._firstVP;
					while (vp) {
						vp.v2 = vp.v1;
						vp.v1 = vp.f ? vt.target[vp.p]() : vt.target[vp.p];
						vp = vp._next;
					}
					vt = vt._next;
				}
			}
		}
		
		/**
		 * Returns the VelocityTracker associated with a particular object. If none exists, 
		 * <code>null</code> will be returned.
		 * 
		 * @param target The object whose VelocityTracker should be returned
		 * @return the VelocityTracker associated with the object (or <code>null</code> if none exists)
		 */
		public static function getByTarget(target:Object):VelocityTracker {
			var vt:VelocityTracker = _first;
			while (vt) {
				if (vt.target === target) {
					return vt;
				}
				vt = vt._next;
			}
			return null;
		}
		
		/**
		 * Returns the current velocity of the given property.
		 * 
		 * @param prop Property name (like <code>"x"</code>)
		 * @return The current velocity
		 */
		public function getVelocity(prop:String):Number {
			var vp:VelocityProp = _lookup[prop],
				dif:Number, rotationCap:Number;
			if (!vp) {
				throw new Error("The velocity of " + prop + " is not being tracked.");
			}
			dif = (vp.v1 - vp.v2);
			if (vp.type === "rad" || vp.type === "deg") { //rotational values need special interpretation so that if, for example, they go from 179 to -178 degrees it is interpreted as a change of 3 instead of -357.
				rotationCap = (vp.type === "rad") ? Math.PI * 2 : 360;
				dif = dif % rotationCap;
				if (dif !== dif % (rotationCap / 2)) {
					dif = (dif < 0) ? dif + rotationCap : dif - rotationCap;
				}
			}
			return dif / ((_time1 - _time2) / 1000);
		}
		
		/**
		 * Allows you to have the velocity of particular properties automatically tracked for you
		 * so that you can access them anytime using the VelocityTracker's <code>getVelocity()</code> 
		 * method, like <code>myTracker.getVelocity("y")</code>. For example, let's say there's an object that the 
		 * user interacts with by dragging it or maybe it is being tweened and then at some point you want
		 * to create a tween that smoothly continues that motion and glides to
		 * a rest. Normally, you'd need to write your own tracking code that records that object's <code>x</code>
		 * and <code>y</code> properties (as well as time stamps) so that when it comes time to feed the 
		 * <code>velocity</code> into the tween, you'd have the necessary data to 
		 * calculate it. But let's face it: that can be cumbersome to do manually, and that's precisely why
		 * the <code>track()</code> method exists. 
		 * 
		 * <p>Just feed in the <code>target</code> and a comma-delimited list of properties that you want
		 * tracked like this:</p><p><code>
		 * 
		 * var tracker:VelocityTracker = VelocityTracker.track(obj, "x,y");</code></p>
		 * 
		 * <p>Then every time the core tweening engine updates (at whatever frame rate you're running), 
		 * the <code>x</code> and <code>y</code> values (or whichever properties you define) will be recorded 
		 * along with time stamps (it keeps a maximum of 2 of these values and keeps writing over the previous
		 * ones, so don't worry about memory buildup). This even works with properties that are function-based, like 
		 * getters and setters.</p>
		 * 
		 * <p>Then, after at least 100ms and 2 "ticks" of the core engine have elapsed (so that some data has been recorded),
		 * you can use the VelocityTracker's <code>getVelocity()</code> method to get the current velocity of a particular 
		 * property.</p>
		 * 
		 * <listing version="3.0">
//first, start tracking "x" and "y":
var tracker:VelocityTracker = VelocityTracker.track(obj, "x,y");
 
//then, after at least 100ms, we can get the velocity:
var vx:Number = tracker.getVelocity("x");
var vy:Number = tracker.getVelocity("y");
 </listing>
		 * 
		 * <p><strong>IMPORTANT:</strong> you should <code>untrack()</code> properties when you no longer 
		 * need them tracked in order to maximize performance and ensure things are released for garbage collection. 
		 * To untrack, simply use the <code>untrack()</code> method:</p>
		 * 
		 * <listing version="3.0">
//stop tracking only the "x" property: 
VelocityTracker.untrack(obj, "x");
 
//stop tracking "x" and "y":
VelocityTracker.untrack(obj, "x,y");
 
//stop tracking all properties of obj:
VelocityTracker.untrack(obj);
		 </listing>
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
		 * @param target the target object whose properties will be tracked
		 * @param props a comma-delimited list of property names, like <code>"y"</code> or <code>"x,y"</code>
		 * @param types a comma-delimited list of property types (only helpful if they are rotation-based), <code>"rad"</code> for radian-based rotation or <code>"deg"</code> for degree-based rotation - this is only useful you'd like to have VelocityTracker compensate for artificial jumps in rotational values when the rotational midline is crossed, like when rotation goes from 179 to -178 degrees it would interpret that as a change of 3 instead of 357 degrees. Leave this blank unless you want the rotational compensation. You can use <code>"num"</code> to indicate normal numeric behavior (or leave it blank). 
		 * @return a VelocityTracker object that's responsible for doing the tracking. 
		 * @see #untrack()
		 * @see #isTracking()
		 */
		public static function track(target:Object, props:String, types:String="num"):VelocityTracker {
			var vt:VelocityTracker = getByTarget(target),
				a:Array = props.split(","),
				t:Array = (types || "").split(","),
				i:int = a.length;
			if (vt == null) {
				vt = new VelocityTracker(target);
			}
			while (--i > -1) {
				vt.addProp(a[i], t[i] || t[0]);
			}
			return vt;
		}
		
		/**
		 * Stops tracking the velocity of certain properties (or all properties of an object), like ones initiated with
		 * the <code>track()</code> method.
		 * 
		 * <listing version="3.0">
//starts tracking "x" and "y":
var tracker:VelocityTracker = VelocityTracker.track(obj, "x,y");
 
//stops tracking only the "x" property: 
VelocityTracker.untrack(obj, "x");
 
//stops tracking "x" and "y":
VelocityTracker.untrack(obj, "x,y");
 
//stops tracking all properties of obj:
VelocityTracker.untrack(obj);

//or you can use the removeProp() method directly on the VelocityTracker instance to remove one at a time:
tracker.removeProp("x");
		 </listing>
		 * 
		 * @param target the target object whose properties should stop being tracked
		 * @param props a comma-delimited list of properties to stop tracking. If <code>null</code>, ALL properties of the <code>target</code> will stop being tracked. 
		 * @see #track()
		 * @see #isTracking()
		 * @see #removeProp()
		 */
		public static function untrack(target:Object, props:String=null):void {
			var vt:VelocityTracker = getByTarget(target),
				a:Array = String(props || "").split(","),
				i:int = a.length;
			if (vt == null) {
				return;
			}
			while (--i > -1) {
				vt.removeProp(a[i]);
			}
			if (!vt._firstVP || props == null) {
				if (vt._prev) {
					vt._prev._next = vt._next;
				} else if (vt == _first) {
					_first = vt._next;
				}
				if (vt._next) {
					vt._next._prev = vt._prev;
				}
			}
		}
		
		/**
		 * Allows you to discern whether the velocity of a particular target or one of its properties is being tracked 
		 * (typically initiated using the <code>VelocityTracker.track()</code> method). 
		 * 
		 * @param target The target object
		 * @param prop the name of the property to check, like <code>"x"</code> or <code>"y"</code>. 
		 * @return <code>true</code> if the target/property is being tracked, <code>false</code> if not.
		 * @see #track()
		 * @see #untrack()
		 * @see #removeProp()
		 * @see #addProp()
		 */
		public static function isTracking(target:Object, prop:String=null):Boolean {
			var vt:VelocityTracker = getByTarget(target);
			return (vt == null) ? false : (prop == null && vt._firstVP) ? true : vt.isTrackingProp(prop);
		}
		
	}
}

internal class VelocityProp {
	public var p:String;
	public var f:Boolean;
	public var v1:Number;
	public var v2:Number;
	public var type:String;
	public var _next:VelocityProp;
	public var _prev:VelocityProp;
	
	public function VelocityProp(p:String, isFunc:Boolean, next:VelocityProp=null) {
		this.p = p;
		this.f = isFunc;
		if (next) {
			this._next = next;
			next._prev = this;
		}
	}
	
}