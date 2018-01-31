//
//  ResponseGetChatUserAsBuyer.h
//  WyjDemo
//
//  Created by zjb on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseGetChatUsers.h"

@interface ResponseGetChatUserAsBuyer : NSObject
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *hasNext;
@property (nonatomic,strong)NSMutableArray *resultArray;
-(id)initwithJson:(id)dic;
@end
