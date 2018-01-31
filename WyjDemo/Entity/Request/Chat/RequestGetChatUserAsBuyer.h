//
//  RequestGetChatUserAsBuyer.h
//  WyjDemo
//
//  Created by zjb on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface RequestGetChatUserAsBuyer : BaseRequest
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *pageSize;

@end
