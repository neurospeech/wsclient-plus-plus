package nslm
{
	
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.util.Base64;
	
	import flame.crypto.RSA;
	import flame.crypto.RSAPKCS1SignatureDeformatter;
	import flame.crypto.RSAParameters;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import wsClasses.License;

	public class NSLicense extends NSXmlObject
	{
		public function NSLicense()
		{
		}
		
		public var IssuedLicense:String = "";
		
		public var LicenseSignature:String = "";
		
		public var ProductUID:String = "";
		
		public var OrderID:int = 0;
		
		public var FeatureSet:NSFeatureSet = new NSFeatureSet();
		
		private var n:String = "woGwa+TGepRSjmmWcAHIoDh+nVI+fIJw6fR11mNayDwPdGz6I6VHOe7cWcVVnALsKBEYCeY2re5WeesoJQXhHXl1+Hqul46VymG695/HXzYN40uSeoKQ803lKDgEDIjbBTBVKgcerX3u1Qrn1jHti3f3Lg7e94Ndf6217ZPAliU=";
		private var exp:String = "AQAB"; 
		
		public function loadFrom(licenseFile:File):void
		{
			
			// load xml
			var fs:FileStream = new FileStream();
			fs.open(licenseFile,FileMode.READ);
			var txt:String = fs.readUTF();
			fs.close();
			
			var xml:XML = new XML(txt);
			
			super.load(xml);
			
			var rsp:RSAParameters = new RSAParameters();
			rsp.modulus = Base64.decodeToByteArray(n);
			rsp.exponent = Base64.decodeToByteArray(exp);
			var rsa:RSA = new RSA(512,rsp);
			
			var v:RSAPKCS1SignatureDeformatter = new RSAPKCS1SignatureDeformatter(rsa);
			
			v.setHashAlgorithm("MD5");
			
			var md5:MD5 = new MD5();
			var hash:ByteArray = md5.hash( Base64.decodeToByteArray(IssuedLicense));
			
			if(!v.verifySignature( hash, Base64.decodeToByteArray(LicenseSignature))){
				Alert.show("License is not valid, application will work in demo mode");
				return;
			}
			
			
			
			verified = true;
			
			// load feature set...
			xml = new XML( Base64.decode(IssuedLicense));
			
			FeatureSet.load(xml);
			
			if(FeatureSet.Version != License.version){
				Alert.show("License is not valid, application will work in demo mode");
				licenseFile.deleteFile();
				License.demo = true;
				return;
			}
			
			FeatureSet.OrderID = OrderID;
			
			License.demo = false;
		}
		
		private var verified:Boolean = false;
		
		public function isVerified():Boolean
		{
			// TODO Auto Generated method stub
			return verified;
		}
	}
}