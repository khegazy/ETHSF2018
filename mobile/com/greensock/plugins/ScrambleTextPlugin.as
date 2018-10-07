/**
 * VERSION: 12.0.5
 * DATE: 2013-03-27
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.TweenLite;
/**
 * Scrambles the text in a TextField with randomized characters (uppercase by default, but you can define lowercase
 * or a set of custom characters), refreshing new randomized characters at regular intervals while gradually 
 * revealing your new text over the course of the tween (left to right). Visually it looks like a computer decoding
 * a string of text. Great for rollovers. 
 * 
 * <p>You can simply pass a string of text directly as the <code>scrambleText</code> and it'll use the defaults
 * for revealing it, or you can customize the settings by using a generic object with any of the following properties:</p>
 * 
 * <ul>
 * 	<li><strong>text</strong> : String - the text that should replace the existing text in the TextField (required).</li>
 * 	
 * 	<li><strong>chars</strong> : String - the characters that should be randomly swapped in to the scrambled portion 
 * 				the text. You can use <code>"upperCase"</code>, <code>"lowerCase"</code>, <code>"upperAndLowerCase"</code>, 
 * 				or a custom string of characters, like <code>"XO"</code> or <code>"TMOWACB"</code>, or <code>"jompaWB!^"</code>, etc.
 * 				(Default: <code>"upperCase"</code>)</li>
 * 
 * 	<li><strong>tweenLength</strong> : Boolean - if the length of the replacement text is different than the original
 * 				text, the difference will be gradually tweened so that the length doesn't suddenly jump. For example, 
 * 				if the original text is 50 characters and the replacement text is 100 characters, during the tween the 
 * 				number of characters would gradually move from 50 to 100 instead of jumping immediatley to 100. 
 * 				However, if you'd prefer to have it immediately jump, set <code>tweenLength</code> to <code>false</code>.
 * 				(Default: <code>true</code>)</li>
 *  <li><strong>revealDelay</strong> : Number - if you'd like the reveal (unscrambling) of the new text to be delayed 
 * 				for a certain portion of the tween so that the scrambled text is entirely visible for a while, use
 * 				<code>revealDelay</code> to define the time you'd like to elapse before the reveal begins. For example,
 * 				if the tween's duration is 3 seconds but you'd like the scrambled text to remain entirely visible for 
 * 				first 1 second of the tween, you'd set <code>revealDelay</code> to <code>1</code>. (Default: <code>0</code>)</li>
 * 
 * 	<li><strong>speed</strong> : Number - controls how frequently the scrambled characters are refreshed. The default is <code>1</code>
 * 				but you could slow things down by using <code>0.2</code> for example (or any number). (Default: <code>1</code>)</li>
 * 
 * 	<li><strong>delimiter</strong> : String - by default, each character is replaced one-by-one, but if you'd prefer to have
 * 				things revealed word-by-word, you could use a delimiter of <code>" "</code> (space). (Default: <code>""</code>)</li>
 * </ul>
 * 
 * <p>ScrambleTextPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get more details. </p>
 * 
 * <p><b>USAGE:</b></p>
 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.plugins.TweenPlugin; 
import com.greensock.plugins.ScrambleTextPlugin; 
TweenPlugin.activate([ScrambleTextPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

//use the defaults
TweenLite.to(yourTextField, 1, {scrambleText:"THIS IS NEW TEXT"}); 
 
//or customize things:
TweenLite.to(yourTextField, 1, {scrambleText:{text:"THIS IS NEW TEXT", chars:"XO", revealDelay:0.5, speed:0.3}}); 
</listing>
 * 
 * <p><strong>Copyright 2008-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class ScrambleTextPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		private static var _upper:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		/** @private **/
		private static var _lower:String = _upper.toLowerCase();
		/** @private **/
		private static var _charsLookup:Object;
		/** @private **/
		private var _tween:TweenLite;
		/** @private **/
		private var _target:Object;
		/** @private **/
		private var _delimiter:String;
		/** @private **/
		private var _original:Array;
		/** @private **/
		private var _text:Array;
		/** @private **/
		private var _length:Number;
		/** @private **/
		private var _lengthDif:int;
		/** @private **/
		private var _charSet:CharSet;
		/** @private **/
		private var _speed:Number;
		/** @private **/
		private var _prevScrambleTime:Number;
		/** @private **/
		private var _setIndex:int;
		/** @private **/
		private var _chars:String;
		/** @private **/
		private var _revealDelay:Number;
		/** @private **/
		private var _tweenLength:Boolean;
		
		/** @private **/
		public function ScrambleTextPlugin() {
			super("scrambleText"); // lower priority so that the x/y tweens occur BEFORE the transformAroundPoint is applied
			if (_charsLookup == null) {
				_charsLookup = {upperCase: new CharSet(_upper), lowerCase: new CharSet(_lower), upperAndLowerCase: new CharSet(_upper + _lower)};
				for (var p:String in _charsLookup) {
					_charsLookup[p.toLowerCase()] = _charsLookup[p];
					_charsLookup[p.toUpperCase()] = _charsLookup[p];
				}
			}
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (target.text == null) {
				trace("scrambleText only works on objects with a 'text' property.");
				return false;
			}
			_target = target;
			if (typeof(value) !== "object") {
				value = {text:value};
			}
			var scramble:String = value.scramble,
				delim:String, i:int, maxLength:int, charset:CharSet;
			_delimiter = delim = value.delimiter || "";
			_original = target.text.split(delim);
			_text = String(value.text || value.value || "").split(delim);
			i = _text.length - _original.length;
			_length = _original.join(delim).length;
			_lengthDif = _text.join(delim).length - _length;
			_charSet = charset = _charsLookup[(value.chars || "upperCase")] || new CharSet(value.chars);
			
			_speed = 0.016 / (value.speed || 1);
			_prevScrambleTime = 0;
			_setIndex = (Math.random() * 20) | 0;
			maxLength = _length + Math.max(_lengthDif, 0);
			if (maxLength > charset.length) {
				charset.grow(maxLength);
			}
			_chars = charset.sets[_setIndex];
			_revealDelay = value.revealDelay || 0;
			_tweenLength = (value.tweenLength !== false);
			_tween = tween;
			return true;
		}
		
		
		/** @private **/
		override public function setRatio(ratio:Number):void {
			var l:int = _text.length,
				delim:String = _delimiter,
				time:Number = _tween._time,
				timeDif:Number = time - _prevScrambleTime,
				i:int, newText:String, oldText:String;
			if (_revealDelay !== 0) {
				if (_tween.vars.runBackwards) {
					time = _tween._duration - time; //invert the time for from() tweens
				}
				ratio = (time === 0) ? 0 : (time < _revealDelay) ? 0.000001 : (time === _tween._duration) ? 1 : _tween._ease.getRatio((time - _revealDelay) / (_tween._duration - _revealDelay));
			}
			if (ratio < 0) {
				ratio = 0;
			} else if (ratio > 1) {
				ratio = 1;
			}
			i = (ratio * l + 0.5) | 0;
			newText = _text.slice(0, i).join(delim);
			oldText = _original.slice(i).join(delim);
			if (ratio) {
				if (timeDif > _speed || timeDif < -_speed) {
					_setIndex = (_setIndex + ((Math.random() * 19) | 0)) % 20;
					_chars = _charSet.sets[_setIndex];
					_prevScrambleTime += timeDif;
				}
				oldText = _chars.substr(newText.length, ((_length + (_tweenLength ? 1 - ((ratio = 1 - ratio) * ratio * ratio * ratio) : 1) * _lengthDif) - newText.length + 0.5) | 0);
			}
			_target.text = newText + delim + oldText;
		}

	}
}

internal class CharSet {
	public var chars:Array;
	public var sets:Array;
	public var length:int;
	
	public function CharSet(chars:String) {
		this.chars = chars.split("");
		this.sets = [];
		this.length = 50;
		var i:int;
		for (i = 0; i < 20; i++) {
			sets[i] = _scrambleText(80, this.chars); //we create 20 strings that are 80 characters long, randomly chosen and pack them into an array. We then randomly choose the scrambled text from this array in order to greatly improve efficiency compared to creating new randomized text from scratch each and every time it's needed. This is a simple lookup whereas the other technique requires looping through as many times as there are characters needed, and calling Math.random() each time through the loop, building the string, etc.
		}
	}
	
	private static function _scrambleText(length:Number, chars:Array):String {
		var l:int = chars.length,
			s:String = "";
		while (--length > -1) {
			s += chars[ ((Math.random() * l) | 0) ];
		}
		return s;
	}
	
	public function grow(newLength:int):void { //if we encounter a tween that has more than 80 characters, we'll need to add to the character sets accordingly. Once it's cached, it'll only need to grow again if we exceed that new length. Again, this is an efficiency tactic.
		var i:int;
		for (i = 0; i < 20; i++) {
			sets[i] += _scrambleText(newLength - length, chars);
		}
		length = newLength;
	}
	
}