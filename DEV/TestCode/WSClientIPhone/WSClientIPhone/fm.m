#import "fm.h"

@implementation AuthHeader

@synthesize username;
@synthesize passKey;


-(void) dealloc{
	[username release];
	username = nil;
	[passKey release];
	passKey = nil;
	[super dealloc];
}


-(NSXMLElement*) toXMLElement{
	NSXMLElement* e = [NSXMLElement elementWithName:@"AuthHeader"];
	[self fillXML:e];
	return e;
}


-(void) fillXML:(NSXMLElement*) e{
	if(username!=nil)
		if(username!=nil){
			[NSWSDL addChild:e withName:@"Username" withValue: username asAttribute:NO];
		}
	if(passKey!=nil)
		if(passKey!=nil){
			[NSWSDL addChild:e withName:@"PassKey" withValue: passKey asAttribute:NO];
		}
}


-(void) loadFrom: (NSXMLElement*) root{
	if(root==nil) return;
	[self setUsername: [NSWSDL getString:root:@"Username":NO]];
	[self setPassKey: [NSWSDL getString:root:@"PassKey":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
	if(root==nil) return nil;
	AuthHeader* obj = [[[AuthHeader alloc] init] autorelease];
	[obj loadFrom:root];
	return obj;
}

@end


@implementation Archivable

@synthesize isArchived;


-(void) dealloc{
	[isArchived release];
	isArchived = nil;
	[super dealloc];
}


-(NSXMLElement*) toXMLElement{
	NSXMLElement* e = [NSXMLElement elementWithName:@"Archivable"];
	[self fillXML:e];
	return e;
}


-(void) fillXML:(NSXMLElement*) e{
	if(isArchived!=nil)
		if(isArchived!=nil){
			[NSWSDL addChild:e withName:@"IsArchived" withValue: [isArchived stringValue] asAttribute:NO];
		}
}


-(void) loadFrom: (NSXMLElement*) root{
	if(root==nil) return;
	[self setIsArchived: [NSWSDL getBool:root:@"IsArchived":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
	if(root==nil) return nil;
	Archivable* obj = [[[Archivable alloc] init] autorelease];
	[obj loadFrom:root];
	return obj;
}

@end


@implementation Customer

@synthesize name;
@synthesize iD;


-(void) dealloc{
	[name release];
	name = nil;
	[iD release];
	iD = nil;
	[super dealloc];
}


-(NSXMLElement*) toXMLElement{
	NSXMLElement* e = [NSXMLElement elementWithName:@"Customer"];
	[self fillXML:e];
	return e;
}


-(void) fillXML:(NSXMLElement*) e{
	[super fillXML:e];
	if(name!=nil)
		if(name!=nil){
			[NSWSDL addChild:e withName:@"Name" withValue: name asAttribute:NO];
		}
	if(iD!=nil)
		if(iD!=nil){
			[NSWSDL addChild:e withName:@"ID" withValue: iD asAttribute:NO];
		}
}


-(void) loadFrom: (NSXMLElement*) root{
	if(root==nil) return;
	[super loadFrom:root];
	[self setName: [NSWSDL getString:root:@"Name":NO]];
	[self setID: [NSWSDL getString:root:@"ID":NO]];
}

+(id) objectByXML:(NSXMLElement*) root{
	if(root==nil) return nil;
	Customer* obj = [[[Customer alloc] init] autorelease];
	[obj loadFrom:root];
	return obj;
}

@end


@implementation HeaderedService
@synthesize headerAuthHeader;

-(void) dealloc
{
	[self setHeaderAuthHeader:nil];
	[super dealloc];
}


+(HeaderedService*) service{
	return [[[HeaderedService alloc] init] autorelease];
}

-(id) init{
	if(!(self = [super init])) return nil;
	[self setUrl: @"/Service/HeaderedService.asmx"];
	return self;
}


-(NSString*)Process : (NSString*) input error:(NSError**)pError{
	[NSWSDL setBusy:YES];
	SoapRequest* _req;
	if(headerAuthHeader!=nil)
	{
		_req = [self buildSoapRequest:@"Process" withNS:@"http://tempuri.org/" withHeader:@"AuthHeader" error:pError];
		NSXMLElement* _h = [[[_req header] children] objectAtIndex:0];
		[headerAuthHeader fillXML: _h];
	}
	else
	{
		_req = [self buildSoapRequest:@"Process" withNS:@"http://tempuri.org/" withHeader:nil error:pError];
	}
	if(_req==nil) return nil;
	NSXMLElement * _method = [_req method];
	[super addParameter:_method withName: @"input" withValue:input];
	
	SoapResponse* _resp = [self getSoapResponse: _req error:pError];
	if(_resp==nil) return nil;
	NSXMLElement* _body = [_resp body];
	NSXMLElement* __eh = [NSWSDL getElement:[_resp header]:@"AuthHeader"];
	if(__eh != nil)
	{
		AuthHeader* __header = [AuthHeader objectByXML:__eh];
		if(__header!=nil)
		{
			[self setHeaderAuthHeader: __header];
		}
	}
	id retVal = [NSWSDL getString:_body:nil:NO];
	[NSWSDL setBusy:NO];
	return retVal;
}

-(Customer*)GetNew : error:(NSError**)pError{
	[NSWSDL setBusy:YES];
	SoapRequest* _req;
	_req = [self buildSoapRequest:@"GetNew" withNS:@"http://tempuri.org/" withHeader:nil error:pError];
	if(_req==nil) return nil;
	
	SoapResponse* _resp = [self getSoapResponse: _req error:pError];
	if(_resp==nil) return nil;
	NSXMLElement* _body = [_resp body];
	id retVal = [Customer objectByXML:_body];
	[NSWSDL setBusy:NO];
	return retVal;
}

-(Archivable*)GetAll : error:(NSError**)pError{
	[NSWSDL setBusy:YES];
	SoapRequest* _req;
	_req = [self buildSoapRequest:@"GetAll" withNS:@"http://tempuri.org/" withHeader:nil error:pError];
	if(_req==nil) return nil;
	
	SoapResponse* _resp = [self getSoapResponse: _req error:pError];
	if(_resp==nil) return nil;
	NSXMLElement* _body = [_resp body];
	id retVal = [Archivable objectByXML:_body];
	[NSWSDL setBusy:NO];
	return retVal;
}

@end


@implementation HeaderedServiceAsync
@synthesize headerAuthHeader;

-(void) dealloc
{
	[self setHeaderAuthHeader:nil];
	[super dealloc];
}


+(HeaderedServiceAsync*) service{
	return [[[HeaderedServiceAsync alloc] init] autorelease];
}

-(id) init{
	if(!(self = [super init])) return nil;
	[self setUrl: @"/Service/HeaderedService.asmx"];
	return self;
}


-(void) onProcessReceived: (id) sender{
	[NSWSDL setBusy: NO];
	if(self.delegate == nil) return;
	if(![self.delegate respondsToSelector:@selector(onProcessReceived:  result:)]) return;
	SoapResponse* _resp = (SoapResponse*)sender;
	NSXMLElement* _body = [_resp body];
	NSXMLElement* __eh = [NSWSDL getElement:[_resp header]:@"AuthHeader"];
	if(__eh != nil)
	{
		AuthHeader* __header = [AuthHeader objectByXML:[_resp header]];
		if(__header!=nil)
		{
			[self setHeaderAuthHeader: __header];
		}
	}
	id retVal = [NSWSDL getString:_body:nil:NO];
	[delegate onProcessReceived: self  result: retVal];
}


-(void)Process : (NSString*) input{
	[NSWSDL setBusy:YES];
	NSError** pError = nil;
	SoapRequest* _req;
	if(headerAuthHeader!=nil)
	{
		_req = [self buildSoapRequest:@"Process" withNS:@"http://tempuri.org/" withHeader:@"AuthHeader" error:pError];
		NSXMLElement* _h = [[[_req header] children] objectAtIndex:0];
		[headerAuthHeader fillXML: _h];
	}
	else
	{
		_req = [self buildSoapRequest:@"Process" withNS:@"http://tempuri.org/" withHeader:nil error:pError];
	}
	if(_req==nil) return;
	NSXMLElement * _method = [_req method];
	[super addParameter:_method withName: @"input" withValue:input];
	
	[super postSoapRequest: _req selector:@selector(onProcessReceived:  result::)];
}

-(void) onGetNewReceived: (id) sender{
	[NSWSDL setBusy: NO];
	if(self.delegate == nil) return;
	if(![self.delegate respondsToSelector:@selector(onGetNewReceived:  result:)]) return;
	SoapResponse* _resp = (SoapResponse*)sender;
	NSXMLElement* _body = [_resp body];
	id retVal = [Customer objectByXML:_body];
	[delegate onGetNewReceived: self  result: retVal];
}


-(void)GetNew {
	[NSWSDL setBusy:YES];
	NSError** pError = nil;
	SoapRequest* _req;
	_req = [self buildSoapRequest:@"GetNew" withNS:@"http://tempuri.org/" withHeader:nil error:pError];
	if(_req==nil) return;
	
	[super postSoapRequest: _req selector:@selector(onGetNewReceived:  result::)];
}

-(void) onGetAllReceived: (id) sender{
	[NSWSDL setBusy: NO];
	if(self.delegate == nil) return;
	if(![self.delegate respondsToSelector:@selector(onGetAllReceived:  result:)]) return;
	SoapResponse* _resp = (SoapResponse*)sender;
	NSXMLElement* _body = [_resp body];
	id retVal = [Archivable objectByXML:_body];
	[delegate onGetAllReceived: self  result: retVal];
}


-(void)GetAll {
	[NSWSDL setBusy:YES];
	NSError** pError = nil;
	SoapRequest* _req;
	_req = [self buildSoapRequest:@"GetAll" withNS:@"http://tempuri.org/" withHeader:nil error:pError];
	if(_req==nil) return;
	
	[super postSoapRequest: _req selector:@selector(onGetAllReceived:  result::)];
}

@end

