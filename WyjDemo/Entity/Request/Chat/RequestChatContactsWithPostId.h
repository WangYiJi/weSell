//
//  RequestChatContactsWithPostId.h
//  WyjDemo
//
//  Created by Alex on 16/3/2.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface RequestChatContactsWithPostId : BaseRequest
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *pageSize;

-(void)setURL:(NSString*)sPostId;
@end
