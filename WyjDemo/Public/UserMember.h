//
//  UserMember.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/3.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseLoginInfo.h"
#import "ResponseRegister.h"
#import "ResponseUserAccount.h"
#import "BaseUserInfo.h"


@interface UserMember : NSObject
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong) BaseUserInfo *baseUserInfo;
@property (nonatomic,strong) NSString *signingKey;
@property (nonatomic,assign) BOOL isLogin;

+(UserMember *)getInstance;
- (void)getUserInfo;
@end
