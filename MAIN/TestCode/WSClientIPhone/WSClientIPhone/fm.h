#import <Foundation/Foundation.h>

#import "NSWSDL.h"
@class hello;
@class helloResponse;


@interface hello : BaseWSObject{
	NSString* name;
}

@property (readwrite,copy) NSString* name;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface helloResponse : BaseWSObject{
	NSString* wsReturn;
}

@property (readwrite,copy) NSString* wsReturn;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface DormasWebservice: SoapWebService{
}

+(DormasWebservice*) service;


-(id) init;

-(NSString*)hello : (NSString*) name error: (NSError**)pError;

@end

@interface DormasWebserviceAsync: SoapWebService{
}

+(DormasWebserviceAsync*) service;


-(id) init;

-(void)hello : (NSString*) name;

@end

@protocol DormasWebserviceDelegate<NSObject>

@optional

-(void) onError: (NSError*) error;


-(void) onhelloReceived : (DormasWebserviceAsync*) service  result:(NSString*) result ;

@end
