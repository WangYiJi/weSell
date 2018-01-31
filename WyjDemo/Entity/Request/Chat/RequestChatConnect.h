//
//  RequestChatConnect.h
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface RequestChatConnect : BaseRequest
@property (nonatomic,copy) NSString *userId2;
@property (nonatomic,copy) NSString *postId;
@end
