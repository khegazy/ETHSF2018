package com.doitflash.utils.scroll
{
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////// import classes
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	import com.greensock.BlitMask;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.consts.ScrollConst;
	import flash.geom.Matrix;
	
	import com.doitflash.text.modules.MySprite;
	//import com.luaye.console.C;
	
	/**
	 * Scroll class is the base class of scrollbars.
	 * 
	 * <b>Copyright 2012, DoItFlash. All rights reserved.</b>
	 * For seeing the scroll preview and sample files visit <a href="http://myappsnippet.com/">http://www.myappsnippet.com/</a>
	 * 
	 * @see com.doitflash.events.ScrollEvent
	 * 
	 * @author Ali Tavakoli - 1/27/2010 8:01 PM
	 * modified - 3/6/2012 11:13 AM
	 * 
	 * @version 2.0
	 */
	public class Scroll extends MySprite
	{
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////// properties
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	// needed variables
		
		/**
		 * @private
		 * set the object to save the setters value inside it self
		 */
		protected var _propSaver:Object = new Object();
		
		protected var _maskHolder:Sprite;
		public var _mask:BlitMask;
		
		protected var _contentBg:Sprite;
		protected var _maskContentHolder:Sprite;
		
		
		
		
	// input variables
		
		protected var _maskWidth:Number = 100;
		protected var _maskHeight:Number = 100;
		
		protected var _maskContent:DisplayObject;
		
		private var _enableVirtualBg:Boolean = true;
		protected var _bitmapMode:String = "weak"; // accepted values: "normal", "strong", "weak"
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////// constructor function
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor function
		 */
		public function Scroll():void
		{	
			this.addEventListener(Event.ADDED_TO_STAGE, start, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, finish, false, 0, true);
		}
		
		/**
		 * when the class is added to stage this method will be called.
		 */
		protected function start(e:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, start);
			this.addEventListener(Event.REMOVED_FROM_STAGE, finish, false, 0, true);
			
			
			if (!_maskHolder) // everything about content will be inside _maskHolder
			{
				_maskHolder = new Sprite();
				this.addChild(_maskHolder);
			}
			
			setMaskContent(_maskContent);
			setContentBg();
			onResize();
		}
		
		/**
		 * when the class is removed from stage this method will be called to collect the garbages.
		 */
		protected function finish(e:Event=null):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, finish);
			this.addEventListener(Event.ADDED_TO_STAGE, start, false, 0, true);
			
			
			if(_mask)
			{
				_mask.dispose();
				_mask = null;
			}
			
			if(_contentBg)
			{
				_contentBg.graphics.clear();
				_maskHolder.removeChild(_contentBg);
				_contentBg = null;
			}
			
			if(_maskContentHolder)
			{
				_maskHolder.removeChild(_maskContentHolder);
				_maskContentHolder = null;
			}
			
			if(_maskHolder)
			{
				this.removeChild(_maskHolder);
				_maskHolder = null;
			}
		}
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////// private function
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function setMaskContent($content:DisplayObject = null):void
		{
			if (!$content) // if user didn't set _maskContent after addChild yet, set a default one because if he has set _maskContent before addChild, so $content won't be null anymore
			{
				_maskContent = new Sprite();
				$content = _maskContent;
			}
			
			
			if (_maskContent && _maskContent != $content) // if _maskContent has been existed already, remove the old _maskContent
			{
				if (stage) _maskContentHolder.removeChild(_maskContent);
				_maskContent = null;
			}
			
			if (_maskContent != $content) _maskContent = $content;
			
			if (stage)
			{
				if (!_maskContentHolder) // set content holder first
				{
					_maskContentHolder = new Sprite();
					//_maskContentHolder.cacheAsBitmap = true; // for more smooth rendering
					//_maskContentHolder.cacheAsBitmapMatrix = new Matrix(); // to render the object through GPU if it's available
					_maskHolder.addChild(_maskContentHolder);
					setMask();
				}
				
				_maskContentHolder.addChild(_maskContent); // because it has been changed and has been removed from stage earlier in this function
			}
		}
		
		private function setMask():void
		{
			if (!_mask) 
			{
				_mask = new BlitMask(null);
				//_maskHolder.addChildAt(_mask, 0);
			}
			
			if (_mask && _maskContentHolder) // this will be true after this function has been called again from setMaskContent()
			{
				_mask.target = _maskContentHolder;
				_mask.x = 0;
				_mask.y = 0;
				// size settings will be set inside onResize()
			}
			
			if (_mask && _maskContentHolder)
			{
				if (_bitmapMode == ScrollConst.STRONG) _mask.bitmapMode = true;
				else _mask.bitmapMode = false;
				
				//_mask.smoothing = true;
				_mask.update();
			}
		}
		
		private function setContentBg():void
		{
			if (_enableVirtualBg)
			{
				if (!_contentBg) _contentBg = new Sprite();
				_maskHolder.addChildAt(_contentBg, 0);
			}
			else
			{
				if (_contentBg)
				{
					_contentBg.graphics.clear();
					_maskHolder.removeChild(_contentBg);
					_contentBg = null;
				}
			}
		}
		
		
		
		
		//================================================================================================================
		//================================================================================================= main functions
		//================================================================================================================
		
		override protected function onResize(e:*=null):void
		{
			super.onResize(e);
			
			if (_mask) 
			{
				_mask.width = _maskWidth;
				_mask.height = _maskHeight;
				_mask.update();
			}
			
			if (_contentBg) setDefaultObject(_contentBg, 0xFFFFFF, 0, _maskWidth, _maskHeight);
			
			
			//var rect:Rectangle = this.getRect(this);
			//this._width = rect.width;
			//this._height = rect.height;
		}
		
		private function setDefaultObject($target:*, $color:uint, $alpha:Number, $width:Number, $height:Number):void
		{
			$target.graphics.clear();
			//$target.graphics.lineStyle(5, 0x0000FF, .5, false);
			$target.graphics.beginFill($color, $alpha);
			$target.graphics.drawRect(0, 0, $width, $height);
			$target.graphics.endFill();
		}
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////// methods
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////// setter - getter
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * indicates mask width.
		 * @default 100
		 */
		public function get maskWidth():Number
		{
			return _maskWidth;
		}
		/**
		 * @private
		 */
		public function set maskWidth(w:Number):void
		{
			if(w != _maskWidth)
			{
				_maskWidth = w;
				_maskWidth = Math.max(ScrollConst.MASK_MIN_WIDTH, _maskWidth);
				
				// set _width according to _maskWidth, because we don't have no other elements for our abstract scroll, 
				// so let the class dimensions change accrording to what is actually visible, I mean the _maskWidth and _maskHeight
				this._width = _maskWidth;
				
				_propSaver.maskWidth = _maskWidth; // pass the new value to the value of the object property
				
				if (stage) onResize();
				
				this.dispatchEvent(new ScrollEvent(ScrollEvent.MASK_WIDTH));
			}
		}
		
		/**
		 * indicates mask height.
		 * @default 100
		 */
		public function get maskHeight():Number
		{
			return _maskHeight;
		}
		/**
		 * @private
		 */
		public function set maskHeight(h:Number):void
		{
			if(h != _maskHeight)
			{
				_maskHeight = h;
				_maskHeight = Math.max(ScrollConst.MASK_MIN_HEIGHT, _maskHeight);
				
				// set _height according to _maskHeight, because we don't have no other elements for our abstract scroll, 
				// so let the class dimensions change accrording to what is actually visible, I mean the _maskWidth and _maskHeight
				this._height = _maskHeight;
				
				_propSaver.maskHeight = _maskHeight; // pass the new value to the value of the object property
				
				if (stage) onResize();
				
				this.dispatchEvent(new ScrollEvent(ScrollEvent.MASK_HEIGHT));
			}
		}
		
		/**
		 * indicates mask content.
		 */
		public function get maskContent():DisplayObject
		{
			return _maskContent;
		}
		/**
		 * @private
		 */
		public function set maskContent(c:DisplayObject):void
		{
			if(c != _maskContent)
			{
				setMaskContent(c);
				if (stage) onResize();
			}
		}
		
		/**
		 * if <code>true</code> scrollbar virtual bg will be enabled,
		 * if <code>false</code> scrollbar virtual bg will be disabled.
		 */
		public function get enableVirtualBg():Boolean
		{
			return _enableVirtualBg;
		}
		/**
		 * @private
		 */
		public function set enableVirtualBg(v:Boolean):void
		{
			if(v != _enableVirtualBg)
			{
				_enableVirtualBg = v;
				
				_propSaver.enableVirtualBg = _enableVirtualBg; // pass the new value to the value of the object property
				if (stage) setContentBg();
			}
		}
		
		/**
		 * indicates when scrollbar should convert mask content into bitmap for faster processing,
		 * specially useful when scrolling on mobile devices.
		 * @default "weak"
		 */
		public function get bitmapMode():String
		{
			return _bitmapMode;
		}
		/**
		 * @private
		 */
		public function set bitmapMode(a:String):void
		{
			if(a != _bitmapMode)
			{
				_bitmapMode = a;
				_propSaver.bitmapMode = _bitmapMode; // pass the new value to the value of the object property
				
				if (stage)
				{
					if (_bitmapMode == ScrollConst.STRONG) _mask.bitmapMode = true;
					else _mask.bitmapMode = false;
				}
			}
		}
		
		/**
		 * @private
		 */
		public function get contentBg():Sprite
		{
			return _contentBg;
		}
		
		/**
		 * indicates the sprite which holds your mask content
		 */
		public function get maskContentHolder():Sprite
		{
			return _maskContentHolder;
		}
		
		/**
		 * export the class and send the Object that holds all of the setters values.
		 */
		public function get exportProp():Object
		{
			return _propSaver;
		}
		/**
		 * import the class and get the Object that holds all of the setters values.
		 */
		public function set importProp(sc:Object):void
		{
			for (var prop:* in sc)
			{
				this[prop] = sc[prop];
			}
		}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}