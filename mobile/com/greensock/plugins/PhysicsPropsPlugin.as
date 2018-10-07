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
/**
 * Sometimes it's useful to tween a value at a particular velocity and/or acceleration without 
 * a specific end value in mind. PhysicsPropsPlugin allows you to tween <strong>any</strong> numeric 
 * property of <strong>any</strong> object based on these concepts. Keep in mind that any easing equation 
 * you define for your tween will be completely ignored for these properties. Instead, the physics 
 * parameters will determine the movement/easing. These parameters, by the way, are not intended to be 
 * dynamically updateable, but one unique convenience is that everything is reverseable. So if you 
 * create several physics-based tweens, for example, and throw them into a TimelineLite, you could 
 * simply call <code>reverse()</code> on the timeline to watch the objects retrace their steps right back 
 * to the beginning. Here are the parameters you can define (note that <code>friction</code> and 
 * <code>acceleration</code> are both completely optional):
 * 	<ul>
 * 		<li><strong>velocity</strong> : Number - the initial velocity of the object measured in units per second
 * 								(or for tweens where <code>useFrames</code> is <code>true</code>, it would 
 * 								be measured per frame). (Default: <code>0</code>)</li>
 * 
 * 		<li><strong>acceleration</strong>  : Number - the amount of acceleration applied to the object, measured
 * 								in units per second (or for tweens where <code>useFrames</code> is <code>true</code>, it would 
 * 								be measured per frame). (Default: 0)</li>
 * 
 * 		<li><strong>friction</strong>  : Number - a value between 0 and 1 where 0 is no friction, 0.08 is a small amount of
 * 								friction, and 1 will completely prevent any movement. This is not meant to be precise or 
 * 								scientific in any way, but it serves as an easy way to apply a friction-like
 * 								physics effect to your tween. Generally it is best to experiment with this number a bit,
 * 								starting at a very low value like 0.02.	Also note that friction requires more processing 
 * 								than physics tweens without any friction. (Default: <code>0</code>)</li>
 * 	</ul>
 * 
 * 
 * <p><b>USAGE:</b></p>
 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.plugins.TweenPlugin;
import com.greensock.plugins.PhysicsPropsPlugin; 
TweenPlugin.activate([PhysicsPropsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 2, {physicsProps:{
									x:{velocity:100, acceleration:200},
									y:{velocity:-200, friction:0.1}
								}
						});
</listing>
 * 
 * <p>PhysicsPropsPlugin is a <a href="http://www.greensock.com/club/" target="_blank">Club GreenSock</a> membership benefit. You must have a valid membership to use this class
 * without violating the terms of use. Visit <a href="http://www.greensock.com/club/" target="_blank">http://www.greensock.com/club/</a> to sign up or get more details.</p>
 * 
 * <p><strong>Copyright 2008-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class PhysicsPropsPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _tween:TweenLite;
		/** @private **/
		protected var _target:Object;
		/** @private **/
		protected var _props:Array;
		/** @private **/
		protected var _hasFriction:Boolean;
		/** @private **/
		protected var _runBackwards:Boolean;
		/** @private **/
		protected var _step:uint; 
		/** @private for tweens with friction, we need to iterate through steps. frames-based tweens will iterate once per frame, and seconds-based tweens will iterate 30 times per second. **/
		protected var _stepsPerTimeUnit:uint;
		
		
		/** @private **/
		public function PhysicsPropsPlugin() {
			super("physicsProps");
			_overwriteProps.pop();
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			_target = target;
			_tween = tween;
			_runBackwards = (_tween.vars.runBackwards === true);
			_step = 0;
			var tl:SimpleTimeline = _tween._timeline,
				cnt:uint = 0,
				p:String, curProp:Object;
			while (tl._timeline) {
				tl = tl._timeline;
			}
			_stepsPerTimeUnit = (tl == Animation._rootFramesTimeline) ? 1 : 30;
			_props = [];
			for (p in value) {
				curProp = value[p];
				if (curProp.velocity || curProp.acceleration) {
					_props[cnt++] = new PhysicsProp(target, p, curProp.velocity, curProp.acceleration, curProp.friction, _stepsPerTimeUnit);
					_overwriteProps[cnt] = p;
					if (curProp.friction) {
						_hasFriction = true;
					}
				}
			}
			return true;
		}
		
		/** @private **/
		override public function _kill(lookup:Object):Boolean {
			var i:int = _props.length;
			while (--i > -1) {
				if (_props[i].p in lookup) {
					_props.splice(i, 1);
				}
			}
			return super._kill(lookup);
		}
		
		/** @private **/
		override public function _roundProps(lookup:Object, value:Boolean=true):void {
			var i:int = _props.length;
			while (--i > -1) {
				if (("physicsProps" in lookup) || (_props[i].p in lookup)) {
					_props[i].r = value;
				}
			}
		}
		
		/** @private **/
		override public function setRatio(v:Number):void {
			var i:int = _props.length, 
				time:Number = _tween._time, 
				curProp:PhysicsProp, val:Number, steps:int, remainder:Number, j:int, tt:Number;
			if (_runBackwards) {
				time = _tween._duration - time;
			}
			if (_hasFriction) {
				time *= _stepsPerTimeUnit;
				steps = int(time) - _step;
				remainder = (time % 1);
				if (steps >= 0) { 	//going forward
					while (--i > -1) {
						curProp = _props[i];
						j = steps;
						while (--j > -1) {
							curProp.v += curProp.a;
							curProp.v *= curProp.friction;
							curProp.value += curProp.v;
						}
						val = curProp.value + (curProp.v * remainder);
						if (curProp.r) {
							val = (val + (val < 0 ? -0.5 : 0.5)) | 0;
						}
						if (curProp.f) {
							_target[curProp.p](val);
						} else {
							_target[curProp.p] = val;
						}
					}					
					
				} else { 			//going backwards
					while (--i > -1) {
						curProp = _props[i];
						j = -steps;
						while (--j > -1) {
							curProp.value -= curProp.v;
							curProp.v /= curProp.friction;
							curProp.v -= curProp.a;
						}
						val = curProp.value + (curProp.v * remainder);
						if (curProp.r) {
							val = (val + (val < 0 ? -0.5 : 0.5)) | 0;
						}
						if (curProp.f) {
							_target[curProp.p](val);
						} else {
							_target[curProp.p] = val;
						}
					}
				}
				_step += steps;
				
			} else {
				tt = time * time * 0.5;
				while (--i > -1) {
					curProp = _props[i];
					val = curProp.start + ((curProp.velocity * time) + (curProp.acceleration * tt));
					if (curProp.r) {
						val = (val + (val < 0 ? -0.5 : 0.5)) | 0;
					}
					if (curProp.f) {
						_target[curProp.p](val);
					} else {
						_target[curProp.p] = val;
					}
				}
			}
			
		}
		
	}
}

internal class PhysicsProp {
	public var p:String;
	public var f:Boolean;
	public var r:Boolean;
	public var start:Number;
	public var velocity:Number;
	public var acceleration:Number;
	public var friction:Number;
	public var v:Number; //used to track the current velocity as we iterate through friction-based tween algorithms
	public var a:Number; //only used in friction-based tweens
	public var value:Number; //used to track the current property value in friction-based tweens
	
	public function PhysicsProp(target:Object, p:String, velocity:Number, acceleration:Number, friction:Number, stepsPerTimeUnit:uint) {
		this.p = p;
		this.f = (target[p] is Function);
		this.start = this.value = (!this.f) ? Number(target[p]) : target[ ((p.indexOf("set") || !("get" + p.substr(3) in target)) ? p : "get" + p.substr(3)) ]();;
		this.velocity = velocity || 0;
		this.v = this.velocity / stepsPerTimeUnit;
		if (acceleration || acceleration == 0) {
			this.acceleration = acceleration;
			this.a = this.acceleration / (stepsPerTimeUnit * stepsPerTimeUnit);
		} else {
			this.acceleration = this.a = 0;
		}
		this.friction = 1 - (friction || 0) ;
	}	

}