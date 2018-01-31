//
//  RegisterEntity.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/1.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface RegisterEntity : BaseRequest
@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *avatarSmallUrl;
@property (nonatomic,copy) NSString *avatarUrl;
@property (nonatomic,copy) NSString *avatarLargeUrl;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *authType;
@property (nonatomic,copy) NSString *authToken;
@property (nonatomic,copy) NSString *acceptedLanguage;


@end
