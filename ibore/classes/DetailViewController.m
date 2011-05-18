    //
//  DetailViewController.m
//  iBore
//
//  Created by peppe on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "ListViewController.h"
#import "iBoreAppDelegate.h"
#import "JSON/JSON.h"
#import "TypeStructure.h"


@interface DetailViewController()

// Layout the Ad Banner and Content View to match the current orientation.
// The ADBannerView always animates its changes, so generally you should
// pass YES for animated, but it makes sense to pass NO in certain circumstances
// such as inside of -viewDidLoad.
//-(void)layoutForCurrentOrientation:(BOOL)animated;

// A simple method that creates an ADBannerView
// Useful if you need to create the banner view in code
// such as when designing a universal binary for iPad
//-(void)createADBannerView;

@end


@implementation DetailViewController

@synthesize sottoTipiView, dettaglioView, subTypes, instance_id, model, titleBar, titleIcon, titleLabel, titleIconP, titleLabelP, sfondo;
@synthesize username, password, changeButton, logged, scrollView, imagesArray, descrizioniArray, likeButton;
@synthesize banner;
@synthesize members_count;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	/*se sono loggato aggiungo un pulsante alla navigationBar
	if (logged){
    
		UIBarButtonItem *dx = [[UIBarButtonItem alloc] initWithTitle:@"My Profile"
                                                           style:UIBarButtonItemStyleBordered
                                                          target:self
                                                          action:nil];
    
		self.navigationItem.rightBarButtonItem = dx;	
	}
	*/
    
    //prova sfondo
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
    sfondo.frame = self.view.bounds;
	[imageView setImage:[UIImage imageNamed:@"bg_vertical.png"]];
	[self.view addSubview:sfondo];		
	
	titleIcon.image = titleIconP;
	titleLabel.text = titleLabelP;
	
	[dettaglioView setDelegate:self];
	[dettaglioView setBackgroundColor:[UIColor clearColor]];
	[dettaglioView setOpaque:NO];	
    
    [self loadDetailView:instance_id];
    
    //Elimino lo scroll della webView
	for ( id subView in dettaglioView.subviews ){
		
		if ( [[subView class] isSubclassOfClass:[UIScrollView class]] ){
			((UIScrollView *)subView).bounces = NO;
			
		}
	}
    /*
    if(banner == nil)
    {
        [self createADBannerView];
    }
    [self layoutForCurrentOrientation:NO];
    */
    [super viewDidLoad];
    

}

-(void)loadDetailView:(NSString *)root {
	NSLog(@"loadDetailView con root: %@", root);		
	
	NSDictionary *j = (NSDictionary *)[model ws2:root];
	NSLog(@"ws2:\n%@", j);
	
	NSString *force_object = [[[NSString alloc] initWithFormat:@"%@", [j objectForKey:@"force_object"]] autorelease];
	
    NSMutableString *dettagli = [NSMutableString stringWithString:@""];
    
	if ( [force_object isEqualToString:@"1"] ){
	
		//JSONObject d=WS3 invocato con parametro id;
		NSDictionary *di = (NSDictionary *)[model ws3:root];
		NSLog(@"json: %@", di);
		
		/*Provo a caricare la struttura del tipo
		 //carico la struttura del tipo
		 TypeStructure ts = app.getStructureFromTypeId(jso.getInt("ID_OF_COMPOSITE_TYPE"));		 
		 
		TypeStructure *ts = [[TypeStructure alloc] init];
		TypeStructure *ttt = (TypeStructure *)[ts createFromFile:@"cdcd"];
		*/
		
	
		//visualizza dettagli dell'oggetto d nella parte superiore della finestra
		NSDictionary *elements = [di objectForKey:@"ELEMENTS"];        
	
		//NSMutableString *dettagli = [NSMutableString stringWithString:@""];
		
		//metodo ricorsivo, riempio la stringa 'dettagli' con i dettagli dell'oggetto
		[model getValue:elements str:dettagli];
		
        if (logged){
            BOOL follow = [[di objectForKey:@"following"] boolValue];
	
            if (!follow ){ 
			//follow = 0 -> icona con x
			NSLog(@"indifferente");
			[likeButton setImage:[UIImage imageNamed:@"likeit"] forState:UIControlStateNormal];
			likeButton.tag = 0;
		
            }
		
            else{
			
                NSLog(@"mi piace");
			[likeButton setImage:[UIImage imageNamed:@"unlikeit"] forState:UIControlStateNormal];
			likeButton.tag = 1;
          }
		}
        else 
            [likeButton removeFromSuperview];
		 
		//inserisco nella webView la stringa dettagli
        [sottoTipiView setHidden:YES];
		//[dettaglioView loadHTMLString:dettagli baseURL:nil];
		
	}
	
	else {
		[dettaglioView removeFromSuperview];
		dettaglioView = nil;
		[titleBar removeFromSuperview];
		
	
        //prova sfondo
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
        [imageView setImage:[UIImage imageNamed:@"bg_vertical.png"]];
        [self.view addSubview:imageView];	
        [self.view addSubview:sottoTipiView];
		sottoTipiView.frame = CGRectMake(0, 42, 320, 460);
	

	}


	imagesArray = [[NSMutableArray alloc] init];
	descrizioniArray = [[NSMutableArray alloc] init];
	
	subTypes = [[NSMutableArray alloc] init];
	//NSLog(@"Ecco i sottotipi:\n%@", [j objectForKey:@"subtypes"]);
	
	for ( NSDictionary *s in [j objectForKey:@"subtypes"] ) {
		
		if ([s isKindOfClass:[NSDictionary class]]){
		}
		else {
		    /*
			 entro in quest'else quando sono loggato come amministratore
			 il campo subtypes da array diventa un insieme di oggetti json..
			*/
			s = [[j objectForKey:@"subtypes"] objectForKey:s];
		}
		
			UIImage *img = [model getIcona:[s objectForKey:@"composite_name"]];
	
			NSString *t = nil;
	
			if ([[s objectForKey:@"composite_plural_name"] isEqualToString:@"Structure Nodes"])
		
				t = [s objectForKey:@"label"];
	
			else
		
				t = [s objectForKey:@"composite_plural_name"];
		
		
			if ( img != nil )
		
				[imagesArray addObject:img];
		

			if ( t != nil ){
	
				[descrizioniArray addObject:t];
	
			}
		
		 if ( s!=nil )
				[subTypes addObject:s];
	
	}
    
    //funzione members
    Boolean isCommunity = [[j objectForKey:@"is_community"] boolValue];
    
    self.members_count = [[j objectForKey:@"members_count"] intValue];
    
    if (isCommunity & (members_count > 0)){
        NSLog(@"visualizzo l'icona mc");
        [imagesArray addObject:[model getIcona:@"Main Group"]];
        [descrizioniArray addObject:@"Members"];
    }
   
	
    
	//se root==null aggiungo l'icona di login
	if (root == nil){
		UIImage *log = nil;
		NSString *logS = nil;
		
		if (!logged){
			log = [model getIcona:@"login"];
			logS = @"Sign Up";
		}
		else {
			log = [model getIcona:@"logout"];
		    logS = @"Logout";
		}
		
		[imagesArray addObject:log];
		[descrizioniArray addObject:logS];
	}
	
	
	if ([imagesArray count] > 0){
	
        if (dettaglioView != nil)
            [dettaglioView loadHTMLString:dettagli baseURL:nil];
        
            [self addIcone:imagesArray conDescrizione:descrizioniArray];
            //[self webViewDidFinishLoad:dettaglioView];
            //[sottoTipiView setHidden:NO];
    }
	//rimuovo la griglia 
	else {

        sottoTipiView = nil;
		[sottoTipiView removeFromSuperview];
        [dettaglioView loadHTMLString:dettagli baseURL:nil];
	
	}

}

//aggiunge le icone alla griglia
-(void)addIcone:(NSMutableArray *)icone conDescrizione:(NSMutableArray *)descrizioni {
	if (dettaglioView != nil){
		[sottoTipiView setHidden:YES];
	}
	
	
	int row = 0;
	int column = 0;
	
	for(int i = 0; i <icone.count; ++i) {
		
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	//button.frame = CGRectMake(column*100+24, row*80+10, 75, 75); //64

	button.frame = CGRectMake(column*75+10, row*89+10, 75, 75);
		
    [button setImage:[icone objectAtIndex:i] forState:UIControlStateNormal];
   	
	[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
		
	//aggiungo il tag
	button.tag = i;
	[sottoTipiView addSubview:button];
	
	//label con icone da 75	px
	//UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(column*75+8, row*90+77, 75, 23)];
	
	//label con icone da 60 px
	UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(column*75+8, row*90+72, 75, 23)];
		
    l.text = [descrizioni objectAtIndex:i];
		NSLog(@"label: %@", l.text);
	l.font = [UIFont boldSystemFontOfSize:11];
		[l setBackgroundColor:nil];
		[l setTextColor:[UIColor blackColor]];
		[l 	setTextAlignment:UITextAlignmentCenter];	
		[l setOpaque:NO];
		 
    [sottoTipiView addSubview:l];
        [l release];
        
	if (column == 3) {
		column = 0;
		row++;
	} else {
		column++;
	
	}	
	
	}

	
}

//invocato quando si tappa su un'icona
-(IBAction)buttonClicked:(id)sender{
	
	UIButton *button = (UIButton *)sender;
	
	if (button.tag > [subTypes count]){

		//Se entro in quest'if -> si è tappato su login o logout
		if (logged ){
			
			UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"You are no more logged!"
															message:nil
														   delegate:nil 
												  cancelButtonTitle:nil
												  otherButtonTitles:nil];	
			[popup show];
			
			//Elimino il cookie -> così non sarà più inserito all'interno delle richieste http
			model.cookie = nil;			
			
			//Provo a ricaricare il menu
			[popup dismissWithClickedButtonIndex:0 animated:YES];	
			[popup release];
            
			DetailViewController *d= [[DetailViewController alloc] init];
			d.model = model;
			d.logged = NO;
			d.title = @"iBorè";
			d.instance_id = nil;
			
            d.banner = self.banner;
            
			iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate.navigationController setViewControllers:[NSArray arrayWithObject:d]];	
			
            [d release];
		}
		else {
			changeButton = button;
			[self visualizzaPopupLogin];
		}
	}
    
    else if (button.tag == [subTypes count]){
        //carico la lista dei membri
           
		ListViewController *list = [[ListViewController alloc] initWithStyle:UITableViewStyleGrouped];
		list.model = model;
		
        list.title = @"Members";
		list.isCommunity = YES;
		list.r = instance_id;
		list.logged = self.logged;
        
        //parametri paginazione
        NSInteger tot_items = self.members_count;
        NSInteger quoz = tot_items / 20;
        if ( (20 * quoz) <= tot_items){
            list.tot_page = quoz+1;
        }
        else {
            list.tot_page = quoz;
        }
        
        list.current_page = 1;

		iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.navigationController pushViewController:list animated:YES];		
		
        [list release];

    }
	
	else {
	
	
	NSDictionary *json_object = (NSDictionary *)[subTypes objectAtIndex:button.tag];

	NSLog(@"%@", [json_object objectForKey:@"direct_link"]);
	
	
	NSString *direct_link = [[NSString alloc] initWithFormat:@"%@", [json_object objectForKey:@"direct_link"]];
	
	
	if ( [direct_link isEqualToString:@"1"] ) {
		
		DetailViewController *det= [[DetailViewController alloc] init];
		det.model = model;
		det.logged = self.logged;
		
		NSLog(@"direct link= 1, carico il dettaglio");
	
		NSLog(@"%@", [json_object objectForKey:@"instance_id"]);
		
		
		//det.title = [json_object objectForKey:@"composite_plural_name"];
		det.instance_id = [json_object objectForKey:@"instance_id"];
	
		if ([[json_object objectForKey:@"composite_plural_name"] isEqualToString:@"Structure Nodes"])
			det.titleLabelP = [json_object objectForKey:@"label"];
		else
			det.titleLabelP = [json_object objectForKey:@"composite_plural_name"];
		
		//det.titleLabelP = [json_object objectForKey:@"composite_name"];
		det.titleIconP = [model getIcona:[json_object objectForKey:@"composite_name"]];

		[direct_link release];
        det.banner = self.banner;
        
		iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.navigationController pushViewController:det animated:YES];	
		[det release];
        
	
	}
	
	
	else {
		//carico la list di oggetti
		NSLog(@"direct link=0, carico la lista di oggetti");
		[direct_link release];
        
		ListViewController *list = [[ListViewController alloc] initWithStyle:UITableViewStyleGrouped];
		list.model = model;
		
		if ([[json_object objectForKey:@"composite_plural_name"] isEqualToString:@"Structure Nodes"])
			list.title = [json_object objectForKey:@"label"];
		else
			list.title = [json_object objectForKey:@"composite_plural_name"];
		
		list.idt = [json_object objectForKey:@"composite_type"];
		list.r = instance_id;
		list.logged = self.logged;
        
        //parametri paginazione
        NSInteger tot_items = [model ws4:list.idt root:list.r];
        NSInteger quoz = tot_items / 20;
        if ( (20 * quoz) <= tot_items){
            list.tot_page = quoz+1;
        }
        else {
            list.tot_page = quoz;
        }
        
        list.current_page = 1;
        
		NSLog(@"Tot page:\n%d", list.tot_page);
        
        
		NSLog(@"idt: %@ root: %@", [json_object objectForKey:@"composite_type"], instance_id);
		iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.navigationController pushViewController:list animated:YES];		
		
        [list release];
		
	}

	}
}

-(IBAction)buttonLike:(id)sender{
    
	//UIButton *button = (UIButton *)sender;
  
    
	if (likeButton.tag == 0) {
		//cambio l'immagine con unlikeit
        [likeButton setImage:[UIImage imageNamed:@"unlikeit"] forState:UIControlStateNormal];
        likeButton.tag = 1;
        
		//se sono loggato, effettuo la chiamata al webservices
		if (logged)
			[model follow:self.instance_id value:YES];
		
		UIAlertView *iniz = [[UIAlertView alloc] initWithTitle:@"You like it"
										  message:nil
										 delegate:self 
								cancelButtonTitle:nil
								otherButtonTitles:nil];
		
		[iniz show];
		[iniz dismissWithClickedButtonIndex:0 animated:YES];
		[iniz release];
		
		
	}
	else {
	
        [likeButton setImage:[UIImage imageNamed:@"likeit"] forState:UIControlStateNormal];
        likeButton.tag = 0;
		
		//se sono loggato, effettuo la chiamata al webservices
		if (logged)
			[model follow:self.instance_id value:NO];
		
		UIAlertView *iniz = [[UIAlertView alloc] initWithTitle:@"You don't like it"
													   message:nil
													  delegate:self 
											 cancelButtonTitle:nil
											 otherButtonTitles:nil];
		
		[iniz show];
		[iniz dismissWithClickedButtonIndex:0 animated:YES];
		[iniz release];
	}
    
}

-(void)visualizzaPopupLogin{
	
	// Ask for Username and password.
	UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"iBorè Login" message:@"\n \n \n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	
	// Adds a username Field
	username = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; 
	username.placeholder = @"Username";
	[username setBackgroundColor:[UIColor whiteColor]]; [alertview addSubview:username];
	
	// Adds a password Field
	password = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 25.0)]; 
	password.placeholder = @"Password";
	[password setSecureTextEntry:YES];
	[password setBackgroundColor:[UIColor whiteColor]]; [alertview addSubview:password];
	
	// Move a little to show up the keyboard
	//CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0, 0.0);
	//[alertview setTransform:transform];
	
	// Show alert on screen.
	[alertview show];
	[alertview release];
	
	//...
	
	// Don't forget to release these after getting their values
	[username release];
	[password release];	
}

-(void)login{
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	
	if ([model doLogin:username.text password:password.text]){
		//[changeButton setImage:[model getIcona:@"logout"] forState:UIControlStateNormal];	
		NSLog(@"loggato");
		//self.logged = YES;

		
		UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"You are logged in successfully!"
														message:nil
													   delegate:nil 
											  cancelButtonTitle:nil
											  otherButtonTitles:nil];	
		[popup show];
		[popup dismissWithClickedButtonIndex:0 animated:YES];
		[popup release];
		[self performSelectorOnMainThread:@selector(ricaricaMenu) withObject:nil waitUntilDone:NO];
	}	
	
	//[pool release];
	
}

-(void)ricaricaMenu{
    
	DetailViewController *d= [[DetailViewController alloc] init];
	d.model = model;
	d.logged = YES;
	
	//da verificare se ogni username ha il formato 'nome.cognome'
	NSArray *values = [username.text componentsSeparatedByString:@"."];	
	d.title = [NSString stringWithFormat:@"iBorè, %@ %@", [[values objectAtIndex:0] capitalizedString], [[values objectAtIndex:1] capitalizedString]];
	d.instance_id = nil;
	
    d.banner = self.banner;
    
	iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationController setViewControllers:[NSArray arrayWithObject:d]];
    [d release];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// Clicked the Submit button
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		if (changeButton != nil && !logged && (username.text != nil || password.text != nil)){
			//[self performSelectorInBackground:@selector(login) withObject:nil];	
			[self performSelectorOnMainThread:@selector(login) 
								   withObject:nil 
								waitUntilDone:YES];
		}
	
	}
}


//Delegato di uiwebView -> viene invocato dopo che la webView è stata 'popolata'
-(void)webViewDidFinishLoad:(UIWebView *)webView{
	
	CGSize fittedSize = [webView sizeThatFits:CGSizeZero];
	webView.frame = CGRectMake(0, 63, 320, fittedSize.height);
	

	CGSize gridSize = [sottoTipiView sizeThatFits:CGSizeZero];
	sottoTipiView.frame = CGRectMake(0, fittedSize.height+55, 320, gridSize.height+50);
	
	
	// Rendo la webView scrollabile
	CGRect bounds = [[UIScreen mainScreen] applicationFrame];
	
	scrollView = [[UIScrollView alloc] initWithFrame:bounds];
	scrollView.contentSize = CGSizeMake(320, (fittedSize.height + sottoTipiView.frame.size.height + 150));
	scrollView.backgroundColor = [UIColor clearColor];
	
	//prova sfondo
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
	[imageView setImage:[UIImage imageNamed:@"bg_vertical.png"]];
	[self.view addSubview:imageView];		
	
	[self.view addSubview:scrollView];
	[scrollView addSubview:dettaglioView];
    
    if (sottoTipiView != nil)
        [scrollView addSubview:sottoTipiView];

	[self.view addSubview:titleBar];

    [sottoTipiView setHidden:NO];
    [self.view addSubview:banner];
    [self.view bringSubviewToFront:banner];
    
    // and make sure it's positioned onscreen.
    //banner.frame = CGRectMake(0.0, 0.0, banner.frame.size.width, banner.frame.size.height);
 
}


 - (void)viewWillAppear:(BOOL)animated {
	 
 [super viewWillAppear:animated];
     // [self layoutForCurrentOrientation:NO];
	
 }
 
 - (void)viewDidAppear:(BOOL)animated {
     
 [super viewDidAppear:animated];
     
}
 

 - (void)viewWillDisappear:(BOOL)animated {
	 
 [super viewWillDisappear:animated];
 }
 

 - (void)viewDidDisappear:(BOOL)animated {
	 
 [super viewDidDisappear:animated];
     
 }

//iad
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   // [self layoutForCurrentOrientation:YES];
}
/*
-(void)createADBannerView
{
    // --- WARNING ---
    // If you are planning on creating banner views at runtime in order to support iOS targets that don't support the iAd framework
    // then you will need to modify this method to do runtime checks for the symbols provided by the iAd framework
    // and you will need to weaklink iAd.framework in your project's target settings.
    // See the iPad Programming Guide, Creating a Universal Application for more information.
    // http://developer.apple.com/iphone/library/documentation/general/conceptual/iPadProgrammingGuide/Introduction/Introduction.html
    // --- WARNING ---
    
    // Depending on our orientation when this method is called, we set our initial content size.
    // If you only support portrait or landscape orientations, then you can remove this check and
    // select either ADBannerContentSizeIdentifierPortrait (if portrait only) or ADBannerContentSizeIdentifierLandscape (if landscape only).
	NSString *contentSize;
	if (&ADBannerContentSizeIdentifierPortrait != nil)
	{
		contentSize = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierLandscape;
	}
	else
	{
		// user the older sizes 
		contentSize = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierLandscape;
    }
	
    // Calculate the intial location for the banner.
    // We want this banner to be at the bottom of the view controller, but placed
    // offscreen to ensure that the user won't see the banner until its ready.
    // We'll be informed when we have an ad to show because -bannerViewDidLoadAd: will be called.
    CGRect frame;
    frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSize];
    frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.view.bounds));
    
    // Now to create and configure the banner view
    ADBannerView *bannerView = [[ADBannerView alloc] initWithFrame:frame];
    // Set the delegate to self, so that we are notified of ad responses.
    bannerView.delegate = self;
    // Set the autoresizing mask so that the banner is pinned to the bottom
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    // Since we support all orientations in this view controller, support portrait and landscape content sizes.
    // If you only supported landscape or portrait, you could remove the other from this set.
    
	bannerView.requiredContentSizeIdentifiers = (&ADBannerContentSizeIdentifierPortrait != nil) ?
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil] : 
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    
    // At this point the ad banner is now be visible and looking for an ad.
    [self.view addSubview:bannerView];
    self.banner = bannerView;
    [bannerView release];
}
*/
-(void)layoutForCurrentOrientation:(BOOL)animated
{
    CGFloat animationDuration = animated ? 0.2f : 0.0f;
    // by default content consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = 0.0f;
    
    // First, setup the banner's content size and adjustment based on the current orientation
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		banner.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierLandscape != nil) ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifierLandscape;
    else
        banner.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierPortrait != nil) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierPortrait; 
    bannerHeight = banner.bounds.size.height; 
	
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    if(banner.bannerLoaded)
    {
        contentFrame.size.height -= bannerHeight;
		bannerOrigin.y -= bannerHeight;
    }
    else
    {
		bannerOrigin.y += bannerHeight;
    }
    
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         //self.view.frame = contentFrame;
                         [self.view layoutIfNeeded];
                         banner.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y, banner.frame.size.width, banner.frame.size.height);
                     }];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    self.sottoTipiView = nil;
    banner.delegate = nil;
    self.banner = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [sottoTipiView release]; sottoTipiView = nil;
    banner.delegate = nil;
    [banner release]; banner = nil;
    [super dealloc];
}

#pragma mark ADBannerViewDelegate methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutForCurrentOrientation:YES];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutForCurrentOrientation:YES];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}


@end
