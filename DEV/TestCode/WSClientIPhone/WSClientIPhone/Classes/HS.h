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
	AuthHeader* authHeader;
}
@property (readwrite,retain) AuthHeader* authHeader;

+(HeaderedService*) service;


-(id) init;

-(NSString*)Process : (NSString*) input error:(NSError**)pError;
-(Customer*)GetNew : error:(NSError**)pError;
-(Archivable*)GetAll : error:(NSError**)pError;

@end

@interface HeaderedServiceAsync: Soap12WebService{
	AuthHeader* authHeader;
}
@property (readwrite,retain) AuthHeader* authHeader;

+(HeaderedServiceAsync*) service;


-(id) init;

-(void)Process : (NSString*) input;
-(void)GetNew ;
-(void)GetAll ;

@end

@protocol HeaderedServiceDelegate<NSObject>

@optional

-(void) onError: (NSError*) error;


-(void) onProcessReceived :(NSString*) result;
-(void) onGetNewReceived :(Customer*) result;
-(void) onGetAllReceived :(Archivable*) result;

@end
