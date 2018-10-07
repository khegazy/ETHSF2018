package com.crowdpark.base
{
	import com.crowdpark.interfaces.InterfaceVO;

	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author antonstepanov
	 */
	public class BaseDataEvent extends Event
	{
		private var _dataProvider : InterfaceVO;

		public function BaseDataEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// SETTERS AND GETTERS
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		public function get dataProvider() : InterfaceVO
		{
			if (!_dataProvider)
			{
				// trace(this,"get dataProvider(): InterfaceVO -> Override with proper dataprovider class");
				_dataProvider = new BaseVO();
			}
			return _dataProvider;
		}

		public function set dataProvider(dataProvider : InterfaceVO) : void
		{
			_dataProvider = dataProvider;
		}

		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// PUBLIC FUNCTIONS
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		override public function clone() : Event
		{
			var eventClass : Class = Class(getDefinitionByName(getQualifiedClassName(this)));
			var clonnedEvent : BaseDataEvent = new eventClass(this.type);
			clonnedEvent.dataProvider = this.dataProvider.clone();
			return clonnedEvent;
		}
	}
}
