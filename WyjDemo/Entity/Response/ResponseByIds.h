//
//  ResponseByIds.h
//  WyjDemo
//
//  Created by 霍霍 on 16/1/5.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseSellPostQuery.h"

@interface ResponseByIds : NSObject
@property (nonatomic, strong)NSMutableArray *ArraySellPost;

-(id)initwithJson:(id)dic;
@end
