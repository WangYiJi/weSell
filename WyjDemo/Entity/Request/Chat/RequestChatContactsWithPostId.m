//
//  RequestChatContactsWithPostId.m
//  WyjDemo
//
//  Created by Alex on 16/3/2.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "RequestChatContactsWithPostId.h"
#import "UserMember.h"

@implementation RequestChatContactsWithPostId
@synthesize page;
@synthesize pageSize;

-(instancetype)init
{
    self = [super init];
    
    return self;
}

-(void)setURL:(NSString*)sPostId
{
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/chattedusers/user/%@/post/%@",PostServer,[UserMember getInstance].userId,sPostId];
}

@end
