//
//  LaunageUtility.m
//  WyjDemo
//
//  Created by wyj on 15/11/14.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "LaunageUtility.h"

static LaunageUtility *launageInstance = nil;

@implementation LaunageUtility
@synthesize dic;
@synthesize languageType;

+(NSString*)getMessageWithTarge:(NSString*)sTarge
{
    if (!launageInstance) {
        launageInstance = [[LaunageUtility alloc] init];
        [LaunageUtility changeLaunageType:@"jianti"];
    }
    
    NSString *sTitle = [launageInstance.dic objectForKey:sTarge];
    return sTitle;
}

- (void)changeLaunageType:(LanguageType)LaunageType
{
    launageInstance.languageType = LaunageType;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Language" ofType:@"plist"];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    launageInstance.dic = [tempDic objectForKey:[self languageKeyWithLanguageType:LaunageType]];
}

+(LaunageUtility *)getInstance {
    static LaunageUtility* shareInstance=nil;
    static dispatch_once_t onceToken;
    if(!shareInstance)
    {
        dispatch_once(&onceToken, ^{
            shareInstance = [[self alloc]init];
            
        });
    }
    return shareInstance;
}

- (NSString *)languageKeyWithLanguageType:(LanguageType)l{
    switch (l) {
        case LanguageType_jianti:
            return @"jianti";
            break;
        case LanguageType_fanti:
            return @"fanti";
            break;
        default:
            return @"jianti";
            break;
    }
}

@end
