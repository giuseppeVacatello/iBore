//
//  iBoreModel.h
//  iBore
//
//  Created by peppe on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeStructure.h"

//Definisco le variabili che contengono gli url relativi alle chiamate ai ws
#define APP_ID                  @"oktago.com"

//E' l'unico valora da cambiare per ogni installazione di borè
#define BASEPATH                    @"http://www.oktago.com/"
//#define BASEPATH                    @"http://ingegneria.oktago.com/"
//#define BASEPATH                    @"http://www.bisotech.com/"


#define SERVICE_PATH                @"index.php?option=com_bore&view=object&format=services&action="
#define TOKEN_URL                   @"index.php?option=com_bore&index.php?option=com_bore&controller=auth&task=getToken"

//ws4
#define COUNT_ROOT_SUBTYPES_URL     @"index.php?option=com_bore&view=object&format=services&action=jsonlistcount&params[idt]=" //ws4 per root = null
#define COUNT_NODE_SUBTYPES_URL     @"index.php?option=com_bore&view=object&format=services&action=jsonlistcount&params[idt]="
#define COUNT_NODE_SUBTYPES_URL_root @"&params[root]=" //ws4

//ws5 per root = main group (null)
#define LIST_ROOT_SUBTYPES_URL_idt  @"index.php?option=com_bore&view=object&format=services&action=jsonlist&params[idt]="
#define LIST_ROOT_SUBTYPES_URL_page @"&params[page]="
#define LIST_ROOT_SUBTYPES_URL_ipp  @"&params[ipp]="

//ws5
#define LIST_NODE_SUBTYPES_URL_idt  @"index.php?option=com_bore&view=object&format=services&action=jsonlist&params[idt]="
#define LIST_NODE_SUBTYPES_URL_page @"&params[page]="
#define LIST_NODE_SUBTYPES_URL_ipp  @"&params[ipp]="
#define LIST_NODE_SUBTYPES_URL_root @"&params[root]="

//ws3
#define INSTANCE_DETAIL_URL         @"index.php?option=com_bore&view=object&format=services&action=jsondetails&params[id]="

//ws2 per root = null e ws2
#define ROOT_TYPES_PATH             @"index.php?option=com_bore&view=object&format=services&action=jsonnode"
#define SUB_TYPES_PATH              @"index.php?option=com_bore&view=object&format=services&action=jsonnode&params[root]="

//ottengo i dettagli di un tipo
#define TYPE_DETAIL_URL             @"index.php?option=com_bore&view=object&format=services&action=jsontypedetails&params[id]="

//ws1
#define VERSION_URL                 @"index.php?option=com_bore&view=object&format=services&action=jsonversion"

//pulsante like
#define FOLLOW   @"index.php?option=com_bore&view=object&format=services&action=jsonfollow&params[id]=<id>&params[value]=<value>"

//members list
#define MEMBER_LIST @"index.php?option=com_bore&view=object&format=services&action=jsonmemberlist&params[page]=<page>&params[ipp]=<ipp>&params[root]=<root>"

#define LOGIN_URL                   @"index.php"

#define ICON_REMOTE_PATH            @"templates/bore/icons/ibore/"

#define DOWNMAN_URL                 @"components/com_bore/downman.php?id=<id>&type=<type>"


@interface iBoreModel : NSObject {

	NSDictionary *version;
	
	NSMutableData *responseData;
	
	NSMutableString *cookie;

}
@property (nonatomic, retain) NSDictionary *version;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableString *cookie;

-(NSString *)versioneLocale;
-(void)salvaVersioneCorrente:(NSString *)versione;

-(NSString *)ws1;
-(NSDictionary *)ws2:(NSString *)root;
-(NSDictionary *)ws3:(NSString *)root;
-(NSArray *)ws5:(NSString *)id root:(NSString *)root page:(NSInteger)page;
-(NSInteger)ws4:(NSString *)id root:(NSString *)root;
-(void)follow:(NSString *)id value:(BOOL)value;

-(void)getValue:(NSDictionary *)elements str:(NSMutableString *)message;

-(UIImage *)getIcona:(NSString *)nome_composite;
-(UIImage *)getAvatar:(NSString *)diskname;

//Metodo per eliminare i tag html da una stringa
-(NSString *)flattenHtml: (NSString *) html;

-(NSString *)getToken;
-(bool)doLogin:(NSString *)username password:(NSString *)password;

-(NSString *)getDateTime:(NSString *)dateToFormat;
-(void) addDetail:(NSDictionary *)jso str:(NSMutableString *)message el:str;
//-(TypeStructure *) getStructureFromTypeId:(NSString *)id;
//-(BOOL) downloadType:(NSString *)typeId;

-(NSArray *)membersList:(NSString *)root page:(NSInteger)page;

@end
