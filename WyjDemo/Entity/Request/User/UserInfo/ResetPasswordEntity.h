//
//  ResetPasswordEntity.h
//  WyjDemo
//
//  Created by 霍霍 on 16/1/18.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface ResetPasswordEntity : BaseRequest
@property (nonatomic,copy) NSString *email;
@end
