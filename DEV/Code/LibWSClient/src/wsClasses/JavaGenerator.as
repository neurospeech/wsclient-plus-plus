package wsClasses
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	public class JavaGenerator extends WSGenerator
	{
		

		public function JavaGenerator(){
			keywords["Element"] = "Element2";
		}
		
		private var keywords:Dictionary = new Dictionary(true);
		
		protected override function escapeClassName(name:String):String
		{
			name = name.replace(".","_");
			if(keywords[name])
				return keywords[name];
			return name;
		}
		
		private function getFilePath(name:String) : String
		{
			return properties.folderPath + File.separator + name + ".java";
		}
		
		private var headersGenerated:Dictionary;
		
		protected override function generate(service:SoapService):void
		{
			
			headersGenerated = new Dictionary(true);
			
			// generate all native information first...
			var st:WSType;
			var sm:WSMethod;
			
//			for each(st in service.types){
//				if(st.isCustom && !st.isArray){
//					st.className = javaEscape(st.wsType);
//				}
//			}
//			
//			// generate classes...
//			for each(st in service.types){
//				if(st.isCustom && !st.isArray)
//					generateClass(st);
//			}
			
			var sw:StringWriter = new StringWriter();
			
			sw.add("package " + properties.localNamespace + ";");
			
			sw.add();
			//sw.add("import java.util.concurrent.Executors;");
			//sw.add("import java.util.*;");
			sw.add("import com.neurospeech.wsclient.*;");
			sw.add("import org.w3c.dom.*;");
			sw.add();

			sw.add("public class " + service.serviceName + " extends " 
				+ (service.enableSoap12 ? "Soap12WebService" : "SoapWebService") +
				  "{");
			sw.indent();
			sw.add();
			
			sw.add();
			sw.add("public " + service.serviceName + "(){");
			sw.indent();
			sw.add("this.setUrl(\"" + service.partialUrl + "\");");
			sw.unindent();
			sw.add("}");
			sw.add();
			
			
			// setup namespace prefixes...
			
			setupNamespaces(sw);
			
			
			for each(sm in service.methods){
				generateHeader(sw,sm);
				generateMethod(sw,sm);
			}
			sw.add();
			sw.unindent();
			sw.add("}");
			sw.save( getFilePath(service.serviceName));
			
			if(!LICENSE::demo)
			{			
				
				headersGenerated = new Dictionary(true);
				
				sw = new StringWriter();
				
				//sw.add("package " + properties.localNamespace + ";");
				sw.addFormat("package {0};",properties.localNamespace);
				
				sw.add();
				//sw.add("import java.util.*;");
				sw.add("import com.neurospeech.wsclient.*;");
				sw.add("import org.w3c.dom.*;");
				sw.add();
				
				//sw.add("public class " + service.serviceName + "Async extends " +(service.enableSoap12 ? "Soap12WebService" : "SoapWebService")+ " {");
				
				sw.addFormat("public class {0}Async extends {1} {", 
					service.serviceName , 
					(service.enableSoap12 ? "Soap12WebService" : "SoapWebService"));
				
				sw.indent();
				sw.add();
				//sw.add("private " + service.serviceName + " innerService;");
				sw.add();
				
				sw.add();
				//sw.add("public " + service.serviceName + "Async(){");
				
				sw.addFormat("public {0}Async(){",
					service.serviceName);
				sw.indent();
				//sw.add('this.setUrl("'+ service.partialUrl +'");');
				
				sw.addFormat('this.setUrl("{0}");',
					service.partialUrl);
				
				//sw.add("innerService = new " + service.serviceName + "();");
				//sw.add("innerService.setUrl(surl);");
				sw.unindent();
				sw.add("}");
				sw.add();
				
				setupNamespaces(sw);
				
				for each(sm in service.methods){
					generateHeader(sw,sm);
					generateAsyncMethod(service,sw,sm);
				}
				sw.add();
				sw.unindent();
				sw.add("}");
				sw.save( getFilePath(service.serviceName+"Async"));
			}
		}
		
		private function setupNamespaces(sw:StringWriter):void
		{
			var ns:Namespace;
			var p:String;
			
			sw.add("protected String getNamespaces()");
			sw.startBrace();
			sw.add("return ");
			for each(ns in service.namespaceMap){
				p = ns.prefix;
				if(ns.uri == service.defaultNS)
					p = null;
				if(p)
					sw.addFormat('" xmlns:{0}=\\"{1}\\" \\r\\n" + ', ns.prefix, ns.uri);
				else
					sw.addFormat('" xmlns=\\"{1}\\" \\r\\n" + ', ns.prefix, ns.uri);
			} 
			sw.add(' "" ;');
			sw.endBrace();
			
			sw.add();
			
			sw.add("protected void appendNamespaces(Element e)");
			sw.startBrace();
			
			for each(ns in service.namespaceMap){
				p = ns.prefix;
				if(ns.uri == service.defaultNS)
					p = null;
				if(p)
					sw.addFormat('e.setAttribute("xmlns:{0}", "{1}");',ns.prefix,ns.uri);
				else
					sw.addFormat('e.setAttribute("xmlns", "{1}");',ns.prefix,ns.uri);
			}
			
			sw.endBrace();
			sw.add();
		}
		
		private function generateHeader(sw:StringWriter,sm:WSMethod):void
		{
			for each(var sh:WSType in sm.headerTypes)
			{
				if(headersGenerated[sh.className]==null){
					headersGenerated[sh.className] = sh;
					
					// generate field.. , the public one...
					
					//sw.add("public " + sm.headerType.wsType + " header" + sm.headerType.wsType + ";");
					sw.addFormat("public {0} header{0};", sh.className);
					
				}
			}
		}
		
		
		private function generateResponseHandler(sw:StringWriter, sm:WSMethod):void
		{
			sw.add();

			//sw.add("public class " + sm.name + "ResultHandler extends ResultHandler");
			sw.addFormat("public class {0}ResultHandler extends ResultHandler",
				sm.name);
			sw.startBrace();
			sw.add();
			sw.add("protected final void onServiceResult()");
			sw.startBrace();
			//sw.add("onResult(("+ sm.outputType.nativeType +")__result);");
			sw.addFormat("onResult(({0})__result);",
				sm.returnType.nativeType);
			sw.endBrace();
			sw.add();
			//sw.add("protected void onResult("+sm.outputType.nativeType+" result){}");
			sw.addFormat("protected void onResult({0} result){}",
				sm.returnType.nativeType);
			sw.add();
			sw.endBrace();
			
			sw.add();
		}
		
		private function generateAsyncMethod(service:SoapService, sw:StringWriter, sm:WSMethod):void
		{
			
			//generate async class
			var className:String = sm.name + "Request";
			var spms:String = "";
			var scs:String = "";
			var sp:WSTypeMember = null;

			spms = "";
			for each(sp in sm.parameters){
				spms += sp.type.nativeType + " " + sp.name + ",";
			}
			
			
				// generate response class...
			if(!sm.returnType.isVoid){
				generateResponseHandler(sw,sm);
			}
			
			
			sw.add();
			//sw.add("class " + className + " extends ServiceRequest");
			
			sw.addFormat("class {0} extends com.neurospeech.wsclient.ServiceRequest", 
				className);
			
			sw.startBrace();
			
			// declare variables...
			for each(sp in sm.parameters){
				sw.add(sp.type.nativeType +" " + sp.name + ";");
			}
			var sr:String = "ResultHandler<"+ sm.returnType.nativeType +">";
			if(sm.returnType.isVoid){
				sr = "VoidResultHandler";
			}else{
				sr = sm.name + "ResultHandler";
			}
			sw.add();

			
			// create constructor...
			//sw.add(className + "(" + spms + " "+sr+" handler)");
			
			sw.addFormat("{0}({1} {2} handler)", 
				className, 
				spms, 
				sr);
			
			sw.startBrace();
			sw.add("super(handler);");
			for each(sp in sm.parameters){
				//sw.add("this." + sp.name + " = " + sp.name + ";");
				sw.addFormat("this.{0} = {0};", sp.name);
			}
			sw.endBrace();
			
			sw.add();
			
			if(!properties.forBlackberry)
				sw.add("@Override");
			
			sw.add("public void executeRequest() throws Exception");
			sw.startBrace();
			
			scs = "";
			for each(sp in sm.parameters){
				scs += "," + sp.name;
			}
			if(scs.length>0)
				scs = scs.substr(1);
			
			/*if(sm.outputType.isVoid){
				sw.add("innerService."+ sm.name + "(" + scs +");");
			}else{
				sw.add("result = innerService."+ sm.name + "(" + scs +");");
			}*/
			generateMethodContent(service,sw,sm,true);
			
			sw.endBrace();
			sw.add();
			
			sw.endBrace();
			sw.add();
			
			// generate method...
			//sw.add("public void " + sm.name + "(" + spms + " " +sr +" handler)");
			
			sw.addFormat("public void {0}({1} {2} handler)",
				sm.name,
				spms,
				sr);
			
			sw.startBrace();
			if(scs.length>0)
				scs += ",";
			
			
			//sw.add(className + " r = new " + className + "(" + scs + "handler);");
			sw.addFormat("{0} r = new {0}({1}handler);",
				className,
				scs);
			
			//sw.add("Thread thread = Executors.defaultThreadFactory().newThread(r);");
			sw.add("r.executeAsync();");
			sw.endBrace();
			sw.add();
		}
		
		private function generateMethod(sw:StringWriter, sm:WSMethod):void
		{
			var sp:WSTypeMember = null;
			sw.add();
			var ps:String = "";
			if(sm.inputType!=null)
			{
				for each(sp in sm.inputType.members)
				{
					ps += ", " + sp.type.nativeType + " " + sp.name;
				}
			}
			if(ps.length>0)
				ps = ps.substr(2);
			//sw.add("public " + sm.outputType.nativeType + " " + sm.name + "(" + ps + ") throws Exception ");
			
			sw.addFormat("public {0} {1}({2}) throws Exception ",
				sm.returnType.nativeType,
				sm.name,
				ps);
			
			sw.startBrace();
			generateMethodContent(service,sw,sm,false);
			sw.endBrace();
			
			for each(var sh:WSType in sm.headerTypes){
				log("Header found for " + sh.wsType);
			}
		}
		
		private function generateMethodContent(service:SoapService, sw:StringWriter, sm:WSMethod, async:Boolean):void
		{
			var sh:WSType;
			
			sw.addFormat('SoapRequest req = buildSoapRequest("{0}");',sm.soapAction);
			
			sw.addFormat('WSHelper ws = new WSHelper(req.document);');
			
			for each(sh in sm.headerTypes){
				var header:String = "header" + sh.className ;
				sw.startIfBrace( header + "!=null");
				sw.addFormat('req.header.appendChild({0}.toXMLElement(ws,req.root));',header);
				sw.endBrace();
			}
			
			sw.addFormat('{0} ____method = new {0}();', sm.inputType.className);
			
			for each(var sp:WSTypeMember in sm.inputType.members){
				sw.addFormat('____method.set{0}({0});',sp.name);
			}
			
			sw.addFormat('req.method = ____method.toXMLElement(ws,req.root);');
			
			sw.add("SoapResponse sr = getSoapResponse(req);");
			if(sm.headerTypes.length>0){
				sw.add("Element eh;");
			}
			for each(sh in sm.headerTypes){
				sw.addFormat('eh = WSHelper.getElement(sr.header, "{0}");',sh.className);
				sw.add("if(eh!=null)");
				sw.startBrace();
				
				sw.addFormat('{0} __header = {1};',sh.className, sh.loadFromService("eh",null,false) );
				sw.addIf('__header!=null','header' + sh.className + ' = __header;');
				sw.endBrace();
			}
			
			if(!sm.returnType.isVoid)
			{
				if(this.properties.forBlackberry){
					sw.addFormat('{0} __response = {0}.load{0}From((Element)sr.body.getFirstChild());',sm.outputType.className);
				}else{
					sw.addFormat('{0} __response = {0}.loadFrom((Element)sr.body.getFirstChild());',sm.outputType.className);
				}
				
				if(sm.returnType != sm.outputType){
					if(async){
						sw.addFormat('__result = __response.get{0}();',sm.returnMember.name);
					}else{
						sw.addFormat('return  __response.get{0}();',sm.returnMember.name);
					}
				}
				else{
					if(async){
						sw.addFormat('__result = __response;');
					}else{
						sw.addFormat('return  __response;');
					}
					
				}
				
			}
		}
		
		public override function generateClass(st:WSType):void
		{
			
			super.beforeGenerateClass(st);
			
//			if(st.className=="null" || st.className == null){
//				// ignore...
//				return;
//			}
//			
			var filePath:String = getFilePath(st.className);
			var f:File = new File(filePath);
			if(f.exists)
				f.deleteFile();
			
			// write now...
			var sw:StringWriter = new StringWriter();
			sw.add("package " + properties.localNamespace + ";");
			
			// imports...
			sw.add();
			sw.add("import com.neurospeech.wsclient.*;");
			sw.add("import org.w3c.dom.*;");
			//if(st.hasArrayMember)
			//	sw.add("import java.util.*;");
			sw.add();
			
			var baseName:String = "WSObject";
			if(!LICENSE::demo){
				if(properties.forAndroid){
					baseName += " implements android.os.Parcelable";
				}
			}
			if(st.baseType!=null){
				baseName = st.baseType.className;
			}
			
			//sw.add("public class " + st.name + " extends " + baseName);
			sw.addFormat("public class {0} extends {1}",st.className , baseName);
			sw.startBrace();
			sw.add();
			
			// add properties...
			for each(var sm:WSTypeMember in st.members){
				generateProperties(sw,sm);
			}
			
			
			// add load from...
			generateLoadFrom(sw,st);
			
			// add to xml...
			generateFillXML(sw,st);
			
			if(!LICENSE::demo){
				if(properties.forAndroid){
					// implement Parcelable
					implementParcelable(sw,st);
				}
			}			
			
			sw.add();
			sw.endBrace();
			
			sw.save(getFilePath(st.className));
		}
		
		private function implementParcelable(sw:StringWriter, sc:WSType):void
		{
			sw.add("public int describeContents(){ return 0; }");
			
			var sm:WSTypeMember = null;
			sw.add("public void writeToParcel(android.os.Parcel out, int flags)");
			sw.startBrace();
			if(sc.baseType!=null){
				sw.add("super.writeToParcel(out,flags);");
			}
			for each(sm in sc.members){
				if(sm.type.isArray){
					if(sm.type.isCustom){
						//sw.add("out.writeTypedList(_"+sm.name+");");
						sw.addFormat("out.writeTypedList(_{0});",sm.name);
					}else{
						//sw.add("out.writeList(_"+sm.name+");");
						sw.addFormat("out.writeList(_{0});",sm.name);
					}
				}else{
					//sw.add("out.writeValue(_"+sm.name+");");
					sw.addFormat("out.writeValue(_{0});",sm.name);
				}
			}
			sw.endBrace();
			
			sw.add("void readFromParcel(android.os.Parcel in)");
			sw.startBrace();
			if(sc.baseType!=null){
				sw.add("super.readFromParcel(in);");
			}
			for each(sm in sc.members){
				if(sm.type.isArray){
					if(sm.type.isCustom){
						//sw.add("in.readTypedList(_"+sm.name+", "+ javaEscape(sm.type.wsType)+".CREATOR );");
						sw.addFormat("in.readTypedList(_{0},{1}.CREATOR);", sm.name, sm.type.className);
					}else{
						//sw.add("in.readList(_"+sm.name+",null);");
						sw.addFormat("in.readList(_{0},null);",sm.name);
					}
				}else{
					//sw.add("_" + sm.name + "=("+sm.type.nativeType+")in.readValue(null);");
					sw.addFormat("_{0} = ({1})in.readValue(null);", sm.name, sm.type.nativeType);
				}
			}
			sw.endBrace();
			
			//sw.add("public static final android.os.Parcelable.Creator<"+sc.name+"> CREATOR = new android.os.Parcelable.Creator<"+sc.name+">()");
			sw.addFormat("public static final android.os.Parcelable.Creator<{0}> CREATOR = new android.os.Parcelable.Creator<{0}>()",sc.className);
			sw.startBrace();
			//sw.add("public " +sc.name+ " createFromParcel(android.os.Parcel in)");
			sw.addFormat("public {0} createFromParcel(android.os.Parcel in)",sc.className);
			sw.startBrace();
			//sw.add(sc.name + " tmp = new "+sc.name+"();");
			sw.addFormat("{0} tmp = new {0}();",sc.className);
			sw.add("tmp.readFromParcel(in);");
			sw.add("return tmp;");
			sw.endBrace();
			//sw.add("public "+sc.name+"[] newArray(int size)");
			sw.addFormat("public {0}[] newArray(int size)",sc.className);
			sw.startBrace();
			//sw.add("return new "+sc.name+"[size];");
			sw.addFormat("return new {0}[size];",sc.className);
			sw.endBrace();
			sw.endBrace();
			sw.add(";");
		}
		
		private function generateFillXML(sw:StringWriter, sc:WSType):void
		{
			sw.add();
			sw.add("public Element toXMLElement(WSHelper ws, Element root)");
			sw.startBrace();
			//sw.add("Element e = root.getOwnerDocument().createElement(\"" + sc.name + "\");");
			sw.addFormat('Element e = ws.createElement("{0}");', sc.prefixedName);
			sw.add("fillXML(ws,e);");
			sw.add("return e;");
			sw.endBrace();
			sw.add();
			var sm:WSTypeMember;

			sw.add("public void fillXML(WSHelper ws,Element e)");
			sw.startBrace();
			
			if(sc.baseType!=null){
				sw.add("super.fillXML(ws,e);");
			}
			
			for each(sm in sc.members){
				if(sm.type.isObjectType){
					//sw.add("if(_"+ sm.name +"!=null)");
					sw.addFormat("if(_{0} != null)",sm.name);
					sw.indent();
				}
				if(sm.bAttribute){
					//sw.add("WSHelper.addChild(e,\"" + sm.name + "\","+ sm.type.toStringValue("_"+ sm.name) +",true);");
					sw.addFormat('ws.addChild(e,"{0}",{1},true);',sm.prefixedName ,sm.type.toStringValue("_"+ sm.name));
					
				}else if(sm.bIsText){
					sw.addFormat('ws.setText(e,{0});', sm.type.toStringValue("_" + sm.name));
				}else{
					if(sm.type.isArray)
					{
						var methodName:String = "addChildArray";
						if(sm.type.isInlineArray)
							methodName += "Inline";
						if(sm.type.isCustom)
						{
							sw.addFormat('ws.{0}(e,"{1}",null, _{2});',methodName,sm.prefixedName, sm.name );	
						}
						else
						{
							sw.addFormat('ws.{0}(e,"{1}","{2}",_{3});',methodName,sm.prefixedName,sm.type.prefixedName, sm.name);
						}
					}
					else
					{
						if(sm.type.isCustom)
						{
							//sw.add('WSHelper.addChildNode(e, "'+sm.name+'",null,_'+ sm.name +");");
							sw.addFormat('ws.addChildNode(e, "{0}",null,_{1});',sm.prefixedName, sm.name);
						}
						else
						{
							//sw.add("WSHelper.addChild(e,\"" + sm.name + "\","+ sm.type.toStringValue("_" + sm.name) +",false);");
							sw.addFormat('ws.addChild(e,"{0}",{1},false);',sm.prefixedName,sm.type.toStringValue("_" + sm.name));
						}
					}
				}
				if(sm.type.isObjectType)
					sw.unindent();
			}
			sw.endBrace();
		}
		
		private function generateLoadFrom(sw:StringWriter, st:WSType):void
		{
			sw.add();
			if(properties.forBlackberry)
				//sw.add("public static " + st.name + " load"+ st.name +"From(Element root) throws Exception" );
				sw.addFormat("public static {0} load{0}From(Element root) throws Exception" ,st.className);
			else
				sw.addFormat("public static {0} loadFrom(Element root) throws Exception" ,st.className);
			sw.startBrace();
			
			sw.addIf("root==null","return null;");
			
			sw.add(st.className + " result = new " + st.className + "();");
			sw.add("result.load(root);");
			sw.add("return result;");
			sw.endBrace();
			sw.add();
			
			sw.add();
			sw.add("protected void load(Element root) throws Exception");
			sw.startBrace();
			if(st.hasArrayMember){
				//sw.add("Element child = null;");
				sw.add("NodeList list;");
				sw.add("int i;");
			}
			
			if(st.baseType != null){
				sw.add();
				sw.add("super.load(root);");
				sw.add();
			}
			
			for each(var sm:WSTypeMember in st.members){
				generateLoadMember(sw,sm,st);
			}
			
			sw.endBrace();
			sw.add();
			sw.add();
		}
		
		private function generateLoadMember(sw:StringWriter, sm:WSTypeMember, st:WSType):void
		{
			if(sm.type.isArray){
				// loading of array...
				if(sm.type.isInlineArray){
					sw.addFormat('list = WSHelper.getChildren(root, "{0}");',sm.localName);
				}else{
					sw.addFormat('list = WSHelper.getElementChildren(root, "{0}");',sm.localName);
				}
				
				sw.add("if(list != null)");
				sw.startBrace();
				sw.add("for(i=0;i<list.getLength();i++)");
				sw.startBrace();
				sw.add("Element nc = (Element)list.item(i);");
				sw.addFormat("_{0}.addElement({1});", sm.name, sm.type.loadFromService("nc",null,false));
				sw.endBrace();
				sw.endBrace();
			}
			else
			{
				if(sm.bIsText){
					sw.addFormat('this.set{0}({1});', sm.name, sm.type.loadFromService('root','null',false));
				}else{
					sw.addFormat("this.set{0}({1});", sm.name, sm.type.loadFromService("root",'"' + sm.name + '"',sm.bAttribute));
				}
			}
		}
		
		
		private function generateProperties(sw:StringWriter, sm:WSTypeMember):void
		{
			var jt:String = sm.type.nativeType;
			var def:String = "";
			if(sm.type.isArray){
				def = " = new " + jt + "()";
			}

			sw.addFormat("private {0} _{1}{2};", jt, sm.name, def);

			sw.addFormat("public {0} get{1}(){", jt, sm.name);
			sw.indent();

				sw.addFormat("return _{0};", sm.name);
			sw.unindent();
			sw.add("}");

			sw.addFormat("public void set{0}({1} value){", sm.name, jt);
			sw.indent();

				sw.addFormat("_{0} = value;", sm.name);
			sw.unindent();
			sw.add("}");
		}
		
		
		protected override function setType(st:WSType):void
		{
			var type:String = "object";
			if(st.isCustom)
			{
				st.nativeType = st.className;
				//st.nativeObjectType = st.wsType;
				st.isValueType = false;
				if(st.isArray){
					if(properties.forBlackberry)
						st.nativeType = "java.util.Vector";
					else
						st.nativeType = "java.util.Vector<" + st.className + ">";
					
				}else{
				}
				st.fnLoadFromService = 
					function (root:String,name:String, b:Boolean):String
					{
						if(properties.forBlackberry){
							if(name==null)
								return st.className + ".load"+ st.className +"From("+root+")";
							return st.className + ".load"+ st.className +"From(WSHelper.getElement("+root+"," + name + "))";
						}
						if(name==null)
							return st.className + ".loadFrom("+root+")";
						return st.className + ".loadFrom(WSHelper.getElement("+root+"," + name + "))";
					};
			}
			else
			{
				st.fnToStringValue = 
					function (m:String):String
					{
						return "String.valueOf("+ m +")";
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
						//st.nativeObjectType = "Boolean";
						if(st.isArray)
						{
							if(properties.forBlackberry)
								st.nativeType = "java.util.Vector";
							else
								st.nativeType = "java.util.Vector<Boolean>";
						}
						st.fnToStringValue = 
							function (m:String):String{
								if(properties.forBlackberry)
									return "(" + m + ".booleanValue() ? \"true\" : \"false\")";
								return "(" + m + " ? \"true\" : \"false\")";
							};
						st.fnLoadFromService = 
							function (root:String,name:String, b:Boolean):String
							{
								return "WSHelper.getBoolean(" + root + ","+name+","+(b ? "true" : "false")+")";
							};
						break;
					case "string":
						st.nativeType = "String";
						//st.nativeObjectType = "String";
						st.isValueType = false;
						if(st.isArray){
							if(properties.forBlackberry)
								st.nativeType = "java.util.Vector";
							else 
								st.nativeType = "java.util.Vector<String>";
						}
						st.fnLoadFromService = 
							function (root:String,name:String, b:Boolean):String
							{
								return "WSHelper.getString(" + root + ","+name+","+(b ? "true" : "false")+")";
							};
						break;
					case "dateTime":
						st.nativeType ="java.util.Date";
						//st.nativeObjectType = "Date";
						if(st.isArray){
							if(properties.forBlackberry)
								st.nativeType = "java.util.Vector";
							else
								st.nativeType = "java.util.Vector<Date>";
						}
						st.fnLoadFromService = 
							function (root:String,name:String, b:Boolean):String
							{
								return "WSHelper.getDate(" + root + ","+name+","+(b ? "true" : "false")+")";
							};
						st.fnToStringValue =
							function (m:String):String
							{
								return "ws.stringValueOf("+ m +")";
							};
						break;
					case "int":
						st.nativeType = "Integer";
						//st.nativeObjectType = "Integer";
						if(st.isArray){
							if(properties.forBlackberry)
								st.nativeType = "java.util.Vector";
							else
								st.nativeType = "java.util.Vector<Integer>";
						}
						st.fnLoadFromService = 
							function (root:String,name:String, b:Boolean):String
							{
								return "WSHelper.getInteger(" + root + ","+name+","+(b ? "true" : "false")+")";
							};
						break;
					case "long":
						st.nativeType = "Long";
						//st.nativeObjectType = "Long";
						if(st.isArray){
							if(properties.forBlackberry)
								st.nativeType = "java.util.Vector";
							else
								st.nativeType = "java.util.Vector<Long>";
						}
						st.fnLoadFromService = 
							function (root:String,name:String, b:Boolean):String
							{
								return "WSHelper.getLong(" + root + ","+name+","+(b ? "true" : "false")+")";
							};
						break;	
					case "double":
						//st.nativeObjectType = "Double";
						st.nativeType = "Double";
						if(st.isArray){
							if(properties.forBlackberry)
								st.nativeType = "java.util.Vector";
							else
								st.nativeType = "java.util.Vector<Double>";
						}
						st.fnLoadFromService = 
							function (root:String,name:String, b:Boolean):String
							{
								return "WSHelper.getDouble(" + root + ","+name+","+(b ? "true" : "false")+")";
							};
						break;	
					case "float":
						st.nativeType = "Float";
						//st.nativeObjectType = "Float";
						if(st.isArray){
							if(properties.forBlackberry)
								st.nativeType = "java.util.Vector";
							else
								st.nativeType = "java.util.Vector<Float>";
						}
						st.fnLoadFromService = 
							function (root:String,name:String, b:Boolean):String
							{
								return "WSHelper.getFloat(" + root + ","+name+","+(b ? "true" : "false")+")";
							};
						break;	
				}
			}
		}		
	}
}