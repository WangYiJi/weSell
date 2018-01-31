//
//  GetSelfSellPostsEntity.m
//  WyjDemo
//
//  Created by zjb on 16/3/2.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "GetSelfSellPostsEntity.h"
//#import "UserMember.h"
@implementation GetSelfSellPostsEntity
@synthesize page;
@synthesize pageSize;
@synthesize status;

-(instancetype)init
{
    self = [super init];
    return self;
}

- (void)setUserId:(NSString *)userId{
        self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/sellposts",PostServer,userId];
}
@end
