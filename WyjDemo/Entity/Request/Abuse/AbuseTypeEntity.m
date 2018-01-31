//
//  AbuseTypeEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 16/1/28.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "AbuseTypeEntity.h"

@implementation AbuseTypeEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/abusetype/download",PostServer];
    return self;
}
@end
