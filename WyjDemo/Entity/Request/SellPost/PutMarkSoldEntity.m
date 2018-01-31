//
//  PutMarkSoldEntity.m
//  WyjDemo
//
//  Created by Jabir on 16/3/2.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "PutMarkSoldEntity.h"
#import "UserMember.h"
@implementation PutMarkSoldEntity

-(instancetype)init
{
    self = [super init];
    return self;
}

- (void)setUrl:(NSString *)sPostid{
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/sellposts/%@/marksold",PostServer,[UserMember getInstance].userId,sPostid];
}
@end
