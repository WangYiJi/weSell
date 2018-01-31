//
//  RequestGetChatUserAsBuyer.m
//  WyjDemo
//
//  Created by zjb on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "RequestGetChatUserAsBuyer.h"
#import "UserMember.h"
@implementation RequestGetChatUserAsBuyer
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/chattedusers/user/%@/asBuyer",PostServer,[UserMember getInstance].userId];
    return self;
}
@end
