/*
  NSXMLDocument.m


  Version: 1.14
 
  Created by Akash Kava on 20/05/10.
  Copyright 2010 NeuroSpeech, Inc. All rights reserved.
*/

#import "NSXMLDocument.h"


@implementation NSXMLNode

@synthesize stringValue;
@synthesize nodeName;
@synthesize localName;
@synthesize name;


+(id) elementWithName: (NSString*)name{
	
	NSXMLElement* e = [[[NSXMLElement alloc] init] autorelease];
	[e setNodeName:name];
	return e;
}


-(NSString*) prefix{
	if(localName==nil)
		return nil;
	if([nodeName isEqualToString:localName])
		return nil;
	int i = [nodeName length]-[localName length];
	if(i==0)
		return nil;
	return [nodeName substringWithRange:NSMakeRange(0, i-1)];
}

-(NSString*) encodedValue{
	// pending...
	//NSLog(@"Warning.. data encoded partially...");
	
	NSString* ev = [stringValue stringByReplacingOccurrencesOfString:@"&" 
												withString:@"&amp;"];
	ev = [ev stringByReplacingOccurrencesOfString:@"<"
														  withString:@"&lt;"];
	ev = [ev stringByReplacingOccurrencesOfString:@">" 
												withString:@"&gt;"];
	return ev;
}


-(void) appendValue: (NSString*) value{
	if(stringValue==nil){
		[self setStringValue:value];
		return;
	}
	[self setStringValue:[stringValue stringByAppendingString:value]];
}

-(void) dealloc
{
	[self setStringValue:nil];
	[self setNodeName:nil];
	[self setLocalName:nil];
	[self setName:nil];
	[super dealloc];
}

@end



@implementation NSXMLElement

//@synthesize parent;
@synthesize namespaceURI;

-(id) init{
	attributes = [[NSMutableArray alloc] init];
	children = [[NSMutableArray alloc] init];
	return self;
}


+(NSXMLElement*) newElement{
	NSXMLElement* e = [[NSXMLElement alloc] init];
	[e autorelease];
	return e;
}


-(void) dealloc{
	
	//[attributes removeAllObjects];
	//[children removeAllObjects];
	[self setNamespaceURI:nil];
	[attributes release];
	[children release];
	[super dealloc];
}

-(NSArray*) elementsForName: (NSString*)lname{
	
	NSMutableArray* ret = [NSMutableArray arrayWithCapacity:10];
	
	int count = [children count];
	
	for (int i=0; i<count; i++) {
		NSXMLElement* child = [children objectAtIndex:i];
		if ([[child nodeName] isEqualToString:lname]) {
			[ret addObject:child];
		}
	}
	
	return ret;
}

-(NSArray*) elementsForLocalName: (NSString*)lname URI:(NSString*) URI{
	NSMutableArray* ret = [NSMutableArray arrayWithCapacity:10];
	
	int count = [children count];
	
	for (int i=0; i<count; i++) {
		NSXMLElement* child = [children objectAtIndex:i];
		//NSLog(@"Searching %@ in %@",lname,[child localName]);
		if (
			([[child localName] isEqualToString:lname])
			&&
			([[child namespaceURI] isEqualToString:URI])
			) 
		{
			[ret addObject:child];
		}
	}
	
	return ret;
}

-(NSArray*) children{
	return children;
}

-(NSXMLNode*) attributeForName: (NSString*) lname{
	
	int count = [attributes count];
	
	for (int i=0; i<count; i++) {
		NSXMLNode* child = [attributes objectAtIndex:i];
		if ([[child nodeName] isEqualToString:lname]) {
			return child ;
		}
	}
	return nil;
}

	
	

-(void) addChild:(NSXMLElement*) child{
	[children addObject:child];
}

-(BOOL) listContainsString:(NSMutableArray*) list text:(NSString*) text{
	int count = [list count];
	for (int i=0; i<count; i++) {
		NSString* listText = [list objectAtIndex:i];
		if([listText isEqualToString:text])
			return YES;
	}
	return NO;
}

-(NSString*) innerXMLWithNamespace: (NSMutableArray*) prefixes{
	
	if(prefixes==nil){
		prefixes = [NSMutableArray array];
	}
	
	// build xml...
	int i = 0;
	
	//NSLog(@"Prefix: %@, %@ %@",[self prefix],[self nodeName],[self localName]);
	
	NSMutableString* xml = [NSMutableString stringWithFormat:@"<%@", nodeName];
	
	int count = [attributes count];
	for (i=0; i<count; i++) {
		NSXMLNode* node = [attributes objectAtIndex:i];
		[xml appendFormat:@" %@=\"%@\"",[node nodeName],[node encodedValue]];
	}
	
	// write namespace uris...
	NSString* nsUri = [self namespaceURI];
	if(nsUri!=nil && [nsUri length]>0){
		if(![self listContainsString:prefixes text:nsUri]){
			NSString* px = [self prefix];
			if(px == nil){
				px = @"xmlns";
			}else{
				px = [NSString stringWithFormat:@"xmlns:%@",px];
			}
			[xml appendFormat:@" %@=\"%@\"",px,nsUri];
			[prefixes addObject:nsUri];
		}
	}
	
	count = [children count];
	
	if (count>0) {
		[xml appendString:@">\r\n"];
		
		for (i=0; i<count; i++) {
			NSXMLElement* child = [children objectAtIndex:i];
			[xml appendString:@"\t"];
			NSMutableArray* childArray = [NSMutableArray arrayWithArray:prefixes];
			[xml appendString:[child innerXMLWithNamespace:childArray]];
		}
		
		[xml appendFormat:@"</%@>\r\n",nodeName];
	}else {
		
		if(stringValue == nil){			
			[xml appendString:@"/>\r\n"];
		}else {
			[xml appendFormat:@">%@</%@>\r\n", [self encodedValue], nodeName];
		}
		
	}
	
	
	return xml;
}

-(NSString*) innerXML{
	return [self innerXMLWithNamespace: nil];
}

-(void) appendAttributes: (NSDictionary*) values{
	NSEnumerator* enm = [values keyEnumerator];
	
	NSString* key;
	while((key = [enm nextObject])){
		NSString* value = [values objectForKey:key];
		
		// add...
		NSXMLNode* node = [[[NSXMLNode alloc] init] autorelease];
		[node setNodeName:key];
		[node setStringValue:value];
		[attributes addObject:node];
	}
}

-(void) setAttribute: (NSString*) lname withValue:(NSString*) value{
	NSXMLNode* node = [self attributeForName:lname];
	if(node==nil){
		node = [[[NSXMLNode alloc] init] autorelease];
		[node setStringValue:value];
		[node setNodeName:lname];
		[attributes addObject:node];
	}else{
		[node setStringValue:value];
	}
}

@end



@implementation NSXMLDocument

@synthesize rootElement;
@synthesize current;


-(id) initWithData: (NSData*) data options:(NSInteger)validationOption error:(NSError**)pErrpr{
	
	[self setRootElement: [NSXMLElement newElement] ];
	
	current = nil;
	
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	stack = [[NSMutableArray alloc] initWithCapacity:10];

	[parser setDelegate:self];
	if(![parser parse])
	{
		// error occured..
		NSString* xml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"XML=%@",xml);
		NSLog(@"Parsing failed..., %@",[[parser parserError] localizedDescription]);
		if(pErrpr!=nil){
			(*pErrpr) = [[parser parserError] autorelease];
		}
	}
	
	[parser release];
	[stack release];
	
	return self;
}

-(id) initWithXMLString: (NSString*) text options:(NSInteger)validationOption error:(NSError**)pError{
	
	return [self initWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:validationOption error:pError];
}


-(NSData*) XMLData{
	NSString* xml = [rootElement innerXML];
	return [xml dataUsingEncoding:NSUTF8StringEncoding];
}

-(void) dealloc
{
	
	[self setCurrent:nil];
	
	//NSLog(@"Releasing Root..");
	[self setRootElement:nil];

	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser 
	didStartElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
	qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict
{
	if(current==nil){
		[self setCurrent: rootElement];
	}else {
		// create new one..
		NSXMLElement* old = current;
		
		[self setCurrent: [NSXMLElement newElement]];
		//[current setParent:old];
		
		[old addChild:current];
		[stack addObject:old];
	}

	
	//NSLog(@"Q:%@ E:%@ NS:%@", qualifiedName, elementName,namespaceURI);
	
	// set name...
	[current setNodeName:qualifiedName];
	[current setName:qualifiedName];
	[current setLocalName:elementName];
	[current setNamespaceURI:namespaceURI];
	
	// set attributes..
	[current appendAttributes:attributeDict];
}

- (void)parser:(NSXMLParser *)parser 
	didEndElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
	qualifiedName:(NSString *)qName
{
	//[self setCurrent: [current parent]];
	int count = [stack count];
	if(count >0 ){
		NSXMLElement* obj = [stack objectAtIndex:count-1];
		[self setCurrent:obj];
		[stack removeObjectAtIndex:count-1];
	}
	else
	{
		[self setCurrent:nil];
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	[current appendValue:string];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
	[current appendValue:[[NSString alloc] 
							initWithData:CDATABlock
						  encoding:NSUTF8StringEncoding]];
}

@end
