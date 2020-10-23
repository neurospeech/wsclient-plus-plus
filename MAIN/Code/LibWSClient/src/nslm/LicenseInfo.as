package nslm
{
	import com.adobe.crypto.MD5;
	import com.neuro.command.GenericCommand;
	import com.neuro.service.NSWebService;
	import com.neuro.utils.MD5;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	import mx.controls.Alert;
	
	[Event(name="verified", type="flash.events.Event")]
	[Event(name="error", type="flash.events.Event")]
	[Event(name="found", type="flash.events.Event")]
	[Bindable]
	public class LicenseInfo extends EventDispatcher
	{
		public function LicenseInfo()
		{
			
			licenseAgreed = false;
			subscribe = false;
			
			if(LICENSE::demo)
			{			
				subscribe = true;
			}
			else
			{
				//startVerify();
			}
			
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespaceDeclarations()[0];
			applicationName = descriptor.ns::name;
			applicationVersion = descriptor.ns::version;
			
			
			// set base url..
			//NSWebService.globalBaseUrl = "https://nsaccount.800casting.com";
			NSWebService.globalBaseUrl = "http://account.neurospeech.com";
			GenericCommand.globalDisplayFault = true;
			
			// try loading...
			var f:File = this.licenceFile;
			if(!f.exists)
				return;
			
			var fs:FileStream = new FileStream();
			fs.open(f,FileMode.READ);
			var obj:Object = fs.readObject();
			for(var p:String in obj){
				this[p] = obj[p];
			}
			fs.close();
			
			editionUID = globalEditionUID;
			
			
			//licenseAgreed = false;
			
			
			
		}
		
		public function startVerify():void
		{
			hp = new HostNameProvider();
			hp.addEventListener(NativeProcessExitEvent.EXIT,onExit, false,0,true);
			hp.getHostName();
		}
		
		private var hp:HostNameProvider = null;
		
		private function onExit(e:Event):void
		{
			computerName = hp.hostName;
			
			if(activationCode!="")
			{ 
				if (verify()){
					this.dispatchEvent(new Event("verified",false,false));
				}else{
					this.dispatchEvent(new Event("error",false,false));
				}
			}else{
				// query web....
				this.dispatchEvent(new Event("found"));
			}
		}
		
		public var computerName:String = "";
		
		private function get licenceFile():File
		{
			var f:File = null;
			
			if(LICENSE::demo){
				f = File.applicationStorageDirectory.resolvePath("demolicense1.as3");
			}else{
				f = File.applicationStorageDirectory.resolvePath("license.as3");
			}
			return f;
		}
		
		public function save():void
		{
			var f:File = licenceFile;
			
			var fs:FileStream = new FileStream();
			fs.open(f,FileMode.WRITE);
			var obj:Object = {
				emailAddress:emailAddress,
				editionUID:editionUID,
				demoCode:demoCode,
				licenceCode:licenceCode,
				activationCode:activationCode,
				subscribe:subscribe,
				licenseAgreed:licenseAgreed
			};
			fs.writeObject(obj);
			fs.close();
		}
		
		public function verifyDemo():Boolean
		{
			var key:String = com.neuro.utils.MD5.hex_md5(emailAddress + ":" + editionUID);
			if(key==demoCode)
				return true;
			return false;
		}
		
		private function verify():Boolean{
			var key:String = com.neuro.utils.MD5.hex_md5(editionUID + ":" + licenceCode + ":" + computerName);
			if(key==activationCode){
				save();
				return true;
			}else{
				licenceFile.deleteFile();
			}
			return false;
		}
		
		public var emailAddress:String = "";
		public var licenseAgreed:Boolean = false;
		public var editionUID:String = globalEditionUID;
		public var demoCode:String = "";
		public var licenceCode:String = "";
		public var activationCode:String = "";
		public var subscribe:Boolean = true;
		public var applicationName:String = "";
		public var applicationVersion:String = "";
		
		public static var globalEditionUID:String = "";
	}
}