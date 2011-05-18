//
//  TypeStructure.m
//  iBore
//
//  Created by Peppe on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TypeStructure.h"
#import "JSON/JSON.h"
#import "AttributeStructure.h"

@implementation TypeStructure

@synthesize idN, name, attributes;

- (id)setJSONObjectAndInit:(NSDictionary *)j {
	
	self = [super init];
	
    if (self) {
		
		if (j != nil){
		idN = [NSNumber numberWithInt:[[j objectForKey:@"ID_OF_COMPOSITE_TYPE"] intValue]];
		name = [j objectForKey:@"NAME_OF_COMPOSITE"];
		}
		
	NSDictionary *elements = [j objectForKey:@"ELEMENTS"];
		
		if (elements != nil){
		
		for (NSString *key in [elements allKeys]) {
			[attributes addObject:[[AttributeStructure alloc] initWithName:key JSONObject:[elements objectForKey:key]]];
			
		}
		
		[attributes sortUsingComparator: ^(id obj1, id obj2) {
			AttributeStructure *a1 = (AttributeStructure *)obj1;
			AttributeStructure *a2 = (AttributeStructure *)obj2;
			NSNumber *d = [NSNumber numberWithDouble:(a1.visualizationOrder - a2.visualizationOrder)];
			if (d<0){
				return (NSComparisonResult)NSOrderedAscending;
			}
			
			if (d>0){
				return (NSComparisonResult)NSOrderedDescending;
			}
			
			return (NSComparisonResult)NSOrderedSame;
			
		}];
	
		}
	}
	
	return self;
}

+(TypeStructure *)createFromFile:(NSString *)fileName {
	TypeStructure *j = nil;
	//return [self setJSONObjectAndInit:j];
	return j;
}
		 
/*
 
 public static TypeStructure createFromFile(String fileName) {
 try {
 String s="";
 BufferedReader in=new BufferedReader(new FileReader(fileName));
 String l=in.readLine();
 while (l!=null) {
 s+=l+" ";
 l=in.readLine();
 }
 in.close();
 JSONObject j=new JSONObject(s);
 return new TypeStructure(j);
 }
 catch (Exception e) {
 return null;
 }
 } 
 */

@end
