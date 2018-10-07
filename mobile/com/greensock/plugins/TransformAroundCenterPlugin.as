/**
 * VERSION: 12.0
 * DATE: 2012-01-14
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.*;
	
	import flash.display.*;
	import flash.geom.*;
/**
 * [AS3/AS2 only] Normally, all transformations (scale, rotation, and position) are based on the DisplayObject's registration
 * point (most often its upper left corner), but TransformAroundCenter allows you to make the 2D transformations
 * occur around the DisplayObject's center.  Keep in mind, though, that Flash doesn't factor in any masks when
 * determining the DisplayObject's center.
 * 
 * <p>If you define an x or y value in the transformAroundCenter object, it will correspond to the center which 
 * makes it easy to position (as opposed to having to figure out where the original registration point 
 * should tween to). If you prefer to define the x/y in relation to the original registration point, do so outside 
 * the transformAroundCenter object, like: </p><p><code>
 * 
 * TweenLite.to(mc, 3, {x:50, y:40, transformAroundCenter:{scale:0.5, rotation:30}});</code></p>
 * 
 * <p>TransformAroundCenterPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get more details. </p>
 * 
 * <p><b>USAGE:</b></p>
 * <listing version="3.0">
import com.greensock.TweenLite;
import com.greensock.plugins.TweenPlugin; 
import com.greensock.plugins.TransformAroundCenterPlugin; 
TweenPlugin.activate([TransformAroundCenterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, {transformAroundCenter:{scale:1.5, rotation:150}}); 
</listing>
 * 
 * <p><strong>Copyright 2008-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class TransformAroundCenterPlugin extends TransformAroundPointPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public function TransformAroundCenterPlugin() {
			super();
			_propName = "transformAroundCenter";
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			var bounds:Rectangle = target.getBounds(target);
			value.point = new Point(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2);
			value.pointIsLocal = true;
			return super._onInitTween(target, value, tween);
		}
		
	}
}