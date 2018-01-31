//
//  CategoryEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "CategoryEntity.h"

@implementation CategoryEntity

-(instancetype)init
{
    self = [super init];
    self.bCloseParams = YES;//表示不传参数
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/categories/download",PostServer];
    return self;
}
@end
