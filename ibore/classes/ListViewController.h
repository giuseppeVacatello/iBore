//
//  ListViewController.h
//  iBore
//
//  Created by peppe on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBoreModel.h"

@interface ListViewController : UITableViewController {
	
	iBoreModel *model;

	NSString *idt;
	NSString *r;
	
	NSMutableArray *listObjects;
	
	bool logged;
    
    NSInteger tot_page;
    NSInteger current_page;
    
    Boolean isCommunity;
    
    NSMutableArray *avatars;

}

@property (nonatomic, retain) iBoreModel *model;
@property (nonatomic, retain) NSString *idt;
@property (nonatomic, retain) NSString *r;
@property (nonatomic, retain) NSMutableArray *listObjects;
@property (nonatomic, assign) bool logged;
@property (nonatomic, assign) NSInteger tot_page;
@property (nonatomic, assign) NSInteger current_page;
@property (nonatomic, assign) Boolean isCommunity;
@property (nonatomic, retain) NSMutableArray *avatars;

-(void)loadListView:(NSString *)id root:(NSString *)root;
-(void)visualizzaPopup;
-(void)loadMore;
-(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

@end
