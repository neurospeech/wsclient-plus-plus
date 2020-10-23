#import "HS.h"

@implementation hello

@synthesize name;


-(void) dealloc{
	[name release];
	name = nil;
	[super dealloc];
}


-(NSXMLElement*) toXMLElement{
	NSXMLElement* e = [NSXMLElement elementWithName:@"ns4:hello"];
	[self fillXML:e];
	return e;
}


-(void) fillXML:(NSXMLElement*) e{
	if(name!=nil)
		if(name!=nil){
			[NSWSDL addChild:e withName:@"ns4:name" withValue: name asAttribute:NO];
		}
}


-(void) loadFrom: (NSXMLElement*) root{
	if(root==nil) return;
	[self setname: [NSWSDL getString:root:@"name":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
	if(root==nil) return nil;
	hello* obj = [[[hello alloc] init] autorelease];
	[obj loadFrom:root];
	return obj;
}

@end


@implementation helloResponse

@synthesize wsReturn;


-(void) dealloc{
	[wsReturn release];
	wsReturn = nil;
	[super dealloc];
}


-(NSXMLElement*) toXMLElement{
	NSXMLElement* e = [NSXMLElement elementWithName:@"ns4:helloResponse"];
	[self fillXML:e];
	return e;
}


-(void) fillXML:(NSXMLElement*) e{
	if(wsReturn!=nil)
		if(wsReturn!=nil){
			[NSWSDL addChild:e withName:@"ns4:return" withValue: wsReturn asAttribute:NO];
		}
}


-(void) loadFrom: (NSXMLElement*) root{
	if(root==nil) return;
	[self setWsReturn: [NSWSDL getString:root:@"return":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
	if(root==nil) return nil;
	helloResponse* obj = [[[helloResponse alloc] init] autorelease];
	[obj loadFrom:root];
	return obj;
}

@end


@implementation DormasWebservice

-(void) dealloc
{
	[super dealloc];
}


+(DormasWebservice*) service{
	return [[[DormasWebservice alloc] init] autorelease];
}

-(id) init{
	if(!(self = [super init])) return nil;
	[self set__url: @"/axis2/services/DormasWebservice.DormasWebserviceHttpsSoap11Endpoint/"];
	return self;
}

-(NSString*) getNamespaces
{
	NSString* ns = [NSString string];
	ns = [ns stringByAppendingString:@" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \r\n"];
	ns = [ns stringByAppendingString:@" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \r\n"];
	ns = [ns stringByAppendingString:@" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" \r\n"];
	ns = [ns stringByAppendingString:@" xmlns:ns4=\"http://dormaswebservice\" \r\n"];
	return ns;
}

-(NSString*)hello : (NSString*) name error: (NSError**)pError{
	[NSWSDL setBusy:YES];
	SoapRequest* _req = [self buildSoapRequest: @"urn:hello" error:pError];
	hello* ___method = [[hello alloc] init];
	[___method setname: name];
	[_req setMethod: [___method toXMLElement]];
	SoapResponse* _resp = [self getSoapResponse: _req error:pError];
	if(_resp==nil) return nil;
	helloResponse* __response = [[helloResponse alloc] init];
	[__response loadFrom: [_resp body]];
	id retVal = [__response wsReturn];
	[NSWSDL setBusy:NO];
	return retVal;
}

@end


@implementation DormasWebserviceAsync

-(void) dealloc
{
	[super dealloc];
}


+(DormasWebserviceAsync*) service{
	return [[[DormasWebserviceAsync alloc] init] autorelease];
}

-(id) init{
	if(!(self = [super init])) return nil;
	[self set__url: @"/axis2/services/DormasWebservice.DormasWebserviceHttpsSoap11Endpoint/"];
	return self;
}

-(NSString*) getNamespaces
{
	NSString* ns = [NSString string];
	ns = [ns stringByAppendingString:@" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \r\n"];
	ns = [ns stringByAppendingString:@" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \r\n"];
	ns = [ns stringByAppendingString:@" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" \r\n"];
	ns = [ns stringByAppendingString:@" xmlns:ns4=\"http://dormaswebservice\" \r\n"];
	return ns;
}

-(void) onhelloReceived: (id) sender{
	[NSWSDL setBusy: NO];
	if(self.delegate == nil) return;
	if(![self.delegate respondsToSelector:@selector(onhelloReceived:  result:)]) return;
	SoapResponse* _resp = (SoapResponse*)sender;
	helloResponse* __response = [[helloResponse alloc] init];
	[__response loadFrom: [_resp body]];
	id retVal = [__response wsReturn];
	[delegate onhelloReceived: self  result: retVal];
}


-(void)hello : (NSString*) name{
	[NSWSDL setBusy:YES];
	NSError** pError = nil;
	SoapRequest* _req = [self buildSoapRequest: @"urn:hello" error:pError];
	hello* ___method = [[hello alloc] init];
	[___method setname: name];
	[_req setMethod: [___method toXMLElement]];
	[super postSoapRequest: _req selector:@selector(onhelloReceived:)];
}

@end

