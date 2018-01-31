//
//  SellPostEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/3.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "SellPostEntity.h"
#import "UserMember.h"

@implementation SellPostEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/sellposts",PostServer,[UserMember getInstance].userId];
    return self;
}

@end
