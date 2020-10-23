package  wsForm
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import wsClasses.AS3Generator;
	import wsClasses.AS4Generator;
	import wsClasses.JavaGenerator;
	import wsClasses.License;
	import wsClasses.ObjCGenerator;
	import wsClasses.SoapService;
	import wsClasses.WSGenerator;
	
	
	[RemoteClass]
	[Bindable]
	public class WSProjectProperties
	{
		public function WSProjectProperties()
		{
			
			this.generateType = "objC";
			this.target = "iphone";		
		}
		
		public var folderPath:String = "";
		
		public var generateType:String = "";
		
		public var generateFilename:String = "";
		
		public var generateRequest:Boolean = false;
		
		public var makeAllBindable:Boolean = true;
		
		public var forIPhone:Boolean = false;
		
		public var forAndroid:Boolean = false;
		
		public var forBlackberry:Boolean = false;
		
		public var forSilverlight:Boolean = false;
		
		public var soapType:String = "soap12";
		
		public var wsdlUrl:String = "";

		// will be used for prefixing in JS and Obj-C
		public var localNamespace:String = "";
		
		public var log:String = "";
		
		public var target:String = "";
		
		public var resultFunc: Function = null;
		
		public function save(f:File = null):void{
			try{
			
				var fs:FileStream = new FileStream();
				fs.open(f, FileMode.WRITE);
				
				var enc:JSONEncoder = new JSONEncoder(this);
				fs.writeUTF(enc.getString());
				
				fs.close();
				
				if(showSuccess)
					Alert.show("File saved successfully");
				showSuccess = true;

				resetCache();
			}
			catch(e:Error)
			{
				Alert.show("Make sure file is not readonly and is checked out !!" + e.toString(),"Save Error");
			}
		}
		
		private function resetCache():void
		{
			_oldCache = {
				folderPath:folderPath,
				generateType:generateType,
				generateFilename:generateFilename,
				generateRequest:generateRequest,
				forIPhone:forIPhone,
				forAndroid:forAndroid,
				forBlackberry:forBlackberry,
				forSilverlight: forSilverlight,
				wsdlUrl:wsdlUrl,
				localNamespace:localNamespace,
				target:target,
				soapType:soapType
			};
		}
		
		private var showSuccess:Boolean = true;
		
		private var _oldCache:Object = null;
		
		public function load(f:File):void
		{
			
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.READ);
			
			
			
			//var dec:JSONDecoder = new JSONDecoder(fs.readUTF(),false);
			
			
			//var val:Object = dec.getValue();
			
			var val:Object = JSON.parse(fs.readMultiByte(fs.bytesAvailable,File.systemCharset));
			
			for (var s:String in val){
				if(s=="log")
					continue;
				if(this.hasOwnProperty(s))
					this[s] = val[s];
			}
			if(this.soapType==null){
				this.soapType = "soap12";
			}
			
			resetCache();
			fs.close();
			
			_oldCache = val;
		}
		
		public function isModified():Boolean
		{
			if(!_oldCache)
				return true;
			for (var s:String in _oldCache){
				if(s=="log")
					continue;
				if(this[s] != _oldCache[s]){
					return true;
				}
			}
			return false;
		}
		
		
		private var generator:WSGenerator = null;
		
		public function generateFiles(gen:WSGenerator):void{
			
			showSuccess = false;
			generator = gen;
			gen.properties = this;
			
			index = 0;
			
			urlsPending = [];
			
			log = "Starting..\n";

			var urlList:Array = wsdlUrl.split(/[\r\n]+/);
			
			for each( var url:String in urlList)
			{
				if(!url)
					continue;
				urlsPending.push(url);
				if(License.demo){
					if(urlsPending.length>1)
						break;
				}
			}
			
			urlsPending = urlsPending.reverse();
			
			generator.start();
			processNext();
		}
		
		
		
		private function processNext():void
		{
			if(urlsPending.length==0)
			{
				generator.end();
				if (resultFunc!=null) {
					resultFunc();
				}else{
					Alert.show("Done");
				}
				return;
			}
			
			var url:String = urlsPending.pop() as String;
			
			if(url ==null || url.length==0)
			{
				processNext();
				return;
			}
			
			log += url + "\n";
			
			var sl:SchemaLoader = new SchemaLoader(url);
			sl.addEventListener(ResultEvent.RESULT,onResult);
			sl.addEventListener(FaultEvent.FAULT,onFault);
			sl.processQueue();
		}
		
		private var urlsPending:Array = [];
		
		private var index:int = 0;
		
		private function onResult(r:ResultEvent):void
		{
			var ss:SoapService = new SoapService();
			ss.schemaArray = r.result[1] as Array;
			ss.enableSoap12 = this.soapType == "soap12";
			
			ss.url = wsdlUrl;
			
			if(License.debug){
				//try{
				ss.load( r.result[0] as XML);
				//}catch(er2:Error){
				//	log += er2.toString() + "\n";
				//	log += "Error: WSClient++ does not support XMLNodes as return type or parameter type\n";
				//	return;
				//}
				
				// load references...
				
				generator.clearTypes();
				generator.generateService(ss);
				
				/*try{
				
				generator.generateService(ss);
				}catch(er:Error){
				log += er.toString() + "\n";
				log += "Please check if WSClient++ has write access to the folder you want to generate files in.\n";
				}*/
			}else{
				try{
				ss.load( r.result[0] as XML);
				}catch(er2:Error){
					log += er2.toString() + "\n";
					log += er2.getStackTrace() + "\n";
					log += "Error: WSClient++ does not support XMLNodes as return type or parameter type\n";
					if (resultFunc!=null) {
						resultFunc();
					}
					return;
				}
				
				try{
					generator.generateService(ss);
				}catch(er:Error){
					log += er.toString() + "\n";
					log += er.getStackTrace() + "\n";
					log += "Please check if WSClient++ has write access to the folder you want to generate files in.\n";
				}
			}
			
			
			processNext();
		}
		
		
		/*private var csGen:CSharpGenerator = null;
		private var objCGen:ObjCGenerator = null;*/
		
		private function onFault(f:FaultEvent):void
		{
			log += f.toString() + "\n";
//			if(f.target != null && f.target.data && f.target.data){
//				log += f.target.data.toString() + "\n";
//			}
			if(f.fault.rootCause){
				log += f.fault.rootCause.toString();
			}
			if (resultFunc != null) {
				resultFunc();
			}else{
				Alert.show(f.toString());
			}
		}
		
		 
	}
}