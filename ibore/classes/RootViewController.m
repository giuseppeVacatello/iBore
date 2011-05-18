//
//  RootViewController.m
//  iBore
//
//  Created by peppe on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "iBoreAppDelegate.h"

@implementation RootViewController

@synthesize model, iniz;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
	model = [[iBoreModel alloc] init];
	model.cookie = nil;
	self.title = @"iBorè";
	
	
	//AVVIO
	NSString *versioneLocale = [model versioneLocale];
	NSString *versioneRemota = [model ws1];
	
	if ( versioneLocale == nil ){
		//popup inizializzazione in corso
		
		UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		act.frame = CGRectMake(121.0f, 50.0f, 37.0f, 37.0f);
		[act startAnimating];
		
		
		iniz = [[UIAlertView alloc] initWithTitle:@"Inizializzazione in corso..."
													   message:nil
													  delegate:self 
											 cancelButtonTitle:nil
											 otherButtonTitles:nil];
		[iniz addSubview:act];
		[act release];
		[iniz show];
		
		//cancello le icone locali e salvo la versione corrente in locale
		NSLog(@"Versione locale == null, INIZIALIZZAZIONE...");
		[model salvaVersioneCorrente:versioneRemota];
		
	}
	else if ( ![versioneLocale isEqualToString:versioneRemota] ){
		//popup aggiornamento in corso
		UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		act.frame = CGRectMake(121.0f, 50.0f, 37.0f, 37.0f);
		[act startAnimating];		
		
		iniz = [[UIAlertView alloc] initWithTitle:@"Aggiornamento in corso..."
													   message:nil
													  delegate:self 
											 cancelButtonTitle:nil
											 otherButtonTitles:nil];
		[iniz addSubview:act];
		[act release];
		[iniz show];
	
		//cancello le icone locali e salvo la versione corrente in locale
		NSLog(@"Versione locale != versioneRemota, aggiornamento...loc:%@, rem:%@", versioneLocale, versioneRemota);
		[model salvaVersioneCorrente:versioneRemota];
	}
	else if ( [versioneLocale isEqualToString:versioneRemota] ){
		NSLog(@"Versione locale == versioneRemota");
		[self visualizzazioneMenu];
		
	}		
	
	
	/*
	iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationController pushViewController:d animated:YES];		
	
	*/
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

-(void)visualizzazioneMenu{
	
	DetailViewController *d = [[DetailViewController alloc] init];
	d.model = model;
	d.instance_id = nil;
	d.logged = NO;
	d.title = @"iBorè";
	//self.view = d.view;
	
	iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationController setViewControllers:[NSArray arrayWithObject:d]];	
	[d release];
}
/*
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
	NSLog(@"Ho premuto ok");
	if ( buttonIndex == 0 ){
		[self visualizzazioneMenu];
	}
}
*/
-(void)didPresentAlertView:(UIAlertView *)alert{
	[self visualizzazioneMenu];
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[iniz dismissWithClickedButtonIndex:0 animated:YES];
	/*
	iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationController pushViewController:d animated:YES];	
*/
	
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {

	
	[super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[iniz release];
    [super dealloc];
}


@end

