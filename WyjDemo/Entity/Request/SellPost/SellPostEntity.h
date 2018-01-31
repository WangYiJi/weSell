//
//  SellPostEntity.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/3.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "BaseRequest.h"
#import "ResponseSellPostQuery.h"
#import "ResponseCountry.h"

@interface SellPostEntity : BaseRequest
@property (nonatomic,copy) NSString *categoryPath;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSString *details;
@property (nonatomic,strong) ThumbnailPhoto *thumbnailPhoto;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) Price *price;
@property (nonatomic,strong) NSString *conditionLevelId;
@property (nonatomic,strong) Address *address;
@property (nonatomic,strong) Coordination *coordination;
@property (nonatomic,copy) NSString *sellType;
//@property (nonatomic,copy) NSString *sponsoredAdUrl;
@property (nonatomic,strong) NSNumber *firmPrice;
@property (nonatomic,strong) NSArray *tags;
@end
