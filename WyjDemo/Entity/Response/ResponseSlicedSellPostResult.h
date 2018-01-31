//
//  ResponseSlicedSellPostResult.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseSellPosts.h"

@interface ResponseSlicedSellPostResult : NSObject
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)BOOL hasNext;
@property (nonatomic,strong)NSMutableArray *result;

-(id)initwithJson:(id)dic;

@end
