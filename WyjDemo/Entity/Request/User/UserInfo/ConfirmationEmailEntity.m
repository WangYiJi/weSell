//
//  ConfirmationEmailEntity.m
//  WyjDemo
//
//  Created by zjb on 16/4/25.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ConfirmationEmailEntity.h"
#import "UserMember.h"
@implementation ConfirmationEmailEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/resendConfirmationEmail",PostServer,[UserMember getInstance].userId];
    return self;
}
@end
