//
//  RequestChatConnect.m
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "RequestChatConnect.h"
#import "UserMember.h"

@implementation RequestChatConnect
@synthesize userId2;
@synthesize postId;

-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/chattedusers/user/%@",PostServer,[UserMember getInstance].userId];
    return self;
}

@end
