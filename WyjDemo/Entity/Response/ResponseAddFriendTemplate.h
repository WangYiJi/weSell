//
//  ResponseAddFriendTemplate.h
//  WyjDemo
//
//  Created by Alex on 16/6/17.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface ResponseAddFriendTemplate : BaseRequest
@property (nonatomic,strong) NSString *messageTemplateId;
@property (nonatomic,strong) NSString *displayName;

-(id)initwithJson:(id)dic;
@end
