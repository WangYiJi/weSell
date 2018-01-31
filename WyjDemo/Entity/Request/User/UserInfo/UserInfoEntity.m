//
//  UserInfoEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/10.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "UserInfoEntity.h"
#import "UserMember.h"
@implementation UserInfoEntity

-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@",PostServer,[UserMember getInstance].userId];
    return self;
}
@end
