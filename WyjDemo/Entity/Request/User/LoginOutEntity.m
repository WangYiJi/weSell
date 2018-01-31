//
//  LoginOutEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 16/1/17.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "LoginOutEntity.h"

@implementation LoginOutEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/logout",PostServer];
    return self;
}
@end