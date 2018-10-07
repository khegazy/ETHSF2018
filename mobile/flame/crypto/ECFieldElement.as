////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.numerics.BigInteger;
	public class ECFieldElement
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * A reference to the IResourceManager object which manages all of the localized resources.
		 * 
		 * @see mx.resources.IResourceManager
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ECFieldElement()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function add(value:ECFieldElement):ECFieldElement
		{
			return null;
		}
		
		internal function divide(value:ECFieldElement):ECFieldElement
		{
			return null;
		}
		
		internal function equals(value:ECFieldElement):Boolean
		{
			return toBigInteger().equals(value.toBigInteger());
		}
		
		internal function multiply(value:ECFieldElement):ECFieldElement
		{
			return null;
		}
		
		internal function negate():ECFieldElement
		{
			return null;
		}
		
		internal function square():ECFieldElement
		{
			return null;
		}
		
		internal function subtract(value:ECFieldElement):ECFieldElement
		{
			return null;
		}
		
		public function toBigInteger():BigInteger
		{
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function get fieldSize():int
		{
			return 0;
		}
	}
}