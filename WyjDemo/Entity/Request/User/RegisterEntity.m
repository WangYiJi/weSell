//
//  RegisterEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/1.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "RegisterEntity.h"

@implementation RegisterEntity
@synthesize displayName;
@synthesize firstName;
@synthesize lastName;
@synthesize avatarUrl;
@synthesize email;
@synthesize authType;
@synthesize authToken;
@synthesize acceptedLanguage;
@synthesize avatarLargeUrl;
@synthesize avatarSmallUrl;

-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users",PostServer];
    return self;
}

@end
