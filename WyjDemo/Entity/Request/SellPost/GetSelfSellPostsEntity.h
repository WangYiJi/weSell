//
//  GetSelfSellPostsEntity.h
//  WyjDemo
//
//  Created by zjb on 16/3/2.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface GetSelfSellPostsEntity : BaseRequest
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *pageSize;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *status;
@end
