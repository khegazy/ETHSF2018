////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.utils
{
	import flash.utils.getQualifiedClassName;
	
	
	
	/**
	 * The DateUtil utility class is an all-static class with methods for working with Date objects.
	 * You do not create instances of DateUtil;
	 * instead you call methods such as the <code>DateUtil.isLeapYear()</code> method.
	 */
	public final class DateUtil
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @throws flash.errors.IllegalOperationError DateUtil is an all-static class.
		 */
		public function DateUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns the number of days in the specified month and year. 
		 * 
		 * @param year The year (a 4-digit year).
		 * 
		 * @param month The month (a number ranging from 1 to 12).
		 * 
		 * @return The number of days in <code>month</code> parameter for the specified <code>year</code> parameter.
		 * For example, if <code>month</code> parameter equals 2 for February,
		 * the return value is 28 or 29 depending upon whether <code>year</code> parameter is a leap year.
		 * 
		 * @throws RangeError Thrown in the following situations:<ul>
		 * <li><code>month</code> parameter is less than 1 or greater than 12.</li>
		 * <li><code>year</code> parameter is less than 1 or greater than 9999.</li>
		 * </ul>
		 */
		public static function daysInMonth(year:int, month:int):int
		{
			
			switch (month)
			{
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					
					return 31;
				
				case 2:
					
					return isLeapYear(year) ? 29 : 28;
				
				case 4:
				case 6:
				case 9:
				case 11:
					
					return 30;
				
				default:
					return 30;
			}
		}
		
		/**
		 * Returns an indication whether the specified year is a leap year.
		 * 
		 * @param year The year (a 4-digit year).
		 * 
		 * @return <code>true</code> if <code>year</code> parameter is a leap year; otherwise, <code>false</code>.
		 * 
		 * @throws RangeError <code>year</code> parameter is less than 1 or greater than 9999.
		 */
		public static function isLeapYear(year:int):Boolean
		{
				
			return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
		}
	}
}