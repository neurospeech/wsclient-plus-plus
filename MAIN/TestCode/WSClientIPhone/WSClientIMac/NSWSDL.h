/*
 NSWSDL.h
 WSClient (MAC)
 
 Version: 1.17
 
 Created by Akash Kava on 03/04/09.
 Copyright 2009 NeuroSpeech, Inc. All rights reserved.
 */

#if TARGET_OS_IPHONE
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#if TARGET_OS_IPHONE

#define NSXMLDocumentValidate 1
#define NSXMLDocumentTidyXML 2




@interface NSXMLNode : NSObject {
	NSString* stringValue;
	NSString* nodeName;
	NSString* localName;
	NSString* name;
}

+(id) elementWithName: (NSString*)name;

@property (nonatomic, copy) NSString* stringValue;
@property (nonatomic, copy) NSString* nodeName;
@property (nonatomic, copy) NSString* localName;
@property (nonatomic, copy) NSString* name;


-(NSString*) encodedValue;

-(NSString*) prefix;

-(void) appendValue: (NSString*) value;

@end



@interface NSXMLElement : NSXMLNode {
	NSMutableArray* attributes;
	NSMutableArray* children;
	NSString* namespaceURI;
	//NSXMLElement* parent;
}
@property (readwrite, copy) NSString* namespaceURI;

+(NSXMLElement*) newElement;

//-(id) init;

-(void) dealloc;

-(NSArray*) elementsForName: (NSString*)name;
-(NSArray*) elementsForLocalName: (NSString*)name URI:(NSString*) URI;

-(NSArray*) children;

-(void) addChild:(NSXMLElement*) child;

-(NSXMLNode*) attributeForName: (NSString*) name;

-(NSString*) innerXML;

-(void) appendAttributes: (NSDictionary*) values;
-(void) setAttribute: (NSString*) name withValue:(NSString*) value;
//@property (nonatomic, retain) NSXMLElement* parent;

@end


@interface NSXMLDocument : NSObject  {
	
	NSXMLElement* rootElement;
	NSXMLElement* current;
	NSMutableArray* stack;
	NSMutableDictionary* lastAttributes;
}

-(id) initWithXMLString: (NSString*) text options:(NSInteger)validationOption error:(NSError**)pError;
-(id) initWithData: (NSData*) data options:(NSInteger)validationOption error:(NSError**)pErrpr;

@property (nonatomic, retain) NSXMLElement* rootElement;
@property (nonatomic, retain) NSXMLElement* current;
@property (nonatomic, retain) NSMutableArray* stack;
@property (nonatomic, retain) NSMutableDictionary* lastAttributes;


-(NSData*) XMLData;

@end
#endif


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
	NSXMLElement* response;
	NSString* faultCode;
	NSString* faultString;
	NSString* rawHttpResponse;
}

@property (nonatomic, retain) NSXMLElement* header;
@property (nonatomic, retain) NSXMLElement* body;
@property (nonatomic, retain) NSXMLElement* response;
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
+(NSArray*) getChildren:(NSXMLElement*)e forName:(NSString*) name;

+(NSString*) toDateString:(NSDate*) date;

@end
