//
//  GetSellPostEntity.m
//  WyjDemo
//
//  Created by Jabir on 16/3/2.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "GetSellPostEntity.h"
#import "UserMember.h"

@implementation GetSellPostEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/sellposts/%@",PostServer,[UserMember getInstance].userId,self.sellposts];
    return self;
}
@end
