//
//  RootViewController.h
//  iBore
//
//  Created by peppe on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBoreModel.h"

@interface RootViewController : UIViewController {
	
	iBoreModel *model;
	UIAlertView *iniz;
}

@property (nonatomic, readonly) iBoreModel *model;
@property (nonatomic, retain) UIAlertView *iniz;

-(void)visualizzazioneMenu;

@end
