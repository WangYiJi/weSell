//
//  UnlistSellPostEntity.m
//  WyjDemo
//
//  Created by zjb on 16/3/3.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "UnlistSellPostEntity.h"
#import "UserMember.h"
@implementation UnlistSellPostEntity

-(instancetype)init
{
    self = [super init];
    return self;
}

- (void)setUrl:(NSString *)sPostid{
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/sellposts/%@/unlist",PostServer,[UserMember getInstance].userId,sPostid];
}

@end
