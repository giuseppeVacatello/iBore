//
//  DetailViewController.h
//  iBore
//
//  Created by peppe on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "iBoreModel.h"

#import <iAd/iAd.h>

@interface DetailViewController : UIViewController <UIWebViewDelegate> {
	
	iBoreModel *model;
	
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet UIScrollView *sottoTipiView;
	IBOutlet UIWebView *dettaglioView;
	
	IBOutlet UIImageView *sfondo;
	
	IBOutlet UIView *titleBar;
	IBOutlet UIImageView *titleIcon;
	IBOutlet UILabel *titleLabel;
	IBOutlet UIButton *likeButton;
    
	UIImage *titleIconP;
	NSString *titleLabelP;
	
	NSMutableArray *subTypes;
	NSMutableArray *imagesArray;
	NSMutableArray *descrizioniArray;

	NSString *instance_id;
	
	UITextField *username;
	UITextField *password;
	UIButton *changeButton;
	
	bool logged;
    
    //iAD
    ADBannerView *banner;
    
    int members_count;

}

@property (nonatomic, retain) iBoreModel *model;
@property (nonatomic, retain) UIScrollView *sottoTipiView;
@property (nonatomic, retain) UIWebView *dettaglioView;
@property (nonatomic, retain) NSMutableArray *subTypes;
@property (nonatomic, retain) NSString *instance_id;
@property (nonatomic, retain) UIView *titleBar;
@property (nonatomic, retain) UIImageView *titleIcon;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImage *titleIconP;
@property (nonatomic, retain) NSString *titleLabelP;
@property (nonatomic, retain) UIButton *likeButton;
@property (nonatomic, retain) UIImageView *sfondo;
@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UIButton *changeButton;
@property (nonatomic) bool logged;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *imagesArray;
@property (nonatomic, retain) NSMutableArray *descrizioniArray;

@property(nonatomic, retain) IBOutlet ADBannerView *banner;

@property (nonatomic, assign) int members_count;

-(void)loadDetailView:(NSString *)root;

-(void)addIcone:(NSArray *)icone conDescrizione:(NSArray *)descrizioni; //aggiunge le icone alla griglia

- (IBAction)buttonClicked:(id)sender;
-(IBAction)buttonLike:(id)sender;

-(void)ricaricaMenu;

-(void)visualizzaPopupLogin;
-(void)login;

@end
