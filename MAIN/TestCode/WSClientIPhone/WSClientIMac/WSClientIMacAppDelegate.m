//
//  WSClientIMacAppDelegate.m
//  WSClientIMac
//
//  Version 1.1
// 
//  Created by Akash Kava on 26/10/10.
//  Copyright 2010 NeuroSpeech, Inc. All rights reserved.
//

#import "WSClientIMacAppDelegate.h"

#import "fm.h"

@implementation WSClientIMacAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 


	[HeaderedService setGlobalBaseUrl:@"http://wsclient.ns"];
	
	HeaderedService* hs = [HeaderedService service];
	AuthHeader* ah = [[[AuthHeader alloc] init] autorelease];
	[ah setUsername:@"akash"];
	[hs setHeaderAuthHeader:ah];
	
	NSString* r = [hs Process:@"input" error:nil];
	NSLog(@"With Header: %@",r);
	
	[hs setHeaderAuthHeader:nil];
	
	r = [hs Process:@"input" error:nil];
	NSLog(@"Without Header: %@",r);
	ah = [hs headerAuthHeader];
	if(ah != nil){
		NSLog(@"%@",[ah username]);
	}
	
	Customer* c = [hs GetNewCustomer:@"akash" passKey:@"pass" error:nil];
	if(c!=nil){
		NSLog(@"Name: %@ ID: %@",[c name],[c iD]);
	}
	
}

@end
