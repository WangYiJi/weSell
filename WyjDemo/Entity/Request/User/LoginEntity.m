//
//  LoginEntity.m
//  WyjDemo
//
//  Created by wyj on 15/10/30.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "LoginEntity.h"
#import "NSString+GUID.h"

@implementation LoginEntity

-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/login",PostServer];
    self.deviceId = [NSString GUIDString];
    return self;
}

@synthesize email;
@synthesize password;
@synthesize mobilePlatform;
@synthesize deviceId;

@end
