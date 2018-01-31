//
//  SellPostQueryEntity.h
//  WyjDemo
//
//  Created by 霍霍 on 15/12/12.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface SellPostQueryEntity : BaseRequest
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *categoryPath;
@property (nonatomic,copy)NSString *conditionLevelId;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *sellType;
@property (nonatomic,copy)NSString *keywords;
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;
@property (nonatomic,copy)NSString *distanceInKm;
@property (nonatomic,copy)NSString *distanceInMiles;
@property (nonatomic,copy)NSString *priceRange;
@property (nonatomic,copy)NSString *sort;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *pageSize;
@end
