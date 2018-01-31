//
//  ChangePasswardEntity.h
//  WyjDemo
//
//  Created by zjb on 16/2/24.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface ChangePasswardEntity : BaseRequest
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *authType;
@property (nonatomic,copy)NSString *currentPassword;
@property (nonatomic,strong,getter=theNewPassword)NSString *newPassword;
@end
