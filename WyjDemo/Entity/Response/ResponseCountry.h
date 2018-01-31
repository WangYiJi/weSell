//
//  ResponseCountry.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseAbuseType.h"

@interface ConditionLevelInfo : NSObject
@property (nonatomic,copy) NSString *conditionLevelId;
@property (nonatomic,copy) NSString *displayName;
@end

@interface conditionLevel : NSObject
@property (nonatomic,copy) NSString *conditionLevelId;
@property (nonatomic,copy) NSString *displayName;
@end

@interface CityInfo : NSObject
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,copy)NSString *countryCode;
@property (nonatomic,copy)NSString *provinceOrStateCode;
@property (nonatomic,strong)NSString *displayName;

@end

@interface ProvinceOrStateInfos : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *provinceOrStateCode;
@property (nonatomic,copy)NSString *countryCode;
@property (nonatomic,strong)NSString *displayName;
@property (nonatomic,strong)NSMutableArray *cities;

@end

@interface sortOptions : NSObject
@property (nonatomic,copy)NSString *sortOptionId;
@property (nonatomic,copy)NSString *displayName;
@end

@interface CountryInfo : NSObject
@property (nonatomic,copy) NSString *countryCode;
@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,copy) NSString *currencySymbol;
@property (nonatomic,copy) NSString *distanceUnit;
@property (nonatomic,strong) NSMutableArray *searchDistances;
@property (nonatomic,strong) NSMutableArray *conditionLevels;
@property (nonatomic,strong) NSMutableArray *provinceOrStateInfos;
@property (nonatomic,strong) NSMutableArray *sortOptions;
/*countryCode (string, optional),
 currency (string, optional) = ['USD', 'CAD', 'MXN'],
 currencySymbol (string, optional) = ['$', '€', '¥'],
 distanceUnit (string, optional) = ['KM', 'Miles'],
 searchDistances (Array[integer], optional),
 displayName (string, optional),
 provinceOrStateInfos (Array[ProvinceOrStateInfo], optional),
 conditionLevels (Array[ConditionLevelInfo], optional)*/
@end

@interface ResponseCountry : NSObject
@property (nonatomic,strong)NSMutableArray *responseCountryInfoArray;

-(id)initwithJson:(id)dic;

@end
