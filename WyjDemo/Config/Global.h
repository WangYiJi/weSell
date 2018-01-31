//
//  Global.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/17.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define RGBA(r,g,b,a)						[UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define AppDelegateEntity                   ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define PostServer                          @"http://52.91.218.82:8080"

//多语言
#define AppLanguage @"appLanguage"
#define CustomLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]:@"zh-Hans"] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]



#define SCREEN_WIDTH  [[UIScreen mainScreen] applicationFrame].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height

#define selectedOrange RGBA(244, 160, 23, 1)
#define PressYellow RGBA(243, 169, 22, 1)
#define CannotPressGray RGBA(203, 203, 203, 1)

#define def_lastChatTime      @"lastCHatTime"
#define def_serverTimeDF      @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

//通知
#define def_postChatHistory   @"postHistory"
#define def_postChatContant   @"postContant"
#define def_postChatMsg       @"postChatMsg"
#define def_connectFinish     @"connectFinish"


//CoreData
#define def_DB_ChatHistory     @"ChatHistoryEntity"
#define def_DB_ChatContacts    @"ChatContactsEntity"

#define def_UserId_userDefault @"UserIdUserDefault"

typedef enum
{
    DisplayNameType,
    GenderType,
}UserInfoTypeed;