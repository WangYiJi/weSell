//
//  LaunageUtility.h
//  WyjDemo
//
//  Created by wyj on 15/11/14.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    LanguageType_jianti = 0,
    LanguageType_fanti = 1
}LanguageType;//语言类型

@interface LaunageUtility : NSObject
{
    NSMutableDictionary *dic;
    LanguageType languageType;
}
@property (nonatomic,strong) NSMutableDictionary *dic;
@property (nonatomic,assign) LanguageType languageType;
+(NSString*)getMessageWithTarge:(NSString*)sTarge;
+(void)changeLaunageType:(LanguageType)LaunageType;
@end
