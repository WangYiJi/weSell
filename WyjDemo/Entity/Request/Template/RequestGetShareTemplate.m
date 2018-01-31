//
//  RequestGetShareTemplate.m
//  WyjDemo
//
//  Created by Alex on 16/6/17.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "RequestGetShareTemplate.h"

@implementation RequestGetShareTemplate

-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/messagetemplates/SHARE_POST_IOS/download",PostServer];
    return self;
}

@end
