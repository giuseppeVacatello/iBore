//
//  iBoreModel.m
//  iBore
//
//  Created by peppe on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iBoreModel.h"
#import "JSON/JSON.h"

@implementation iBoreModel

@synthesize version, responseData, cookie;


-(NSString *)ws1{

	
	NSString *url = [[NSString alloc] initWithFormat:@"%@%@", BASEPATH, VERSION_URL];
	
	NSLog(@"ws1 %@", url);
	
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [url release];
	[request setHTTPShouldHandleCookies:NO];
	//Se 'cookie' è diverso da null -> sono loggato -> inserisco il cookie nella richiesta http
	//if (cookie != nil)
		[request addValue:cookie forHTTPHeaderField:@"Cookie"];	
			
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil
														 error:nil];
	
	NSString *json_string = [[NSString alloc] initWithData:response
												  encoding:NSUTF8StringEncoding];
	
	NSDictionary *dictionary = [parser objectWithString:json_string error:nil];
	
	[parser release];
	[json_string release];
	NSLog(@"Vers remota: %@", [dictionary objectForKey:@"v"]);
	return [dictionary objectForKey:@"v"];
}


-(NSString *)versioneLocale{
	self.cookie = nil;
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentDirectory = [paths objectAtIndex:0];
	
	
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"version.dat"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];

	NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSDictionary *vL = [parser objectWithString:json_string error:nil];
	
    [json_string release];
    [parser release];
    
	if ( vL == nil )
		return nil;
	NSLog(@"Vers locale: %@", [vL objectForKey:@"v"]);
	return [vL objectForKey:@"v"];
	
}

-(void)salvaVersioneCorrente:(NSString *)versione{
	
	NSString *url = [[NSString alloc] initWithFormat:@"%@%@", BASEPATH, VERSION_URL];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil
														 error:nil];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentDirectory = [paths objectAtIndex:0];
	
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"version.dat"];
	
							 
	[response writeToFile:filePath atomically:YES];
	
	[url release];
	
	
}

-(NSDictionary *)ws2:(NSString *)r{
	
	NSString *url;
	
	if (r == nil )
		
		url = [[NSString alloc] initWithFormat:@"%@%@", BASEPATH, ROOT_TYPES_PATH];
	else 
		
		url = [[NSString alloc] initWithFormat:@"%@%@%@", BASEPATH, SUB_TYPES_PATH, r];	
	
	
	
	NSLog(@"%@", url);
	
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [url release];
	[request setHTTPShouldHandleCookies:NO];
	//Se 'cookie' è diverso da null -> sono loggato -> inserisco il cookie nella richiesta http
	//if (cookie != nil)
		[request addValue:cookie forHTTPHeaderField:@"Cookie"];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil
														 error:nil];

	NSString *json_string = [[NSString alloc] initWithData:response
												  encoding:NSUTF8StringEncoding];

	NSDictionary *dictionary = [parser objectWithString:json_string error:nil];
	
	[parser release];
	//[request release];
	//[response release];
	[json_string release];
	//	[dictionary release];
	

	return dictionary;
}



-(NSDictionary *)ws3:(NSString *)r {
	
	NSLog(@"parametro ricevuto da ws3: %@", r);
	
	NSString *url = [[NSString alloc] initWithFormat:@"%@%@%@", BASEPATH, INSTANCE_DETAIL_URL, r];
	
	NSLog(@"ws3 %@", url);
	
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[url release];
	[request setHTTPShouldHandleCookies:NO];
	//Se 'cookie' è diverso da null -> sono loggato -> inserisco il cookie nella richiesta http
	//if (cookie != nil)
		[request addValue:cookie forHTTPHeaderField:@"Cookie"];
	
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil
														 error:nil];
	
	NSString *json_string = [[NSString alloc] initWithData:response
												  encoding:NSUTF8StringEncoding];
	
	NSDictionary *dictionary = [parser objectWithString:json_string error:nil];
	NSLog(@"%@", dictionary);
	
	[parser release];
	//[request release];
	//[response release];
	[json_string release];
	//	[dictionary release];
	
	return dictionary;
}

-(NSInteger)ws4:(NSString *)id root:(NSString *)root{
	NSLog(@"Sono in ws4");
	
	NSString *url;
	
	if (root == nil) {
		
		url = [[NSString alloc] initWithFormat:@"%@%@%@", BASEPATH, COUNT_ROOT_SUBTYPES_URL, id];
		
	}
	else {
		
		url = [[NSString alloc] initWithFormat:@"%@%@%@%@%@", BASEPATH, COUNT_NODE_SUBTYPES_URL, id, COUNT_NODE_SUBTYPES_URL_root, root];		
	}
	
	
	NSLog(@"%@", url);
	
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [url release];
	[request setHTTPShouldHandleCookies:NO];
	//Se 'cookie' è diverso da null -> sono loggato -> inserisco il cookie nella richiesta http
	//if (cookie != nil)
		[request addValue:cookie forHTTPHeaderField:@"Cookie"];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request 
											 returningResponse:nil 
														 error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response
												  encoding:NSUTF8StringEncoding];
	
	NSMutableString *c = [NSMutableString stringWithString:json_string];
    [json_string release];
	NSRange match;
	match = [c rangeOfString:@"\""];
	
	if ( match.location != NSNotFound ){
		[c replaceCharactersInRange:match withString:@""];
	}
	match = [c rangeOfString:@"\""];
	
	if ( match.location != NSNotFound ){
		[c replaceCharactersInRange:match withString:@""];
	}		
	
	
	NSInteger i=[c intValue];
	
	return i;
	
}

-(NSArray *)ws5:(NSString *)id root:(NSString *)root page:(NSInteger)page{
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	
	NSString *url;
	
	if (root == nil) {
		
		url = [[NSString alloc] initWithFormat:@"%@%@%@%@%i%@%i", BASEPATH, LIST_ROOT_SUBTYPES_URL_idt, id, LIST_ROOT_SUBTYPES_URL_page, page, LIST_ROOT_SUBTYPES_URL_ipp, 20];
		
	}
	else {
		
		url = [[NSString alloc] initWithFormat:@"%@%@%@%@%i%@%i%@%@", BASEPATH, LIST_NODE_SUBTYPES_URL_idt, id, LIST_NODE_SUBTYPES_URL_page, page, LIST_NODE_SUBTYPES_URL_ipp, 20, LIST_NODE_SUBTYPES_URL_root, root];		
	}
	
	
	NSLog(@"%@", url);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [url release];
	[request setHTTPShouldHandleCookies:NO];
	//Se 'cookie' è diverso da null -> sono loggato -> inserisco il cookie nella richiesta http
	//if (cookie != nil)
		[request addValue:cookie forHTTPHeaderField:@"Cookie"];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request 
											 returningResponse:nil 
														 error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response
												  encoding:NSUTF8StringEncoding];
	
	
	NSArray *array = [parser objectWithString:json_string error:nil];
	[parser release];
    [json_string release];
    
	NSLog(@"%@", array);
	
	return array;
	
}

-(NSArray *)membersList:(NSString *)root page:(NSInteger)page{

    SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@", BASEPATH, MEMBER_LIST];
	
	NSRange match;
	match = [url rangeOfString:@"<ipp>"];
    if ( match.location != NSNotFound ){
		[url replaceCharactersInRange:match withString:@"20"];
	}
    
    match = [url rangeOfString:@"<page>"];
    if ( match.location != NSNotFound ){
		[url replaceCharactersInRange:match withString:[NSString stringWithFormat:@"%i", page]];
	}
    
	
	if (root == nil) {
		
        match = [url rangeOfString:@"&params[root]=<root>"];
        if ( match.location != NSNotFound ){
            [url replaceCharactersInRange:match withString:@""];
        }
		
	}
	else {
        match = [url rangeOfString:@"<root>"];
        if ( match.location != NSNotFound ){
            [url replaceCharactersInRange:match withString:root];
        }
    }
	
	
	NSLog(@"%@", url);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

	[request setHTTPShouldHandleCookies:NO];
	//Se 'cookie' è diverso da null -> sono loggato -> inserisco il cookie nella richiesta http
	//if (cookie != nil)
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request 
											 returningResponse:nil 
														 error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response
												  encoding:NSUTF8StringEncoding];
	
	
	NSArray *array = [parser objectWithString:json_string error:nil];
	[parser release];
    [json_string release];
    
	NSLog(@"%@", array);
	
	return array;
    
}



-(UIImage *)getIcona:(NSString *)nome_composite {


	NSMutableString *composite_name_OK = [NSMutableString stringWithString:[nome_composite lowercaseString]];
	NSRange match;
	match = [composite_name_OK rangeOfString:@"è"];
	
	if ( match.location != NSNotFound ){
		[composite_name_OK replaceCharactersInRange:match withString:@"e"];
	}
	//se nome_composite presenta una '/' la elimino (per esempio tesi/stage.png)
	match = [composite_name_OK rangeOfString:@"/"];
	if ( match.location != NSNotFound )
		[composite_name_OK replaceCharactersInRange:match withString:@""];
	//se nome_composite presenta uno spazio lo elimino
	match = [composite_name_OK rangeOfString:@" "];
	if ( match.location != NSNotFound )
		[composite_name_OK replaceCharactersInRange:match withString:@""];
	
	
	//PROCEDURA PER CARICARE UN ICONA DALLA CACHE
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		
		NSString *documentDirectory = [paths objectAtIndex:0];
		
		
		NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", documentDirectory, composite_name_OK, @"-60.png"];
		
		
		NSData *icona = [NSData dataWithContentsOfFile:filePath];
	
	
		UIImage *img = [UIImage imageWithData:icona];
		
	if ( img != nil ){
		
		NSLog(@"Icona caricata dalla cache al seguente path: %@", filePath );		
		return img;
	}	
	
	
	//PROCEDURA PER SCARICARE L'ICONA DAL SERVER E SALVARLA IN LOCALE
	
	NSString *url = [NSString stringWithFormat:@"%@%@%@%@", BASEPATH, ICON_REMOTE_PATH, composite_name_OK, @"-60.png"];	
	
	url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

	
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil
														 error:nil];
	
	
	UIImage *image = [[[UIImage alloc] initWithData:response] autorelease];
	//salvo l'icona in locale
	[response writeToFile:filePath atomically:YES];

	//se image è nil la inizializzo con un'immagine provvisoria
	if ( image == nil )  image = [UIImage imageNamed:@"document-60"];		
	
	
	NSLog(@"Icona scaricata dal server al seguente url: %@", url);

    
	return image;	
		
}

-(UIImage *)getAvatar:(NSString *)diskname{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", BASEPATH, @"components/com_bore/pubmedia/", diskname];
	url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil
														 error:nil];
	
	
	UIImage *image = [[[UIImage alloc] initWithData:response] autorelease];
	//salvo l'icona in locale
	//[response writeToFile:filePath atomically:YES];
    
	//se image è nil la inizializzo con un'immagine provvisoria
	if ( image == nil )  image = [UIImage imageNamed:@"document-60"];		
     
	return image;    
}

- (NSString *)flattenHtml: (NSString *) html {
	NSScanner *theScanner;
	NSString *text = nil;
	
	theScanner = [NSScanner scannerWithString: html];
	
	while ([theScanner isAtEnd] == NO) {
		// find start of tag
		[theScanner scanUpToString: @"<" intoString: NULL];
		
		// find end of tag
		[theScanner scanUpToString: @">" intoString:&text];
		
		
		// replace the found tag with a space
		//(you can filter multi-spaces out later if you wish)
		html = [html stringByReplacingOccurrencesOfString:
				[NSString stringWithFormat: @"%@>", text]
											   withString: @" "];
	} // while //
	
	return html;
}

//Metodo ricorsivo per recuperare gli attributi dell'istanza di un oggetto
-(void)getValue:(NSDictionary *)elements str:(NSMutableString *)message{
	
	for (NSString *elem in elements){
		
		if (![elem isEqualToString:@"title"]) //con questo if non aggiungo il campo title nel body
			
		if ([[elements objectForKey:elem] isKindOfClass:[NSArray class]]){
			
			if ( ![[[[elements objectForKey:elem] objectAtIndex:0] objectForKey:@"VALUE"] isEqualToString:@""] ){ //se value non è vuoto lo aggiungo 
				
				[self addDetail:[[elements objectForKey:elem] objectAtIndex:0]  str:message el:elem];
											
			}//if
		}
		
			else {
				
				for (NSString *subElem in [elements objectForKey:elem]){
			
					
				//	if ([[[elements objectForKey:elem] objectForKey:subElem] objectForKey:@"ELEMENTS"] != nil)
						 
					if ([[[[elements objectForKey:elem] objectForKey:subElem] objectForKey:@"ELEMENTS"] count] > 0)
						
						//chiamata ricorsiva
						[self getValue:[[[elements objectForKey:elem] objectForKey:subElem] objectForKey:@"ELEMENTS"] str:message];
					
					else {
						[self addDetail:[[elements objectForKey:elem] objectForKey:subElem] str:message el:elem];
					}

				}//for
				
			}//else
		
	}//for
	
}

/*
 jso: oggetto json
 message: stringa contentente i tag html da passare alla webview
 */
-(void) addDetail:(NSDictionary *)jso str:(NSMutableString *)message el:str{
	
	NSMutableString *elem = [NSMutableString stringWithString:[str capitalizedString]];
	
	NSString *BASIC_TYPE_NAME = [jso objectForKey:@"BASIC_TYPE_NAME"];
	
	if ([BASIC_TYPE_NAME isEqualToString:@"datetime"] || [BASIC_TYPE_NAME isEqualToString:@"date"]){
		//se la data è diversa da 00:00:00 la aggiungo, altrimenti non faccio nulla
		if ([self getDateTime:[jso objectForKey:@"VALUE"]] != nil)
			[message appendFormat:@"<strong>%@</strong>:<br>%@<br><br>", elem, [self getDateTime:[jso objectForKey:@"VALUE"]]];
	}
	
	else if ([BASIC_TYPE_NAME isEqualToString:@"string"]){
		
		if (![elem isEqualToString:@"Description"]){
			
			[message appendFormat:@"<strong>%@:</strong> %@<br>", elem, [jso objectForKey:@"VALUE"]];					  
		}
		else 
			
			[message appendFormat:@"%@<br>", [jso objectForKey:@"VALUE"]];	
	}//if
	
	else if ([BASIC_TYPE_NAME isEqualToString:@"text"]){
		
		if (![elem isEqualToString:@"Text"] && ![elem isEqualToString:@"Description"]){
			
			[message appendFormat:@"<strong>%@:</strong><br>%@", elem, [jso objectForKey:@"VALUE"]];					  
		}
		else 
			
			[message appendFormat:@"%@<br>", [jso objectForKey:@"VALUE"]];	
	}//if
	
	else if ([BASIC_TYPE_NAME isEqualToString:@"media"]) {
	
		BOOL image = FALSE;
		NSMutableString *fileName = nil;
		NSRange match;
		
		NSArray *values = [[jso objectForKey:@"VALUE"] componentsSeparatedByString:@"|"];
	    NSMutableArray *v = [NSMutableArray arrayWithArray:values];
 		
		for (NSMutableString *va in v){
			NSMutableString *val = [NSMutableString stringWithString:va];

			match = [val rangeOfString:@"diskname="];
			if ( match.location != NSNotFound ){
				[val replaceCharactersInRange:match withString:@""];
				fileName = val;
			}
			
			match = [val rangeOfString:@"mime="];
			if ( match.location != NSNotFound ){
				
				[val replaceCharactersInRange:match withString:@""];
				
				match = [val rangeOfString:@"image"];
				if ( match.location != NSNotFound ){
					image = TRUE;
				}
			}			
		}
		
		if (fileName != nil && image){
			NSString *imgSrcHtml = [NSString stringWithFormat:@"<img src=\"%@%@%@\" WIDTH=\"150\" HEIGHT=\"190\"/>", BASEPATH, @"components/com_bore/pubmedia/", fileName];
			[message appendFormat:@"<br>%@<br><br>", imgSrcHtml];
			NSLog(@"Media image with url: %@", imgSrcHtml);
		}
		

		
	}//if
	
	else if ([BASIC_TYPE_NAME isEqualToString:@"attachment"]) {
		NSRange match;
		
		NSMutableString *name = nil;
		NSMutableString *size = nil;
		
		NSArray *values = [[jso objectForKey:@"VALUE"] componentsSeparatedByString:@"|"];
	    NSMutableArray *v = [NSMutableArray arrayWithArray:values];
 		
		for (NSMutableString *va in v){
			NSMutableString *val = [NSMutableString stringWithString:va];
			
			match = [val rangeOfString:@"name="];
			if ( match.location != NSNotFound && ![name length] > 0 ){
				[val replaceCharactersInRange:match withString:@""];
				name = val;
			}
			
			match = [val rangeOfString:@"size="];
			if ( match.location != NSNotFound ){
				[val replaceCharactersInRange:match withString:@""];
				size = val;
				NSNumber *bytes = [NSNumber numberWithInt:[size intValue]];
				if ( bytes < [NSNumber numberWithInt:1024] ){
					NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
					[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
					size = [NSMutableString stringWithFormat:@"%@", [numberFormatter stringFromNumber:bytes]];
					
					//size = [NSMutableString stringWithFormat:@"%f B", bytes];
				}
				else if ( bytes <= [NSNumber numberWithInt:(1048576)] ){
					
					NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
					[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
					size = [NSMutableString stringWithFormat:@"%@", [numberFormatter stringFromNumber:bytes]];
					
					//NSNumber *kB = [NSNumber numberWithDouble:([size intValue]/1024)];
					//size = [NSMutableString stringWithFormat:@"%f kB", kB];
				}
				else {
					NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
					[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
					NSNumber *n = [NSNumber numberWithFloat:([size intValue]/1048576.0)];
					size = [NSMutableString stringWithFormat:@"%@ MB", [numberFormatter stringFromNumber:n]];
					
					//NSNumber *MB = [NSNumber numberWithFloat:([size floatValue]/(1048576))];					
					//size = [NSMutableString stringWithFormat:@"%f MB", MB];
				}

			}
			
		}//for
		
		if ( name != nil ){
			
			NSString *imagePath = [NSBundle pathForResource:@"ico_allegato_20x20" ofType:@"png" inDirectory:[[NSBundle mainBundle] bundlePath] ];
			NSString *imgSrcHtml = [NSString stringWithFormat:@"<img src=\"file://%@\"/>", [imagePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] ];		
			[message appendFormat:@"<br>%@&nbsp;", imgSrcHtml];
			
			
			NSMutableString *downman_url = [NSMutableString stringWithString:DOWNMAN_URL];
			
			match = [downman_url rangeOfString:@"<id>"];
			if ( match.location != NSNotFound ){
				[downman_url replaceCharactersInRange:match withString:[jso objectForKey:@"ID_OF_FIELD_ASSIGNMENT"]];
			}
			
			match = [downman_url rangeOfString:@"<type>"];
			if (match.location != NSNotFound){
				[downman_url replaceCharactersInRange:match withString:@"at"];
			}
			NSLog(@"%@", downman_url);
			[message appendFormat:@"<a href=\"%@%@\">%@</a>", BASEPATH, downman_url, name];
			
		}
		
		if ( size != nil ){
			[message appendFormat:@" [ %@ ]<br><br>", size];
		}
	}
	
	else 
		
		[message appendFormat:@"<strong>%@:</strong> %@<br>", elem, [jso objectForKey:@"VALUE"]];	
}


-(NSString *)getToken{
		
		
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASEPATH, TOKEN_URL]]];
		
		
		NSData *response = [NSURLConnection sendSynchronousRequest:request
												 returningResponse:nil
															 error:nil];
		
		NSString *token = [[NSString alloc] initWithData:response
												encoding:NSUTF8StringEncoding];
		
		NSLog(@"Token: %@", token);
    [token release];
		return token;
		
}
	


-(bool)doLogin:(NSString *)username password:(NSString *)password{
	
	// Hide the keyboard 
	//[self.textToExtractTextView resignFirstResponder];

	
	// Create a string for the URL 
	NSString *urlString =@"http://www.oktago.com/index.php";	
	// Create the NSURL 
	NSURL *url = [NSURL URLWithString:urlString];	
	
	// Create a mutable request because we will append data to it. 
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
														   cachePolicy:NSURLRequestUseProtocolCachePolicy 
													   timeoutInterval: 30.0];	
	
	// Set the HTTP method of the request to POST 
	[request setHTTPMethod:@"POST"];	
	// Build a string for the parameters 
	
	NSMutableString *c = [NSMutableString stringWithString:[self getToken]];
	NSRange match;
	match = [c rangeOfString:@"\""];
	
	if ( match.location != NSNotFound ){
		[c replaceCharactersInRange:match withString:@""];
	}
	match = [c rangeOfString:@"\""];
	
	if ( match.location != NSNotFound ){
		[c replaceCharactersInRange:match withString:@""];
	}		
	
	
	
	
	NSString *parameters =[[NSString alloc] initWithFormat:@"option=com_bore&controller=auth&remember=yes&&task=login&username=%@&passwd=%@&%@=1", username, password, c];
	NSLog(@"Parameters: %@", parameters);
	// Set the body of the request 
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];	
	[parameters release];
	
	//NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSHTTPURLResponse *response;
	//provo a fare una richiesta sincrona
	NSData *responseData2 = [NSURLConnection sendSynchronousRequest:request
												  returningResponse:&response
														 error:nil];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding]; 
	
	NSLog(@"Response String: %@", responseString);
	
	if ([responseString isEqualToString:@"1"]){
		
		//Se il login avviene con successo -> recupero il cookie e lo salvo in 'cookie'
		if ([response respondsToSelector:@selector(allHeaderFields)]) {
			NSDictionary *dictionary = [response allHeaderFields];
			self.cookie = [NSMutableString stringWithString:[dictionary valueForKey:@"Set-Cookie"]];
		}		
        [responseString release];
	
		return YES;
		
	}
	else if ([responseString isEqualToString:@"-1"]){
		[responseString release];
		return NO;
	}
	else {
		[responseString release];
		return NO;
	}	
	
	
	return NO;

	// Clean up our local variables 
	[urlString release]; 
	[parameters release];	
	[request release];
	
}


//Formatta ua stringa in un oggetto NSDate e lo ritorna come stringa
-(NSString *)getDateTime:(NSString *)dateToFormat{
	
	//Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *it = [[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"];
	[dateFormat setLocale:it];
	[it release];
	
	//Se la stringa 'dateToFormat' contiene tutti 0 -> return null
	NSRange match;
	match = [dateToFormat rangeOfString:@"0000-00-00 00:00:00"];	
	if ( match.location != NSNotFound ){
        [dateFormat release];
		return nil;
	}	
	
	//Se la stringa 'dateToFormat' contiene l'ora settata a zero ritornerò solo la data, senza ora
	match = [dateToFormat rangeOfString:@"00:00:00"];
	if ( match.location != NSNotFound ){
		NSDate *date = [dateFormat dateFromString:dateToFormat];
		[dateFormat setDateFormat:@"dd MMMM yyyy"];
		dateToFormat = [dateFormat stringFromDate:date];
		[dateFormat release];
		return [dateToFormat capitalizedString];		
	}
	
	//Se invece l'ora non è presente sarà un oggetto 'date'
	else if ( ([dateToFormat length] < 12) ){
		[dateFormat setDateFormat:@"yyyy-MM-dd"];
		NSDate *date = [dateFormat dateFromString:dateToFormat];
		[dateFormat setDateFormat:@"dd MMMM yyyy"];
		dateToFormat = [dateFormat stringFromDate:date];
		[dateFormat release];
		return [dateToFormat capitalizedString];
	}

	
	NSDate *date = [dateFormat dateFromString:dateToFormat];
	[dateFormat setDateFormat:@"dd MMMM yyyy HH:mm"];
	dateToFormat = [dateFormat stringFromDate:date];
	[dateFormat release];
	return [dateToFormat capitalizedString];
}

//metodo invocato quando si tappa sul pulsante 'like'
-(void)follow:(NSString *)id value:(BOOL)value{

	NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@", BASEPATH, FOLLOW];
	
	NSRange match;
	match = [url rangeOfString:@"<id>"];
	
	if ( match.location != NSNotFound ){
		[url replaceCharactersInRange:match withString:id];
	}
	
	match = [url rangeOfString:@"<value>"];
	if ( match.location != NSNotFound ){
		if (value)
			[url replaceCharactersInRange:match withString:@"1"];
		else 
			[url replaceCharactersInRange:match withString:@"0"];
	}	
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	[request setHTTPShouldHandleCookies:NO];
	//Se 'cookie' è diverso da null -> sono loggato -> inserisco il cookie nella richiesta http
	//if (cookie != nil)
	[request addValue:cookie forHTTPHeaderField:@"Cookie"];
	
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil
														 error:nil];
	
	NSString *string = [[NSString alloc] initWithData:response
												  encoding:NSUTF8StringEncoding];
	

	NSLog(@"Follow: %@", string);
	
	[string release];	
}
/*
-(TypeStructure *) getStructureFromTypeId:(NSString *)id{
	
	TypeStructure *res;
	
	if ( res != nil ) {
		return res;
	}

	res = [TypeStructure createFromFile:[NSString stringWithFormat:@"%@%@%@", BASEPATH, TYPE_DETAIL_URL, id]];
	
	if (res == nil && [self downloadType:id] ) {
		res = [TypeStructure createFromFile:[NSString stringWithFormat:@"%@%@%@", BASEPATH, TYPE_DETAIL_URL, id]];
	}
	
	return res;
	
}
*/
/*
-(BOOL) downloadType:(NSString *)typeId {
	
	NSString *url = [NSString stringWithFormat:@"%@%@%@", BASEPATH, TYPE_DETAIL_URL, typeId];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil
														 error:nil];
	
	return YES;
	
	 NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	 
	 NSData *response = [NSURLConnection sendSynchronousRequest:request
	 returningResponse:nil
	 error:nil];
	 
	 
	 UIImage *image = [[UIImage alloc] initWithData:response];
	 //salvo l'icona in locale
	 [response writeToFile:filePath atomically:YES];
	 
	 //se image è nil la inizializzo con un'immagine provvisoria
	 if ( image == nil )  image = [UIImage imageNamed:@"document-60"];	 
	 
	
}
*/

@end
