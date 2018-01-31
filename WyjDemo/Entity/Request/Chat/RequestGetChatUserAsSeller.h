//
//  RequestGetChatUserAsSeller.h
//  WyjDemo
//
//  Created by Alex on 16/3/2.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface RequestGetChatUserAsSeller : BaseRequest
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *pageSize;
@end
