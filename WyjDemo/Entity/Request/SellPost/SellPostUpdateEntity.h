//
//  SellPostUpdateEntity.h
//  WyjDemo
//
//  Created by Jabir on 16/4/16.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"
#import "ResponseSellPostQuery.h"
#import "ResponseCountry.h"

@interface SellPostUpdateEntity : BaseRequest
@property (nonatomic,copy) NSString *categoryPath;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSString *details;
@property (nonatomic,strong) ThumbnailPhoto *thumbnailPhoto;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) Price *price;
@property (nonatomic,strong) NSString *conditionLevelId;
@property (nonatomic,strong) Address *address;
@property (nonatomic,strong) NSNumber *firmPrice;
@property (nonatomic,strong) NSArray *tags;
//@property (nonatomic,strong) NSNumber *isFirmPrice;
- (void)setPutUrl:(NSString *)spostId;
@end
