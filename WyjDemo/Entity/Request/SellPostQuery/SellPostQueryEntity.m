//
//  SellPostQueryEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/12.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "SellPostQueryEntity.h"

@implementation SellPostQueryEntity

-(instancetype)init
{
    self = [super init];
//    self.status = @"AVAILABLE";
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/sellposts/byCriteria",PostServer];
    return self;
}

@end
