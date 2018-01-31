//
//  SendMessageEntity.h
//  WyjDemo
//
//  Created by wyj on 15/11/6.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface SendMessageEntity : BaseRequest
@property (nonatomic,copy) NSString *MsgId;
@property (nonatomic,copy) NSString *To;
@property (nonatomic,copy) NSString *Type;
@property (nonatomic,copy) NSString *Payload;
@end
