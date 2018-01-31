//
//  BaseUserInfo.m
//  WyjDemo
//
//  Created by wyj on 16/1/22.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseUserInfo.h"

@implementation BaseUserInfo
@synthesize authType;
@synthesize avatarLargeUrl;
@synthesize avatarSmallUrl;
@synthesize avatarUrl;
@synthesize displayName;
@synthesize email;
@synthesize firstName;
@synthesize goodSeller;
@synthesize guaranteedSeller;
@synthesize lastName;
@synthesize lastSelectedCityId;
@synthesize status;
@synthesize userId;
@synthesize signingKey;
@synthesize scopes;
@synthesize maxNumberOfPicturesPerPost;

-(id)initWithDic:(NSMutableDictionary*)dic
{
    self = [super init];
    if (self) {
        for (NSString *sKey in [dic allKeys]) {
            if ([self respondsToSelector:NSSelectorFromString(sKey)]) {
                [self setValue:[dic objectForKey:sKey] forKey:sKey];
            }
        }
    }
    return self;
}


@end
