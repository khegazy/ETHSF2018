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

	public class PrimeEllipticCurve extends EllipticCurve
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _q:BigInteger;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PrimeEllipticCurve(q:BigInteger, a:BigInteger, b:BigInteger)
		{
			super();
			
			_q = q;
			_a = bigIntegerToFieldElement(a);
			_b = bigIntegerToFieldElement(b);
			_pointAtInfinity = new PrimeECPoint(this, null, null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		  
		override public function bigIntegerToFieldElement(value:BigInteger):ECFieldElement
		{
			return new PrimeECFieldElement(_q, value);
		}
		
		override public function createPoint(x:BigInteger, y:BigInteger):ECPoint
		{
			return new PrimeECPoint(this, bigIntegerToFieldElement(x), bigIntegerToFieldElement(y));
		}

		override public function equals(value:EllipticCurve):Boolean
		{
			return value is PrimeEllipticCurve && _q.equals(PrimeEllipticCurve(value)._q) && super.equals(value);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		override public function get fieldSize():int
		{
			return _q.bitLength;
		}
		
		public function get q():BigInteger
		{
			return _q;
		}
	}
}