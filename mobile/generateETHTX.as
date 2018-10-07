package  {
	
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	import flame.crypto.RIPEMD160;
	import com.adobe.crypto.SHA256;
    import flame.crypto.ECDSA
	import encodeSig
	import flash.net.SharedObject
	//import flash.net.dns.AAAARecord;
	import flame.crypto.ECCParameters
	import flame.crypto.ECDSASignatureDeformatter
	import flame.crypto.ECDSASignatureFormatter
	import com.sha3.Keccak
	
    //This class generates hex TX from given parameters (inputs and outputs)
	//Bu sınıf transfer işlemini hex formatında oluşturur.
	
	public class generateETHTX {
		

		public function generateTX() {

		}
		
		public function generateUnsignedTX(nonce:Number,gasPrice:Number,toAddress:String,value:Number, data:String):ByteArray {
			
			var returnArray:ByteArray= new ByteArray()
			var unsignedTX:ByteArray= new ByteArray()
			
			unsignedTX.writeBytes(encodeNonce(nonce))
			//unsignedTX.writeBytes(encodeASN(gasPrice))
			unsignedTX.writeBytes(encodeASN(10000000000))
			
			//unsignedTX.writeByte(0x82)
			//unsignedTX.writeByte(0x52)
			//unsignedTX.writeByte(0x08)
			
			unsignedTX.writeByte(0x83)
			unsignedTX.writeByte(0x1B)
			unsignedTX.writeByte(0x06)
			unsignedTX.writeByte(0xE4)
			
			
			
			
			unsignedTX.writeByte(0x94)
			unsignedTX.writeBytes(Hex.toArray(toAddress))
			
			
			//unsignedTX.writeBytes(encodeASN(value))
			unsignedTX.writeByte(0x80)
			
			
			//unsignedTX.writeByte(0x80)
			
			
			unsignedTX.writeBytes(Hex.toArray(data))
			
			
			
			unsignedTX.writeByte(0x04)
			unsignedTX.writeByte(0x80)
			unsignedTX.writeByte(0x80)
			trace("lollen "+Hex.fromArray(unsignedTX))
			var numberOfLength:Number= Number(Hex.fromArray(unsignedTX).length)/2
			trace("numberOfLength "+numberOfLength)
			var RLP2nd:String= byteCheck(numberOfLength.toString(16))
			trace("RLP2nd "+RLP2nd)
			var RLP1st:String= byteCheck(Number(247 + Number(RLP2nd.length)/2).toString(16))
			trace("RLP1st "+RLP1st)
			
			returnArray.writeBytes(Hex.toArray(RLP1st + RLP2nd))
			
			returnArray.writeBytes(unsignedTX)
			
			trace("unsigneddtxis:  "+Hex.fromArray(returnArray))
			
			return returnArray
			
		}
		
		public function generateSignedTX(nonce:Number, gasPrice:Number, toAddress:String, value:Number, priKey:String, mode:Number, data:String):ByteArray{
			
			var unsignedTX:ByteArray= new ByteArray()
			unsignedTX.writeBytes(generateUnsignedTX(nonce, gasPrice, toAddress, value, data))
			
			var signaturePart:ByteArray= new ByteArray()
			signaturePart.writeBytes(signTX(unsignedTX, priKey, mode))
			
			//returnArray.writeByte(0xf8)
			//returnArray.writeBytes(Hex.toArray(Number(Number(Number(Hex.fromArray(unsignedTX).length) + Number(Hex.fromArray(signaturePart).length))/2).toString(16)))
			
			var returnArray:ByteArray= new ByteArray()
			
			returnArray.writeBytes(encodeNonce(nonce))
			//unsignedTX.writeBytes(encodeASN(gasPrice))
			returnArray.writeBytes(encodeASN(10000000000))
			
			//unsignedTX.writeByte(0x82)
			//unsignedTX.writeByte(0x52)
			//unsignedTX.writeByte(0x08)
			
			returnArray.writeByte(0x83)
			returnArray.writeByte(0x1B)
			returnArray.writeByte(0x06)
			returnArray.writeByte(0xE4)
			
			
			
			
			returnArray.writeByte(0x94)
			returnArray.writeBytes(Hex.toArray(toAddress))
			
			
			//unsignedTX.writeBytes(encodeASN(value))
			returnArray.writeByte(0x80)
			
			
			//unsignedTX.writeByte(0x80)
			
			
			returnArray.writeBytes(Hex.toArray(data))
			
			
			returnArray.writeBytes(signaturePart)
			
			var finalReturnArray:ByteArray= new ByteArray()
			
			finalReturnArray.writeByte(0xf8)
			finalReturnArray.writeBytes(Hex.toArray(Number(Hex.fromArray(returnArray).length/2).toString(16)))
			
			

			finalReturnArray.writeBytes(returnArray)
			
			trace("SSsigneddtxis:  "+Hex.fromArray(finalReturnArray))
			
			return finalReturnArray
			
		}
		
		
		public function signTX(data:ByteArray,priKey:String,mode:Number):ByteArray{
			
			trace("signprikeyis: "+priKey)
			
			var keccak256hexS = new Keccak(256);
			
			var dataDigest:String= keccak256hexS.hexStringInput(Hex.fromArray(data)) 
			
			trace("dataDdigestis "+dataDigest)
			
		    var ecdsa:ECDSA = new ECDSA(256);
		    ecdsa.deriveCorrespondingPubkey2(Hex.toArray(priKey))

		    var formatter:ECDSASignatureFormatter = new ECDSASignatureFormatter(ecdsa);

			var ECsignature:ByteArray = formatter.createSignature(Hex.toArray(dataDigest));
			
			trace("signatureis1:  "+ Hex.fromArray(ECsignature).substr(0,64))
			trace("signatureis2:  "+ Hex.fromArray(ECsignature).substr(64,64))
			
			
			var rSig:ByteArray= new ByteArray()
			var sSig:ByteArray= new ByteArray()
			
			rSig.writeBytes(Hex.toArray(Hex.fromArray(ECsignature).substr(0,64)))
			sSig.writeBytes(Hex.toArray(Hex.fromArray(ECsignature).substr(64,64)))
			
			var signature:ByteArray= new ByteArray()
			
			if(mode==1){
			signature.writeByte(0x26)
			}
			else if(mode==2){
			signature.writeByte(0x25)
			}

			signature.writeByte(0xa0)
			signature.writeBytes(rSig)
			signature.writeByte(0xa0)
			signature.writeBytes(sSig)
			
			return signature
			
		}
		
		
		
		public function encodeNonce(nonce:Number):ByteArray{
			
			var returnArray:ByteArray= new ByteArray()
			
			if(nonce==0){
				
				returnArray.writeByte(0x80)
				
			}
			else if(nonce>=1){
				
				if(nonce<=127){
					returnArray.writeBytes(Hex.toArray(byteCheck(nonce.toString(16))))
					
				}
				else if(nonce>=128){
					
					if(nonce<=255){
						
						returnArray.writeByte(0x81)
						returnArray.writeBytes(Hex.toArray(byteCheck(nonce.toString(16))))
						
					}
					
					else if(nonce>=256){
						
						returnArray.writeByte(0x82)
						returnArray.writeBytes(Hex.toArray(byteCheck(nonce.toString(16))))
						
					}
					
				}
				
			}
			
			return returnArray

			
		}
		
		
		public function encodeASN(p1:Number):ByteArray{
			
			var returnArray:ByteArray= new ByteArray()
			
			var str:String= byteCheck(p1.toString(16))
			
			returnArray.writeBytes(Hex.toArray("8"+String(Number(Number(str.length)/2).toString(16))))
			returnArray.writeBytes(Hex.toArray(str))
			
			return returnArray
			
		}
		
		
		
		public function byteCheck(str:String):String{
			var returnStr:String= str
			
			if(Number(Number(str.length) % 2)!=0){
				returnStr= "0" + str
			}
			
			return returnStr
			
		}
		
		
		

	}
	
}
