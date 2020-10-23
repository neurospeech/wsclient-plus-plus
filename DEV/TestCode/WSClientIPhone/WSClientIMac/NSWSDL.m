/*
  NSWSDL.m
  WSClient (MAC)
 
  Version: 1.14

  Created by Akash Kava on 03/04/09.
  Copyright 2010 NeuroSpeech, Inc. All rights reserved.
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



@implementation SoapRequest

@synthesize document;
@synthesize header;
@synthesize method;
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
	[super dealloc];
}


+(SoapRequest*) newRequest{
	SoapRequest* req = [[[SoapRequest alloc] init] autorelease];
	return req;
}

@end


@implementation SoapResponse

@synthesize header;
@synthesize body;
@synthesize faultCode;
@synthesize faultString;
@synthesize rawHttpResponse;

-(void) dealloc{
	[self setHeader:nil];
	[self setBody:nil];
	[self setFaultCode:nil];
	[self setFaultString:nil];
	[self setRawHttpResponse:nil];
	[super dealloc];
}

+(SoapResponse*) newResponse{
	SoapResponse* res = [[[SoapResponse alloc] init] autorelease];
	return res;
}

@end




NSString* __baseUrl = nil;

@implementation SoapWebService

@synthesize url;
@synthesize baseUrl;
@synthesize delegate;
@synthesize data;
@synthesize soapAction;

-(void) dealloc{
	[self setData:nil];
	[self setDelegate:nil];
	[self setUrl:nil];
	[self setBaseUrl:nil];
	[self setSoapAction:nil];
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


-(SoapRequest*) buildSoapRequest: (NSString*) methodName withNS:(NSString*)nsUri withAction:(NSString*)action withHeader:(NSString*)header error:(NSError**) pError
{
	SoapRequest* req = [SoapRequest newRequest];
	[req setMethodName:methodName];
	if(action==nil){
		[req setSoapAction:[nsUri stringByAppendingString:methodName]];
	}else {
		[req setSoapAction:action];
	}	
	NSString* headerXml = @"";
	if(header != nil){
		headerXml = [NSString stringWithFormat:@"<soap12:Header><%@ xmlns='%@'></%@></soap12:Header>",header, nsUri, header];
	}
	
	NSString* soapRequest = [NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='SOAPENVELOPE'>SOAPHEADER<soap12:Body><SOAPREQUEST xmlns='%@'></SOAPREQUEST></soap12:Body></soap12:Envelope>", nsUri];
	soapRequest = [soapRequest stringByReplacingOccurrencesOfString:@"SOAPREQUEST" withString:methodName];
	soapRequest = [soapRequest stringByReplacingOccurrencesOfString:@"SOAPENVELOPE" withString:[self soapEnvelopeNS]];
	soapRequest = [soapRequest stringByReplacingOccurrencesOfString:@"SOAPHEADER" withString:headerXml];
	NSXMLDocument* doc = [NSWSDL documentWithText:soapRequest orData:nil options:NSXMLDocumentValidate error:pError];
	[req setDocument:doc];
	NSXMLElement* root = [doc rootElement];
	if(header!=nil){
		[req setHeader: [NSWSDL getElement:root:@"soap12:Header"] ];
	}
	NSXMLElement* body = [NSWSDL getElement:root :@"soap12:Body"];
	[req setMethod:[NSWSDL getElementNS:body forNamespace:nsUri forName:methodName]];
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
		return [baseUrl stringByAppendingString:url];
	}
	if(__baseUrl!=nil && ([__baseUrl length]>0)){
		return [__baseUrl stringByAppendingString:url];
	}
	return url;
}

-(NSMutableURLRequest*) buildHttpRequest: (SoapRequest*) soapReq error:(NSError**) pError{
	NSData* xmlData = [[soapReq document] XMLData];
	NSURL * nsURL = [NSURL URLWithString:[self getServiceUrl]];
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:nsURL];
	[request setValue: [self contentType] forHTTPHeaderField:@"Content-Type"];
	if ([self isSoapActionRequired]) {
		[request setValue:[soapReq soapAction] forHTTPHeaderField: @"SOAPAction"];
	}
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
	SoapResponse* res = [SoapResponse newResponse];
	[res setRawHttpResponse:resp];
	
	NSXMLElement* fault = [NSWSDL getElementNS:root forNamespace:rootNS forName:@"Fault"];
	if(fault!=nil){
		[res setFaultCode:[NSWSDL getString:fault :@"faultcode" :false]];
		[res setFaultString:[NSWSDL getString:fault :@"faultstring" :false]];
		return res;
	}
	
	[res setBody:[NSWSDL getElementNS:root forNamespace:rootNS forName:@"Body"]];
	[res setHeader:[NSWSDL getElementNS:root forNamespace:rootNS forName:@"Header"]];
	
	NSXMLElement* body = [res body];
	body = [[body children] objectAtIndex:0];
	body = [[body children] objectAtIndex:0];
	[res setBody:body];
	return res;
}

-(SoapResponse*) getSoapResponse:(SoapRequest *)soapReq error:(NSError **)pError{
	NSMutableURLRequest* httpRequest = [self buildHttpRequest:soapReq  error:pError];
	
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSError* error = nil;
	//NSString* dts = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	SoapResponse* root = [self buildSoapResponse:data error:&error];
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
	NSArray* ary = [root elementsForName:name];
	if(!ary)
		return nil;
	if([ary count]<=0)
		return nil;
	NSXMLElement* e1 = [ary objectAtIndex:0];
	return e1;
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

+(NSDate*)  getDate: (NSXMLElement*) root: (NSString*) name: (BOOL) bAttribute{
	
	NSString* val = [NSWSDL getString:root :name :bAttribute];
	if(val==nil)
		return nil;
	NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
	NSLocale* locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	[df setLocale:locale];
	[df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
	[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return [df dateFromString:val];
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
		//[root setAttribute:name withValue:value];
		NSXMLNode* node = [root attributeForName:name];
		if(node==nil){
			node = [NSXMLNode attributeWithName:name stringValue:value];
			[root addChild:node];
		}else{
			[node setStringValue:value];
		}
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
		while (obj = [en nextObject]) {
			[arrayElement addChild:[((BaseWSObject*)obj) toXMLElement]];
		}
	}
	else{
		while (obj = [en nextObject]) {
			NSXMLElement* ne = [NSXMLElement elementWithName:type];
			[ne setStringValue:[obj stringValue]];
			[arrayElement addChild:ne];
		}
	}
}

+(void) addChildNode: (NSXMLElement*) root withName:(NSString*) name withElement: (NSXMLElement*) e withObject:(BaseWSObject*) obj{
	if(obj==nil)
		return;
	NSXMLElement* node = [NSXMLElement elementWithName:name];
	[root addChild:node];
	if(e != nil){
		[node addChild:e];
	}else {
		[obj fillXML:e];
	}
	
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
	if(pError!=nil && *pError!=nil)
		return nil;
	[doc autorelease];
	return doc;
}

@end
