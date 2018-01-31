//
//  ChangePasswardEntity.m
//  WyjDemo
//
//  Created by zjb on 16/2/24.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ChangePasswardEntity.h"
#import "UserMember.h"

@implementation ChangePasswardEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/passwordchange",PostServer,[UserMember getInstance].userId];
    return self;
}
@end
