//
//  GetFavoritePostEntity.m
//  WyjDemo
//
//  Created by Jabir on 16/2/27.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "GetFavoritePostEntity.h"
#import "UserMember.h"
@implementation GetFavoritePostEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/favoriteposts",PostServer,[UserMember getInstance].userId];
    return self;
}
@end
