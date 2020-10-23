#import "HS.h"

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

@synthesize authHeader;

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
	NSXMLDocument * _doc = [self buildSoapRequest:@"Process" withNS:@"http://tempuri.org/" error:pError];
	if(_doc==nil) return nil;
	NSXMLElement * _body = [self getSoapRequest: _doc];
	[super addParameter:_body withName: @"input" withValue:input];
	
	_body = [self getSoapResponse: _doc error:pError];
	if(_body==nil) return nil;
	id retVal = [NSWSDL getString:_body:nil:NO];
	[NSWSDL setBusy:NO];
	return retVal;
}

-(Customer*)GetNew : error:(NSError**)pError{
	[NSWSDL setBusy:YES];
	NSXMLDocument * _doc = [self buildSoapRequest:@"GetNew" withNS:@"http://tempuri.org/" error:pError];
	if(_doc==nil) return nil;
	NSXMLElement * _body = [self getSoapRequest: _doc];
	
	_body = [self getSoapResponse: _doc error:pError];
	if(_body==nil) return nil;
	id retVal = [Customer objectByXML:_body];
	[NSWSDL setBusy:NO];
	return retVal;
}

-(Archivable*)GetAll : error:(NSError**)pError{
	[NSWSDL setBusy:YES];
	NSXMLDocument * _doc = [self buildSoapRequest:@"GetAll" withNS:@"http://tempuri.org/" error:pError];
	if(_doc==nil) return nil;
	NSXMLElement * _body = [self getSoapRequest: _doc];
	
	_body = [self getSoapResponse: _doc error:pError];
	if(_body==nil) return nil;
	id retVal = [Archivable objectByXML:_body];
	[NSWSDL setBusy:NO];
	return retVal;
}

@end


@implementation HeaderedServiceAsync

@synthesize authHeader;

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
	if(![self.delegate respondsToSelector:@selector(onProcessReceived:)]) return;
	NSXMLElement* _body = (NSXMLElement*)sender;
	id retVal = [NSWSDL getString:_body:nil:NO];
	[delegate onProcessReceived: retVal];
}


-(void)Process : (NSString*) input{
	[NSWSDL setBusy:YES];
	NSError* error = nil;
	NSXMLDocument * _doc = [self buildSoapRequest:@"Process" withNS:@"http://tempuri.org/" error:&error];
	if(_doc==nil){
		[self onError:error];
		return;
	}
	NSXMLElement * _body = [self getSoapRequest: _doc];
	if(input!=nil){
		[super addParameter:_body withName: @"input" withValue:input];
	}
	
	[super postSoapRequest: _doc selector:@selector(onProcessReceived:)];
}

-(void) onGetNewReceived: (id) sender{
	[NSWSDL setBusy: NO];
	if(self.delegate == nil) return;
	if(![self.delegate respondsToSelector:@selector(onGetNewReceived:)]) return;
	NSXMLElement* _body = (NSXMLElement*)sender;
	id retVal = [Customer objectByXML:_body];
	[delegate onGetNewReceived: retVal];
}


-(void)GetNew {
	[NSWSDL setBusy:YES];
	NSError* error = nil;
	NSXMLDocument * _doc = [self buildSoapRequest:@"GetNew" withNS:@"http://tempuri.org/" error:&error];
	if(_doc==nil){
		[self onError:error];
		return;
	}
	
	[super postSoapRequest: _doc selector:@selector(onGetNewReceived:)];
}

-(void) onGetAllReceived: (id) sender{
	[NSWSDL setBusy: NO];
	if(self.delegate == nil) return;
	if(![self.delegate respondsToSelector:@selector(onGetAllReceived:)]) return;
	NSXMLElement* _body = (NSXMLElement*)sender;
	id retVal = [Archivable objectByXML:_body];
	[delegate onGetAllReceived: retVal];
}


-(void)GetAll {
	[NSWSDL setBusy:YES];
	NSError* error = nil;
	NSXMLDocument * _doc = [self buildSoapRequest:@"GetAll" withNS:@"http://tempuri.org/" error:&error];
	if(_doc==nil){
		[self onError:error];
		return;
	}
	
	[super postSoapRequest: _doc selector:@selector(onGetAllReceived:)];
}

@end

