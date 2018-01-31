//
//  AbuseReportEntity.h
//  WyjDemo
//
//  Created by 霍霍 on 16/1/28.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface AbuseReportEntity : BaseRequest
@property (nonatomic,copy) NSString *abuseItemType;
@property (nonatomic,copy) NSString *abuseItemId;
@property (nonatomic,copy) NSString *abuseType;
@property (nonatomic,copy) NSString *abuseTypeMessage;
@end
