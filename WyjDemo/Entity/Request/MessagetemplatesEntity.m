

//
//  MessagetemplatesEntity.m
//  WyjDemo
//
//  Created by zjb on 16/2/24.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "MessagetemplatesEntity.h"

@implementation MessagetemplatesEntity
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/messagetemplates/BUY_NOW/download",PostServer];
    return self;
}
@end
