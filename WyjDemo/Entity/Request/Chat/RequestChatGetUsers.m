//
//  RequestChatGetUsers.m
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "RequestChatGetUsers.h"
#import "UserMember.h"
@implementation RequestChatGetUsers
@synthesize page;
@synthesize pageSize;
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/chattedusers/user/%@",PostServer,[UserMember getInstance].userId];
    return self;
}
@end
