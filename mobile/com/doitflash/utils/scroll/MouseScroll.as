package com.doitflash.utils.scroll
{
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////// import classes
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	//import flash.system.System;
	
	//import fl.transitions.Tween;
	//import fl.transitions.easing.*;
	//import fl.transitions.TweenEvent;
	//import gs.plugins.*;
	//import gs.events.*;
	//import gs.easing.*;
	//import gs.*;
	
	import com.greensock.plugins.*;
	import com.greensock.*; 
	import com.greensock.events.*;
	import com.greensock.easing.*;
	//import com.greensock.easing.EaseLookup;
	
	import com.doitflash.utils.scroll.MouseScroll;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import com.doitflash.consts.ScrollConst;
	
	//import com.luaye.console.C;
	//import flash.utils.getTimer;
	
	/**
	 * MouseScroll is a class to create a mouse scroll, that is a kind of scrollbar to scroll your contents by your mouse movement
	 * 
	 * <b>Copyright 2012, DoItFlash. All rights reserved.</b>
	 * For seeing the scroll preview and sample files visit <a href="http://myappsnippet.com/">http://www.myappsnippet.com/</a>
	 * 
	 * @see Scroll
	 * @see com.doitflash.events.ScrollEvent
	 * @see com.doitflash.consts.Orientation
	 * @see com.doitflash.consts.Easing
	 * @see com.doitflash.consts.ScrollConst
	 * @see MouseScroll
	 * 
	 * @author Ali Tavakoli - 6/12/2010 5:50 PM
	 * modified - 3/6/2012 1:56 PM
	 * @version 2.0
	 * 
	 * @example The following example shows you how to create a simple scrollbar,
	 * I have called all of the scrollbar inputs in this example to show you the available setters,
	 * but scrollbar works perfect even if you just set one input and it's nothing but your content.
	 * 
	 * <listing version="3.0">
	 * import com.doitflash.events.ScrollEvent;
	 * import com.doitflash.consts.Orientation;
	 * import com.doitflash.utils.scroll.MouseScroll;
	 * import com.doitflash.consts.Easing;
	 * import com.doitflash.consts.ScrollConst;
	 * 
	 * var _mouseScroll:MouseScroll =  new MouseScroll();
	 * var _myContent:MyContent = new MyContent(); // the content you want to scroll
	 * 
	 * this.addChild(_mouseScroll);
	 * 
	 * _mouseScroll.addEventListener(ScrollEvent.ENTER_FRAME, onScrollEnterFrame); // this listener works like a simple on Enter Frame
	 * _mouseScroll.addEventListener(ScrollEvent.MASK_WIDTH, onMaskWidth); // listens when ever the mask width changes by calling maskWidth setter
	 * _mouseScroll.addEventListener(ScrollEvent.MASK_HEIGHT, onMaskHeight); // listens when ever the mask height changes by calling maskHeight setter
	 * 
	 * // set inputs
	 * _mouseScroll.maskContent = _myContent;
	 * _mouseScroll.maskWidth = 200;
	 * _mouseScroll.maskHeight = 200;
	 * _mouseScroll.enableVirtualBg = true;
	 * 
	 * _mouseScroll.orientation = Orientation.AUTO; // accepted values: Orientation.AUTO, Orientation.VERTICAL, Orientation.HORIZONTAL
	 * _mouseScroll.easeType = Easing.Expo_easeOut;
	 * _mouseScroll.scrollSpace = 0;
	 * _mouseScroll.aniInterval = .5;
	 * _mouseScroll.blurEffect = true;
	 * _mouseScroll.lessBlurSpeed = 3;
	 * _mouseScroll.yPerc = 0; // min value is 0, max value is 100
	 * _mouseScroll.xPerc = 0; // min value is 0, max value is 100
	 * _mouseScroll.mouseWheelSpeed = 2;
	 * _mouseScroll.isMouseScroll = true;
	 * _mouseScroll.bitmapMode = ScrollConst.WEAK; // use it for smoother scrolling, special when working on mobile devices, accepted values: "normal", "weak", "strong"
	 * 
	 * // _mouseScroll.maskAutoForceUpdate = true; // set it to false if you don't want the mask to take a new bitmap from the modified maskContent when its size changes and like to do it yourself when ever you like
	 * // _mouseScroll._mask.update(null, true); // if you have set bitmapMode to "normal" or "strong" and like to force update the mask manually
	 * // _mouseScroll._mask.smoothing = true; // allow mask smoothing
	 * 
	 * function onScrollEnterFrame(e:ScrollEvent):void
	 * {
	 * 		trace(_mouseScroll.yPerc);
	 * 
	 * 		trace(_mouseScroll.vSpeed); // user can see what's the scroll speed at the time, but ONLY can get it; because it must be set by the class itself obviously
	 * 		trace(_mouseScroll.hSpeed); // user can see what's the scroll speed at the time, but ONLY can get it; because it must be set by the class itself obviously
	 * }
	 * 
	 * function onMaskWidth(e:ScrollEvent):void
	 * {
	 * 		trace(_mouseScroll.maskWidth);
	 * }
	 * 
	 * function onMaskHeight(e:ScrollEvent):void
	 * {
	 * 		trace(_mouseScroll.maskHeight);
	 * }
	 * </listing>
	 * 
	 * @example The following example shows you how to create a simple scrollbar,
	 * then export it and duplicating it for an other content.
	 * 
	 * <listing version="3.0">
	 * import com.doitflash.events.ScrollEvent;
	 * import com.doitflash.consts.Orientation;
	 * import com.doitflash.utils.scroll.MouseScroll;
	 * import com.doitflash.consts.Easing;
	 * 
	 * var _mouseScroll:MouseScroll =  new MouseScroll();
	 * var _mouseScroll2:MouseScroll =  new MouseScroll(); // scrollbar that you want to duplicate from the first one
	 * 
	 * var _myContent:MyContent = new MyContent(); // the first content you want to scroll by the first scrollbar
	 * var _myContent2:MyContent2 = new MyContent2(); // the second content you want to scroll by the second scrollbar (the duplicated scrollbar from the first scrollbar)
	 * 
	 * this.addChild(_mouseScroll);
	 * this.addChild(_mouseScroll2);
	 * _mouseScroll2.x = 250;
	 * 
	 * // set inputs for the first scrollbar
	 * 
	 * _mouseScroll.maskContent = _myContent;
	 * _mouseScroll.maskWidth = 200;
	 * _mouseScroll.maskHeight = 200;
	 * _mouseScroll.easeType = Easing.Expo_easeOut;
	 * _mouseScroll.blurEffect = true;
	 * _mouseScroll.lessBlurSpeed = 3;
	 * 
	 * 
	 * 
	 * // set inputs for the second scrollbar
	 * 
	 * _mouseScroll2.maskContent = _myContent2; // you just need to set its content
	 * 
	 * _mouseScroll2.importProp = _mouseScroll.exportProp; // now import other inputs from the first scrollbar
	 * 
	 * </listing>
	 */
	public class MouseScroll extends Scroll
	{
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////// properties
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	// input variables
		protected var _orientation:String = Orientation.AUTO; // input values: AUTO, VERTICAL, HORIZONTAL
		private var _easeType:String = Easing.Expo_easeOut;
		private var _scrollSpace:Number = 0;
		private var _aniInterval:Number = .5;
		private var _blurEffect:Boolean = false;
		private var _lessBlurSpeed:Number = 2; // to get less speed amount if we'd like to
		protected var _yPerc:Number = 0;
		protected var _xPerc:Number = 0;
		protected var _hSpeed:Number = 0; // user can only get its value (there's no setter to set its value, it must be set by the class itself in contentMover() )
		protected var _vSpeed:Number = 0; // user can only get its value (there's no setter to set its value, it must be set by the class itself in contentMover() )
		private var _mouseWheelSpeed:Number = 0;
		
	// needed variables
		private var _scrollRemoved:Boolean = false;
		
		private var _oldContentH:Number;
		private var _oldContentW:Number;
		
		private var _oldMaskW:Number;
		private var _oldMaskH:Number;
		
		protected var _easeTypeFunc:* = EaseLookup.find(_easeType);
		
		protected var _isYPercManual:Boolean = false; // to see we have set yPerc manually or not,used in contentMover()
		protected var _isXPercManual:Boolean = false; // to see we have set xPerc manually or not,used in contentMover()
		
		private var _oldYLoc:Number = 0; // to know _yLoc is equal to it now or not to not set the _yLoc all the time in contentMover() so that we can set new value to _yPerc in vMouseWheel()
		private var _oldXLoc:Number = 0; // to know _xLoc is equal to it now or not to not set the _xLoc all the time in contentMover() so that we can set new value to _xPerc in hMouseWheel()
		
	// protected variables
		protected var _checkContentWH:Boolean = true; // to check content size or not, used in contentMover()
		protected var _checkMaskWH:Boolean = true; // to check mask size or not, used in contentMover()
		
		protected var _isMouseScroll:Boolean = true; // to see we want to scroll with mouse or not,used in hMouseWheel()
		
		protected var _vScroll:Boolean = false; // to get that we have _vScroll or not, used in setMouseScroll()
		protected var _hScroll:Boolean = false; // to get that we have _hScroll or not, used in setMouseScroll()
		
		protected var _yLoc:Number = 0; // set the _yLoc all the time and content sets its y place according to it
		protected var _xLoc:Number = 0; // set the _xLoc all the time and content sets its x place according to it
		
		protected var _vMin:Number; // set the vertical minimum area that is acceptable to be scrolled, used in setMouseScroll()
		protected var _vMax:Number; // set the vertical maximum area that is acceptable to be scrolled, used in setMouseScroll()
		
		protected var _hMin:Number; // set the horizontal minimum area that is acceptable to be scrolled, used in setMouseScroll()
		protected var _hMax:Number; // set the horizontal maximum area that is acceptable to be scrolled, used in setMouseScroll()
		
		protected var _vMouseScrollTarget:Array; // push the targets that we need to mouse scroll on them, used in setMouseScroll()
		protected var _hMouseScrollTarget:Array; // push the targets that we need to mouse scroll on them, used in setMouseScroll()
		protected var _hMouseScrollTarget2:Array; // push the targets that we need to mouse scroll on them, used in setMouseScroll()
		
		protected var _updateMask:Boolean = false; // to see is it really necessary to force update the mask when this._bitmapMode == "normal"
		protected var _maskAutoForceUpdate:Boolean = true; // to see do we need to force update the mask on maskContent size change or user likes to foce update the mask himeself when ever he needs manually
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////// constructor function
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * Constructor function
		 */
		public function MouseScroll():void
		{
			// I'm ready
		}
		
		/**
		 * when the class is added to stage this method will be called
		 */
		override protected function start(e:Event = null):void
		{
			super.start(e);
			
		// let's set the settings
			gc();
			setMajorSettings();
			onResize();
		}
		
		/**
		 * when the class is removed from stage this method will be called to collect the garbages.
		 */
		override protected function finish(e:Event = null):void
		{
			gc();
			
			super.finish(e);
		}
		
		private function gc():void
		{
		// remove scrollbar ENTER_FRAME listener
			this.removeEventListener(Event.ENTER_FRAME, contentMover);
			
		// remove listeners
			_maskHolder.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			if (_isMouseScroll) _maskHolder.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
		// null the arrays that we needed to have in mouseWheel()
			_vMouseScrollTarget = null;
			_hMouseScrollTarget = null;
			_hMouseScrollTarget2 = null;
		}
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////// private function
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * set initial major settings
		 */
		private function setMajorSettings():void
		{
		// add scrollbar ENTER_FRAME listener
			this.addEventListener(Event.ENTER_FRAME, contentMover, false, 0, true);
			
		// add listeners
			_maskHolder.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel, false, 0, true);
			if (_isMouseScroll) _maskHolder.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			
			
		// set _oldContentH and _oldContentW
			_oldContentH = _maskContent.height;
			_oldContentW = _maskContent.width;
			
		// set _oldMaskH and _oldMaskW
			//_oldYLoc -= .5;
			//_oldXLoc -= .5;
			//_oldMaskH = maskHeight;
			//_oldMaskW = maskWidth;
			
		// add the things that we need to have in mouseWheel() to the arrays
			_vMouseScrollTarget = new Array();
			_hMouseScrollTarget = new Array();
			_hMouseScrollTarget2 = new Array();
			
			_vMouseScrollTarget.push(_maskHolder);
			_hMouseScrollTarget.push(_maskHolder);
		}
		
		/**
		 * for children to set more setting when orientation and content size changes.
		 */
		protected function setMinorSettings():void
		{
		// set min and max space that we can move within
			//_vMin = 0;
			//_vMax = maskHeight;
			
			//_hMin = 0;
			//_hMax = maskWidth;
			
			//_vMouseScrollTarget.push(... can push more items when children use this function)
			//_hMouseScrollTarget.push(... can push more items when children use this function)
			//_hMouseScrollTarget2.push(... can push more items when children use this function)
		}
		
		private function setScroll():void
		{
			switch(_orientation)
			{
				case Orientation.AUTO: // if orientation is auto
					
					if(_maskContent.width > maskWidth && _maskContent.height <= maskHeight)
					{
						_hScroll = true;
						_vScroll = false;
					}
					else if(_maskContent.width <= maskWidth && _maskContent.height > maskHeight)
					{
						_hScroll = false;
						_vScroll = true;
					}
					else if(_maskContent.width > maskWidth && _maskContent.height > maskHeight)
					{
						_hScroll = true;
						_vScroll = true;
					}
					else
					{
						_hScroll = false;
						_vScroll = false;
					}
				break;
					
				case Orientation.VERTICAL: // if orientation is vertical
					
					if(_maskContent.height > maskHeight)
					{
						_hScroll = false;
						_vScroll = true;
					}
					else
					{
						_hScroll = false;
						_vScroll = false;
					}
				break;
				
				case Orientation.HORIZONTAL: // if orientation is horizontal
					
					if(_maskContent.width > maskWidth)
					{
						_hScroll = true;
						_vScroll = false;
					}
					else
					{
						_hScroll = false;
						_vScroll = false;
					}
				break;
			}
		}
		
		
		private function mouseWheel(e:MouseEvent):void
		{
			if(!_hScroll && _vScroll) // if we have _vScroll
			{
				vMouseWheel(e.delta, e.currentTarget);
			}
			else if(_hScroll && !_vScroll) // if we have _hScroll
			{
				hMouseWheel(e.delta, e.currentTarget, true);
			}
			else if(_hScroll && _vScroll) // if we have _hScroll and _vScroll
			{
				vMouseWheel(e.delta, e.currentTarget);
				
				hMouseWheel(e.delta, e.currentTarget, false);
			}
		}
		private function vMouseWheel($delta:Number, $target:*):void
		{
		// set mouseWheel variables
			var __delta:Number;
			var __targetIsOk:Boolean = false;
			
		// set delta amount
			__delta = ($delta < 0) ? $delta - _mouseWheelSpeed : $delta + _mouseWheelSpeed;
			
		// check if $target is what we need to set the _yLoc if $target is ok
			for (var i:int = 0; i < _vMouseScrollTarget.length; i++) 
			{
				if ($target == _vMouseScrollTarget[i]) // if $target was equal to one of the array values do the rest, __targetIsOk = true
				{
					__targetIsOk = true;
					break;
				}
			}
			
			if (__targetIsOk) _yLoc -= __delta;
			// next settings and content movement will be done inside the contentMover()
		}
		private function hMouseWheel($delta:Number, $target:*, $isHighPriority:Boolean):void
		{
		// set mouseWheel variables
			var __delta:Number;
			var __mouseScrollTarget:Array;
			var __targetIsOk:Boolean = false;
			
		// set delta amount
			__delta = ($delta < 0) ? $delta - _mouseWheelSpeed : $delta + _mouseWheelSpeed;
			
		// check if $target is what we need to set the _xLoc if $target is ok
			__mouseScrollTarget = ($isHighPriority) ? _hMouseScrollTarget : _hMouseScrollTarget2;
			
			for (var i:int = 0; i < __mouseScrollTarget.length; i++) 
			{
				if ($target == __mouseScrollTarget[i]) // if $target was equal to one of the array values do the rest, __targetIsOk = true
				{
					__targetIsOk = true;
					break;
				}
			}
			
			if (__targetIsOk) _xLoc -= __delta;
			// next settings and content movement will be done inside the contentMover()
		}
		
		protected function mouseMove(e:MouseEvent):void
		{
			// for a vice versa mouse scroll
			//var _y:Number = _vMax - this.mouseY;
			//var _x:Number = _hMax - this.mouseX;
			//_yLoc = _y;
			//_xLoc = _x;
			
			_yLoc = this.mouseY;
			_xLoc = this.mouseX;
			
		}
		
		protected function contentMover(e:Event = null):void
		{
			this.dispatchEvent(new ScrollEvent(ScrollEvent.ENTER_FRAME));
			
			if (_checkContentWH)
			{
				if(_maskContent.height != _oldContentH && _maskContent.width == _oldContentW)
				{
					setScroll();
					setMinorSettings();
					
					if (_maskAutoForceUpdate)
					{
						if (this._bitmapMode == ScrollConst.STRONG) _mask.update(null, true);
					}
					
					
					// if this._bitmapMode == this.NORMAL, we need to know if the content size has been change and we need to set a force update for our mask only once when we are scrolling,
					// because we don't want our scroller to force update the mask eveytime we scroll or its size changes, we need it to force update the mask only when its necessary
					_updateMask = true; 
					
					_oldYLoc -= .5; // to set the content y later in this function
					_oldContentH = _maskContent.height;
				}
				else if(_maskContent.width != _oldContentW && _maskContent.height == _oldContentH)
				{
					setScroll();
					setMinorSettings();
					
					if (_maskAutoForceUpdate)
					{
						if (this._bitmapMode == ScrollConst.STRONG) _mask.update(null, true);
					}
					
					// if this._bitmapMode == this.NORMAL, we need to know if the content size has been change and we need to set a force update for our mask only once when we are scrolling,
					// because we don't want our scroller to force update the mask eveytime we scroll or its size changes, we need it to force update the mask only when its necessary
					_updateMask = true; 
					
					_oldXLoc -= .5; // to set the content x later in this function
					_oldContentW = _maskContent.width;
				}
				else if(_maskContent.width != _oldContentW && _maskContent.height != _oldContentH)
				{
					setScroll();
					setMinorSettings();
					
					if (_maskAutoForceUpdate)
					{
						if (this._bitmapMode == ScrollConst.STRONG) _mask.update(null, true);
					}
					
					// if this._bitmapMode == this.NORMAL, we need to know if the content size has been change and we need to set a force update for our mask only once when we are scrolling,
					// because we don't want our scroller to force update the mask eveytime we scroll or its size changes, we need it to force update the mask only when its necessary
					_updateMask = true; 
					
					_oldYLoc -= .5; // to set the content y later in this function
					_oldXLoc -= .5; // to set the content x later in this function
					_oldContentH = _maskContent.height;
					_oldContentW = _maskContent.width;
				}
			}
			
			if (_checkMaskWH) // to check if the mask size changed set the content position again according to the percentage
			{
				// we don't need to call any function here like _checkContentWH, because mask size only changes when WE ourself change it by calling maskWidth() or maskHeight(), so we do any other function by using them if we needed
				if(maskHeight != _oldMaskH && maskWidth == _oldMaskW)
				{
					_isYPercManual = true; // to not set the _yPerc, instead set the _yLoc
					
					_oldYLoc -= .5;
					_oldMaskH = maskHeight;
					
				}
				else if(maskWidth != _oldMaskW && maskHeight == _oldMaskH)
				{
					_isXPercManual = true; // to not set the _xPerc, instead set the _xLoc
					
					_oldXLoc -= .5;
					_oldMaskW = maskWidth;
				}
				else if(maskWidth != _oldMaskW && maskHeight != _oldMaskH)
				{
					_isYPercManual = true; // to not set the _yPerc, instead set the _yLoc
					_isXPercManual = true; // to not set the _xPerc, instead set the _xLoc
					
					_oldYLoc -= .5;
					_oldXLoc -= .5;
					_oldMaskH = maskHeight;
					_oldMaskW = maskWidth;
				}
			}
			
			var __contentYLoc:Number;
			var __contentXLoc:Number;
			
			var __vSpeed:Number;
			var __hSpeed:Number;
			
			function scrollVSetting($doAni:Boolean = true):void
			{
				// don't let _yLoc to get higher or lower than expected
				if (_yLoc < _vMin) _yLoc = _vMin;
				if (_yLoc > _vMax) _yLoc = _vMax;
				
				
				// set _yPerc according to _yLoc
				if (!_isYPercManual)
				{
					_yPerc = ( (_yLoc - _vMin) * 100) / (_vMax - _vMin); // Periodic Table-> _yLoc / maskHeight = ? / 100
				}
				else
				{
					_yLoc = (_yPerc * (_vMax - _vMin) ) / 100; // Periodic Table-> ? / maskHeight = _yPerc / 100
				}
				
				// set __contentYLoc according to _yPerc
				__contentYLoc = (_yPerc * (_maskContent.height - maskHeight)) / 100; // Periodic Table-> _yPerc / 100 = ? / _maskContent.height
				//_maskContentHolder.y = - __contentYLoc;
				
				// if we have chosen to have scroll blur effect, understand the scroll speed
				__vSpeed = ((- __contentYLoc) - _maskContentHolder.y) / _aniInterval;
				__vSpeed = Math.sqrt(Math.pow(__vSpeed, 2)); // set to always get positive number
				_vSpeed = __vSpeed; // we have set _vSpeed ONLY for user, to get the scroll speed if needed
				__vSpeed = __vSpeed / _lessBlurSpeed; // to get less speed amount if we'd like to
				
				if ($doAni)
				{
					TweenMax.to(_maskContentHolder, _aniInterval, { bezier:[ { y:_maskContentHolder.y }, { y: - __contentYLoc } ], onUpdate:_mask.update, ease:_easeTypeFunc } );
					if (_blurEffect && _aniInterval != 0) TweenMax.to(_maskContentHolder, _aniInterval, { blurFilter: { blurY:__vSpeed }, ease:_easeTypeFunc } );
				}
				
				
				_oldYLoc = _yLoc; // to do the else function
				_isYPercManual = false; // set it false again if it became true by calling yPerc()
			}
			
			function scrollHSetting($doAni:Boolean = true):void
			{
				// don't let _xLoc to get higher or lower than expected
				if (_xLoc < _hMin) _xLoc = _hMin;
				if (_xLoc > _hMax) _xLoc = _hMax;
				
				// set _xPerc according to _xLoc
				if (!_isXPercManual)
				{
					_xPerc = ( (_xLoc - _hMin) * 100) / (_hMax - _hMin); // Periodic Table-> _xLoc / maskWidth = ? / 100
				}
				else
				{
					_xLoc = (_xPerc * (_hMax - _hMin) ) / 100; // Periodic Table-> ? / maskWidth = _xPerc / 100
				}
				
				// set __contentXLoc according to _xPerc
				__contentXLoc = (_xPerc * (_maskContent.width - maskWidth)) / 100; // Periodic Table-> _xPerc / 100 = ? / _maskContent.width
				//_maskContentHolder.x = - __contentXLoc;
				
				// if we have chosen to have scroll blur effect, understand the scroll speed
				__hSpeed = ((- __contentXLoc) - _maskContentHolder.x) / _aniInterval;
				__hSpeed = Math.sqrt(Math.pow(__hSpeed, 2)); // set to always get positive number
				_hSpeed = __hSpeed; // we have set _hSpeed ONLY for user, to get the scroll speed if needed
				__hSpeed = __hSpeed / _lessBlurSpeed; // to get less speed amount if we'd like to
				
				if ($doAni)
				{
					TweenMax.to(_maskContentHolder, _aniInterval, { bezier:[ { x:_maskContentHolder.x }, { x: - __contentXLoc } ], onUpdate:_mask.update, ease:_easeTypeFunc } );
					if (_blurEffect && _aniInterval != 0) TweenMax.to(_maskContentHolder, _aniInterval, { blurFilter: { blurX:__hSpeed }, ease:_easeTypeFunc } );
				}
				
				_oldXLoc = _xLoc; // to do the else function
				_isXPercManual = false; // set it false again if it became true by calling xPerc()
			}
			
			
			
			
			if(!_hScroll && _vScroll) // if we have _vScroll
			{
				if (_oldYLoc != _yLoc)
				{
					scrollVSetting();
				}
				else
				{
					if (_maskContentHolder.x != 0)
					{
						TweenMax.to(_maskContentHolder, _aniInterval, { bezier:[ { x:0 } ], onUpdate:_mask.update, ease:_easeTypeFunc } );
					}
					if (_blurEffect && _aniInterval != 0) TweenMax.to(_maskContentHolder, _aniInterval, { blurFilter: { blurX:0, blurY:0, remove:true }, onUpdate:_mask.update, ease:_easeTypeFunc } );
					//if (_blurEffect && _aniInterval != 0) TweenMax.to(_maskContentHolder, _aniInterval, {blurFilter:{blurY:0, remove:true}, ease:_easeTypeFunc});
				}
			}
			else if(_hScroll && !_vScroll) // if we have _hScroll
			{
				if (_oldXLoc != _xLoc)
				{
					scrollHSetting();
				}
				else
				{
					if (_maskContentHolder.y != 0)
					{
						TweenMax.to(_maskContentHolder, _aniInterval, { bezier:[ { y:0 } ], onUpdate:_mask.update, ease:_easeTypeFunc } );
					}
					if (_blurEffect && _aniInterval != 0) TweenMax.to(_maskContentHolder, _aniInterval, { blurFilter: { blurX:0, blurY:0, remove:true }, onUpdate:_mask.update, ease:_easeTypeFunc } );
					//if (_blurEffect && _aniInterval != 0) TweenMax.to(_maskContentHolder, _aniInterval, {blurFilter:{blurX:0, remove:true}, ease:_easeTypeFunc});
				}
			}
			else if(_hScroll && _vScroll) // if we have _hScroll and _vScroll
			{
				if (_oldYLoc != _yLoc && _oldXLoc == _xLoc)
				{
					scrollVSetting();
				}
				else if (_oldYLoc == _yLoc && _oldXLoc != _xLoc)
				{
					scrollHSetting();
				}
				else if (_oldYLoc != _yLoc && _oldXLoc != _xLoc)
				{
					scrollVSetting(false);
					scrollHSetting(false);
					
					TweenMax.to(_maskContentHolder, _aniInterval, { bezier:[ { x:_maskContentHolder.x, y:_maskContentHolder.y }, { x:- __contentXLoc, y: - __contentYLoc } ], onUpdate:_mask.update, ease:_easeTypeFunc } );
					if (_blurEffect && _aniInterval != 0) TweenMax.to(_maskContentHolder, _aniInterval, { blurFilter: { blurX:__hSpeed, blurY:__vSpeed }, ease:_easeTypeFunc } );
				}
				else if (_oldYLoc == _yLoc && _oldXLoc == _xLoc)
				{
					if (_blurEffect && _aniInterval != 0) TweenMax.to(_maskContentHolder, _aniInterval, { blurFilter: { blurX:0, blurY:0, remove:true }, onUpdate:_mask.update, ease:_easeTypeFunc } );
				}
			}
			else
			{
				if (_maskContentHolder.x != 0 || _maskContentHolder.y != 0)
				{
					TweenMax.to(_maskContentHolder, _aniInterval, { bezier:[ { x:0, y:0 } ], onUpdate:_mask.update, ease:_easeTypeFunc } );
				}
				if (_blurEffect && _aniInterval != 0) TweenMax.to(_maskContentHolder, _aniInterval, { blurFilter: { blurX:0, blurY:0, remove:true }, onUpdate:_mask.update, ease:_easeTypeFunc } );
			}
		}
		
		
		
		
		//================================================================================================================
		//================================================================================================= main functions
		//================================================================================================================
		
		override protected function onResize(e:*=null):void
		{
			// set min and max space that we can move within
			_vMin = _scrollSpace;
			_vMax = maskHeight - _scrollSpace;
			
			_hMin = _scrollSpace;
			_hMax = maskWidth - _scrollSpace;
			
			
			setScroll();
			
			// we call contentMover() onEnterFrame function just once manually, bacause if this is the first time that the user runs scrollbar instance
			// and imidietly after the class addChild, modifies maskWidth or maskHeight values as the onEnterFrme listener takes a little time in flash to run,
			// so we don't get if user on that time that we couldn't check have changed his maskContent size or not, so each time onResize() we call our onEnterFrame function too
			contentMover();
			
			super.onResize(e);
		}
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////// methods
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////// setter - getter
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * indicates the type of orientation.
		 * @default Orientation.AUTO
		 * @see Orientation
		 */
		public function get orientation():String
		{
			return _orientation;
		}
		/**
		 * @private
		 */
		public function set orientation(sc:String):void
		{
			if(sc != _orientation)
			{
				_orientation = sc;
				
				if (stage)
				{
					setScroll();
					setMinorSettings();
				}
				
				_propSaver.orientation = _orientation; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * indicates the type of scrollbar ease.
		 * @default Easing.Expo_easeOut
		 * @see Easing
		 */
		public function get easeType():String
		{
			return _easeType;
		}
		/**
		 * @private
		 */
		public function set easeType(sc:String):void
		{
			if(sc != _easeType)
			{
				_easeType = sc;
				_easeTypeFunc = EaseLookup.find(_easeType);
				
				_propSaver.easeType = _easeType; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * indicates a imaginary space around the content,
		 * in the space area scrolling won't take place.
		 * @default 0
		 */
		public function get scrollSpace():Number
		{
			return _scrollSpace;
		}
		/**
		 * @private
		 */
		public function set scrollSpace(sc:Number):void
		{
			if(sc != _scrollSpace)
			{
				_scrollSpace = sc;
				
				_propSaver.scrollSpace = _scrollSpace; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * indicates the content scrolling ease animation delay.
		 * @default .5
		 */
		public function get aniInterval():Number
		{
			return _aniInterval;
		}
		/**
		 * @private
		 */
		public function set aniInterval(sc:Number):void
		{
			if(sc != _aniInterval)
			{
				_aniInterval = sc;
				
				_propSaver.aniInterval = _aniInterval; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * if <code>true</code>, blurry scroll is available,
		 * if <code>false</code>, blurry scroll is unavailable.
		 * @default false
		 */
		public function get blurEffect():Boolean
		{
			return _blurEffect;
		}
		/**
		 * @private
		 */
		public function set blurEffect(sc:Boolean):void
		{
			if(sc != _blurEffect)
			{
				_blurEffect = sc;
				
				_propSaver.blurEffect = _blurEffect; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * indicates the number to make the blur effect less than its real amount,
		 * if blurEffect is <code>true</code>.
		 * @default 2
		 */
		public function get lessBlurSpeed():Number
		{
			return _lessBlurSpeed;
		}
		/**
		 * @private
		 */
		public function set lessBlurSpeed(sc:Number):void
		{
			if(sc != _lessBlurSpeed)
			{
				_lessBlurSpeed = sc;
				
				_propSaver.lessBlurSpeed = _lessBlurSpeed; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * indicates the location of the vertical scrollbar, values are from 0 to 100.
		 * @default 0
		 */
		public function get yPerc():Number
		{
			return _yPerc;
		}
		/**
		 * @private
		 */
		public function set yPerc(sc:Number):void
		{
			if(sc != _yPerc)
			{
				_yPerc = sc;
				
				_isYPercManual = true;
				_oldYLoc -= .5; // to set the content y in contentMover()
				_propSaver.yPerc = _yPerc; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * indicates the location of the horizontal scrollbar, values are from 0 to 100.
		 * @default 0
		 */
		public function get xPerc():Number
		{
			return _xPerc;
		}
		/**
		 * @private
		 */
		public function set xPerc(sc:Number):void
		{
			if(sc != _xPerc)
			{
				_xPerc = sc;
				
				_isXPercManual = true;
				_oldXLoc -= .5; // to set the content x in contentMover()
				_propSaver.xPerc = _xPerc; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * indicates the mouse wheel speed when scrolling the content.
		 * @default 0
		 */
		public function get mouseWheelSpeed():Number
		{
			return _mouseWheelSpeed;
		}
		/**
		 * @private
		 */
		public function set mouseWheelSpeed(sc:Number):void
		{
			if(sc != _mouseWheelSpeed)
			{
				_mouseWheelSpeed = sc;
				
				_propSaver.mouseWheelSpeed = _mouseWheelSpeed; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * if <code>true</code>, we have mouse scroll ability,
		 * if <code>false</code>, we don't have mouse scroll ability.
		 * @default true
		 */
		public function get isMouseScroll():Boolean
		{
			return _isMouseScroll;
		}
		/**
		 * @private
		 */
		public function set isMouseScroll(sc:Boolean):void
		{
			if(sc != _isMouseScroll)
			{
				_isMouseScroll = sc;
				
				_propSaver.isMouseScroll = _isMouseScroll; // pass the new value to the value of the object property
				
				if (stage)
				{
					if (!_isMouseScroll) _maskHolder.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					else _maskHolder.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
				}
			}
		}
		
		/**
		 * if <code>true</code>, when the maskContent size changes, mask will be automatically forced to update it self to have a correct screenshot of the modified content,
		 * if <code>false</code>, mask won't take a new screenshot on maskContent size change (you must do it manually yourself like this: <code>_mouseScroll._mask.update(null, true);</code>).
		 * @default true
		 */
		public function get maskAutoForceUpdate():Boolean
		{
			return _maskAutoForceUpdate;
		}
		/**
		 * @private
		 */
		public function set maskAutoForceUpdate(sc:Boolean):void
		{
			if(sc != _maskAutoForceUpdate)
			{
				_maskAutoForceUpdate = sc;
				
				_propSaver.maskAutoForceUpdate = _maskAutoForceUpdate; // pass the new value to the value of the object property
			}
		}
		
		/**
		 * indicates the vertical speed of scrollbar.
		 * @default 0
		 */
		public function get vSpeed():Number
		{
			return _vSpeed;
		}
		
		/**
		 * indicates the horizontal speed of scrollbar.
		 * @default 0
		 */
		public function get hSpeed():Number
		{
			return _hSpeed;
		}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}