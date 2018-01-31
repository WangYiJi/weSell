
//
//  RelistSellPost.m
//  WyjDemo
//
//  Created by zjb on 16/3/3.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "RelistSellPostEntity.h"
#import "UserMember.h"
@implementation RelistSellPostEntity
-(instancetype)init
{
    self = [super init];

    return self;
}

- (void)setUrl:(NSString *)sPostid{
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/sellposts/%@/relist",PostServer,[UserMember getInstance].userId,sPostid];
}
@end
