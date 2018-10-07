 package
{
	
	import com.adobe.crypto.SHA256;
	import com.hurlant.util.Hex;
	import com.king.encoder.Base58Encoder;
	import com.king.encoder.RippleBase58Encoder;
	import flame.crypto.RIPEMD160;
	import flash.utils.ByteArray;

	//This class derives all popular cryptocurrency Base-58 addresses from single public key base.
	
	public class encodeKeys {

		public function encodeKeys()
		{
			

		}
		
		
		
		public function derivePubKeyHash(publicKey:ByteArray):String {

			var ripe:RIPEMD160 = new RIPEMD160();
			
			//Hashing public key with SHA-256 of RIPEMD-160.
			//Açık anahtarımızın SHA-256 karmasını RIPEMD-160 ile özetliyoruz.
			var riped:ByteArray = ripe.computeHash(Hex.toArray(SHA256.hashBytes(publicKey)));

			return Hex.fromArray(riped);
		}
		
		
		
		
		
		public function encodePrivateKey(privateKey:String,prefix:String):String {


			var encodedPrivateKey:ByteArray = new ByteArray();
			
			//Adding "0x00" prefix.
			//"0x00" ön ekini ekliyoruz.
			encodedPrivateKey.writeBytes(Hex.toArray(prefix));
			encodedPrivateKey.writeBytes(Hex.toArray(privateKey));
			
			//Generating address checksum by hashing twice with SHA-256.
			//Adres sağlamasını ikili SHA-256 karması ile oluşturuyoruz.
			var checksum:String = SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(encodedPrivateKey))).substr(0,8);

			//Finalizing address by adding checksum
			//Adres sağlamasını ekleyerek sonlandırıyoruz.
			encodedPrivateKey.writeBytes(Hex.toArray(checksum));
			encodedPrivateKey.position = 0;
			
			return Base58Encoder.encode(encodedPrivateKey);
		}

		
		public function deriveBitcoinAddress(publicKey:ByteArray):String {

			var ripe:RIPEMD160 = new RIPEMD160();
			
			//Hashing public key with SHA-256 of RIPEMD-160.
			//Açık anahtarımızın SHA-256 karmasını RIPEMD-160 ile özetliyoruz.
			var riped:ByteArray = ripe.computeHash(Hex.toArray(SHA256.hashBytes(publicKey)));
			var versionRiped:ByteArray = new ByteArray();
			
			//Adding "0x00" prefix.
			//"0x00" ön ekini ekliyoruz.
			versionRiped.writeByte(0x00);;
			versionRiped.writeBytes(riped);
			
			//Generating address checksum by hashing twice with SHA-256.
			//Adres sağlamasını ikili SHA-256 karması ile oluşturuyoruz.
			var checksum:String = SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(versionRiped))).substr(0,8);

			//Finalizing address by adding checksum
			//Adres sağlamasını ekleyerek sonlandırıyoruz.
			versionRiped.writeBytes(Hex.toArray(checksum));
			versionRiped.position = 0;
			
			return Base58Encoder.encode(versionRiped);
		}
		
		
		public function deriveLitecoinAddress(publicKey:ByteArray):String {

			var ripe:RIPEMD160 = new RIPEMD160();
			
			//Hashing public key with SHA-256 of RIPEMD-160.
			//Açık anahtarımızın SHA-256 karmasını RIPEMD-160 ile özetliyoruz.
			var riped:ByteArray = ripe.computeHash(Hex.toArray(SHA256.hashBytes(publicKey)));
			var versionRiped:ByteArray = new ByteArray();
			
			//Adding "0x30" prefix.
			//"0x30" ön ekini ekliyoruz.
			versionRiped.writeByte(0x30);;
			versionRiped.writeBytes(riped);
			
			//Generating address checksum by hashing twice with SHA-256.
			//Adres sağlamasını ikili SHA-256 karması ile oluşturuyoruz.
			var checksum:String = SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(versionRiped))).substr(0,8);

			//Finalizing address by adding checksum
			//Adres sağlamasını ekleyerek sonlandırıyoruz.
			versionRiped.writeBytes(Hex.toArray(checksum));
			versionRiped.position = 0;
			
			return Base58Encoder.encode(versionRiped);
		}
		
	    
		public function deriveDashAddress(publicKey:ByteArray):String {

			var ripe:RIPEMD160 = new RIPEMD160();
			
			//Hashing public key with SHA-256 of RIPEMD-160.
			//Açık anahtarımızın SHA-256 karmasını RIPEMD-160 ile özetliyoruz.
			var riped:ByteArray = ripe.computeHash(Hex.toArray(SHA256.hashBytes(publicKey)));
			var versionRiped:ByteArray = new ByteArray();
			
			//Adding "0x4C" prefix.
			//"0x4C" ön ekini ekliyoruz.
			versionRiped.writeByte(0x4C);;
			versionRiped.writeBytes(riped);
			
			//Generating address checksum by hashing twice with SHA-256.
			//Adres sağlamasını ikili SHA-256 karması ile oluşturuyoruz.
			var checksum:String = SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(versionRiped))).substr(0,8);

			//Finalizing address by adding checksum
			//Adres sağlamasını ekleyerek sonlandırıyoruz.
			versionRiped.writeBytes(Hex.toArray(checksum));
			versionRiped.position = 0;
			
			return Base58Encoder.encode(versionRiped);
		}
		
		
		public function deriveDogeAddress(publicKey:ByteArray):String {

			var ripe:RIPEMD160 = new RIPEMD160();
			
			//Hashing public key with SHA-256 of RIPEMD-160.
			//Açık anahtarımızın SHA-256 karmasını RIPEMD-160 ile özetliyoruz.
			var riped:ByteArray = ripe.computeHash(Hex.toArray(SHA256.hashBytes(publicKey)));
			var versionRiped:ByteArray = new ByteArray();
			
			//Adding "0x1E" prefix.
			//"0x1E" ön ekini ekliyoruz.
			versionRiped.writeByte(0x1E);;
			versionRiped.writeBytes(riped);
			
			//Generating address checksum by hashing twice with SHA-256.
			//Adres sağlamasını ikili SHA-256 karması ile oluşturuyoruz.
			var checksum:String = SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(versionRiped))).substr(0,8);

			//Finalizing address by adding checksum
			//Adres sağlamasını ekleyerek sonlandırıyoruz.
			versionRiped.writeBytes(Hex.toArray(checksum));
			versionRiped.position = 0;
			
			return Base58Encoder.encode(versionRiped);
		}
		
		
		public function deriveNeoAddress(publicKey:ByteArray):String {

			var ripe:RIPEMD160 = new RIPEMD160();
			
			//Hashing public key with SHA-256 of RIPEMD-160.
			//Açık anahtarımızın SHA-256 karmasını RIPEMD-160 ile özetliyoruz.
			var riped:ByteArray = ripe.computeHash(Hex.toArray(SHA256.hashBytes(publicKey)));
			var versionRiped:ByteArray = new ByteArray();
			
			//Adding "0x1E" prefix.
			//"0x1E" ön ekini ekliyoruz.
			versionRiped.writeByte(0x17);;
			versionRiped.writeBytes(riped);
			
			//Generating address checksum by hashing twice with SHA-256.
			//Adres sağlamasını ikili SHA-256 karması ile oluşturuyoruz.
			var checksum:String = SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(versionRiped))).substr(0,8);

			//Finalizing address by adding checksum
			//Adres sağlamasını ekleyerek sonlandırıyoruz.
			versionRiped.writeBytes(Hex.toArray(checksum));
			versionRiped.position = 0;
			
			return Base58Encoder.encode(versionRiped);
		}
		
		public function deriveZCashAddress(publicKey:ByteArray):String {

			var ripe:RIPEMD160 = new RIPEMD160();
			
			//Hashing public key with SHA-256 of RIPEMD-160.
			//Açık anahtarımızın SHA-256 karmasını RIPEMD-160 ile özetliyoruz.
			var riped:ByteArray = ripe.computeHash(Hex.toArray(SHA256.hashBytes(publicKey)));
			var versionRiped:ByteArray = new ByteArray();
			
			//Adding "0x1C" prefix.
			//"0x1C" ön ekini ekliyoruz.
			versionRiped.writeByte(0x1C);;
		    
			//Then adding "0xB8" prefix.
			//Ardından "0xB8" ön ekini ekliyoruz.
			versionRiped.writeByte(0xB8);;
			versionRiped.writeBytes(riped);
			
			//Generating address checksum by hashing twice with SHA-256.
			//Adres sağlamasını ikili SHA-256 karması ile oluşturuyoruz.
			var checksum:String = SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(versionRiped))).substr(0,8);

			//Finalizing address by adding checksum
			//Adres sağlamasını ekleyerek sonlandırıyoruz.
			versionRiped.writeBytes(Hex.toArray(checksum));
			versionRiped.position = 0;
			
			return Base58Encoder.encode(versionRiped);
		}
		
		
		public function deriveRippleAddress(publicKey:ByteArray):String {

			var ripe:RIPEMD160 = new RIPEMD160();
			
			//Hashing public key with SHA-256 of RIPEMD-160.
			//Açık anahtarımızın SHA-256 karmasını RIPEMD-160 ile özetliyoruz.
			var riped:ByteArray = ripe.computeHash(Hex.toArray(SHA256.hashBytes(publicKey)));
			var versionRiped:ByteArray = new ByteArray();
			
			//Then adding "0x00" prefix.
			//Ardından "0x00" ön ekini ekliyoruz.
			versionRiped.writeByte(0x00);;
			versionRiped.writeBytes(riped);
			
			//Generating address checksum by hashing twice with SHA-256.
			//Adres sağlamasını ikili SHA-256 karması ile oluşturuyoruz.
			var checksum:String = SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(versionRiped))).substr(0,8);

			//Finalizing address by adding checksum
			//Adres sağlamasını ekleyerek sonlandırıyoruz.
			versionRiped.writeBytes(Hex.toArray(checksum));
			versionRiped.position = 0;
			
			return RippleBase58Encoder.encode(versionRiped);
		}
		
		

		
		
		
		
	}
}