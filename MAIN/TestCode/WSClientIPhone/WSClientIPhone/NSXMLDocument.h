/*
  NSXMLDocument.h


  Version: 1.14
 
  Created by Akash Kava on 20/05/10.
  Copyright 2010 NeuroSpeech, Inc. All rights reserved.
*/

#import <Foundation/Foundation.h>

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


@interface NSXMLDocument : NSObject {
	
	NSXMLElement* rootElement;
	NSXMLElement* current;
	NSMutableArray* stack;
}

-(id) initWithXMLString: (NSString*) text options:(NSInteger)validationOption error:(NSError**)pError;
-(id) initWithData: (NSData*) data options:(NSInteger)validationOption error:(NSError**)pErrpr;

@property (nonatomic, retain) NSXMLElement* rootElement;
@property (nonatomic, retain) NSXMLElement* current;



-(NSData*) XMLData;

@end
