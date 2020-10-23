package wsForm
{
	import com.adobe.utils.StringUtil;
	
	import flash.events.EventDispatcher;
	import flash.xml.XMLNode;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	import mx.utils.URLUtil;
	
	import wsClasses.ObjCGenerator;
	
	
	[Event(name='result',type='mx.rpc.events.ResultEvent')]
	[Event(name='fault',type='mx.rpc.events.FaultEvent')]
	public class SchemaLoader extends EventDispatcher
	{
		private var queue:Array = [];
		
		public function SchemaLoader(url:String)
		{
			baseUrl = url;
			queue.push( { destinationUrl:url, merge:false} );
		}
		
		private var baseUrl:String = "";
		
		private var result:XML = null;
		
		private var merged:Array = [];
		
		public var schemaArray:Array = [];
		
		public function processQueue():void{
			
			if(queue.length==0){
				// done...
				//trace(result.toXMLString());
				this.dispatchEvent(new ResultEvent(ResultEvent.RESULT,false,false,[result,schemaArray]));
				return;
			}
			
			var r:Object = queue.pop();
			
			var hs:HTTPService = new HTTPService();
			hs.useProxy = false;
			
			hs.url = r.destinationUrl;
			merged.push(r.destinationUrl);
			trace(hs.url);
			hs.resultFormat = "text";
			if(r.merge)
				hs.addEventListener(ResultEvent.RESULT, onResultMerge);
			else
				hs.addEventListener(ResultEvent.RESULT, onResult);
			hs.addEventListener(FaultEvent.FAULT, onFault);
			hs.send();
		}
		
		private var xsd:Namespace = new Namespace("http://www.w3.org/2001/XMLSchema");
		private var wsdl:Namespace = new Namespace("http://schemas.xmlsoap.org/wsdl/");
		
		private function onResult(re:ResultEvent):void
		{
			result = new XML(re.result);
			
			//result = mergeNamespaces(result,result);
			//trace(result.toXMLString());
			
			// check schemas...
			checkAndMergeImports(result);
		}
		
		
		
		private function onResultMerge(re:ResultEvent):void
		{
			// merge !!!
			
			var x:XML = new XML(re.result);
			
			/*x = mergeNamespaces(result,x);
			
			var type:XML = (result..wsdl::types)[0];
			
			type.appendChild(x);*/
			
			schemaArray.push(x);
			
			checkAndMergeImports(x);
		}
		
		private function checkAndMergeImports(r:XML):void{
			
			var imp:Object = null;
			var url:String = "";
			for each(var schema:XML in r..xsd::schema){
				for each(imp in schema..*){
					if(!imp || !imp.name())
						continue;
					if(imp.name().localName == "import" || imp.name().localName =="include"){
						url = imp.@schemaLocation;

						if(url==null || url.length==0 || imp.@namespace=="http://www.w3.org/1999/xlink")
							continue;
						
						// merge urls...
						if(!URLUtil.isHttpURL(url) && !URLUtil.isHttpsURL(url))
						{
							url = URLUtil.getFullURL(baseUrl,url);
							push(url);
						}else{
							if(url == "http://www.w3.org/2005/05/xmlmime" 
								|| url == "http://www.w3.org/2004/08/xop/include")
								continue;
							push(url);
						}
						
					}
				}
			}

			for each(imp in r..*){
				if(!imp || !imp.name())
					continue;
				if(imp.name().localName == "import" || imp.name().localName == "include"){
					url = imp.@location;
					
					
					if(url==null || url.length==0)
					{
						url = imp.@schemaLocation;
						if(url == null || url.length == 0 || imp.@namespace=="http://www.w3.org/1999/xlink")
							continue;
					}
					
					// merge urls...
					if(!URLUtil.isHttpURL(url) && !URLUtil.isHttpsURL(url))
					{
						url = URLUtil.getFullURL(baseUrl,url);
						push(url);
					}else{
						if(url == "http://www.w3.org/2005/05/xmlmime" 
							|| url == "http://www.w3.org/2004/08/xop/include")
							continue;
						push(url);
					}
					
				}
			}
			
			processQueue();
		}
		
		private function push(url:String):void
		{
			for each(var s:String in merged){
				if(s == url)
					return;
			}
			queue.push( { destinationUrl:url, merge:true} );
		}
		
		private function onFault(fe:FaultEvent):void
		{
			this.dispatchEvent(fe);
		}
		
		
		private function mergeNamespaces(src:XML,dest:XML):XML
		{
			var sdest:String = dest.toXMLString();
			for each(var ns:Namespace in src.namespaceDeclarations()){
				for each(var ns2:Namespace in dest.namespaceDeclarations()){
					if(ns2.uri == ns.uri){
						sdest = com.adobe.utils.StringUtil.replace(sdest,"<" + ns2.prefix + ":","<" + ns.prefix+":");
						sdest = com.adobe.utils.StringUtil.replace(sdest,"</" + ns2.prefix + ":","</" + ns.prefix+":");
						sdest = com.adobe.utils.StringUtil.replace(sdest,'"' + ns2.prefix + ":",'"' + ns.prefix+":");
						sdest = com.adobe.utils.StringUtil.replace(sdest,'xmlns:' + ns2.prefix,'xmlns:' + ns.prefix);
					}
				}
				/*for each(var e:XML in dest..*){
					trace(e.name());
					var ns2:Namespace = e.namespace();
					if(ns2!=null){
						if(ns2.uri == ns.uri){
							e.setNamespace(ns);
						}
					}
					trace(e.name());
				}*/
			}
			return new XML(sdest);
		}
		
	}
}