/*
 NSWSDL.h
 WSClient (iOS)
 
 Version: 1.14
 
 Created by Akash Kava on 03/04/09.
 Copyright 2009 NeuroSpeech, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "NSXMLDocument.h"

@interface SoapRequest : NSObject
{
	NSXMLDocument* document;
	NSXMLElement* header;
	NSXMLElement* method;
	NSString* methodName;
	NSString* soapAction;
	NSString* rawHttpRequest;
}

@property (nonatomic, retain) NSXMLDocument* document;
@property (nonatomic, retain) NSXMLElement* header;
@property (nonatomic, retain) NSXMLElement* method;
@property (nonatomic, copy) NSString* methodName;
@property (nonatomic, copy) NSString* soapAction;
@property (nonatomic, copy) NSString* rawHttpRequest;

+(SoapRequest*) newRequest;

@end


@interface SoapResponse : NSObject
{
	NSXMLElement* header;
	NSXMLElement* body;
	NSString* faultCode;
	NSString* faultString;
	NSString* rawHttpResponse;
}

@property (nonatomic, retain) NSXMLElement* header;
@property (nonatomic, retain) NSXMLElement* body;
@property (nonatomic, retain) NSString* faultCode;
@property (nonatomic, retain) NSString* faultString;
@property (nonatomic, retain) NSString* rawHttpResponse;

+(SoapResponse*) newResponse;

@end



@interface SoapWebService : NSObject
{
	NSString* url;
	NSString* baseUrl;
	id delegate;
	NSMutableData* data;
	SEL responseSelector;
	
	NSString* soapAction;
}

@property (nonatomic, copy) NSString* baseUrl;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* soapAction;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSMutableData* data;


-(SoapRequest*) buildSoapRequest: (NSString*) methodName withNS:(NSString*)nsUri withAction:(NSString*)action withHeader:(NSString*)header error:(NSError**) pError;
-(SoapResponse*) getSoapResponse: (SoapRequest*) doc error:(NSError**) pError;
//-(NSXMLElement*) getSoapRoot: (NSXMLElement*) docRoot;
//-(NSXMLElement*) getSoapRequest: (NSXMLDocument*) doc;
-(void) addParameter: (NSXMLElement*)root withName:(NSString*)name withValue:(NSString*) value;

-(NSString*) getServiceUrl;


-(void) postSoapRequest: (SoapRequest*) doc selector:(SEL)s;
-(void) soapResponseReceived: (SoapResponse*)response withSelector:(SEL) sel;
-(void) onError: (NSError*) error;

+(NSString*) globalBaseUrl;
+(void) setGlobalBaseUrl:(NSString*) gbUrl;

-(NSString*) soapEnvelopeNS;
-(NSString*) contentType;
-(BOOL) isSoapActionRequired;

@end

@interface Soap12WebService : SoapWebService
{
}
@end


@interface BaseWSObject : NSObject
{
	
}

-(void) fillXML:(NSXMLElement*) node;
-(NSXMLElement*) toXMLElement;

@end



@interface NSWSDLDateTime : NSObject{
}
@end



/*@interface NSArrayDataSource : NSObject{
 NSArray* internalArray;
 }
 -(id) initWithArray: (NSArray*) objects;
 -(int)numberOfRowsInTableView:(NSTableView *)aTableView;
 -(id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;
 -(void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;
 @end
 */

@interface NSWSDL : NSObject {
	
}

+(NSXMLElement*)getElementNS:(NSXMLElement*) root forNamespace:(NSString*) forNS forName:(NSString*) name;
+(NSXMLElement*)	getElement: (NSXMLElement*) root: (NSString*) name;
+(NSString*)	getAttributeString: (NSXMLElement*) root: (NSString*) name;

+(NSString*)		getString:	(NSXMLElement*) root: (NSString*) name :(BOOL) bAttribute;
+(NSNumber*)		getBool: (NSXMLElement*) root: (NSString*) name: (BOOL) bAttribute;
+(NSDecimalNumber*)	getNumber: (NSXMLElement*) root: (NSString*) name: (BOOL) bAttribute;
+(NSDate*)  getDate: (NSXMLElement*) root: (NSString*) name: (BOOL) bAttribute;

+(NSXMLDocument*) documentWithText: (NSString*)text orData:(NSData*) data  options:(NSInteger)validationOption error:(NSError**)pError;

+(void) setBusy:(BOOL)busy;

+(void) addChild: (NSXMLElement*) root withName:(NSString*) name withValue:(NSString*) value asAttribute:(BOOL)bAttribute;
+(void) addChildArray: (NSXMLElement*) root withName: (NSString*) name withType:(NSString*) type withArray:(NSArray*) array;
+(void) addChildNode: (NSXMLElement*) root withName:(NSString*) name withElement: (NSXMLElement*) e withObject:(BaseWSObject*) obj;

+(NSString*) toDateString:(NSDate*) date;

@end
