package wsClasses
{
	import com.adobe.net.URI;
	import com.neuro.utils.NSArrayCollection;
	
	import flash.net.dns.AAAARecord;
	import flash.utils.Dictionary;
	import flash.xml.XMLNodeType;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.logging.Log;
	import mx.utils.StringUtil;
	import mx.utils.URLUtil;
	
	public class SoapService
	{
		public function SoapService()
		{
		}
		
		public var serviceName:String = "";
		
		//public var className:String = "";
		
		public var methods:Array = [];
		
		//public var headers:Array = [];
		
		public var types:Array = [];
		
		//public var simpleTypes:Array = [];
		
		public var url:String = "";
		
		private var forceNamespaces:Boolean = true;
		
		public var addressUrl:String= null;
		
		public var partialUrl:String = null;
		
		public var targetNamespace:String = null;
		
		public var enableSoap12:Boolean = true;
		
		public var qualifiedMembers:Boolean = false;
		
		private var wsdl:Namespace = new Namespace("http://schemas.xmlsoap.org/wsdl/");
		
		private var soap12:Namespace = new Namespace("http://schemas.xmlsoap.org/wsdl/soap12/");
		
		private var s:Namespace = new Namespace("http://www.w3.org/2001/XMLSchema");
		
		private var soapEnc:Namespace = new Namespace("http://schemas.xmlsoap.org/soap/encoding/");
		
		private var xmlDoc:XML = null;
		
		private var schemaPrefix:String = "s";
		
		public var schemaArray:Array = [];
		
		public function get headers():Array{
			var h:Array = [];
			for each(var sm:WSMethod in methods){
				for each(var sh:WSType in sm.headerTypes){
					if(h.indexOf(sh)==-1){
						h.push(sh);
					}
				}
			}
			return h;
		}		
		
		public function get allSchema():Array
		{
			var a:Array = [];
			a.push(xmlDoc);
			if(schemaArray!=null){
				for each(var x:XML in schemaArray){
					a.push(x);
				}
			}
			return a;
		}
		
		
		private var _portType:String = null;
		
		
		public function load(xml:XML):void
		{
			xmlDoc = xml;
			
			registerNamespace("http://www.w3.org/2001/XMLSchema-instance","xsi");
			
			var steps:int = 0;
			
			do{
				
				enableSoap12 = !enableSoap12;
			
				soap12 = enableSoap12 ? 
					new Namespace("http://schemas.xmlsoap.org/wsdl/soap12/") : 
					new Namespace("http://schemas.xmlsoap.org/wsdl/soap/");			
				
				
				for each(var sn:XML in xml..wsdl::service)
				{
					serviceName = sn.@name;
					for each(var ad:Object in sn..soap12::address){
						addressUrl = ad.@location;
					}
				}
				
				for each(var bn:XML in xml..wsdl::binding){
					var el:XMLList = bn.soap12::binding;
					if(el != null && el.length()>0){
						_portType = postFixText(bn.@type);	
					}
				}
				
				if(addressUrl!=null){
					var i:int = addressUrl.indexOf("://");
					var a1:String = addressUrl.substr(i + 3);
					i = a1.indexOf("/");
					partialUrl = a1.substr(i); 
				}
				steps++;
			}while(partialUrl==null && steps < 10);
			
			var u:URI = new URI(url);
			if(partialUrl==null){
				partialUrl = u.path;
			}
			if(serviceName==null || serviceName == ""){
				serviceName = u.getFilename(true);
			}
			
			registerNamespace("http://www.w3.org/2001/XMLSchema","xsd");
			registerNamespace(enableSoap12 ? "http://www.w3.org/2003/05/soap-envelope" : "http://schemas.xmlsoap.org/soap/envelope/", "soap" );
			
			var ssx:XML;

			for each(ssx in allSchema){
				parseSimpleTypes(ssx);
			}
			
			for each(ssx in allSchema){
				parseTypes(ssx);
			}
			
			for each(ssx in allSchema){
				parseMethods(ssx);
			}
			
			resolveReferences();
			
			sortTypes();
			
			resolvePrefixes();
			
			escapeMemberNames();
			
			if(LICENSE::demo){
				if(methods.length>2)
					methods = methods.slice(0,2);
			}			
			
			
			
			//methods = typeRepository.methods;
			//types = typeRepository.types;
		}
		
		private function escapeMemberNames():void
		{
			for each(var st:WSType in types){
				for each(var sm:WSTypeMember in st.members){
					sm.localName = sm.name;
					sm.name = escapeMemberName(sm.name);
				}
			}
		}
		
		private function escapeMemberName(n:String):String
		{
			return n.replace(".","_");
		}
		
		private function resolvePrefixes():void
		{
			if(forceNamespaces)
				defaultNS = null;
			
			var sm:WSTypeMember;
			for each(var st:WSType in types){
				
				if(st.qName.uri == defaultNS){
					st.prefixedName = st.wsType;
					for each(sm in st.members){
						sm.prefixedName = sm.name;
					}
					continue;
				}
				
				st.prefixedName = st.prefix + ":" + st.wsType;
				for each(sm in st.members){
					if(sm.noNamespace || st.isHeader)
					{
						sm.prefixedName = sm.name;
					}
					else
					{
						sm.prefixedName = st.prefix + ":" + sm.name;
					}
				}
				
				if(st.elementNames.length>0){
					trace(st.qName.uri + ":" + st.qName.localName);
					for each(var e:QName in st.elementNames){
						trace("\t -->"  + e.uri + ":" + e.localName);
					}
				}
			}
		}
		
		public function toString() : String
		{
			var str:String = "";
			for each (var sm:WSMethod in methods)
			{
				str += sm.name;
				str += "\n";
				if(sm.inputType!=null)
					str += sm.inputType.toString();
				if(sm.outputType!=null)
					str += sm.outputType.toString();
				str += "\n";
			}
			for each(var sc:WSType in types)
			{
				str += sc.qName.localName;
				str += "\n";
				for each(var sp1:WSTypeMember in sc.members)
				{
					str += "\t" + sp1.name + ":" + sp1.type.qName.localName;
					str += "\n";
				}
			}
			return str;
		}
		
		public var namespaceMap:Array = [];

		public function parseSimpleTypes(xml:XML):void
		{
			
			
			var tn:String = xml.@targetNamespace;
			
			var nodeName:String = xml.name().localName;
			
			if(nodeName == "schema"){
				
				qualifiedMembers = false;
				
				if(xml.@elementFormDefault == "qualified"){
					qualifiedMembers = true;
				}
				
				parseSimpleType(xml,tn);
			}
		}
		
		
		public function parseTypes(xml:XML):void
		{
			
			
			var tn:String = xml.@targetNamespace;
			
			var nodeName:String = xml.name().localName;
			
			if(nodeName == "schema"){
				
				qualifiedMembers = false;
				
				if(xml.@elementFormDefault == "qualified"){
					qualifiedMembers = true;
				}
				
				parseElementNames(xml,tn);
				
				parseComplexTypes(xml,tn);
				
			}
			
		}
		
		public function parseMethods(xml:XML):void
		{
			var sx:XML;
			
			var tn:String = xml.@targetNamespace;
			
			var nodeName:String = xml.name().localName;
			
			if(nodeName == "definitions")
			{

				// call recursively for every schema element...
				for each(sx in xml.wsdl::types.s::schema)
				{
					parseSimpleTypes(sx);
				}

				// call recursively for every schema element...
				for each(sx in xml.wsdl::types.s::schema)
				{
					parseTypes(sx);
				}
				
				// parse binding and message types...
				parseMethodNames(xml,tn);
				
				parseMethodParts(xml,tn);
			}
			
		}
		
		public var defaultNS:String = null;
		
		private function parseMethodParts(xml:XML, tn:String):void
		{
			var op:XML = null;
			var x:XML = null;
			var sm:WSMethod = null;
			
			var xlist:XMLList = null;
			
			if(_portType){
				xlist = xml..wsdl::portType.(@name==_portType)..wsdl::operation;
			}else{
				xlist = xml..wsdl::portType..wsdl::operation;
			}
			
			for each(op in xlist){
				var methodName:String = op.@name;
				
				sm = getMethod(methodName,tn);
				
				var xl:XMLList = op..wsdl::input;
				if(xl.length()>0){
					x = xl[0];	
					sm.inputMessage = postFixText(x.@message);
				}
				xl = op..wsdl::output;
				if(xl.length()>0){
					x = xl[0];	
					sm.ouputMessage = postFixText(x.@message);
				}
			}
			
			
			for each(sm in methods){
				sm.inputType = parseMessagePart(xml,sm,tn,sm.inputMessage, sm.name);
				sm.outputType = parseMessagePart(xml,sm,tn,sm.ouputMessage);
				if(sm.outputType!=null && sm.ouputMessage)
					trace("Found " + sm.outputType.qName.localName + " for " + sm.ouputMessage);
				if(sm.headerMessages.length>0){
					for each(var h:String in sm.headerMessages){
						var ht:WSType = parseMessagePart(xml,sm,tn,h);
						ht.isHeader = true;
						ht.headerNS = ht.qName.uri;
						sm.headerTypes.push(ht);
					}
				}
			}
			
		}
		
		private function parseMessagePart(xml:XML, sm:WSMethod, tn:String, msgName:String, methodName:String = null):WSType
		{
			var argName:String;
			var typeName:String;
			var elementName:String;
			var part:XML;
			var type:WSType;
			
			defaultNS = sm.targetNamespace;
			
			for each(part in  (xml..wsdl::message.(@name==msgName)..wsdl::part))
			{
				argName = part.@name;
				typeName = part.@type;
				elementName = part.@element;
				
				if( elementName != ""){
					// found element... return by element name...
					type = getType( XmlHelper.toQName(part,elementName),true);
					type.serviceName = this.serviceName;
					return type;
				}
				
				if(typeName != ""){
					if(type==null){
						var q:QName = new QName( sm.targetNamespace, methodName ? methodName : msgName);
						type = getType(q,false);
						type.serviceName = this.serviceName;
					}
					
					var member:WSTypeMember = new WSTypeMember();
					member.name = argName;
					member.noNamespace = true;
					forceNamespaces = true;
					member.bAttribute = false;
					member.type = getType(XmlHelper.toQName(part,typeName),false);
					
					type.addMember(member);
				}
				
			}
			
			if(type==null && msgName != null){
				type = getType( new QName(tn,methodName ? methodName : msgName));
			}
			
			return type;
		}
		
		private function parseMethodNames(xml:XML, tn:String):void
		{
			var tl:XMLList = null;
			var sm:WSMethod;
			for each (var operation:Object in xml..wsdl::binding..wsdl::operation)
			{
				tl = operation..soap12::operation;
				if(tl==null || tl.length()==0)
					continue;
				
				sm = getMethod(operation.@name,tn);
				sm.soapAction = ((operation..soap12::operation)[0]).@soapAction;
				if(sm.soapAction!=null && sm.soapAction.length==0){
					sm.soapAction = '\\"\\"';
				}
				
				if(LICENSE::demo){
					if(methods.length>1)
						break;
				}
				
				var et:XMLList = operation..soap12::header;
				if(et.length()>0){
					if(!LICENSE::demo){
						/*var et0:XML = et[0];
						//sm.headerType = getTypeFrom(et0,et0.@part);
						sm.headerMessage = postFixText(et0.@message);*/
						for each(var ett:Object in et){
							var hm:String = ett.@part;
							sm.headerMessages.push( postFixText(hm));
						}
					}else{
					}
				}
				
			}
		}
		
		
		private function getMethod(methodName:String,tn:String):WSMethod
		{
			var sm:WSMethod;
			for each(sm in methods){
				if(sm.name == methodName)
					return sm;
			}
			sm = new WSMethod(this);
			sm.name = methodName;
			sm.targetNamespace = tn;
			sm.outputType = getType(new QName(s.uri,"void"));
			sm.inputType = sm.outputType;
			methods.push(sm);
			return sm;
		}
		
		
		public function resolveReferences():void {
			
			for each(var st:WSType in types)
			{
				
				for each(var sm:WSTypeMember in st.members){
					
					if(sm.ref != null){
						
						// replace...
						var wt:WSType = getTypeFromElements(sm.ref);
						if(wt!=null){
							sm.name = sm.ref.localName; 
							sm.ref = null;
							sm.type = wt;
						}
						
					}
					
				}
				
			}
			
		}
		
		public function sortTypes():void
		{
			var ac:NSArrayCollection = new NSArrayCollection();
			
			for each(var t:WSType in types){
				checkAndAdd(t,ac);
			}
			
			types = ac.toArray();
		}
		
		private function checkAndAdd(t:WSType, ac:NSArrayCollection):void
		{
			if(t.baseType!=null){
				checkAndAdd(t.baseType,ac);
			}
			
			for each(var et:WSType in ac){
				if(et==t)
					return;
			}
			ac.addItem(t);
		}
		
		public function getTypeFromElements(q:QName):WSType
		{
			for each(var wt:WSType in types){
				for each(var xq:QName in wt.elementNames){
					if(xq.localName == q.localName && xq.uri == q.uri){
						return wt;
					}
				}
			}
			return null;
		}
		
		private function parseElementNames(xml:XML, tn:String):void
		{
			var e:XML;
			var sm:WSTypeMember;
			var sc:WSType;
			var t:XML;
			
			var name:String = null;
			var type:String = null;
			
			for each(t in xml.s::element){
				var n:String = t.@name;
				var b:String = t.@type;
				if(b!=""){
					sc = getTypeFrom(t,b);
					if(sc.isBuiltin && postFixText(n) != sc.qName.localName){
						// create new type...
						var bt:WSType = getType( new QName(tn,n));
						var btm:WSTypeMember = new WSTypeMember();
						btm.name = n;
						btm.bIsText = true;
						btm.type = sc;
						btm.noNamespace = !this.qualifiedMembers;
						bt.addMember(btm);
					}else{
						sc.elementNames.push( new QName(tn,n) );
					}
				} else {
					for each(e in t.s::complexType){
						sc = getType(new QName(tn,n));
						parseComplexType(sc,e,tn, true);
					}
				}
			}
			
			for each(t in xml.s::attribute){
				name = t.@name;
				type = t.@type;
				if(type!=""){
					sc = getTypeFrom(t,type);
					sc.elementNames.push(new QName(tn,name));
				}
			}
			
		}
		
		
		private function parseSimpleType(xml:XML, tn:String):void
		{
			var e1:XML;
			var sm:WSTypeMember;
			for each(var t:XML in xml.s::simpleType){
				var n:String = t.@name;
				var xl:XMLList = (t..s::restriction);
				var b:String = "";
				if(xl.length()>0){
					b = (t..s::restriction[0]).@base;
				}else{
					b = "string";
				}
				trace("ST Created: " + n + " " + b);
				var sc:WSType = getType( new QName(s.uri,postFixText(b)));
				sc.elementNames.push( new QName(tn,n) );
			}				
		}
		
		private function hasExtension(t:XML):Boolean
		{
			var et:XMLList = t..s::extension;
			return et!=null && et.length()>0;
		}
		
		private function parseComplexType(sc:WSType, t:XML, tn:String, isElement:Boolean = false):void
		{
			var e1:XML;
			var sm:WSTypeMember;
			
			
			// fill elements...
			
			// check if array...
			var et:XMLList = t..s::element;
			if(!isElement && et!=null && et.length()==1){
				
				// should not be derived too....
				
				if(!hasExtension(t)){
					e1 = et[0];
					if((e1.@name).length() == 0){
					// and no attributes...
						et = t..s::attribute;
						if(et.length()==0 && e1.@maxOccurs == "unbounded")
						{
							sc.isArray = true;
							sc.arrayType = getTypeFrom(e1,e1.@type);
							//sc.qName = sc.arrayType.qName;
							sc.isCustom = sc.arrayType.isCustom;
							return;
						}
					}
				}
			}
			
			// check if array, with soap encoding...
			et = t..s::attribute;
			if(et!=null && et.length()==1){
				e1 = et[0];
				//trace(e1.@wsdl::arrayType + "\n");
				var str:String = e1.@wsdl::arrayType;
				if(str != ""){
					sc.isArray = true;
					if(str.indexOf("[]")!=-1){
						str = str.substring(0, str.length-2);
					}
					sc.arrayType = getTypeFrom(e1,str);
					sc.isCustom = sc.arrayType.isCustom;
					//sc.qName = sc.arrayType.qName;
					return;
				}
			}
			
			// check if its dictionary...
			et = t..s::complexType;
			if(et!=null && et.length()==1){
				// special case of dictionary only...
				var tarray:XML = (t..s::element)[0];
				if(tarray==null){
					// void...
					return;
				}
				if(tarray.@maxOccurs == "unbounded"){
					
					var ctList:XMLList = tarray.s::complexType;
					if(ctList.length()>0){
						
						var e:XML = ctList[0];
						var scComplex:WSType = getType(new QName(tn,tarray.@name));
						parseComplexType(scComplex,e,tn);
						
						
						sm = new WSTypeMember();
						sm.noNamespace = !qualifiedMembers;
						sm.name = tarray.@name;
						sm.type = getInlineArrayType(scComplex);
						sc.addMember(sm);
						return;
					}
				}
			}
			
			et = t..s::extension;
			if(et.length()==1)
			{
				var et0:XML = et[0];
				var t1:String = et0.@base;
				sc.baseType = getTypeFrom(et0,t1);
				
				// is base string??
				if(sc.baseType.qName.uri == s.uri){
					// special case...
					
					sm = new WSTypeMember();
					sm.noNamespace = !qualifiedMembers;
					sm.name = "valueField";
					sm.bIsText = true;
					sm.type = sc.baseType;
					sc.addMember(sm);					
					sc.baseType = null;
					
				}
				
			}
			
			
			for each(var se:XML in t..s::element)
			{
				var xr:String = se.@ref;
				if(xr!="" && postFixText(xr) == "Include"){
					continue;
				}
				
				if(xr!=""){
					sm = new WSTypeMember();
					sm.noNamespace= !qualifiedMembers;
					sm.ref = XmlHelper.toQName(se,xr);
					if(!isSchema(sm.ref))
						sc.addMember(sm);
					continue;
				}
				
				sm = new WSTypeMember();
				sm.name = se.@name;
				sm.noNamespace= !qualifiedMembers;
				//sm.type.wsType = se.@type;
				
				var typeName:String = se.@type;
				if(typeName != ""){
					sm.type = getTypeFrom(se,se.@type);
				}
				else
				{
					var xl:XMLList = se..s::extension;
					if(xl.length()==1){
						sm.type = getTypeFrom(xl[0], xl[0].@base);
					}else{
						xl = se..s::restriction;
						if(xl.length()==1){
							sm.type = getTypeFrom(xl[0],xl[0].@base);
						}
					}
				}
				
				
				//loadType(sm.type, se.@type);
				var mo:String = se.@maxOccurs;
				if(mo == "unbounded"){
					//sm.type.isArray = true;
					//sm.type.isInlineArray = true;
					sm.type = getInlineArrayType(sm.type);
				}
				if(sm.type!=null)
					sc.addMember(sm);
				
				
				
			}
			for each(var se2:XML in t..s::attribute)
			{
				var sr2:String = se2.@ref;
				if(sr2!="")
				{
					sm = new WSTypeMember();
					sm.ref = XmlHelper.toQName(se2, sr2);
					sm.noNamespace = !qualifiedMembers;
					if(!isSchema(sm.ref))
						sc.addMember(sm);
					continue;
				}
				sm = new WSTypeMember();
				sm.bAttribute = true;
				sm.name = se2.@name;
				sm.noNamespace = !qualifiedMembers;
					 
				//sm.type.wsType = se2.@type;
				sm.type = getTypeFrom(se2,se2.@type);
				if(sm.type!=null)
					sc.addMember(sm);
			}				
		}
		
		private function isSchema(n:QName):Boolean
		{
			if(n.uri == s.uri && n.localName == "schema")
				return true;
			return false;
		}
		
		private function parseComplexTypes(xml:XML, tn:String):void
		{
			for each(var t:XML in xml.s::complexType){
				var n:String = t.@name;
				var sc:WSType = getType(new QName(tn,n));
				parseComplexType(sc,t,tn);
			}
		}
		
		private function getInlineArrayType(type:WSType):WSType
		{
			for each(var t:WSType in types){
				if(t.arrayType == type)
					return t;
			}
			var t1:WSType = new WSType();
			//t1.namespaceUri = type.namespaceUri;
			var n:String = type.qName.localName;
			t1.qName = new QName(type.qName.uri,n);
			//var nf:Namespace = registerNamespace(type.qName.uri);
			t1.isArray = true;
			t1.isInlineArray = true;
			t1.isCustom = type.isCustom;
			t1.arrayType = type;
			types.push(t1);
			return t1;
		}
		
		
		public function getTypeFrom(e:XML , name:String ):WSType
		{
			var q:QName = XmlHelper.toQName(e,name);
			
			return getType(q, true);
		}
		
		public function registerNamespace(uri:String, prefix:String = null):Namespace
		{
			var nf:Namespace = null;
			
			for each(var n:Namespace in namespaceMap){
				if(n.uri == uri){
					nf = n;
					break;
				}
			}
			
			if(nf==null){
				// create one...
				if(prefix == null){
					prefix = "ns" + (namespaceMap.length+1).toString();
				}
				nf = new Namespace(prefix, uri);
				namespaceMap.push(nf);
			}
			return nf;
		}
		
		public function getType(qName:QName, matchElement:Boolean = false):WSType
		{
			
			var t:WSType = null;
			
			
			
			var nf:Namespace = null;
			
			if(qName.uri != ""){
				nf = registerNamespace(qName.uri);
				
				// get....
				for each(t in types){
					if(t.qName.uri == qName.uri && t.qName.localName == qName.localName){
						t.prefix = nf.prefix;
						return t;
					}
					if(true){
						for each(var nq:QName in t.elementNames){
							if(nq.localName == qName.localName && nq.uri == qName.uri){
								return t;
							}
						}
					}
					
				}	
			}
			
			t = new WSType();
			if(nf!=null)
				t.prefix = nf.prefix;
			t.qName = qName;
			
			t.isCustom = qName.uri != s.uri;
			t.isBuiltin = !t.isCustom ;
			
			if(t.qName.localName==null || t.qName.localName=="null"){
				//trace("Types...");
			}
			//trace("Type Created: " + t.qName.localName + " {" + t.qName.uri + "}");
			
			if(t.qName.localName == this.serviceName){
				this.serviceName = this.serviceName + "Service";
			}
			
			types.push(t);
			
			return t;
		}
		
		private function preFixText(name:String):String{
			var i:int = name.indexOf(":");
			if(i==-1)
				return name;
			return name.substring(0,i);
		}
		
		private function postFixText(name:String):String
		{
			var i:int = name.indexOf(":");
			if(i==-1)
				return name;
			return name.substring(i+1);
		}
		
		
	}
}