//
//  AttributeStructure.h
//  iBore
//
//  Created by Peppe on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TEXT @"text"
#define STRING @"string"
#define MEDIA @"media"
#define INT @"int"
#define DOUBLE @"double"
#define ENUM @"enum"
#define DATE @"date"
#define DATETIME @"datetime"
#define ATTACHMENT @"attachment"
#define BOOLEAN @"boolean"
#define RAWTEXT @"rawtext"

@interface AttributeStructure : NSObject {
	
	NSNumber *idN;
	NSString *name;
	NSString *basicTypeName;
	NSNumber *visualizationOrder;
	bool title;
	bool hidden;
	bool showLabel;

}

@property (nonatomic, retain) NSNumber *idN;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *basicTypeName;
@property (nonatomic, retain) NSNumber *visualizationOrder;
@property (nonatomic) bool title;
@property (nonatomic) bool hidden;
@property (nonatomic) bool showLabel;

- (id)initWithName:(NSString *)n JSONObject:(NSDictionary *)j;
- (bool)getShowLabel;
@end
