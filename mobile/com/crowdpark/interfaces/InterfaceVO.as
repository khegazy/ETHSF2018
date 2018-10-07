package com.crowdpark.interfaces
{
	/**
	 * @author antonstepanov
	 */
	public interface InterfaceVO
	{
		function get rawData() : Object;

		function set rawData(value : Object) : void;

		function getDataByKey(key : String) : Object;

		function setDataByKey(key : String, value : Object) : void;

		function toString() : String;

		function clone() : InterfaceVO;
	}
}
