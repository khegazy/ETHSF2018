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
	
	public class ECPoint
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
		
		protected var _curve:EllipticCurve;
		protected var _multiplier:ECPointMultiplier;
		protected var _x:ECFieldElement;
		protected var _y:ECFieldElement;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ECPoint(curve:EllipticCurve, x:ECFieldElement, y:ECFieldElement)
		{
			super();
			
			_curve = curve;
			_x = x;
			_y = y;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function add(value:ECPoint):ECPoint
		{
			return null;
		}
		
		internal function double():ECPoint
		{
			return null;
		}
		
		public function multiply(value:BigInteger):ECPoint
		{
			return _multiplier.multiply(value);
		}
		
		internal function negate():ECPoint
		{
			return null;
		}
		
		internal function subtract(value:ECPoint):ECPoint
		{
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		public function get curve():EllipticCurve
		{
			return _curve;
		}
		
		public function get isAtInfinity():Boolean
		{
			return _x == null && _y == null;
		}
		
		public function get x():ECFieldElement
		{
			return _x;
		}
		
		public function get y():ECFieldElement
		{
			return _y;
		}
	}
}