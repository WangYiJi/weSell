//
//  RequestGetChatUserAsSeller.m
//  WyjDemo
//
//  Created by Alex on 16/3/2.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "RequestGetChatUserAsSeller.h"
#import "UserMember.h"

@implementation RequestGetChatUserAsSeller
@synthesize page;
@synthesize pageSize;

-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/chattedusers/user/%@/asSeller",PostServer,[UserMember getInstance].userId];
    return self;
}

@end
