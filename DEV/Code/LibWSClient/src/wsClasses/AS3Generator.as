package wsClasses
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.dns.AAAARecord;
	import flash.text.engine.SpaceJustifier;
	import flash.utils.Dictionary;
	
	public class AS3Generator extends WSGenerator
	{
		public function AS3Generator()
		{
			//keywords["Element"] = "Element2";
		}
		
		private var keywords:Dictionary = new Dictionary(true);
		
		protected override function escapeClassName(name:String):String
		{
			if(keywords[name])
				return keywords[name];
			return name;
		}
		
		private function toFullName(t:String):String
		{
			//t = javaEscape(t);
			return properties.localNamespace + "." + t;
		}
		
		public function get folderFile():File{
			return new File(properties.folderPath);
		}
		
		private function deleteAll():void
		{
			for each ( var f:File in folderFile.getDirectoryListing()){
				if(!f.isDirectory)
					f.deleteFile();
			}
		}
		
		protected function includeServiceImports(sw:StringWriter):void
		{
			sw.add("import mx.rpc.AsyncToken;");
			sw.add("import mx.rpc.events.ResultEvent;");
			sw.add("import com.neuro.service.SoapWebService;");
			sw.add("import com.neuro.service.Soap12WebService;");
			sw.add("import com.neuro.service.*;");
			sw.add("import com.neuro.utils.*;");
		}
		
		private var headersGenerated:Dictionary;
		
		protected override function generate(service:SoapService):void
		{

			headersGenerated = new Dictionary();
			
			
			// generate all native information first...
			var st:WSType;
			var sm:WSMethod;
			
			
//			// generate all types...
//			for each(st in service.types){
//				if(st.isCustom && !st.isArray)
//				{
//					st.className = javaEscape(st.wsType);
//					generateClass(st);
//				}
//			}
//			
			// generate WS type
			
			var sw:StringWriter = new StringWriter();
			//sw.add("package " + properties.localNamespace);
			sw.addFormat("package {0}",properties.localNamespace);
			sw.add("{");
			sw.indent();
			
			sw.add();
			
			includeServiceImports(sw);
			
			sw.add();
			
			for each(sm in service.methods)
			{
				//sw.add("[Event(name='Result_" + sm.name + "', type='" + sm.resultEventName + "')]");
				
				sw.addFormat('[Event(name="Result_{0}", type="{1}.{2}")]', sm.name, properties.localNamespace,sm.resultEventName);
			}
			
			//sw.add("public class " + service.serviceName + " extends NSWebService");
			sw.addFormat("public class {0} extends {1}" , service.serviceName , (service.enableSoap12 ? "Soap12WebService" : "SoapWebService" ) );
			sw.startBrace();
			
			sw.add();
			//sw.add("public function " + service.serviceName + "()");
			sw.addFormat("public function {0}()", service.serviceName);
			sw.startBrace();
			//sw.add("this.url = '" + service.partialUrl + "';");
			sw.addFormat("this.url = '{0}';", service.partialUrl );
			sw.endBrace();
			sw.add();
			
			
			// generate namespace strings...
			sw.add("protected override function getNamespaces():String ");
			sw.startBrace();
			sw.add("return ");
			for each(var ns:Namespace in service.namespaceMap){
				sw.addFormat('" xmlns:{0}=\\"{1}\\" \\r\\n" + ', ns.prefix, ns.uri);
			} 
			sw.add(' "" ;');
			sw.endBrace();
			
			
			// generate method signature 
			for each(sm in service.methods)
			{
				
				
				
				// generate method..
				generateHeader(sw,sm);
				generateMethod(sw, sm, service);
				
				if(properties.generateRequest){
					generateMethodRequest(sw,sm,service);
					generateRequestObject(sm);
				}
				
				generateEventClass(sm);
				
			}
			
			for each(sm in service.methods)
			{
				generateLastResult(sw,sm);
			}
			
			sw.add();
			
			// add request members...
			for each(sm in service.methods)
			{
				if(sm.parameters.length==0)
					continue;
				sw.add("[Bindable]");
				sw.add("public var Request_" + sm.name + ":" + sm.requestName + ";" );
			}
			
			sw.add();
			
			sw.unindent();
			sw.add("}");
			sw.add();	
			
			sw.unindent();
			sw.add("}");
			
			saveFile(service.serviceName, sw, false);
			
			// generate services	
		}
		
		private function generateHeader(sw:StringWriter,sm:WSMethod):void
		{
			for each(var sh:WSType in sm.headerTypes){
				if(headersGenerated[sh.wsType]==null){
					headersGenerated[sh.wsType] = sh;
					
					// generate field.. , the public one...
					
					//sw.add("public " + sm.headerType.wsType + " header" + sm.headerType.wsType + ";");
					sw.addFormat("public var header{0}:{0};", sh.wsType);
					
				}
			}
		}		
		
		protected function includeRequestObjectImports(sw:StringWriter):void
		{
			sw.add("import mx.utils.ObjectProxy;");
			sw.add("import flash.events.Event;");
			sw.add("import mx.rpc.soap.types.*;");
			sw.add("import com.neuro.utils.NSArrayCollection;");
		}
		
		private function generateRequestObject(sm:WSMethod):void
		{
			if(sm.parameters.length==0)
				return;
			
			var sw:StringWriter = new StringWriter();
			sw.add("package " + properties.localNamespace);
			sw.startBrace();
			
			includeRequestObjectImports(sw);
			
			sw.add("[Bindable]");
			
			sw.add("public class " + sm.requestName);
			sw.startBrace();
			
			for each(var sp:WSTypeMember in sm.parameters)
			{
				sw.add("public var " + sp.name + ":" + sp.type.nativeType + ";");
			}
			
			sw.endBrace();
			
			sw.endBrace();
			
			saveFile(sm.requestName ,sw, false);
		}
		
		private function generateMethodRequest(sw:StringWriter, sm:WSMethod, service:SoapService):void
		{
			sw.add("public function " + sm.name + "_send():AsyncToken" );
			sw.startBrace();
			
			//sw.add("super.refreshBindings();");
			
			var n:String = "Request_" + sm.name;
			
			sw.add("return this." + sm.name + "(");
				sw.indent();
				var bFirst:Boolean = true;
				for each(var sp:WSTypeMember in sm.parameters)
				{
					if(bFirst)
						sw.add( n +  "." + sp.name);
					else
						sw.add(", " + n + "." + sp.name);
					bFirst = false;
				} 	
				sw.unindent();
			sw.add(");");
			sw.endBrace();
		}		
		
		private function generateMethod(sw:StringWriter, sm:WSMethod, service:SoapService):void
		{
			
			var sp:WSTypeMember;
			
			sw.add("public function " + sm.name + "(");
			sw.indent();
			var bFirst:Boolean = true;
			for each(sp in sm.parameters)
			{
				if(bFirst)
					sw.add(sp.name + ":" + sp.type.nativeType);
				else
					sw.add("," + sp.name + ":" + sp.type.nativeType);
				bFirst = false;
			} 	
			sw.unindent();
			sw.add("):AsyncToken" );
			
			sw.startBrace();
			

			sw.add('var req:SoapRequest = buildSoapRequest("'+ sm.soapAction  +'");');
			
			sw.addFormat('req.methodName = "{0}";',sm.name);
			
			for each(var sh:WSType in  sm.headerTypes){
				var header:String = "header" + sh.wsType ;
				sw.startIfBrace( header + "!=null");
				sw.addFormat('req.header.add({0}.toXMLElement());',header);
				sw.endBrace();
			}
			
			sw.addFormat('var __method:{0} = new {0}();', sm.inputType.wsType);
			
			for each(sp in sm.parameters){
				sw.addFormat('__method.{0} = {0};',sp.name);
			}
			
			sw.addFormat('req.method = __method.toXMLElement();');
			
			sw.add("return postWS(req);");
			sw.endBrace();
			
			generateMethodReturn(sw,sm);
		}
		
		private function generateMethodReturn(sw:StringWriter, sm:WSMethod):void
		{
			var returnType:String = sm.returnType.nativeType;
			
			sw.add("public function on" + sm.name + "_Result(req:SoapRequest, sr:SoapResponse):Object");
			sw.startBrace();

			if(sm.headerTypes.length>0){
				sw.add("var eh:XML;");
			}

			for each(var sh:WSType in sm.headerTypes){
				// load header if present...
				//sw.add('Element eh = WSHelper.getElement(sr.header, "'+ sm.headerType.wsType +'");');
				sw.addFormat('eh = WSHelper.getElement(sr.header, "{0}");',sh.wsType);
				sw.add("if(eh!=null)");
				sw.startBrace();
				//sw.add(sm.headerType.wsType + ' __header = ' +  sm.headerType.loadFromService("eh",null,false) + ';');
				sw.addFormat('var __header:{0} = {1};',sh.wsType, sh.loadFromService("eh",null,false) );
				sw.addIf('__header!=null','header' + sh.wsType + ' = __header;');
				sw.endBrace();
			}
			
			sw.addFormat('var __response:{0} = new {0}();',sm.outputType.wsType);
			sw.addFormat('__response.loadFrom(sr.body.elements()[0]);');
			if(!sm.returnType.isVoid)
			{
				if(sm.returnType != sm.outputType){
					var p:WSTypeMember = sm.returnMember;
					sw.addFormat('var retVal:{0} = __response.{1}', p.type.wsType, p.name);
					sw.addFormat("return { re: new {0}(retVal) , result:retVal };",sm.resultEventName);
				}
				else{
					sw.addFormat("return { re: new {0}(__response) , result:__response };",sm.resultEventName);
				}
				
				/*if(sm.multipleReturns){
					sw.add("var response:XML = sr.body.elements()[0];");
				}else{
					sw.add("var response:XML = sr.body.elements()[0].elements()[0];");
				}
				if(sm.returnType.isArray){
					//sw.add( sm.returnType.nativeType + " retVal = new " + sm.returnType.nativeType + "();");
					sw.addFormat("var retVal:{0} = new {0}();",sm.returnType.nativeType);
					sw.add("list = WSHelper.getElementChildren(response,null);");
					sw.add("for each(var e:XML in list)");
					sw.startBrace();
					sw.addFormat("retVal.addItem({0});",sm.returnType.loadFromService("e",null,false) );
					sw.endBrace();
				}
				else
				{
					sw.addFormat("var retVal:{0} = {1};", sm.returnType.nativeType , sm.returnType.loadFromService("response",null,false));
				}
				sw.addFormat("return { re: new {0}(retVal) , result:retVal };",sm.resultEventName);*/
			}			
			else{
				sw.addFormat("return { re: new {0}() };",sm.resultEventName);
			}
			//sw.add("return null;");
			sw.endBrace();
		}
		
		private function generateLastResult(sw:StringWriter, sm:WSMethod):void
		{
			if(sm.returnType.isVoid)
				return;
			sw.add("[Bindable('Result_" + sm.name + "')]");
			sw.add("public var LastResult_" + sm.name + ":" + sm.returnType.nativeType + ";");
		}
		
		private function generateEventClass(sm:WSMethod):void
		{
			var sw:StringWriter = new StringWriter();
			sw.add("package " + properties.localNamespace);
			sw.add("{");
			sw.indent();
			
			var eventName:String = "Result_" + sm.name;
			var className:String = sm.resultEventName;
			var returnType:String = sm.returnType.nativeType;
			
			sw.add("import mx.utils.ObjectProxy;");
			sw.add("import flash.events.Event;");
			sw.add("import mx.rpc.soap.types.*;");
			sw.add("import com.neuro.utils.NSArrayCollection;");
			
			sw.add("public class " + className + " extends Event" );
			sw.add("{");
			sw.indent();
			
			sw.add("public static var " + eventName + ":String = '" + eventName + "';");
			
			if(!sm.returnType.isVoid)
			{
				sw.add();
				sw.add("public var result:" + returnType + ";");
				sw.add();
			}
			
			sw.add();
			if(sm.returnType.isVoid){
				sw.add("public function " + className + "(){super("+eventName+",false,false);}");
			}else{
				sw.add("public function " + className + "(r:" + returnType + ")");
				sw.startBrace();
				sw.add("super(" + eventName + ",false,false);");
				sw.add("result = r;");
				sw.endBrace();
				sw.add();
				
			}
			
			sw.unindent();
			sw.add("}");
			
			sw.unindent();
			sw.add("}");
			
			saveFile(sm.resultEventName, sw, false); 
			
		}
		
		private function saveFile(name:String, sw:StringWriter , verify:Boolean = false):void
		{
			var file:File = folderFile.resolvePath(name + ".as");
			
			if(verify){
				/*if(file.exists)
				{
					if(!makeAll)
						return;
				}
				else 
				{
					if(!makeAll && !makeNewOnly)
						return;
				}*/
			}
			
			if(file.exists)
				file.deleteFile();
			
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeMultiByte(sw.code, File.systemCharset);
			fs.close();
		}
		
		protected function includeClassImports(sw:StringWriter):void
		{
			sw.add("import mx.utils.ObjectProxy;");
			sw.add("import flash.utils.ByteArray;");
			sw.add("import mx.collections.ArrayCollection;");
			sw.add("import mx.rpc.soap.types.*;");
			sw.add("import com.neuro.utils.NSArrayCollection;");
			sw.add("import com.neuro.service.NSWebService;");
			sw.add("import com.neuro.service.WSObject;");
			sw.add("import com.neuro.service.WSHelper;");
		}
		
		public override function generateClass(sc:WSType):void{
			
			super.beforeGenerateClass(sc);
			
			var sw:StringWriter = new StringWriter();
			sw.add("package " + properties.localNamespace);
			
			sw.startBrace();
			
			sw.add();
			
			// imports...
			includeClassImports(sw);
			
			sw.add();
			
			if(properties.makeAllBindable)
				sw.add("[Bindable]");
			
			var ext:String = "";
			if(sc.baseType!=null)
				ext = "extends " + sc.baseType.wsType;
			else
				ext = "extends WSObject";
				
			
			// generate class...
			sw.add("public class " + sc.wsType + " " + ext);
			sw.startBrace();
			
			sw.add("public function " + sc.wsType + "(){}");
			
			sw.add();
			
			for each(var sm:WSTypeMember in sc.members){
				if(!sm.type.isArray)
					sw.add("public var " + sm.name + ":" + sm.type.nativeType + (sm.type.defaultValue ? '=' + sm.type.defaultValue : '') + ";");
				else
					sw.add("public var " + sm.name + ":NSArrayCollection = new NSArrayCollection();");
			}
			
			sw.add();
			

			generateLoadXML(sw,sc);			
			
			
			generateFillXML(sw, sc);
			
			
			
			// end class
			sw.endBrace();
			
			
			// end package
			sw.endBrace();

			saveFile(sc.wsType, sw, true);			
		}
		
		private function generateLoadXML(sw:StringWriter, sc:WSType):void
		{
			sw.add();
			sw.add("public static function loadFrom(node:XML):" + sc.wsType);
			sw.startBrace();
			sw.add("if(node == null) return null;");
			sw.add("var obj:" + sc.wsType + " = new " + sc.wsType + "();");
			sw.add("obj.load(node);");
			sw.add("return obj;");
			sw.endBrace();
			sw.add();
			
			// load method...
			sw.add("public override function load(root:XML):void");
			sw.startBrace();
			sw.add("super.load(root);");
			
			if(sc.hasArrayMember){
				sw.add("var list:Array;");
				sw.add("var i:int;");
				sw.add("var nc:XML;");
			}
			
			for each(var sm:WSTypeMember in sc.members){
				generateLoadMember(sw,sm,sc);
			}
			
			sw.endBrace();
			sw.add();
		}
		
		private function generateLoadMember(sw:StringWriter, sm:WSTypeMember, st:WSType):void
		{
			if(sm.type.isArray){
				// loading of array...
				if(sm.type.isInlineArray){
					//sw.add("list = WSHelper.getChildren(root, \"" + sm.name + "\");");
					sw.addFormat('list = WSHelper.getChildren(root, "{0}");',sm.name);
				}else{
					//sw.add("list = WSHelper.getElementChildren(root, \"" + sm.name + "\");");
					sw.addFormat('list = WSHelper.getElementChildren(root, "{0}");',sm.name);
				}
				
				sw.add("if(list != null)");
				sw.startBrace();
				sw.add("for each(nc in list)");
				sw.startBrace();
					sw.addFormat("this.{0}.addItem({1});", sm.name, sm.type.loadFromService("nc",null,false));
				sw.endBrace();
				sw.endBrace();
			}
			else
			{
				sw.addFormat("this.{0} = ({1});", sm.name, sm.type.loadFromService("root",'"' + sm.name + '"',sm.bAttribute));
			}
		}		
		
		private function generateFillXML(sw:StringWriter, sc:WSType):void
		{
			var sm:WSTypeMember;
			sw.add('public override function toXMLElement():XML');
			sw.startBrace();
			sw.add('var node:XML = <node/>');
			//var qName:QName = new QName();
			//sw.add('node.setName(new QName("'+sc.qName.uri+'","'+sc.wsType+'"))');
			sw.add('node.setName("'+ sc.prefixedName +'");');
			sw.add('this.fillXML(node);');
			sw.add('return node;');
			sw.endBrace();
			
			// fillXML method...
			sw.add("public override function fillXML(e:XML):void");
			sw.startBrace();
			
			sw.add();
			sw.add("super.fillXML(e);");
			sw.add();
			
			
			for each(sm in sc.members){
				if(sm.type.isObjectType){
					//sw.add("if(_"+ sm.name +"!=null)");
					sw.addFormat("if({0} != null)",sm.name);
					sw.indent();
				}
				if(sm.bAttribute){
					//sw.add("WSHelper.addChild(e,\"" + sm.name + "\","+ sm.type.toStringValue("_"+ sm.name) +",true);");
					sw.addFormat('WSHelper.addChild(e,"{0}",{1},true);',sm.prefixedName ,sm.type.toStringValue(sm.name));
				}else{
					if(sm.type.isArray)
					{
						var methodName:String = "addChildArray";
						if(sm.type.isInlineArray)
							methodName += "Inline";
						if(sm.type.isCustom)
						{
							sw.addFormat('WSHelper.{0}(e,"{2}",null, {1});',methodName,sm.name, sm.prefixedName );	
						}
						else
						{
							sw.addFormat('WSHelper.{0}(e,"{3}","{2}",{1});',methodName,sm.name,sm.type.prefixedName, sm.prefixedName);
						}
					}
					else
					{
						if(sm.type.isCustom)
						{
							//sw.add('WSHelper.addChildNode(e, "'+sm.name+'",null,_'+ sm.name +");");
							sw.addFormat('WSHelper.addChildNode(e, "{1}",null,{0});',sm.name, sm.prefixedName);
						}
						else
						{
							//sw.add("WSHelper.addChild(e,\"" + sm.name + "\","+ sm.type.toStringValue("_" + sm.name) +",false);");
							sw.addFormat('WSHelper.addChild(e,"{0}",{1},false);',sm.prefixedName,sm.type.toStringValue(sm.name));
						}
					}
				}
				if(sm.type.isObjectType)
					sw.unindent();
			}
			sw.endBrace();
		}
		


		protected override function setType(st:WSType):void{
			if(st.isCustom){
				st.nativeType = toFullName(st.className);
				st.fnLoadFromService = 
					function (root:String, name:String, attribute:Boolean):String
					{
						if(name==null)
							return toFullName(st.className) + ".loadFrom("+root+")";
						return toFullName(st.className) + '.loadFrom(WSHelper.getElement('+root+','+name+'))';
					};
				if(st.isArray){
					st.nativeType = "NSArrayCollection";
					st.isValueType = false;
				}
				return;
			}
			st.fnToStringValue = 
				function (m:String):String
				{
					return m + ".toString()";
				};
			switch(st.wsType)
			{
				case "void":
					st.nativeType = "void";
					break;
				case "boolean":
				case "Boolean":
				case "bit":
				case "Bit":
					st.nativeType = "Boolean";
					st.isValueType = true;
					st.defaultValue = 'false';
					st.fnLoadFromService = 
						function(root:String, name:String, attribute:Boolean):String
						{
							var b:String = attribute ? "true":"false";
							return "WSHelper.getBoolean(" + root + "," + name + "," + b + ")";
						};
					break;
				case "string":
					st.nativeType = "String";
					st.defaultValue = '""';
					st.fnLoadFromService = 
						function(root:String, name:String, attribute:Boolean):String
						{
							var b:String = attribute ? "true":"false";
							return "WSHelper.getString(" + root + "," + name + "," + b + ")";
						};
					break;
				case "dateTime":
					st.nativeType = "Date";
					st.isDate = true;
					st.fnToStringValue = 
						function(m:String):String
						{
							return 'WSHelper.toDateString(' + m + ")";
						};
					st.fnLoadFromService = 
						function(root:String, name:String, attribute:Boolean):String
						{
							var b:String = attribute ? "true":"false";
							return "WSHelper.getDate(" + root + "," + name + "," + b + ")";
						};
					break;
				default:
					st.nativeType = "Number";
					st.defaultValue = "0";
					st.isValueType = true;
					st.fnToStringValue = 
						function(m:String):String
						{
							return '(isNaN('+m+') ? "0" : '+m+'.toString())';
						};
					st.fnLoadFromService = 
						function(root:String, name:String, attribute:Boolean):String
						{
							var b:String = attribute ? "true":"false";
							return "WSHelper.getNumber(" + root + "," + name + "," + b + ")";
						}
					break;
			}
			if(st.isArray){
				st.nativeType = "NSArrayCollection";
				st.isValueType = false;
			}
		}
		
	}
}