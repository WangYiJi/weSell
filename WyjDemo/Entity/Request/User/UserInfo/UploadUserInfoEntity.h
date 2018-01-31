//
//  UploadUserInfoEntity.h
//  WyjDemo
//
//  Created by 霍霍 on 16/1/18.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface UploadUserInfoEntity : BaseRequest

@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *avatarSmallUrl;
@property (nonatomic,copy) NSString *avatarUrl;
@property (nonatomic,copy) NSString *avatarLargeUrl;
@property (nonatomic,copy) NSString *lastSelectedCityId;
@property (nonatomic,copy) NSString *acceptedLanguage;


@end
