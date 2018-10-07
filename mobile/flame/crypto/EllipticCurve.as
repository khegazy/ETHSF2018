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
	
	
	
	
	
	public class EllipticCurve
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
		
		
		protected var _a:ECFieldElement;
		protected var _b:ECFieldElement;
		protected var _pointAtInfinity:ECPoint;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function EllipticCurve()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
	
		public function bigIntegerToFieldElement(value:BigInteger):ECFieldElement
		{
			return null;
		}
		
		public function createPoint(x:BigInteger, y:BigInteger):ECPoint
		{
			return null;
		}
		
		public function equals(value:EllipticCurve):Boolean
		{
			return _a.equals(value._a) && _b.equals(value._b);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		public function get a():ECFieldElement
		{
			return _a;
		}
		
		public function get b():ECFieldElement
		{
			return _b;
		}
		
		public function get fieldSize():int
		{
			return 0
		}
		
		public function get pointAtInfinity():ECPoint
		{
			return _pointAtInfinity;
		}
	}
}