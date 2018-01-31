//
//  ResetPasswordEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 16/1/18.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResetPasswordEntity.h"

@implementation ResetPasswordEntity
@synthesize email;
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/passwordreset",PostServer];
    return self;
}
@end
