//
//  SellByIdEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 16/1/5.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "SellByIdEntity.h"

@implementation SellByIdEntity
@synthesize postIds;
@synthesize viewerId;

-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/sellposts/byIds",PostServer];
    return self;
}
@end
