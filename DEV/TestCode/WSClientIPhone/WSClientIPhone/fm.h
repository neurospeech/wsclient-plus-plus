#import <Foundation/Foundation.h>

#import "NSWSDL.h"

@interface AuthHeader : BaseWSObject{
	NSString* username;
	NSString* passKey;
}

@property (readwrite,retain) NSString* username;
@property (readwrite,retain) NSString* passKey;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface Archivable : BaseWSObject{
	NSNumber* isArchived;
}

@property (readwrite,retain) NSNumber* isArchived;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface Customer : Archivable{
	NSString* name;
	NSString* iD;
}

@property (readwrite,retain) NSString* name;
@property (readwrite,retain) NSString* iD;

-(NSXMLElement*) toXMLElement;
-(void) fillXML: (NSXMLElement*)e;
-(void) loadFrom: (NSXMLElement*) root;
+(id) objectByXML:(NSXMLElement*) root;

@end

@interface HeaderedService: SoapWebService{
AuthHeader* headerAuthHeader;
}
@property (readwrite, retain) AuthHeader* headerAuthHeader;

+(HeaderedService*) service;


-(id) init;

-(NSString*)Process : (NSString*) input error:(NSError**)pError;
-(Customer*)GetNew : error:(NSError**)pError;
-(Archivable*)GetAll : error:(NSError**)pError;

@end

@interface HeaderedServiceAsync: SoapWebService{
AuthHeader* headerAuthHeader;
}
@property (readwrite, retain) AuthHeader* headerAuthHeader;

+(HeaderedServiceAsync*) service;


-(id) init;

-(void)Process : (NSString*) input;
-(void)GetNew ;
-(void)GetAll ;

@end

@protocol HeaderedServiceDelegate<NSObject>

@optional

-(void) onError: (NSError*) error;


-(void) onProcessReceived : (HeaderedServiceAsync*) service  result:(NSString*) result ;
-(void) onGetNewReceived : (HeaderedServiceAsync*) service  result:(Customer*) result ;
-(void) onGetAllReceived : (HeaderedServiceAsync*) service  result:(Archivable*) result ;

@end
