/**
 * VERSION: 12.0.5
 * DATE: 2013-03-27
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.TweenLite;
	import com.greensock.core.Animation;
	import com.greensock.core.SimpleTimeline;
	
	import flash.display.DisplayObject;
/**
 * Provides simple physics functionality for tweening an Object's x and y coordinates based on a
 * combination of velocity, angle, gravity, acceleration, accelerationAngle, and/or friction. It is not intended
 * to replace a full-blown physics engine and does not offer collision detection, but serves 
 * as a way to easily create interesting physics-based effects with the GreenSock animation platform. Parameters
 * are not intended to be dynamically updateable, but one unique convenience is that everything is reverseable. 
 * So if you spawn a bunch of particle tweens, for example, and throw them into a TimelineLite, you could
 * simply call <code>reverse()</code> on the timeline to watch the particles retrace their steps right back to the beginning. 
 * Keep in mind that any easing equation you define for your tween will be completely ignored for these properties.
 * 
 * 	<ul>
 * 		<li><strong>velocity</strong> : Number - the initial velocity of the object measured in pixels per time 
 * 								unit (usually seconds, but for tweens where useFrames is true, it would 
 * 								be measured in frames). (Default: <code>0</code>)</li>
 * 
 * 		<li><strong>angle</strong> : Number - the initial angle (in degrees) at which the object should travel. 
 * 								This only matters when a <code>velocity</code> is defined. For example, if the object 
 * 								should start out traveling at -60 degrees (towards the upper right), the <code>angle</code>
 * 								would be -60. (Default: <code>0</code>)</li>
 * 
 * 		<li><strong>gravity</strong> : Number - the amount of downward acceleration applied to the object, typically measured
 * 								in pixels per second (or for tweens where <code>useFrames</code>
 * 								is <code>true</code>, it would be measured per frame). You can <b>either</b> use <code>gravity</code>
 * 								<b>or</b> <code>acceleration</code>, not both because gravity is the same thing
 * 								as acceleration applied at an <code>accelerationAngle</code> of 90. Think of <code>gravity</code>
 * 								as a convenience property that automatically sets the <code>accelerationAngle</code> 
 * 								for you. (Default: <code>null</code>)</li>
 * 
 * 		<li><strong>acceleration</strong> : Number - the amount of acceleration applied to the object, typically measured
 * 								in pixels per second (or for tweens where <code>useFrames</code> is <code>true</code>, it 
 * 								would be measured per frame). To apply the acceleration in a specific
 * 								direction that is different than the <code>angle</code>, use the <code>accelerationAngle</code>
 * 								property. You can <b>either</b> use <code>gravity</code>
 * 								<b>or</b> <code>acceleration</code>, not both because gravity is the same thing
 * 								as acceleration applied at an <code>accelerationAngle</code> of 90. (Default: <code>null</code>)</li>
 * 
 * 		<li><strong>accelerationAngle</strong> : Number - the angle at which acceleration is applied (if any), measured in degrees. 
 * 								So if, for example, you want the object to accelerate towards the left side of the
 * 								screen, you'd use an <code>accelerationAngle</code> of 180. If you define a
 * 								<code>gravity</code> value, it will automatically set the <code>accelerationAngle</code>
 * 								to 90 (downward). (Default: <code>null</code>)</li>
 * 
 * 		<li><strong>friction</strong> : Number - a value between 0 and 1 where 0 is no friction, 0.08 is a small amount of
 * 								friction, and 1 will completely prevent any movement. This is not meant to be precise or 
 * 								scientific in any way, but it serves as an easy way to apply a friction-like
 * 								physics effect to your tween. Generally it is best to experiment with this number a bit - start with 
 * 								very small values like 0.02. Also note that friction requires more processing than physics 
 * 								tweens without any friction. (Default: <code>0</code>)</li>
 * 
 * 		<li><strong>xProp</strong> : String - By default, the <code>"x"</code> property of the target object is used to control 
 * 								x-axis movement, but if you'd prefer to use a different property name, use <code>xProp</code> 
 * 								like <code>xProp:"left"</code>. (Default: <code>"x"</code>)</li>
 * 
 * 		<li><strong>yProp</strong> : String - By default, the <code>"y"</code> property of the target object is used to control 
 * 								y-axis movement, but if you'd prefer to use a different property name, use <code>yProp</code> 
 * 								like <code>yProp:"top"</code>. (Default: <code>"y"</code>)</li>
 * 	</ul>
 * 
 * 
 * <p><b>USAGE:</b></p>
 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.plugins.TweenPlugin; 
import com.greensock.plugins.Physics2DPlugin; 
TweenPlugin.activate([Physics2DPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 2, {physics2D:{velocity:300, angle:-60, gravity:400}});

//--OR--

TweenLite.to(mc, 2, {physics2D:{velocity:300, angle:-60, friction:0.1}}); 

//--OR--

TweenLite.to(mc, 2, {physics2D:{velocity:300, angle:-60, acceleration:50, accelerationAngle:180}}); 
</listing>
 * 
 * <p>Physics2DPlugin is a <a href="http://www.greensock.com/club/" target="_blank">Club GreenSock</a> membership benefit. You must have a valid membership to use this class
 * without violating the terms of use. Visit <a href="http://www.greensock.com/club/" target="_blank">http://www.greensock.com/club/</a> to sign up or get more details.</p>
 * 
 * <p><strong>Copyright 2008-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class Physics2DPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private precomputed for speed **/
		private static const _DEG2RAD:Number = Math.PI / 180;
		
		/** @private **/
		protected var _tween:TweenLite;
		/** @private **/
		protected var _target:Object;
		/** @private **/
		protected var _x:Physics2DProp;
		/** @private **/
		protected var _y:Physics2DProp;
		/** @private **/
		protected var _skipX:Boolean;
		/** @private **/
		protected var _skipY:Boolean;
		/** @private **/
		protected var _friction:Number;
		/** @private **/
		protected var _runBackwards:Boolean;
		/** @private **/
		protected var _step:uint; 
		/** @private for tweens with friction, we need to iterate through steps. frames-based tweens will iterate once per frame, and seconds-based tweens will iterate 30 times per second. **/
		protected var _stepsPerTimeUnit:uint = 30;
		
		
		public function Physics2DPlugin() {
			super("physics2D");
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			_target = target;
			_tween = tween;
			_runBackwards = Boolean(_tween.vars.runBackwards == true);
			_step = 0;
			var tl:SimpleTimeline = _tween._timeline;
			while (tl._timeline) {
				tl = tl._timeline;
			}
			if (tl == Animation._rootFramesTimeline) { //indicates the tween uses frames instead of seconds.
				_stepsPerTimeUnit = 1;
			}
			
			var angle:Number = Number(value.angle) || 0,
				velocity:Number = Number(value.velocity) || 0,
				acceleration:Number = Number(value.acceleration) || 0,
				xProp:String = value.xProp || "x",
				yProp:String = value.yProp || "y",
				aAngle:Number = (value.accelerationAngle || value.accelerationAngle == 0) ? Number(value.accelerationAngle) : angle;
			if (value.gravity) {
				acceleration = Number(value.gravity);
				aAngle = 90;
			}
			angle *= _DEG2RAD;
			aAngle *= _DEG2RAD;
			_overwriteProps.push(xProp);
			_overwriteProps.push(yProp);
			_friction = 1 - Number(value.friction || 0);
			_x = new Physics2DProp(_target, xProp, Math.cos(angle) * velocity, Math.cos(aAngle) * acceleration, _stepsPerTimeUnit);
			_y = new Physics2DProp(_target, yProp, Math.sin(angle) * velocity, Math.sin(aAngle) * acceleration, _stepsPerTimeUnit);
			return true;
		}
		
		/** @private **/
		override public function _kill(lookup:Object):Boolean {
			if (_x.p in lookup) {
				_skipX = true;
			}
			if (_y.p in lookup) {
				_skipY = true;
			}
			return super._kill(lookup);
		}
		
		/** @private **/
		override public function _roundProps(lookup:Object, value:Boolean=true):void {
			if (("physics2D" in lookup) || (_x.p in lookup)) {
				_x.r = value;
			}
			if (("physics2D" in lookup) || (_y.p in lookup)) {
				_y.r = value;
			}
		}
		
		/** @private **/
		override public function setRatio(v:Number):void {
			var time:Number = _tween._time, 
				x:Number, y:Number, tt:Number, steps:int, remainder:Number, j:int;
			if (_runBackwards == true) {
				time = _tween._duration - time;
			}
			if (_friction == 1) {
				tt = time * time * 0.5;
				x = _x.start + ((_x.velocity * time) + (_x.acceleration * tt));
				y = _y.start + ((_y.velocity * time) + (_y.acceleration * tt));
			} else {
				steps = int(time * _stepsPerTimeUnit) - _step;
				remainder = ((time * _stepsPerTimeUnit) % 1);
				if (steps >= 0) { 	//going forward
					j = steps;
					while (--j > -1) {
						_x.v += _x.a;
						_y.v += _y.a;
						_x.v *= _friction;
						_y.v *= _friction;
						_x.value += _x.v;
						_y.value += _y.v;
					}	
					
				} else { 			//going backwards
					j = -steps;
					while (--j > -1) {
						_x.value -= _x.v;
						_y.value -= _y.v;
						_x.v /= _friction;
						_y.v /= _friction;
						_x.v -= _x.a;
						_y.v -= _y.a;
					}
				}
				x = _x.value + (_x.v * remainder);
				y = _y.value + (_y.v * remainder);	
				_step += steps;
			}
			
			if (!_skipX) {
				if (_x.r) {
					x = (x + (x < 0 ? -0.5 : 0.5)) | 0;
				}
				if (_x.f) {
					_target[_x.p](x);
				} else {
					_target[_x.p] = x;
				}
			}
			if (!_skipY) {
				if (_y.r) {
					y = (y + (y < 0 ? -0.5 : 0.5)) | 0;
				}
				if (_y.f) {
					_target[_y.p](y);
				} else {
					_target[_y.p] = y;
				}
			}
		}
		
	}
}

internal class Physics2DProp {
	public var p:String;
	public var f:Boolean;
	public var start:Number;
	public var velocity:Number;
	public var v:Number;
	public var a:Number;
	public var r:Boolean;
	public var value:Number;
	public var acceleration:Number;
	
	public function Physics2DProp(target:Object, p:String, velocity:Number, acceleration:Number, stepsPerTimeUnit:uint) {
		this.p = p;
		this.f = (typeof(target[p]) === "function");
		this.start = this.value = (!this.f) ? parseFloat(target[p]) : target[ ((p.indexOf("set") || typeof(target["get" + p.substr(3)]) !== "function") ? p : "get" + p.substr(3)) ]();
		this.velocity = velocity;
		this.v = this.velocity / stepsPerTimeUnit;
		if (acceleration || acceleration == 0) {
			this.acceleration = acceleration;
			this.a = this.acceleration / (stepsPerTimeUnit * stepsPerTimeUnit);
		} else {
			this.acceleration = this.a = 0;
		}
	}	

}