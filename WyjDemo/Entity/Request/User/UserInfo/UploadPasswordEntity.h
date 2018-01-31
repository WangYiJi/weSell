//
//  UploadPasswordEntity.h
//  WyjDemo
//
//  Created by 霍霍 on 16/1/18.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface UploadPasswordEntity : BaseRequest
@property (nonatomic,copy) NSString *resetToken;
@property (nonatomic,copy) NSString *password;
@end
