/*
  NSWSDL.h
 
 Version: 1.914
 
 */

#import "NSWSDL.h"

/*
 @implementation NSArrayDataSource 
 
 -(id) initWithArray: (NSArray*) objects{
 if(self = [super init])
 {
 internalArray = [[NSArray alloc] initWithArray:objects];
 }
 return self;
 }
 
 -(int)numberOfRowsInTableView:(NSTableView *)aTableView{
 return [internalArray count];
 }
 
 -(id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex{
 id obj = [internalArray objectAtIndex:rowIndex];
 return [obj name];
 }
 
 -(void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex{
 }
 
 @end
 */


#if TARGET_OS_IPHONE
@implementation NSXMLNode

@synthesize stringValue;
@synthesize nodeName;
@synthesize localName;
@synthesize name;


+(id) elementWithName: (NSString*)name{
	
	NSXMLElement* e = [[[NSXMLElement alloc] init] autorelease];
	[e setNodeName:name];
	[e setStringValue:@""];
	return e;
}


-(NSString*) prefix{
	if(localName==nil)
		return nil;
	if([nodeName isEqualToString:localName])
		return nil;
	int i = [nodeName length]-[localName length];
	if(i==0)
		return nil;
	return [nodeName substringWithRange:NSMakeRange(0, i-1)];
}

-(NSString*) encodedValue{
	// pending...
	//NSLog(@"Warning.. data encoded partially...");
	
	NSString* ev = [stringValue stringByReplacingOccurrencesOfString:@"&" 
                                                          withString:@"&amp;"];
	ev = [ev stringByReplacingOccurrencesOfString:@"<"
                                       withString:@"&lt;"];
	ev = [ev stringByReplacingOccurrencesOfString:@">" 
                                       withString:@"&gt;"];
	return ev;
}


-(void) appendValue: (NSString*) value{
	if(stringValue==nil){
		[self setStringValue:value];
		return;
	}
	[self setStringValue:[stringValue stringByAppendingString:value]];
}

-(void) dealloc
{
	[self setStringValue:nil];
	[self setNodeName:nil];
	[self setLocalName:nil];
	[self setName:nil];
	[super dealloc];
}

@end



@implementation NSXMLElement

//@synthesize parent;
@synthesize namespaceURI;

-(id) init{
    self = [super init];
	attributes = [[NSMutableArray alloc] init];
	children = [[NSMutableArray alloc] init];
	return self;
}


+(NSXMLElement*) xmlElement{
	return [[[self alloc] init] autorelease];
}


-(void) dealloc{
	
	//[attributes removeAllObjects];
	//[children removeAllObjects];
	[self setNamespaceURI:nil];
	[attributes release];
	[children release];
	[super dealloc];
}

-(NSArray*) elementsForName: (NSString*)lname{
	
	NSMutableArray* ret = [NSMutableArray arrayWithCapacity:10];
	
	int count = [children count];
	
	for (int i=0; i<count; i++) {
		NSXMLElement* child = [children objectAtIndex:i];
		if ([[child nodeName] isEqualToString:lname]) {
			[ret addObject:child];
		}
	}
	
	return ret;
}

-(NSArray*) elementsForLocalName: (NSString*)lname URI:(NSString*) URI{
	NSMutableArray* ret = [NSMutableArray arrayWithCapacity:10];
	
	int count = [children count];
	
	for (int i=0; i<count; i++) {
		NSXMLElement* child = [children objectAtIndex:i];
		//NSLog(@"Searching %@ in %@",lname,[child localName]);
		if (
			([[child localName] isEqualToString:lname])
			&&
			([[child namespaceURI] isEqualToString:URI])
			) 
		{
			[ret addObject:child];
		}
	}
	
	return ret;
}

-(NSArray*) children{
	return children;
}

-(NSXMLNode*) attributeForName: (NSString*) lname{
	
	int count = [attributes count];
	
	for (int i=0; i<count; i++) {
		NSXMLNode* child = [attributes objectAtIndex:i];
		if ([[child nodeName] isEqualToString:lname]) {
			return child ;
		}
	}
	return nil;
}




-(void) addChild:(NSXMLElement*) child{
	[children addObject:child];
}

-(BOOL) listContainsString:(NSMutableArray*) list text:(NSString*) text{
	int count = [list count];
	for (int i=0; i<count; i++) {
		NSString* listText = [list objectAtIndex:i];
		if([listText isEqualToString:text])
			return YES;
	}
	return NO;
}

-(NSString*) innerXMLWithNamespace: (NSMutableArray*) prefixes{
	
	/*if(prefixes==nil){
     prefixes = [NSMutableArray array];
     }*/
	
	// build xml...
	int i = 0;
	
	//NSLog(@"Prefix: %@, %@ %@",[self prefix],[self nodeName],[self localName]);
	
	NSMutableString* xml = [NSMutableString stringWithFormat:@"<%@", nodeName];
	
	int count = [attributes count];
	for (i=0; i<count; i++) {
		NSXMLNode* node = [attributes objectAtIndex:i];
		[xml appendFormat:@" %@=\"%@\"",[node nodeName],[node encodedValue]];
	}
	
	/*/ write namespace uris...
     NSString* nsUri = [self namespaceURI];
     if(nsUri!=nil && [nsUri length]>0){
     if(![self listContainsString:prefixes text:nsUri]){
     NSString* px = [self prefix];
     if(px == nil){
     px = @"xmlns";
     }else{
     px = [NSString stringWithFormat:@"xmlns:%@",px];
     }
     [xml appendFormat:@" %@=\"%@\"",px,nsUri];
     [prefixes addObject:nsUri];
     }
     }*/
	
	count = [children count];
	
	if (count>0) {
		[xml appendString:@">\r\n"];
		
		for (i=0; i<count; i++) {
			NSXMLElement* child = [children objectAtIndex:i];
			[xml appendString:@"\t"];
			[xml appendString:[child innerXMLWithNamespace:nil]];
		}
		
		[xml appendFormat:@"</%@>\r\n",nodeName];
	}else {
		
		if(stringValue == nil){			
			[xml appendString:@"/>\r\n"];
		}else {
			[xml appendFormat:@">%@</%@>\r\n", [self encodedValue], nodeName];
		}
		
	}
	
	
	return xml;
}

-(NSString*) innerXML{
	return [self innerXMLWithNamespace: nil];
}

-(void) appendAttributes: (NSDictionary*) values{
	NSEnumerator* enm = [values keyEnumerator];
	
	
	NSString* key;
	while((key = [enm nextObject])){
		NSString* value = [values objectForKey:key];
		
		// add...
		NSXMLNode* node = [[[NSXMLNode alloc] init] autorelease];
		[node setNodeName:key];
		[node setStringValue:value];
		[attributes addObject:node];
	}
}

-(void) setAttribute: (NSString*) lname withValue:(NSString*) value{
	NSXMLNode* node = [self attributeForName:lname];
	if(node==nil){
		node = [[[NSXMLNode alloc] init] autorelease];
		[node setStringValue:value];
		[node setNodeName:lname];
		[attributes addObject:node];
	}else{
		[node setStringValue:value];
	}
}

@end



@implementation NSXMLDocument

@synthesize rootElement;
@synthesize current;
@synthesize stack;
@synthesize lastAttributes;


-(id) initWithData: (NSData*) data options:(NSInteger)validationOption error:(NSError**)pErrpr{
	
	[self setRootElement: [NSXMLElement xmlElement] ];
	
	current = nil;
	
	
	
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	[self setStack:[NSMutableArray arrayWithCapacity:10] ];
	[self setLastAttributes:[NSMutableDictionary dictionaryWithCapacity:10]];
    
	[stack addObject:[self rootElement]];
	
	[parser setDelegate:self];
	if(![parser parse])
	{
		// error occured..
		NSString* xml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"XML=%@",xml);
		NSLog(@"Parsing failed..., %@",[[parser parserError] localizedDescription]);
        [xml release];
		if(pErrpr!=nil){
			(*pErrpr) = [parser parserError];
		}
	}
	
	[parser release];
	
	return self;
}

-(id) initWithXMLString: (NSString*) text options:(NSInteger)validationOption error:(NSError**)pError{
	
	return [self initWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:validationOption error:pError];
}


-(NSData*) XMLData{
	NSString* xml = [rootElement innerXML];
	return [xml dataUsingEncoding:NSUTF8StringEncoding];
}

-(void) dealloc
{
	
	[self setCurrent:nil];
	[self setStack:nil];
	[self setLastAttributes:nil];
	//NSLog(@"Releasing Root..");
	[self setRootElement:nil];
    
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI{
	if (prefix==nil || [prefix length]==0) {
		[lastAttributes setValue:namespaceURI forKey:@"xmlns"];
		return;
	}
	[lastAttributes setValue:namespaceURI forKey:[NSString stringWithFormat:@"xmlns:%@",prefix]];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict
{
	if(current==nil){
		[self setCurrent: rootElement];
	}else {
		// create new one..
		NSXMLElement* old = current;
		
		[self setCurrent: [NSXMLElement xmlElement]];
		//[current setParent:old];
		
		[old addChild:current];
		[stack addObject:old];
	}
    
	
	//NSLog(@"Q:%@ E:%@ NS:%@", qualifiedName, elementName,namespaceURI);
	
	// set name...
	[current setNodeName:qualifiedName];
	[current setName:qualifiedName];
	[current setLocalName:elementName];
	[current setNamespaceURI:namespaceURI];
	
	// set attributes..
	[current appendAttributes:attributeDict];
	[current appendAttributes:lastAttributes];
	[lastAttributes removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	//[self setCurrent: [current parent]];
	int count = [stack count];
	if(count >0 ){
		NSXMLElement* obj = [stack objectAtIndex:count-1];
		[self setCurrent:obj];
		[stack removeObjectAtIndex:count-1];
	}
	else
	{
		[self setCurrent:nil];
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	[current appendValue:string];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    NSString* str = [[NSString alloc] 
                     initWithData:CDATABlock
                     encoding:NSUTF8StringEncoding];
	[current appendValue:str];
    [str release];
}

@end
#endif



@implementation SoapRequest

@synthesize document;
@synthesize header;
@synthesize method;
@synthesize root;
@synthesize methodName;
@synthesize soapAction;
@synthesize rawHttpRequest;

-(void) dealloc{
	[self setDocument:nil];
	[self setHeader:nil];
	[self setMethod:nil];
	[self setMethodName:nil];
	[self setSoapAction:nil];
	[self setRawHttpRequest:nil];
    [self setRoot:nil];
	[super dealloc];
}


+(SoapRequest*) soapRequest{
	return [[[self alloc] init] autorelease];
}

@end


@implementation SoapResponse

@synthesize header;
@synthesize body;
@synthesize response;
@synthesize faultCode;
@synthesize faultString;
@synthesize faultDetail;
@synthesize rawHttpResponse;

-(void) dealloc{
	[self setHeader:nil];
	[self setBody:nil];
	[self setResponse:nil];
	[self setFaultCode:nil];
	[self setFaultString:nil];
	[self setFaultDetail:nil];
	[self setRawHttpResponse:nil];
	[super dealloc];
}

+(SoapResponse*) soapResponse{
	return [[[self alloc] init] autorelease];
}

@end




NSString* __baseUrl = nil;

@implementation SoapWebService

@synthesize __url;
@synthesize baseUrl;
@synthesize delegate;
@synthesize data;
@synthesize soapAction;
@synthesize httpHeaders;
@synthesize httpTimeout;

-(void) dealloc{
	[self setData:nil];
	[self setDelegate:nil];
	[self set__url:nil];
	[self setBaseUrl:nil];
	[self setSoapAction:nil];
    [self setHttpHeaders: nil];
	[super dealloc];
}

+(NSString*) globalBaseUrl
{
	return __baseUrl;
}

+(void) setGlobalBaseUrl:(NSString*) gbUrl{
	__baseUrl = gbUrl;
}

-(void) onError: (NSError*) error{
	[NSWSDL setBusy: NO];
	if(self.delegate == nil) return;
	if(![self.delegate respondsToSelector:@selector(onError:)]) return;
	[delegate onError:error];
}


-(SoapRequest*) buildSoapRequest: (NSString*)action error:(NSError**) pError
{
	SoapRequest* req = [SoapRequest soapRequest];
    
	
    [req setSoapAction:action];
    NSString* soapRequest = [NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?> <soap:Envelope %@> <soap:Header/> <soap:Body/> </soap:Envelope>", [self getNamespaces]];
    
	NSXMLDocument* doc = [NSWSDL documentWithText:soapRequest orData:nil options:NSXMLDocumentValidate error:pError];
	[req setDocument:doc];
    [req setRoot: [doc rootElement]];
    [req setHeader:[NSWSDL getElementNS:[req root] forNamespace:[self soapEnvelopeNS] forName:@"Header"]];
	return req;
}

-(NSString*) soapEnvelopeNS{
	return @"http://schemas.xmlsoap.org/soap/envelope/";
}

-(NSString*) contentType{
	return @"text/xml; charset=utf-8";
}

-(BOOL) isSoapActionRequired{
	return YES;
}


-(NSString*) getServiceUrl{
	if(baseUrl!=nil && ([baseUrl length]>0)){
		return [baseUrl stringByAppendingString:__url];
	}
	if(__baseUrl!=nil && ([__baseUrl length]>0)){
		return [__baseUrl stringByAppendingString:__url];
	}
	return __url;
}

-(NSMutableURLRequest*) buildHttpRequest: (SoapRequest*) soapReq error:(NSError**) pError{
    
    NSXMLElement* e = [NSWSDL getElementNS:[soapReq root] forNamespace:[self soapEnvelopeNS] forName:@"Body"];
    [e addChild: [soapReq method] ];
    
	NSData* xmlData = [[soapReq document] XMLData];
	NSURL * nsURL = [NSURL URLWithString:[self getServiceUrl]];
	
	
	//NSLog(@"Connecting to: %@",[nsURL absoluteString]);
	
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:nsURL];
    //	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];	
	[request setValue: [self contentType] forHTTPHeaderField:@"Content-Type"];
	if ([self isSoapActionRequired]) {
		[request setValue:[soapReq soapAction] forHTTPHeaderField: @"SOAPAction"];
	}
	
    NSDictionary* d = [self httpHeaders];
    if (d!=nil) {
        
        NSEnumerator* en = [d keyEnumerator];
        NSString* key ;
        while((key = [en nextObject])!=nil){
            NSString* val = [d objectForKey:key];
            [request setValue:val forHTTPHeaderField:key];
        }
        
    }
    
    if([self httpTimeout]>0){
        [request setTimeoutInterval:[self httpTimeout]];
	}
	//NSString* req = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
	
	//NSLog(@"Request:\r\n%@\r\n",req);
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:xmlData];
	return request;
}

-(SoapResponse*) buildSoapResponse: (NSData*) xmlData error:(NSError**)pError
{
	NSString* resp = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
	
	
	NSXMLDocument* doc1 = [NSWSDL documentWithText:nil orData:xmlData options:NSXMLDocumentTidyXML error:pError];	
	NSXMLElement* root = [doc1 rootElement];
	NSString* rootNS = [self soapEnvelopeNS];
	SoapResponse* res = [SoapResponse soapResponse];
	[res setRawHttpResponse:resp];
	
	//NSLog(@"Response:\r\n%@\r\n",resp);
	
	NSXMLElement* fault = [NSWSDL getElementNS:root forNamespace:rootNS forName:@"Fault"];
	if(fault==nil){
		NSXMLElement* bf = [NSWSDL getElementNS:root forNamespace:rootNS forName:@"Body"];
		fault = [NSWSDL getElementNS:bf forNamespace:rootNS forName:@"Fault"];
	}
	if(fault!=nil){
		[res setFaultCode:[NSWSDL getString:fault :@"faultcode" :false]];
		[res setFaultString:[NSWSDL getString:fault :@"faultstring" :false]];
		[res setFaultDetail:[NSWSDL getString:fault :@"detail" : false]];
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:4];
        [dict setObject:res forKey:@"soapResponse"];
        //[dict setObject:[res faultCode] forKey:@"faultCode"];
        //[dict setObject:[res faultString] forKey:@"faultString"];
        
		if([res faultCode]!=nil)
            [dict setObject:[res faultCode] forKey:@"faultCode"];
        if([res faultString]!=nil)
            [dict setObject:[res faultString] forKey:@"faultString"];
		if([res faultDetail]!=nil)
			[dict setObject:[res faultDetail] forKey:@"faultDetail"];
        
		NSError* er = [NSError errorWithDomain:@"Fault" code:-1 userInfo:dict ];
        [self onError: er];
		if(pError)
			(*pError) = er;
		return nil;
	}
    
	
	[res setBody:[NSWSDL getElementNS:root forNamespace:rootNS forName:@"Body"]];
	[res setHeader:[NSWSDL getElementNS:root forNamespace:rootNS forName:@"Header"]];
	
	NSXMLElement* body = [res body];
	body = [[body children] objectAtIndex:0];
	[res setResponse:body];
	//body = [[body children] objectAtIndex:0];
	[res setBody:body];
	return res;
}

-(NSString*) getNamespaces{
    return @"";
}

-(SoapResponse*) getSoapResponse:(SoapRequest *)soapReq error:(NSError **)pError{
    
    
    
	NSMutableURLRequest* httpRequest = [self buildHttpRequest:soapReq  error:pError];
    //	[httpRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];	
	NSData* xmlData = [NSURLConnection sendSynchronousRequest:httpRequest returningResponse:nil error:pError];
	SoapResponse* res = [self buildSoapResponse:xmlData error:pError];
	return res;
}


-(void) postSoapRequest: (SoapRequest*) soapReq selector:(SEL)s{
	if(data!=nil){
		
		return;
	}
	
	responseSelector = s;
	
	NSMutableURLRequest * request = [self buildHttpRequest:soapReq error:nil];
	
	[self setData:[NSMutableData dataWithLength:1024]];
	NSURLConnection* conn = [NSURLConnection connectionWithRequest:request delegate:self];
	[conn start];
}

-(void) addParameter: (NSXMLElement*)root withName:(NSString*)name withValue:(NSString*) value{
	NSXMLElement* node = [NSXMLElement elementWithName:name];
	[node setStringValue:value];
	[root addChild:node];
}

-(void) soapResponseReceived: (SoapResponse*)response withSelector:(SEL) sel{
	[self performSelector:sel withObject:response];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[self setData:nil];
	[self onError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)rdata{
	[data appendData:rdata];
}

// Uncomment following lines to enable Self Signed Certificates

//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *) space {
//	if([[space authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//		return YES; // Self-signed cert will be accepted
//	}
//	return NO;
//}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSError* error = nil;
	//NSString* dts = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	SoapResponse* root = [self buildSoapResponse:data error:&error];
	if(root!=nil)
		[self soapResponseReceived:root withSelector: (SEL)responseSelector];
}



@end

@implementation Soap12WebService

-(NSString*) soapEnvelopeNS{
	return @"http://www.w3.org/2003/05/soap-envelope";
}

-(NSString*) contentType{
	if([self soapAction]!=nil){
		return [NSString stringWithFormat:@"application/soap+xml; charset=utf-8; action=\"%@\"",soapAction];
	}
	return @"application/soap+xml; charset=utf-8";
}

-(BOOL) isSoapActionRequired{
	return NO;
}

@end



@implementation BaseWSObject

-(void) fillXML:(NSXMLElement*) node{
	
}
-(NSXMLElement*) toXMLElement{
	return nil;
}

@end




@implementation NSWSDL

+(NSXMLElement*)getElementNS:(NSXMLElement*) root forNamespace:(NSString*) forNS forName:(NSString*) name{
	if(name==nil)
		return nil;
	if(forNS==nil)
		return nil;
	NSArray* ary = [root elementsForLocalName:name URI:forNS];
	if(!ary)
		return nil;
	if([ary count]<=0)
		return nil;
	NSXMLElement* e1 = [ary objectAtIndex:0];
	return e1;
}

+(NSXMLElement*)getElement: (NSXMLElement*) root: (NSString*) name{
	if (name == nil)
	{
		return nil;
	}
	/*NSArray* ary = [root elementsForName:name];
     if(!ary)
     return nil;
     if([ary count]<=0)
     return nil;
     NSXMLElement* e1 = [ary objectAtIndex:0];
     return e1;*/
	
	NSEnumerator* en = [[root children] objectEnumerator];
	NSXMLElement* child = nil;
	while ((child = [en nextObject])!=nil) {
		if([[child localName] isEqualToString:name])
		{
			return child;
		}
	}
	
	return nil;
}

+(NSString*)getAttributeString: (NSXMLElement*) root: (NSString*) name{
	if (name == nil)
	{
		return nil;
	}
	NSXMLNode* node = [root attributeForName:name];
	if(node == nil)
		return nil;
	return [node stringValue];
}

+(NSString*)	getString:	(NSXMLElement*) root: (NSString*) name : (BOOL) bAttribute{
	if(bAttribute == YES)
	{
		return [NSWSDL getAttributeString:root :name];
	}
	
	if (name == nil)
	{
		return [root stringValue];
	}
	NSXMLNode* e1 = [NSWSDL getElement:root :name];
	return [e1 stringValue];
}

+(NSNumber*)			getBool:	(NSXMLElement*) root: (NSString*) name : (BOOL) bAttribute{
	NSString* val = [NSWSDL getString:root :name : bAttribute];
	BOOL b = NO;
	if(val!=nil)
	{
		val = [val lowercaseString];
		if([val compare: @"true"]==0)
			b = YES;
		else if([val compare: @"yes"]==0)
			b = YES;
	}
	NSNumber* num = [NSNumber numberWithBool:b];
	return num ;
}

+(NSDecimalNumber*)		getNumber: (NSXMLElement*) root: (NSString*) name: (BOOL) bAttribute{
	NSString* val = [NSWSDL getString:root :name :bAttribute];
	if(val==nil)
		return [NSDecimalNumber decimalNumberWithString:@"0"];
	return [NSDecimalNumber decimalNumberWithString: val] ;
}

+(NSDate*) parseDate:(NSString*) dateString withFormat:(NSString*) format 
{
	NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
	NSLocale* locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	[df setLocale:locale];
	[df setDateFormat:format];
	[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return [df dateFromString:dateString];
}

+(NSDate*)  getDate: (NSXMLElement*) root: (NSString*) name: (BOOL) bAttribute{
	
	NSString* val = [NSWSDL getString:root :name :bAttribute];
	if(val==nil)
		return nil;
    
    if (val.length > 20) {
        val = [val stringByReplacingOccurrencesOfString:@":"
                                             withString:@""
                                                options:0
                                                  range:NSMakeRange(20, val.length-20)];
    }
    
	NSDate* dt = [NSWSDL parseDate:val withFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
	if(dt!=nil)
		return dt;
	dt = [NSWSDL parseDate:val withFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
	if(dt!=nil)
		return dt;
	dt = [NSWSDL parseDate:val withFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
	if(dt!=nil)
		return dt;
    dt = [NSWSDL parseDate:val withFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSSSSSSZZZ"];
    if(dt!=nil)
        return dt;
	dt = [NSWSDL parseDate:val withFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'FZZZ"];
	if(dt!=nil)
		return dt;
	dt = [NSWSDL parseDate:val withFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'F"];
	if(dt!=nil)
		return dt;
	dt = [NSWSDL parseDate:val withFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'F'Z'"];
	if(dt!=nil)
		return dt;
	return nil;
}

+(NSString*) toDateString:(NSDate*) date{
	NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
	NSLocale* locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	[df setLocale:locale];
	[df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
	[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return [df stringFromDate:date];
}

+(void) addChild: (NSXMLElement*) root withName:(NSString*) name withValue:(NSString*) value asAttribute:(BOOL)bAttribute{
	if(value==nil)
		return;
	if(bAttribute){
#if TARGET_OS_IPHONE
        [root setAttribute:name withValue:value];
#else
        NSXMLNode* node = [root attributeForName:name];
        if(node==nil){
            node = [NSXMLNode attributeWithName:name stringValue:value];
            [root addChild:node];
        }else{
            [node setStringValue:value];
        }
#endif
	}else{
		NSXMLElement* child = [NSXMLElement elementWithName:name];
		[root addChild:child];
		[child setStringValue:value];
	}
}

+(void) addChildArray: (NSXMLElement*) root withName: (NSString*) name withType:(NSString*) type withArray:(NSArray*) array{
	
	if(array==nil || ([array count]==0))
		return;
	
	NSEnumerator* en = [array objectEnumerator];
	NSXMLElement* arrayElement = [NSXMLElement elementWithName:name];
	[root addChild:arrayElement];
	id obj;
	if(type == nil)
	{
		while ((obj = [en nextObject])) {
			[arrayElement addChild:[((BaseWSObject*)obj) toXMLElement]];
		}
	}
	else{
		while ((obj = [en nextObject])) {
			NSXMLElement* ne = [NSXMLElement elementWithName:type];
			if([type isEqualToString:@"string"])
				[ne setStringValue: obj];
			else
				[ne setStringValue:[obj stringValue]];
			[arrayElement addChild:ne];
		}
	}
}

+(void) addChildArrayInline: (NSXMLElement*) root withName: (NSString*) name withType:(NSString*) type withArray:(NSArray*) array{
	
	if(array==nil || ([array count]==0))
		return;
	
	NSEnumerator* en = [array objectEnumerator];
	NSXMLElement* arrayElement = root;
	id obj;
	if(type == nil)
	{
		while ((obj = [en nextObject])) {
			NSXMLElement* ne = [NSXMLElement elementWithName:name];
			[((BaseWSObject*)obj) fillXML:ne];
			[arrayElement addChild:ne];
		}
	}
	else{
		while ((obj = [en nextObject])) {
			NSXMLElement* ne = [NSXMLElement elementWithName:name];
			if([type isEqualToString:@"string"])
				[ne setStringValue: obj];
			else
				[ne setStringValue:[obj stringValue]];
			[arrayElement addChild:ne];
		}
	}
}


+(void) addChildNode: (NSXMLElement*) root withName:(NSString*) name withElement: (NSXMLElement*) e withObject:(BaseWSObject*) obj{
	NSXMLElement* node = [NSXMLElement elementWithName:name];
	[root addChild:node];
	if(e != nil){
		[node addChild:e];
	}else {
		if(obj==nil)
			return;
		[obj fillXML:node];
	}
	
}

+(NSEnumerator*) getChildren:(NSXMLElement*)e forName:(NSString*) name{
	NSMutableArray* retVal = [NSMutableArray arrayWithCapacity:10];
	NSEnumerator* en = [[e children] objectEnumerator];
	id obj;
	while((obj = [en nextObject])){
		if([[obj localName] isEqualToString:name])
			[retVal addObject:obj];
	}
	return [retVal objectEnumerator];
}

+(void) setBusy:(BOOL)busy{
	
}


+(NSXMLDocument*) documentWithText: (NSString*)text orData:(NSData*) data  options:(NSInteger)validationOption error:(NSError**)pError{
	NSXMLDocument* doc = nil;
	if(text==nil){
		doc = [[NSXMLDocument alloc] initWithData:data options:validationOption error:pError];
	}else {
		doc = [[NSXMLDocument alloc] initWithXMLString:text options:validationOption error:pError];
	}
	[doc autorelease];
	if(pError!=nil && *pError!=nil)
		return nil;
	return doc;
}

@end
