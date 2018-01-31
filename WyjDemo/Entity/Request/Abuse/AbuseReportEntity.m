//
//  AbuseReportEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 16/1/28.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "AbuseReportEntity.h"
#import "UserMember.h"

@implementation AbuseReportEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@/abusereport",PostServer,[UserMember getInstance].userId];
    return self;
}
@end
