//
//  CategoryAndCountryInfo.h
//  WyjDemo
//
//  Created by Jabir on 16/4/5.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseCountry.h"
#import "ResponseCategory.h"

@interface CategoryAndCountryInfo : NSObject
@property (nonatomic,strong) ResponseCountry *countryInfo;
@property (nonatomic,strong) ResponseCategory *categoryInfo;

+(CategoryAndCountryInfo *)getInstance;
-(CategoryInfo *)getCategoryWithPath:(NSString *)categoryPath;//通过名字获取到类别
-(CountryInfo *)getCountryWithCode:(NSString *)code;//通过名字获取到国家
-(ProvinceOrStateInfos *)getProvinceWithCode:(NSString *)code From:(CountryInfo *)country;//通过名字获取到省份
-(CityInfo *)getCityInfoWithCode:(NSString *)code From:(ProvinceOrStateInfos *)Province;//通过名字获取到城市
-(ConditionLevelInfo *)getConditionWithCode:(NSString *)conditionLevelId From:(CountryInfo *)country;//通过名字获取到条件

-(NSMutableDictionary *)getCountryInfoWithCityId:(NSString *)sCityId;
@end
