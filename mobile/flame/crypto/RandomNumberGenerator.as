////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.utils.ByteArrayUtil;
	
	import flash.crypto.generateRandomBytes;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * Implements a Random Number Generator (RNG). This is an all-static class.
	 */
	public final class RandomNumberGenerator
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
		 * @throws flash.errors.IllegalOperationError RandomNumberGenerator is an all-static class.
		 */
		public function RandomNumberGenerator()
		{
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Returns an array of bytes with a sequence of random values.
		 * <p>Internally, this method uses the <code>generateRandomBytes()</code> method to generate random bytes.</p>
		 * 
		 * @param count The length of the returned byte array.
		 * 
		 * @return A byte array with randomly generated bytes.
		 * 
		 * @throws RangeError <code>count</code> parameter is less than zero.
		 * 
		 * @see flash.crypto.#generateRandomBytes() flash.crypto.generateRandomBytes()
		 */
		public static function getBytes(count:int):ByteArray
		{
			
			var data:ByteArray = generateRandomBytes(Math.min(count, 1024));
			
			if (count > 1024)
			{
				for (var i:int = 1, length:int = count / 1024; i < length; i++)
					data.writeBytes(generateRandomBytes(1024));
				
				length = count % 1024;
				
				if (length != 0)
					data.writeBytes(generateRandomBytes(length));
				
				data.position = 0;
			}
			
	        return data || new ByteArray();
		}
		
		/**
		 * Returns an array of bytes with a sequence of random nonzero values.
		 * <p>Internally, this method uses the <code>generateRandomBytes()</code> method to generate random bytes.</p>
		 * 
		 * @param count The length of the returned byte array.
		 * 
		 * @return A byte array with randomly generated nonzero bytes.
		 * 
		 * @throws RangeError <code>count</code> parameter is less than zero.
		 * 
		 * @see flash.crypto.#generateRandomBytes() flash.crypto.generateRandomBytes()
		 */
		public static function getNonZeroBytes(count:int):ByteArray
		{
			
			var data:ByteArray = getBytes(count);
            
	        for (var i:int = 0; i < count; i++)
				while (data[i] == 0)
					data[i] = generateRandomBytes(1)[0];
	            
	        return data;
		}
	}
}