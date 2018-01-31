//
//  ResponseSellPostQuery.h
//  WyjDemo
//
//  Created by 霍霍 on 15/12/12.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseCountry.h"

@interface ResponseSellPostQuery : NSObject
@property (nonatomic,copy)NSString *hasNext;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,strong)NSMutableArray *result;

-(id)initwithJson:(id)dic;
@end

@interface Address : NSObject
//@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *countryCode;
@property (nonatomic,copy) NSString *postalCode;
@property (nonatomic,copy) NSString *provinceOrStateCode;
@property (nonatomic,copy) NSString *streetLine1;
@property (nonatomic,copy) NSString *streetLine2;
@end

@interface Photos : NSObject
@property (nonatomic,copy)NSNumber *height;
@property (nonatomic,copy)NSNumber *width;
@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,copy)NSString *smallImageUrl;
@end

@interface Price : NSObject
@property (nonatomic,copy)NSString *currency;
@property (nonatomic,copy) NSString *currencySymbol;
@property (nonatomic,copy)NSNumber *value;
@end

@interface ThumbnailPhoto : NSObject
@property (nonatomic,copy)NSNumber *height;
@property (nonatomic,copy)NSNumber *width;
@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,copy)NSString *smallImageUrl;
@end

@interface Coordination : NSObject
@property (nonatomic,strong)NSNumber *longitude;
@property (nonatomic,strong)NSNumber *lattitude;
@end

@interface SellPostQueryResult : NSObject
@property (nonatomic,strong)    Address *address;
@property (nonatomic,copy)      NSString *categoryPath;
#warning conditionLevel是个对象有时间修改，暂时无碍
@property (nonatomic,strong)    conditionLevel *conditionLevel;
@property (nonatomic,strong)    Coordination *coordination;
@property (nonatomic,copy)      NSString *createdAt;
@property (nonatomic,copy)      NSString *details;
@property (nonatomic,strong)    NSNumber *favoriteCnt;
@property (nonatomic,strong)    NSString *favoriteId;
@property (nonatomic,strong)    NSNumber *favorited;
@property (nonatomic,strong)    NSNumber *firmPrice;
@property (nonatomic,strong)    NSNumber *modifiedAt;
@property (nonatomic,strong)    NSMutableArray *photos;
@property (nonatomic,copy)      NSString *postId;
@property (nonatomic,strong)    Price *price;
@property (nonatomic,copy)      NSString *sellType;
@property (nonatomic,strong)    NSArray *sponsoredAds;
@property (nonatomic,copy)      NSString *status;
@property (nonatomic,copy)      NSString *tags;
@property (nonatomic,strong)    ThumbnailPhoto *thumbnailPhoto;
@property (nonatomic,copy)      NSString *title;
@property (nonatomic,copy)      NSString *userDiapName;
@property (nonatomic,copy)      NSString *userId;
@property (nonatomic,copy)      NSString *userAvatarSmallUrl;
@end


