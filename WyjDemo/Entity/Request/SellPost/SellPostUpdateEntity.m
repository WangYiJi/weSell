//
//  SellPostUpdateEntity.m
//  WyjDemo
//
//  Created by Jabir on 16/4/16.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "SellPostUpdateEntity.h"
#import "UserMember.h"
@implementation SellPostUpdateEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/sellposts",PostServer,[UserMember getInstance].userId];
    return self;
}

- (void)setPutUrl:(NSString *)spostId
{
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/sellposts/%@",PostServer,[UserMember getInstance].userId,spostId];
}

@end
