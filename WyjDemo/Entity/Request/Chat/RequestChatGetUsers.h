//
//  RequestChatGetUsers.h
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface RequestChatGetUsers : BaseRequest
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *pageSize;
@end
