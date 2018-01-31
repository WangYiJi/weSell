//
//  DeleteFavoritePost.m
//  WyjDemo
//
//  Created by zjb on 16/2/24.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "DeleteFavoritePost.h"
#import "UserMember.h"

@implementation DeleteFavoritePost
@synthesize favId;
-(instancetype)init
{
    self = [super init];
    return self;
}

-(void)setFavId:(NSString *)_favId
{
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/favoriteposts/%@",PostServer,[UserMember getInstance].userId,_favId];
    favId = _favId;
}

@end
