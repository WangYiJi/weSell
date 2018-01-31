//
//  SellByIdEntity.h
//  WyjDemo
//
//  Created by 霍霍 on 16/1/5.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface SellByIdEntity : BaseRequest
@property (nonatomic,copy) NSString *postIds;
@property (nonatomic,copy) NSString *viewerId;
@end
