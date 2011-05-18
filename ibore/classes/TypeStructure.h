//
//  TypeStructure.h
//  iBore
//
//  Created by Peppe on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TypeStructure : NSObject {
	
	NSNumber *idN;
	NSString *name;
	NSMutableArray *attributes;

}

@property (nonatomic, retain) NSNumber *idN;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *attributes;

- (TypeStructure *)setJSONObjectAndInit:(NSDictionary *)j;
+ (TypeStructure *)createFromFile:(NSString *)fileName;

@end
