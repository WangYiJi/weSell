//
//  PublicUserEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "PublicUserEntity.h"

@implementation PublicUserEntity
@synthesize userIds;
-(instancetype)init
{
    self = [super init];
//    self.bCloseParams = YES;
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/public",PostServer];
    return self;
}
@end
