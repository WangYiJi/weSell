//
//  CountryEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/23.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "CountryEntity.h"

@implementation CountryEntity
-(instancetype)init
{
    self = [super init];
    self.bCloseParams = YES;//表示不传参数
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/countries/download",PostServer];
    return self;
}
@end
