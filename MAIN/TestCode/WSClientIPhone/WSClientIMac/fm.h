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

@interface HeaderedService: Soap12WebService{
AuthHeader* headerAuthHeader;
}
@property (readwrite, retain) AuthHeader* headerAuthHeader;

+(HeaderedService*) service;


-(id) init;

-(NSString*)Process : (NSString*) input error: (NSError**)pError;
-(Customer*)GetNew :(NSError**)pError;
-(Archivable*)GetAll :(NSError**)pError;
-(Customer*)GetNewCustomer : (NSString*) name passKey: (NSString*) passKey error: (NSError**)pError;

@end

@interface HeaderedServiceAsync: Soap12WebService{
AuthHeader* headerAuthHeader;
}
@property (readwrite, retain) AuthHeader* headerAuthHeader;

+(HeaderedServiceAsync*) service;


-(id) init;

-(void)Process : (NSString*) input;
-(void)GetNew ;
-(void)GetAll ;
-(void)GetNewCustomer : (NSString*) name passKey: (NSString*) passKey;

@end

@protocol HeaderedServiceDelegate<NSObject>

@optional

-(void) onError: (NSError*) error;


-(void) onProcessReceived : (HeaderedServiceAsync*) service  result:(NSString*) result ;
-(void) onGetNewReceived : (HeaderedServiceAsync*) service  result:(Customer*) result ;
-(void) onGetAllReceived : (HeaderedServiceAsync*) service  result:(Archivable*) result ;
-(void) onGetNewCustomerReceived : (HeaderedServiceAsync*) service  result:(Customer*) result ;

@end
