package  {
	
	import flash.display.MovieClip;
	import com.sha3.Keccak
	import org.qrcode.QRCode;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.consts.Orientation;
	import com.doitflash.utils.scroll.TouchScroll;
	import com.doitflash.consts.Easing;
	import com.doitflash.consts.ScrollConst;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.SharedObject
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	import deriveAddress
	import com.king.encoder.RippleBase58Encoder;
	import flame.utils.ByteArrayUtil;
	import rippleFamily
	import flame.crypto.ECCParameters
    import flame.crypto.ECDSA
    import flame.crypto.asn1.ASN1BMPString
	import com.adobe.crypto.SHA256;
	import com.hurlant.util.der.ByteString
	import com.hurlant.util.der.DER
	import com.hurlant.util.der.IAsn1Type
	import com.hurlant.util.der.Integer;
	import flame.numerics.BigInteger;
	import encodeSig
    import generateTX
    import generateETHTX
	import checkAddress
	import flash.display.Stage
	import com.king.encoder.Base58Encoder;
	import encodeKeys
	import flame.crypto.ECDSASignatureDeformatter
	import flame.crypto.ECDSASignatureFormatter
	
	
	
	public class gasbois extends MovieClip {
		
	public var logInfo:SharedObject
	public var walletInfo:SharedObject
	public var keyData:ECCParameters= new ECCParameters()
	public var encodeSigClass:encodeSig= new encodeSig()
	public var generateTXClass:generateTX= new generateTX()
	public var generateETHTXClass:generateETHTX= new generateETHTX()
	public var ECDSAclass:ECDSA = new ECDSA()
	public var deriveAddressClass:deriveAddress= new deriveAddress()
	public var checkAddressClass:checkAddress= new checkAddress()
	public var encodeKeysClass:encodeKeys= new encodeKeys()
		
	public var TXInput_txid:Array = new Array()
	public var TXInput_vout:Array = new Array()
	public var TXOutput_amount:Array = new Array()
	public var TXOutput_address:Array = new Array()
		
		public function main() {
			// constructor code
			logInfo = SharedObject.getLocal("logInfo");
			walletInfo = SharedObject.getLocal("walletInfo");
			
		}
		
		
		public function generateWallet():void {
			
			var privateKey:ByteArray = new ByteArray();
			var publicKey:ByteArray = new ByteArray();

        	keyData= ECDSAclass.exportParameters(true)
			
			privateKey.writeBytes(keyData.d); //.d
			publicKey.writeBytes(keyData.x); //.x
			publicKey.writeBytes(keyData.y); //.y
			
		
			walletInfo.data.publicKey= Hex.fromArray(publicKey)
			walletInfo.data.privateKey= Hex.fromArray(privateKey)
			walletInfo.data.keyData= keyData
			walletInfo.data.ethereumAddress= deriveAddressClass.deriveEthereumAddress(publicKey)
			walletInfo.flush()

		
		}
		
		
		
		
		
	}
	
}
