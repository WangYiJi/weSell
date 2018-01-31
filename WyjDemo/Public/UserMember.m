//
//  UserMember.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/3.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "UserMember.h"
#import "Global.h"
#import "UserInfoEntity.h"
#import "NetworkEngine.h"
#import "BaseUserInfo.h"

@implementation UserMember
@synthesize userId;
@synthesize isLogin;
@synthesize signingKey;
@synthesize baseUserInfo;

+(UserMember *)getInstance {
    static UserMember* shareInstance;
    static dispatch_once_t onceToken;
    if(!shareInstance)
    {
        dispatch_once(&onceToken, ^{
            shareInstance = [[self alloc]init];
            
        });
    }
    return shareInstance;
}

-(NSString *)userId
{
    if (userId.length <= 0) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:def_UserId_userDefault];
        if (str.length <= 0) {
            return @"";
        } else {
            return str;
        }
    } else {
        return userId;
    }
}

- (void)getUserInfo {
    UserInfoEntity *userInfo = [[UserInfoEntity alloc]init];
    
    __weak typeof(self) weakSelf = self;
    [NetworkEngine getJSONWithUrl:userInfo success:^(id json) {
        BaseUserInfo *info = [[BaseUserInfo alloc] initWithDic:json];
        weakSelf.baseUserInfo = info;

    } fail:^(NSError *error) {
        
    }];
}

@end
