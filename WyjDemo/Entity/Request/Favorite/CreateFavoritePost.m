//
//  CreateFavoritePost.m
//  WyjDemo
//
//  Created by Jabir on 16/2/23.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "CreateFavoritePost.h"
#import "UserMember.h"
@implementation CreateFavoritePost
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/favoriteposts",PostServer,[UserMember getInstance].userId];
    return self;
}
@end
