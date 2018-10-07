package  {
	import flame.numerics.BigInteger;
	import flash.utils.ByteArray;
	import com.hurlant.util.Hex;
	
		//This class encodes for DER representation to the raw ECDSA signature.
		//Bu sınıf ECDSA dijital imzasını DER sunum formatına dönüştürür.
	
	public class encodeSig {

		public function encodeSig() {

		}
		
		
		public function encodeSigParameters(r:String,s:String):ByteArray {
			
			trace("RIS: "+r)
			trace("SIS: "+s)

			
			var pushSignArray:ByteArray= new ByteArray()
			pushSignArray.writeByte(0x30)
			pushSignArray.writeBytes(Hex.toArray(uint2hex(Number(r.length+s.length)/2 +4)))
			pushSignArray.writeBytes(encodeR(r))
			pushSignArray.writeBytes(Hex.toArray(r))
			pushSignArray.writeBytes(encodeS(s))
			pushSignArray.writeBytes(Hex.toArray(s))
			pushSignArray.writeByte(0x01)
			pushSignArray.position= 0
			
            return pushSignArray

		}
		
		
		public function encodeR(r:String):ByteArray {
			var encodeRArray:ByteArray= new ByteArray()
			encodeRArray.writeByte(0x02)
			encodeRArray.writeBytes(Hex.toArray(uint2hex(Number(r.length/2))))
			encodeRArray.position= 0
			
			return encodeRArray
			
		}
		
		
		public function encodeS(s:String):ByteArray {
			var encodeSArray:ByteArray= new ByteArray()
			encodeSArray.writeByte(0x02)
			encodeSArray.writeBytes(Hex.toArray(uint2hex(Number(s.length/2))))
			encodeSArray.position= 0
			
			return encodeSArray
			
		}
		
		
		public function uint2hex(dec:uint):String {
			var digits:String = "0123456789ABCDEF";
	        var hex:String = '';
 
	        while (dec > 0) {
		   		var next:uint = dec & 0xF;
				dec >>= 4;
				hex = digits.charAt(next) + hex;
	        }
     
	        if (hex.length == 0) hex = '0'
 
	        	return hex;
}


	}
	
}
