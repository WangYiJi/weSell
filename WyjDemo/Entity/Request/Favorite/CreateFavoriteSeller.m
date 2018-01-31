//
//  CreateFavoriteSeller.m
//  WyjDemo
//
//  Created by Jabir on 16/2/23.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "CreateFavoriteSeller.h"
#import "UserMember.h"

@implementation CreateFavoriteSeller
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/favoritesellers",PostServer,[UserMember getInstance].userId];
    return self;
}
@end
