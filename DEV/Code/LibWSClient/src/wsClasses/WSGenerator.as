package wsClasses
{
	import flash.utils.Dictionary;
	
	import wsForm.WSProjectProperties;

	public class WSGenerator
	{
		public function WSGenerator()
		{
		}
		
		public var properties:WSProjectProperties = null;
		
		public function start():void
		{
		}
		
		protected var service:SoapService = null;
		
		protected var url:String = "";
		
		public var libPath:String = "";
		
		protected final function log(s:String):void
		{
			properties.log += s + "\n";
		}
		
		private var s:Namespace = new Namespace("http://www.w3.org/2001/XMLSchema");
		
		protected function escapeClassName(name:String):String
		{
			return name;
		}
		
		protected function getClassName(sc:WSType):String
		{
			var name:String = sc.wsType;
			if(sc.serviceName!=null){
				name = sc.serviceName + "_" + name;
			}
			if(types.hasOwnProperty(name)){
				var i:int = types[name];
				i = i+1;
				types[name] = i;
				return name + i.toString(); 
			}else{
				types[name] = 0;
			}
			return name;
		}
		
		private var types:Dictionary = new Dictionary();
		
		public final function clearTypes():void
		{
			types = new Dictionary();
		}
		
		public final function generateService(ss:SoapService):void
		{
			
			if(LICENSE::demo){
				log("WARNING! Only two web services and only two methods will be created in demo version !!");
			}
			
			var sc:WSType;
			
			clearTypes();
			
			service = ss;
			beforeGenerate(ss);
			// generate all native information first...
			
			// generate all classes first..
			for each(sc in ss.types)
			{
				if(sc.isCustom && !sc.isArray)
				{
					sc.className = escapeClassName(getClassName(sc));
				}
			}
			
			for each(sc in ss.types)
			{
				if(sc.isCustom && sc.isArray)
				{
					sc.className = sc.arrayType.className;
				}
			}
			
			
			var st:WSType;
			
			for each(st in ss.types){
				_setType(st);
			}
			
			for each(sc in ss.types)
			{
				if(sc.isCustom && !sc.isArray)
				{
					generateClass(sc);
				}
			}
			
			
			
			log("Generating Web Service: " + ss.serviceName);
			
			generate(ss);
			afterGenerate(ss);
		}
		
		public function generateClass(sc:WSType):void
		{
		}
		
		
		private function _setType(st:WSType):void
		{
			if(st.isArray){
				st.arrayType.qName = changeQName(st.arrayType.qName);	
			}else{
				st.qName = changeQName(st.qName);
			}
			// change types ...
			setType(st);
		}
		
		private function changeQName(qn:QName):QName
		{
			if(qn.uri == s.uri){
				switch(qn.localName){
					
					
					case "byte":
					case "unsignedByte":
					case "unsignedInt":
					case "unsignedShort":
					case "integer":
					case "short":
					case "negativeInteger":
					case "nonNegativeInteger":
					case "nonPositiveInteger":
					case "positiveInteger":
						//st.wsType = "int";
						//st.wsNameSpace = "s";
						qn = new QName(s.uri,"int");
						break;
					
					
					case "unsignedLong":
						//st.wsFullType = "s:long";
						//st.wsType = "long";
						//st.wsNameSpace = "s";
						qn = new QName(s.uri,"long");
						break;
					
					
					case "token":
					case "hexBinary":
					case "base64Binary":
					case "duration":
					case "anyURI":
					case "QName":
					case "NOTATION":
					case "normalizedString":
					case "Name":
					case "guid":
					case "ID":
					case "NMTOKEN":
					case "IDREF":
						
						//st.wsFullType = "s:string";
						//st.wsType = "string";
						//st.wsNameSpace = "s";
						qn = new QName(s.uri,"string");
						break;
					
					
					case "date":
					case "time":
						//st.wsFullType = "s:dateTime";
						//st.wsType = "dateTime";
						//st.wsNameSpace = "s";
						qn = new QName(s.uri,"dateTime");
						break;
					
					
					case "decimal":
						//st.wsFullType = "s:double";
						//st.wsType = "double";
						//st.wsNameSpace = "s";
						qn = new QName(s.uri,"double");
						break;
					
					
				}
			}
			return qn;
		}
		
		protected function setType(st:WSType):void
		{
		}
		
		protected function generate(ss:SoapService):void
		{
		}
		
		protected function beforeGenerateClass(st:WSType):void
		{
			log("Generating Type:" + st.wsType);
		}
		
		protected function beforeGenerate(ss:SoapService):void
		{
		}
		
		protected function afterGenerate(ss:SoapService):void
		{
		}
		
		public function end():void
		{
			log("Services Generated...");
		}
	}
}