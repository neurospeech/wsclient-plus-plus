package wsClasses
{
	import com.adobe.utils.StringUtil;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;
	import mx.utils.URLUtil;
	
	public class ObjCGenerator extends WSGenerator
	{
		
		private var keywords:Dictionary = new Dictionary(true);
		
		private var reservedClassNames:Dictionary = new Dictionary(true);
		
		public function ObjCGenerator()
		{
			keywords["id"] = { member:"wsID" , property:"WsID"};
			keywords["case"] = { member:"wsCase", property:"WsCase" };
			keywords["inline"] = { member:"wsInline", property:"WsInline" };
			keywords["handle"] = { member:"wsHandle", property:"WsHandle" };
			keywords["Handle"] = { member:"wsHandle", property:"WsHandle" };
			keywords["signed"] = { member: "wsSigned", property:"WsSigned" };
			keywords["return"] = { member: "wsReturn", property:"WsReturn" };
			keywords["int"] = { member: "wsInt", property: "WsInt" };
			keywords["long"] = { member: "wsLong", property: "WsLong" };
			
			reservedClassNames["echo"] = "Echo";
			reservedClassNames["id"] = "WSID";
			reservedClassNames["handle"] = "WSHandle";
			reservedClassNames["Handle"] = "WSHandle";
			reservedClassNames["return"] = "WSReturn";
			reservedClassNames["signed"] = "WSSigned";
			reservedClassNames["case"] = "WSCase";
			reservedClassNames["int"] = "WSInt";
			reservedClassNames["long"] = "WSLong";
		}
		
		protected override function escapeClassName(name:String):String
		{
			name = name.replace(".","_");
			
			// use prefix...
			if(this.properties.localNamespace!=null && this.properties.localNamespace!=""){
				name = this.properties.localNamespace + name;
			}
			
			var m:String = reservedClassNames[name];
			if(m!=null)
				return m;
			return name;
		}
		
		private function toMember(t:String):String{
			var m:Object = keywords[t];
			if(m==null)
				return t.charAt(0).toLowerCase() + t.substr(1) ;
			return m.member;
		}
		
		private function toProperty(t:String):String{
			var m:Object = keywords[t];
			if(m==null)
				return t.charAt(0).toUpperCase() + t.substr(1) ;
			return m.property;
		}
		
		public var header:StringWriter = new StringWriter();
		
		public var code:StringWriter = new StringWriter();
		
		public override function start():void
		{
			code.add("#import \"" + properties.generateFilename + ".h\"")
			if(properties.forIPhone){
				header.add("#import <Foundation/Foundation.h>\n\n#import \"NSWSDL.h\"");
			}
			else
			{
				code.add("#import \"AppController.h\"");
				
				header.add("#import <Cocoa/Cocoa.h>\n\n#import \"NSWSDL.h\"");
			}
			header.add("$$HEADER$$");
		}
		
		
		protected override function generate(service:SoapService):void
		{
			
			
			// generate all native information first...
			var sc:WSType;
			var sm:WSMethod;
			var sp:WSTypeMember;
			
			var st:WSType;
			var ht:String;
			
			
			
//			// generate all classes first..
//			for each(sc in service.types)
//			{
//				if(sc.isCustom && !sc.isArray)
//				{
//					sc.className = objEscape(sc.wsType);
//					if(types[sc.className] == null){
//						generateClass(sc);
//						types[sc.className] = sc.className;
//					}
//				}
//			}
			
			header.add();
			
			header.add("@interface " + service.serviceName + ": "  + ( service.enableSoap12 ? "Soap12WebService" : "SoapWebService" ) + "{");
			for each(st in service.headers){
				ht = st.className;				
				header.add(ht + '* header'+ht+';');
			}
			header.add("}");
			
			for each(st in service.headers){
				ht = st.className;				
				header.add('@property (readwrite, retain) ' + ht + '* header'+ht+';');
			}
			
			header.add();
			header.add("+(" + service.serviceName + "*) service;");
			header.add();
			
			
			header.add();
			header.add("-(id) init;");
			header.add();
			// setup methods..
			for each(sm in service.methods)
			{
				var line:String = sm.returnType.wsType == "void" ? "-(void)" : "-("+ sm.returnType.nativeType +")";
				line += sm.name + " ";
				var bfirst:Boolean = true;
				for each(sp in sm.parameters)
				{
					sp.publicName = toMember(sp.name);
					if(!bfirst){
						line += " "+ sp.publicName;
					}
					bfirst = false;
					line +=  ": (" + sp.type.nativeType + ") " + sp.publicName;
				}
				if(sm.parameters.length==0)
					line += ":(NSError**)pError";
				else
					line += " error: (NSError**)pError";
				sm.signature = line;
				header.add(sm.signature + ";");
			}
			header.add();
			header.add("@end");
			
			
			// add code...
			code.add();
			code.add("@implementation " + service.serviceName);
			
			
			for each(st in service.headers){
				ht = st.className;				
				code.add('@synthesize header'+ht+';');
			}
			
			
			// add dealloc
			code.add();
			code.add("#if __has_feature(objc_arc)");
			code.add("#else");
			code.add('-(void) dealloc');
			code.startBrace();
			for each(st in service.headers){
				ht = st.className;				
				code.add('[self setHeader'+ht+':nil];');
			}
			code.add("[super dealloc];");
			code.endBrace();
			code.add("#endif");
			code.add();
			
			
			code.add();
			code.add("+(" + service.serviceName + "*) service{");
			code.indent();
			code.add("#if __has_feature(objc_arc)");
			code.add("return [[" + service.serviceName + " alloc] init];");
			code.add("#else");
			code.add("return [[[" + service.serviceName + " alloc] init] autorelease];");
			code.add("#endif");
			code.unindent();
			code.add("}");
			code.add();
			
			
			// add init
			code.add("-(id) init{");
			code.indent();
			code.add("if(!(self = [super init])) return nil;");
			code.add("[self set__url: @\"" + service.partialUrl + "\"];");
			code.add("return self;");
			code.unindent();
			code.add("}");
			code.add();
			
			setNamespaces(code);
			
			// add methods..
			for each(sm in service.methods)
			{
				var retVal:String = sm.returnType.wsType == "void" ? "" : "nil";
				
				code.add();
				code.add(sm.signature + "{");
				code.indent();
				
				code.add("[NSWSDL setBusy:YES];");
				buildRequest(service,sm);
				code.add("SoapResponse* _resp = [self getSoapResponse: _req error:pError];");
				code.add("if(_resp==nil) return " + retVal + ";");
				if(sm.returnType.wsType != "void")
				{
					//code.add("NSXMLElement* _body = [_resp body];");
					buildResponse(service,sm);
					code.add("[NSWSDL setBusy:NO];");
					code.add("return retVal;");
				}else
				{
					code.add("[NSWSDL setBusy:NO];");
				}
				code.unindent();
				code.add("}");
			}
			
			code.add();
			code.add("@end");
			code.add();
			
			
			// add asynchronous method...
			if(!License.demo)
				generateAsync(service);
		}
		
		private function buildRequest(service:SoapService, sm:WSMethod, async:Boolean = false):void
		{
			var sp:WSTypeMember;
			if(async){
				code.addFormat('SoapRequest* _req = [self buildSoapRequest: @"{0}" error:nil];', sm.soapAction);
			}else{
				code.addFormat('SoapRequest* _req = [self buildSoapRequest: @"{0}" error:pError];', sm.soapAction);
			}
			var retVal:String = sm.returnType.wsType == "void" ? "" : "nil";
			
			for each(var sh:WSType in sm.headerTypes){
				var headerName:String = "header" + sh.className;
				var headerType:String = sh.className;
				code.add("if("+headerName+"!=nil)");
				code.startBrace();
				code.addFormat('[[_req header] addChild: [[self {0}] toXMLElement]];', headerName);
				code.endBrace();
			}
			code.add("#if __has_feature(objc_arc)");
			code.addFormat('{0}* ___method = [[{0} alloc] init];',sm.inputType.className);
			code.add("#else");
			code.addFormat('{0}* ___method = [[[{0} alloc] init] autorelease];',sm.inputType.className);
			code.add("#endif");
			for each(sp in sm.parameters)
			{
				code.addFormat('[___method set{0}: {1}];', sp.upName, sp.publicName);
			}

			code.addFormat('[_req setMethod: [___method toXMLElement]];');
		}
		
		private function buildResponse(service:SoapService,sm:WSMethod):void
		{
			// load header...
			if(sm.headerTypes.length>0){
				code.add("NSXMLElement* __eh;");
			}
			code.add("if([_resp header]!=nil)");
			code.startBrace();
			for each(var sh:WSType in sm.headerTypes){
				var headerName:String = "header" + sh.className;
				var headerType:String = sh.className;
				code.add('__eh = [NSWSDL getElement:[_resp header]:@"'+ headerType +'"];');
				code.add('if(__eh != nil)');
				code.startBrace();
				code.add( headerType + '* __header = ['+headerType+' objectByXML:__eh];');
				code.add('if(__header!=nil)');
				code.startBrace();
				code.add('[self setHeader'+sh.className+': __header];');
				code.endBrace();
				code.endBrace();
			}
			code.endBrace();
			code.add("#if __has_feature(objc_arc)");
			code.addFormat('{0}* __response = [[{0} alloc] init];', sm.outputType.className);
			code.add("#else");
			code.addFormat('{0}* __response = [[[{0} alloc] init] autorelease];', sm.outputType.className);
			code.add("#endif");
			code.addFormat('[__response loadFrom: [_resp body]];');
			
			if(sm.returnType != sm.outputType){
				code.addFormat('id retVal = [__response {0}];', sm.returnMember.publicName);
			}else{
				code.addFormat('id retVal = __response;');
			}
		}
		
		private function generateAsync(service:SoapService):void
		{
			var sp:WSTypeMember;
			var sm:WSMethod;
			var st:WSType;
			var ht:String;
			
			// asynchronous...
			header.add();
			
			header.add("@interface " + service.serviceName + "Async: "
				+ (service.enableSoap12 ? "Soap12WebService" : "SoapWebService")+"{");
			
			for each(st in service.headers){
				ht = st.className;				
				header.add(ht + '* header'+ht+';');
			}
			
			header.add("}");
			
			for each(st in service.headers){
				ht = st.className;				
				header.add('@property (readwrite, retain) ' + ht + '* header'+ht+';');
			}
			
			
			header.add();
			header.add("+(" + service.serviceName + "Async*) service;");
			header.add();
			
			
			header.add();
			header.add("-(id) init;");
			header.add();
			// setup methods..
			for each(sm in service.methods)
			{
				var line:String = "-(void)";
				line += sm.name + " ";
				var bfirst:Boolean = true;
				
				for each(sp in sm.parameters)
				{
					sp.publicName = toMember(sp.name);
					
					if(!bfirst){
						line += " "+ sp.publicName;
					}
					bfirst = false;
					line +=  ": (" + sp.type.nativeType + ") " + sp.publicName;
				}
				sm.signature = line;
				header.add(sm.signature + ";");
				
			}
			header.add();
			header.add("@end");
			
			
			// declare protocol...
			header.add();
			header.add("@protocol " + service.serviceName + "Delegate<NSObject>");
			header.add();
			header.add("@optional");
			header.add();
			header.add("-(void) onError: (NSError*) error;");
			header.add();
			header.add();
			for each(sm in service.methods){
				var r:String = ": ("+ service.serviceName +"Async*) service ";
				if(!sm.returnType.isVoid)
				{
					r += " result:(" + sm.returnType.nativeType+ ") result ";
				}
				var m:String = "-(void) on" + sm.name + "Received " + r + ";";
				header.add(m);
			}
			header.add();
			header.add("@end");
			
			// add code...
			code.add();
			code.add("@implementation " + service.serviceName + "Async");
			
			for each(st in service.headers){
				ht = st.className;				
				code.add('@synthesize header'+ht+';');
			}
			
			
			// add dealloc
			code.add();
			code.add("#if __has_feature(objc_arc)");
			code.add("#else");
			code.add('-(void) dealloc');
			code.startBrace();
			for each(st in service.headers){
				ht = st.className;				
				code.add('[self setHeader'+ht+':nil];');
			}
			code.add("[super dealloc];");
			code.endBrace();
			code.add("#endif");
			code.add();
			
			
			code.add();
			code.add("+(" + service.serviceName + "Async*) service{");
			code.indent();
			code.add("#if __has_feature(objc_arc)");
			code.add("return [[" + service.serviceName + "Async alloc] init];");
			code.add("#else");
			code.add("return [[[" + service.serviceName + "Async alloc] init] autorelease];");
			code.add("#endif");
			code.unindent();
			code.add("}");
			code.add();
			
			
			// add init
			code.add("-(id) init{");
			code.indent();
			code.add("if(!(self = [super init])) return nil;");
			code.add("[self set__url: @\"" + service.partialUrl + "\"];");
			code.add("return self;");
			code.unindent();
			code.add("}");
			code.add();
			
			setNamespaces(code);
			
			// add methods..
			for each(sm in service.methods)
			{
				
				// add response method...
				code.add();
				var smr:String = "on" + sm.name + "Received: ";
				var mr:String = smr + "self ";
				var methodDelegate:String = "on" + sm.name + "Received:";
				if(!sm.returnType.isVoid){
					mr += " result:";
					smr += " result:";
				}
				code.add("-(void) on" + sm.name + "Received: (id) sender{");
				code.indent();
				code.add("[NSWSDL setBusy: NO];");
				code.add("if(self.delegate == nil) return;");
				code.add("if(![self.delegate respondsToSelector:@selector("+ smr +")]) return;");
				if(!sm.returnType.isVoid)
				{
					code.add("SoapResponse* _resp = (SoapResponse*)sender;");
					//code.add("NSXMLElement* _body = [_resp body];");
					buildResponse(service,sm);
					code.add("[delegate "+ mr +" retVal];");
				}
				else
				{
					code.add("[delegate " + mr + "];");
				}
				code.unindent();
				code.add("}");
				code.add();
				
				
				code.add();
				code.add(sm.signature + "{");
				code.indent();
				
				code.add("[NSWSDL setBusy:YES];");
				//code.add("NSError** pError = nil;");
				buildRequest(service,sm,true);
				code.add("[super postSoapRequest: _req selector:@selector(" + methodDelegate + ")];");					
				code.unindent();
				code.add("}");
			}
			
			code.add();
			code.add("@end");
			code.add();			
		}
		
		private function setNamespaces(code:StringWriter):void
		{
			code.addFormat("-(NSString*) getNamespaces");
			code.startBrace();
			code.addFormat('NSString* ns = [NSString string];');
			for each(var ns:Namespace in service.namespaceMap)
			{
				var p:String = ns.prefix;
				if(ns.uri == service.defaultNS)
					p = null;
				if(p)
					code.addFormat('ns = [ns stringByAppendingString:@" xmlns:{0}=\\"{1}\\" \\r\\n"];',ns.prefix,ns.uri);
				else
					code.addFormat('ns = [ns stringByAppendingString:@" xmlns=\\"{1}\\" \\r\\n"];',ns.prefix,ns.uri);
				
			}
			code.addFormat('return ns;');
			code.endBrace();
		}

		
		public override function end():void
		{
			var f:File = new File(properties.folderPath + File.separator + properties.generateFilename + ".h");
			if(f.exists)
				f.deleteFile();
			header.save(f.nativePath);
			f = new File(properties.folderPath + File.separator + properties.generateFilename + ".m");
			code.save(f.nativePath);
			
		}
		
		
//		private function objEscape(t:String):String
//		{
//			if(keywords[t])
//				return keywords[t];
//			return t;
//		}
		
		public override function generateClass(sc:WSType):void
		{
			
			super.beforeGenerateClass(sc);
			
			var sm:WSTypeMember;
			// set public name...
			
			
			header.addHeader("@class " + sc.className + ";");
			
			// write header prototype..
			header.add();
			header.add("@interface " + sc.className + " : " + (sc.baseType==null ? "BaseWSObject" : sc.baseType.className) + "{");
			header.indent();
			
			for each(sm in sc.members)
			{
				sm.publicName = sm.name.substring(0,1).toLocaleLowerCase() + sm.name.substring(1);
				sm.upName = sm.name.substring(0,1).toUpperCase() + sm.name.substring(1);
				sm.upName = toProperty(sm.publicName);
				sm.publicName = toMember(sm.publicName);
				var st:String = sm.type.nativeType;
				
				header.add(st + " " + sm.publicName + ";");
				
			}
			
			header.unindent();
			header.add("}");
			header.add();
			for each(sm in sc.members)
			{
				var p:String = "";
				if(!sm.type.isObjectType)
					p = ",copy";
				else
					p = ",retain";
				header.add("@property (readwrite" + p + ") "+ sm.type.nativeType + " " + sm.publicName+ ";");
			}
			header.add();
			header.add("-(NSXMLElement*) toXMLElement;");
			header.add("-(void) fillXML: (NSXMLElement*)e;");
			header.add("-(void) loadFrom: (NSXMLElement*) root;");
			header.add("+(id) objectByXML:(NSXMLElement*) root;");
			//header.add("+(id) arrayByXML:(NSXMLElement*) root;");
			header.add();
			header.add("@end");
			
			var hasCustom:Boolean = false;
			
			// write code prototype..
			code.add();
			code.add("@implementation " + sc.className);
			code.add();
			for each(sm in sc.members)
			{
				code.add("@synthesize " + sm.publicName+ ";");
			}
			code.add();
			
			code.add();
			code.add("#if __has_feature(objc_arc)");
			code.add("#else");
			code.add("-(void) dealloc");
			code.startBrace();
			if(License.demo){
				code.add("//Not supported in Demo edition!!!");
			}
			else{			
				for each(sm in sc.members){
					code.add("[self set" + sm.upName + ": nil];");
				}
				code.add("[super dealloc];");
			}
			code.endBrace();
			code.add("#endif");
			code.add();
			
			
			// add toXMLElement....
			code.add();
			code.add("-(NSXMLElement*) toXMLElement{");
			code.indent();
			code.add("NSXMLElement* e = [NSXMLElement elementWithName:@\"" + sc.prefixedName + "\"];");
			if(sc.isHeader){
				code.add('[e setAttribute:@"xmlns" withValue:@"' + sc.headerNS + '"];');
			}
			
			code.add("[self fillXML:e];");
			code.add("return e;");
			code.unindent();
			code.add("}");
			code.add();
			
			// add fillXML....
			code.add();
			generateFillXML(sc);
			code.add();
			
			
			// add loadFrom..
			code.add();
			code.add("-(void) loadFrom: (NSXMLElement*) root{");
			code.indent();
			if(sc.hasArrayMember)
			{
				code.add("NSMutableArray* ary;");
				code.add("NSXMLElement* e1;");
				code.add("NSEnumerator* en;");
				//code.add("NSArray* ec1;");
				//code.add("int _index;");
				//code.add("int _total;");
			}
			code.add("if(root==nil) return;");
			if(sc.baseType!=null)
				code.add("[super loadFrom:root];");
			for each(sm in sc.members)
			{
				if(sm.type.isArray)
				{
					if(sm.type.isInlineArray){
						code.add("en = [NSWSDL getChildren:root forName:@\"" + sm.localName + "\"];");
						code.add("if(en != nil){");
						code.indent();
						code.add("ary = [NSMutableArray arrayWithCapacity:10];");
						code.add("while(e1 = [en nextObject]){");
						code.indent();
						if(sm.type.isCustom)
							code.add("[ary addObject: ["+ sm.type.className +" objectByXML:e1]];");
						else
							code.add("[ary addObject: " + sm.type.loadFromService("e1","nil", false) + " ];");
						code.unindent();
						code.add("}");
						code.add("[self set"+ sm.upName +": ary ];");
						code.unindent();
						code.add("}");
					}else
					{
						code.add("e1 = [NSWSDL getElement:root:@\"" + sm.localName + "\"];");
						code.add("if(e1 != nil){");
						code.indent();
						code.add("en = [[e1 children] objectEnumerator];");
						code.add("ary = [NSMutableArray arrayWithCapacity:10];");
						code.add("while((e1 = [en nextObject])){");
						code.indent();
						if(sm.type.isCustom)
							code.add("[ary addObject: ["+ sm.type.className +" objectByXML:e1]];");
						else
							code.add("[ary addObject: " + sm.type.loadFromService("e1","nil", false) + " ];");
						code.unindent();
						code.add("}");
						code.add("[self set"+ sm.upName +": ary ];");
						code.unindent();
						code.add("}");
					}
				}
				else
				{
					// set references simple...
					//code.add("[self set"+ sm.upName +": " + getLoadFunction(sm.type, sm.bAttribute, "@\"" + sm.name + "\"" ) + "];");
					code.add("[self set"+ sm.upName +": " + sm.type.loadFromService("root", "@\"" + sm.name + "\"", sm.bAttribute) + "];");
				}
			}
			code.unindent();
			code.add("}");
			code.add();
			
			code.add("+(id) objectByXML:(NSXMLElement*) root{");
			code.indent();
			code.add("if(root==nil) return nil;");
			code.add("#if __has_feature(objc_arc)");
			code.add(sc.className + "* obj = [["+ sc.className +" alloc] init];");
			code.add("#else");
			code.add(sc.className + "* obj = [[["+ sc.className +" alloc] init] autorelease];");
			code.add("#endif");
			code.add("[obj loadFrom:root];");
			code.add("return obj;");
			code.unindent();
			code.add("}");
			code.add();
			code.add("@end");
			code.add();
			
		}
		
		private function generateFillXML(sc:WSType):void
		{
			var sm:WSTypeMember;
			code.add("-(void) fillXML:(NSXMLElement*) e{");
			code.indent();
			
			if(sc.baseType){
				code.add("[super fillXML:e];");
			}
			
			for each(sm in sc.members){
				code.add("if("+ sm.publicName +"!=nil)");
				code.indent();
				if(sm.bAttribute){
					code.add("[NSWSDL addChild:e withName:@\"" + sm.prefixedName + "\" withValue: "+ sm.type.toStringValue(sm.publicName) +" asAttribute:YES];");
				}else{
					if(sm.type.isArray)
					{
						if(sm.type.isCustom)
						{
							if(sm.type.isInlineArray){
								code.add("[NSWSDL addChildArrayInline:e withName:@\"" + sm.prefixedName + "\" withType:nil withArray:"+ sm.publicName +"];");
							}else{
								code.add("[NSWSDL addChildArray:e withName:@\"" + sm.prefixedName + "\" withType:nil withArray:"+ sm.publicName +"];");
							}
						}
						else
						{
							if(sm.type.isInlineArray){
								code.add("[NSWSDL addChildArrayInline:e withName:@\"" + sm.prefixedName + "\" withType:@\"" + sm.type.prefixedName + "\" withArray:"+ sm.publicName +"];");
							}else{
								code.add("[NSWSDL addChildArray:e withName:@\"" + sm.prefixedName + "\" withType:@\"" + sm.type.prefixedName + "\" withArray:"+ sm.publicName +"];");
							}
						}
					}
					else
					{
						if(sm.type.isCustom)
						{
							//code.add('[NSWSDL addChildNode:e withName:@"'+sm.name+'" withElement:['+ sm.publicName +' toXMLElement] withObject:nil];');
							code.add('[NSWSDL addChildNode:e withName:@"'+sm.prefixedName+'" withElement:nil withObject:'+ sm.publicName +'];');
						}
						else
						{
							code.add("if("+sm.publicName+"!=nil){");
							code.indent();
							code.add("[NSWSDL addChild:e withName:@\"" + sm.prefixedName + "\" withValue: "+ sm.type.toStringValue(sm.publicName) +" asAttribute:NO];");
							code.unindent();
							code.add("}");
						}
					}
				}
				code.unindent();
			}
			code.unindent();
			code.add("}");
		}
		
		
		protected override function setType(st:WSType):void{
			if(st.isArray){
				st.nativeType = "NSArray*";
				st.isValueType = false;
			}
			if(st.isCustom){
				if(!st.isArray)
					st.nativeType = st.className +"*";
				st.fnToStringValue = 
					function(m:String):String
					{
						return m;
					};
				st.fnLoadFromService = 
					function (root:String,name:String, b:Boolean):String
					{
						if(name==null)
							return "[" + st.className + " objectByXML:"+root+"]";
						return "[" + st.className + " objectByXML: [NSWSDL getElement:"+root+":" + name + "]]";
					};
				return;
			}
			st.fnToStringValue = 
				function(m:String):String
				{
					return "[" + m + " stringValue]";
				}
			switch(st.wsType)
			{
				case "void":
					st.nativeType = "void";
					break;
				case "boolean":
				case "Boolean":
				case "bit":
				case "Bit":
					if(!st.isArray)
						st.nativeType = "NSNumber*";
					st.fnLoadFromService = 
					function (root:String,name:String, b:Boolean):String
					{
						return "[NSWSDL getBool:" + root + ":"+name+":"+(b ? "YES" : "NO")+"]";
					};
					return;
				case "string":
					if(!st.isArray)
						st.nativeType = "NSString*";
					st.fnToStringValue = 
					function(m:String):String
					{
						return m;
					};
					st.fnLoadFromService = 
					function (root:String,name:String, b:Boolean):String
					{
						return "[NSWSDL getString:" + root + ":"+name+":"+(b ? "YES" : "NO")+"]";
					};
					return;
				case "dateTime":
					if(!st.isArray)
						st.nativeType = "NSDate*";
					st.isDate = true;
					st.fnToStringValue = 
					function (m:String):String
					{
						return "[NSWSDL toDateString:"+m+"]";
					};
					st.fnLoadFromService = 
					function (root:String,name:String, b:Boolean):String
					{
						return "[NSWSDL getDate:" + root + ":"+name+":"+(b ? "YES" : "NO")+"]";
					};
					return;
			}
			if(!st.isArray)
				st.nativeType = "NSNumber*";
			st.fnLoadFromService = 
				function (root:String,name:String, b:Boolean):String
				{
					return "[NSWSDL getNumber:" + root + ":"+name+":"+(b ? "YES" : "NO")+"]";
				};
		}		
		
		
	}
}