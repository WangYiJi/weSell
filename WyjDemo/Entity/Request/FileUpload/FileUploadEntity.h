//
//  FileUploadEntity.h
//  WyjDemo
//
//  Created by 霍霍 on 15/12/26.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface FileUploadEntity : BaseRequest
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *fileType;
@property (nonatomic,copy) NSString *from;
@end
