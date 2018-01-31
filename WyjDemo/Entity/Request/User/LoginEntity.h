//
//  LoginEntity.h
//  WyjDemo
//
//  Created by wyj on 15/10/30.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface LoginEntity : BaseRequest
@property (nonatomic,copy) NSString *email;//
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *mobilePlatform;
@property (nonatomic,copy) NSString *deviceId;

@end
