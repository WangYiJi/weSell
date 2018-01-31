//
//  RequestDeleteChatUser.m
//  WyjDemo
//
//  Created by Alex on 16/6/12.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "RequestDeleteChatUser.h"
#import "UserMember.h"

@implementation RequestDeleteChatUser
@synthesize postId;
-(instancetype)init
{
    self = [super init];
    
    return self;
}

-(void)setPostId:(NSString *)_postId
{
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/chattedusers/user/%@/chattedposts/%@",PostServer,[UserMember getInstance].userId,_postId];
    postId = _postId;
}

@end
