//
//  ListViewController.m
//  iBore
//
//  Created by peppe on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "JSON/JSON.h"
#import "iBoreAppDelegate.h"
#import "DetailViewController.h"
#import "UIImageExtras.h"

@implementation ListViewController

@synthesize idt, r;
@synthesize listObjects;
@synthesize model;
@synthesize logged;
@synthesize tot_page;
@synthesize current_page;
@synthesize isCommunity;
@synthesize avatars;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
    avatars = [[NSMutableArray alloc] init];
 
    
	//Aggiungo l'immagine di sfonfo
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
	[imageView setImage:[UIImage imageNamed:@"bg_vertical.png"]];
	[self.tableView setBackgroundView:imageView];
	
	[self loadListView:idt root:r];
		
    [super viewDidLoad];

}

-(void)loadListView:(NSString *)id root:(NSString *)root{
    
    NSArray *lo;
    
    if (self.isCommunity){
        lo = (NSArray *)[model membersList:root page:self.current_page];
    }
    
    else {
        lo = (NSArray *)[model ws5:id root:root page:self.current_page];
    }
	
	self.listObjects = [[NSMutableArray alloc] init];
	[self.listObjects addObjectsFromArray:lo];
    
    
    //paginazione
    if ((self.tot_page - current_page) != 0){
        
        UIBarButtonItem *load = [[UIBarButtonItem alloc] initWithTitle:@"Load More"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(loadMore)];
        
        
        self.navigationItem.rightBarButtonItem = load;
    }
    
}

-(void)loadMore{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ListViewController *list = [[ListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    list.model = model;
    list.idt = self.idt;
    list.r = self.r;
    list.logged = self.logged;
    list.tot_page = self.tot_page;
    list.current_page = self.current_page + 1;
    list.title = [NSString stringWithFormat:@"%d/%d", list.current_page, list.tot_page];
    
    iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navigationController pushViewController:list animated:YES];		
    
    [list release];
    [pool release];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
		
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait  ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
    // Return the number of rows in the section.
	return [listObjects count];
	
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60;
}
*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier] autorelease];
    }
    	
    // Configure the cell...
	NSInteger row = [indexPath row];
 
    if (self.isCommunity){
        cell.textLabel.text = [[[listObjects objectAtIndex:row] objectForKey:@"preview_value"] capitalizedString];
        
        //carico l'avatar dall'array locale se è presente
        if ([avatars count]>row){
            cell.imageView.image = [avatars objectAtIndex:row];
        }
        
        //altrimenti lo scarico e lo salvo nell'array
        else {
            
        NSString *avatarValue = [[listObjects objectAtIndex:row] objectForKey:@"avatar_value"];
        NSArray *values = [avatarValue componentsSeparatedByString:@"|"];
	    NSMutableArray *v = [NSMutableArray arrayWithArray:values];
        NSRange match;
 		
		for (NSMutableString *va in v){
			NSMutableString *diskname = [NSMutableString stringWithString:va];
            
			match = [diskname rangeOfString:@"diskname="];
			if ( match.location != NSNotFound ){
				[diskname replaceCharactersInRange:match withString:@""];
                 
                UIImage *av = [self scale:[model getAvatar:diskname] toSize:CGSizeMake(40, 50)];
                cell.imageView.image = av;
                [avatars addObject:av];

			}
         
			/*
			match = [val rangeOfString:@"mime="];
			if ( match.location != NSNotFound ){
				
				[val replaceCharactersInRange:match withString:@""];
				
				match = [val rangeOfString:@"image"];
				if ( match.location != NSNotFound ){
					image = TRUE;
				}
			}	
             */
		}
        }//else

    }
    
    else {
        
	cell.textLabel.text = [[model flattenHtml:[[listObjects objectAtIndex:row] objectForKey:@"composite_instance_preview"]] capitalizedString];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15]];	
    }
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.backgroundColor = [UIColor clearColor];
	
    return cell;
}

-(UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)visualizzaPopup{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	act.frame = CGRectMake(121.0f, 50.0f, 37.0f, 37.0f);
	[act startAnimating];		
	
	UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Downloading..."
									  message:nil
									 delegate:nil 
							cancelButtonTitle:nil
							otherButtonTitles:nil];
	[popup addSubview:act];
	[act release];
	[popup show];	
	
	[popup dismissWithClickedButtonIndex:0 animated:YES];
    [popup release];
	[pool release];
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
	
	[self performSelectorInBackground:@selector(visualizzaPopup) withObject:nil];	
	

	DetailViewController *obj= [[DetailViewController alloc] init];
	NSLog(@"tap su un oggetto della lista");
	
	NSInteger row = [indexPath row];
	
	NSLog(@"%@", listObjects);
	
	NSDictionary *dict = (NSDictionary *)[listObjects objectAtIndex:row];
	
	NSLog(@"Oggetto json:\n%@", dict);
	
    if (self.isCommunity){
        
        obj.titleLabelP = [[listObjects objectAtIndex:row] objectForKey:@"title_value"];
        obj.instance_id = [[listObjects objectAtIndex:row] objectForKey:@"id_composite_user"];
        obj.model = model;
        obj.logged = logged;
        obj.titleIconP = [model getIcona:@"Main Group"];
    
    }
    
    else{
    
	UIImage *icon = (UIImage *)[model getIcona:[dict objectForKey:@"composite_name"]];
    obj.instance_id = [[listObjects objectAtIndex:row]  objectForKey:@"composite_instance"];	
	obj.model = model;
	obj.titleIconP = icon;
	obj.logged = self.logged;
	
	if ( [[dict objectForKey:@"composite_name"] isEqualToString:@"Comment"])
		obj.titleLabelP = [[dict objectForKey:@"creation_user_complete_name"] capitalizedString];
	else 
		obj.titleLabelP = [[[listObjects objectAtIndex:row] objectForKey:@"composite_instance_title"] capitalizedString];
	}	
        
	iBoreAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationController pushViewController:obj animated:YES];
    
    [obj release];

	 
}


/*
-(UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
	
	return UITableViewCellAccessoryDetailDisclosureButton;
}
*/
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[idt release];
	[r release];
	[listObjects release];
    [avatars release];
    [super dealloc];
}


@end

