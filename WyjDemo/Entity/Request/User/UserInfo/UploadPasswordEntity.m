//
//  UploadPasswordEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 16/1/18.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "UploadPasswordEntity.h"

@implementation UploadPasswordEntity
@synthesize resetToken;
@synthesize password;
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/passwordupdate",PostServer];
    return self;
}
@end
