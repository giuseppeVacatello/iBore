//
//  AttributeStructure.m
//  iBore
//
//  Created by Peppe on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttributeStructure.h"
#import "JSON/JSON.h"

@implementation AttributeStructure

@synthesize idN, name, basicTypeName, visualizationOrder, title, hidden, showLabel;

- (id)initWithName:(NSString *)strName JSONObject:(NSDictionary *)j {
	
    self = [super init];
	
    if (self) {
		
        /* class-specific initialization goes here */
		title = FALSE;
		hidden = FALSE;
		showLabel = TRUE;
		
		if ( [j objectForKey:@"ID_OF_FIELD"] != nil ){
			idN = [NSNumber numberWithInt:[[j objectForKey:@"ID_OF_FIELD"] intValue]];
		}
		
		self.name = [NSString stringWithString:strName];
			
		
		if ( [j objectForKey:@"BASIC_TYPE_NAME"] != nil ){
			basicTypeName = [j objectForKey:@"BASIC_TYPE_NAME"];
		}	
		
		if ( [j objectForKey:@"VISUALIZATION_ORDER"] != nil ){
			visualizationOrder = [NSNumber numberWithDouble:[[j objectForKey:@"VISUALIZATION_ORDER"] doubleValue]];
		}
		
		if ( [j objectForKey:@"PROPERTIES"] != nil ){
			NSDictionary *properties = [j objectForKey:@"PROPERTIES"];
			title = ([properties objectForKey:@"title"] != nil);
			hidden = ([properties objectForKey:@"hidden"] != nil);	
			showLabel = !([properties objectForKey:@"dont_show_label"] != nil);
		}		
		
    }
	
    return self;
	
}

-(bool)getShowLabel{
	return (showLabel && ![ATTACHMENT isEqualToString:basicTypeName] && ![MEDIA isEqualToString:basicTypeName]);
																		 
}


@end
