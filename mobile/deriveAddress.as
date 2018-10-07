 package
{
	
	import com.adobe.crypto.SHA256;
	import com.hurlant.util.Hex;
	import com.king.encoder.Base58Encoder;
	import com.king.encoder.RippleBase58Encoder;
	import flame.crypto.RIPEMD160;
	import flash.utils.ByteArray;
	import com.sha3.Keccak
	
	//This class derives all popular cryptocurrency Base-58 addresses from single public key base.
	
	public class deriveAddress {

		public function deriveAddress()
		{
			
		}
		
		public function deriveEthereumAddress(publicKey:ByteArray):String {
			
			var keccak256hexS = new Keccak(256);

			return "0x" + String(keccak256hexS.hexStringInput(Hex.fromArray(publicKey))).substr(24,40) 			
		}


		
	}
}