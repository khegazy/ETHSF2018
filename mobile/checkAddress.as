package  {
	import flame.numerics.BigInteger;
	import flash.utils.ByteArray;
	import com.hurlant.util.Hex;
	import com.adobe.crypto.SHA256;
	import com.king.encoder.Base58Encoder;
	

	
	public class checkAddress {
		
		public function checkAddress() {
					
	}

		public function check(address:String):Boolean{
			var decodestr:String= Hex.fromArray(Base58Encoder.decode(address))
			
			if(decodestr.length==48){
				decodestr= "00" + decodestr
			}
			
			if(decodestr.length==46){
				decodestr= "0000" + decodestr
			}
			
			var checksum:String= SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(Hex.toArray(decodestr.substr(0,42))))).substr(0,8)
			var equal:Boolean
			
			if(checksum == decodestr.substr(42,8)){
				equal= true
			}
			else {
				equal= false
			}
			
			return equal
		 
		}

	}
	
}
