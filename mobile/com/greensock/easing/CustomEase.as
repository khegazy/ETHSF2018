/**
 * VERSION: 1.01
 * DATE: 7/15/2009
 * AS3 (AS2 is also available)
 * UPDATES AND DOCUMENTATION AT: http://www.greensock.com/customease/
 **/
package com.greensock.easing {
/**
 * 	[AS3/AS2 only] Facilitates creating custom bezier eases with the GreenSock Custom Ease Builder tool. It's essentially
 *  a place to store the bezier segment information for each ease instead of recreating it inside each
 *  function call which would slow things down. Please use the interactive tool available at 
 *  <a href="http://blog.greensock.com/customease/">http://blog.greensock.com/customease/</a> 
 * to generate the necessary code.<br /><br />
 * 
 * <p><strong>Copyright 2008-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */	 
	public class CustomEase {
		/** @private **/
		public static const VERSION:Number = 1.01;
		/** @private **/
		private static var _all:Object = {}; //keeps track of all CustomEase instances.
		/** @private **/
		private var _segments:Array;
		/** @private **/
		private var _name:String;
		
		public static function create(name:String, segments:Array):Function {
			var b:CustomEase = new CustomEase(name, segments);
			return b.ease;
		}
		
		public static function byName(name:String):Function {
			return _all[name].ease;
		}
		
		public function CustomEase(name:String, segments:Array) {
			_name = name;
			_segments = [];
			var l:int = segments.length;
			for (var i:int = 0; i < l; i++) {
				_segments[_segments.length] = new Segment(segments[i].s, segments[i].cp, segments[i].e);
			}
			_all[name] = this;
		}
		
		public function ease(time:Number, start:Number, change:Number, duration:Number):Number {
			var factor:Number = time / duration, qty:uint = _segments.length, t:Number, s:Segment;
			var i:int = int(qty * factor);
			t = (factor - (i * (1 / qty))) * qty;
			s = _segments[i];
			return start + change * (s.s + t * (2 * (1 - t) * (s.cp - s.s) + t * (s.e - s.s)));
		}
		
		public function destroy():void {
			_segments = null;
			delete _all[_name];
		}
		
	}
}

//allows for strict data typing, making lookups faster
internal class Segment {
	public var s:Number;
	public var cp:Number;
	public var e:Number;
	
	public function Segment(s:Number, cp:Number, e:Number) {
		this.s = s;
		this.cp = cp;
		this.e = e;
	}
}