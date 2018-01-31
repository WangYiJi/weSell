//
//  ResponseSellPost.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseSellPostQuery.h"

//@interface Coordination : NSObject
//@property (nonatomic,assign)NSInteger Coordination;
//@property (nonatomic,assign)NSInteger lattitude;
//
//@end

//@interface Address : NSObject
//@property (nonatomic,copy)NSString *streetLine1;
//@property (nonatomic,copy)NSString *streetLine2;
//@property (nonatomic,copy)NSString *city;
//@property (nonatomic,copy)NSString *cityId;
//@property (nonatomic,copy)NSString *provinceOrStateCode;
//@property (nonatomic,copy)NSString *countryCode;
//@property (nonatomic,copy)NSString *postalCode;
//
//@end
//
//@interface Price : NSObject
//@property (nonatomic,assign)NSInteger value;
//@property (nonatomic,copy)NSString *currency;
//
//@end

@interface SellPost : NSObject
@property (nonatomic,copy)NSString *postId;
@property (nonatomic,copy)NSString *categoryPath;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *description;
@property (nonatomic,copy)NSString *thumbnailUrl;
@property (nonatomic,strong)NSArray *photoUrls;
@property (nonatomic,strong)Price *price;
@property (nonatomic,copy)NSString *conditionLevel;
@property (nonatomic,strong)NSArray *tags;
@property (nonatomic,strong)Address *address;
@property (nonatomic,strong)Coordination *coordination;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *sellType;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *userDiapName;
@property (nonatomic,copy)NSString *createdAt;
@property (nonatomic,copy)NSString *modifiedAt;
@property (nonatomic,assign)NSInteger favoriteCnt;
@property (nonatomic,strong)NSNumber *firmPrice;

@end

@interface ResponseSellPosts : NSObject
@property (nonatomic,strong)NSMutableArray *responseSellPostsArray;

-(id)initwithJson:(id)dic;

@end
