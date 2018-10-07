package com.crowdpark.base
{
	import com.crowdpark.interfaces.InterfaceVO;

	/**
	 * @author antonstepanov
	 */
	public class BaseVO implements InterfaceVO
	{
		private var sourceDP : Object = {};

		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// SETTERS AND GETTERS
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		public function get rawData() : Object
		{
			return sourceDP;
		}

		public function set rawData(value : Object) : void
		{
			sourceDP = value;
		}

		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// PUBLIC FUNCTIONS
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		public function getDataByKey(key : String) : Object
		{
			return sourceDP[key];
		}

		public function setDataByKey(key : String, value : Object) : void
		{
			sourceDP[key] = value;
		}

		public function toString() : String
		{
			// change to multiline key-value printout ?
			return JSON.stringify(sourceDP);
		}

		public function clone() : InterfaceVO
		{
			var clonedVO : BaseVO = new BaseVO();
			for (var key:String in sourceDP)
			{
				clonedVO.rawData[key] = sourceDP[key];
			}
			return clonedVO;
		}
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// PRIVATE FUNCTIONS
		// ::::::::::::::::::::::::::::::::::::::::::::::::::::::
	}
}
