//
//  CategoryAndCountryInfo.m
//  WyjDemo
//
//  Created by Jabir on 16/4/5.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "CategoryAndCountryInfo.h"

@implementation CategoryAndCountryInfo
@synthesize countryInfo;
@synthesize categoryInfo;

+(CategoryAndCountryInfo *)getInstance{
    static CategoryAndCountryInfo* shareInstance;
    static dispatch_once_t onceToken;
    if(!shareInstance)
    {
        dispatch_once(&onceToken, ^{
            shareInstance = [[self alloc]init];
            
        });
    }
    return shareInstance;
}

-(CategoryInfo *)getCategoryWithPath:(NSString *)categoryPath{
    //2级目录
    for (CategoryInfo *c in self.categoryInfo.responseCategoryArray) {
        for (CategoryInfo *cc in c.childCategories) {
            if ([cc.categoryPath isEqualToString:categoryPath]) {
                return cc;
            }
        }
        
    }
    return nil;
}

-(CountryInfo *)getCountryWithCode:(NSString *)code{
    for (CountryInfo *c in self.countryInfo.responseCountryInfoArray) {
        if ([c.countryCode isEqualToString:code]) {
            return c;
        }
    }
    return nil;
}

-(ProvinceOrStateInfos *)getProvinceWithCode:(NSString *)code From:(CountryInfo *)country{
    for (ProvinceOrStateInfos *p in country.provinceOrStateInfos) {
        if ([p.provinceOrStateCode isEqualToString:code]) {
            return p;
        }
    }
    return nil;
}

-(CityInfo *)getCityInfoWithCode:(NSString *)code From:(ProvinceOrStateInfos *)Province{
    for (CityInfo *c in Province.cities) {
        if ([c.cityId isEqualToString:code]) {
            return c;
        }
    }
    return nil;
}

-(ConditionLevelInfo *)getConditionWithCode:(NSString *)conditionLevelId From:(CountryInfo *)country{
    for (ConditionLevelInfo *c in country.conditionLevels) {
        if ([c.conditionLevelId isEqualToString:conditionLevelId]) {
            return c;
        }
    }
    return nil;
}

//通过cityid判断用户设置的城市省份和国家,没有就返回默认的第一个城市
-(NSMutableDictionary *)getCountryInfoWithCityId:(NSString *)sCityId{
    NSMutableDictionary *dic_CountryInfo = [[NSMutableDictionary alloc] init];
    for (CountryInfo *country in self.countryInfo.responseCountryInfoArray) {
        for (ProvinceOrStateInfos *province in country.provinceOrStateInfos) {
            for (CityInfo *city in province.cities) {
                if ([city.cityId isEqualToString:sCityId]) {
                    [dic_CountryInfo setValue:city forKey:@"chooseCity"];
                    [dic_CountryInfo setValue:province forKey:@"chooseProvince"];
                    [dic_CountryInfo setValue:country forKey:@"chooseCountry"];
                    return dic_CountryInfo;
                }
            }
        }
    }
    if (self.countryInfo.responseCountryInfoArray.count > 0) {
        CountryInfo *firstCountry = [self.countryInfo.responseCountryInfoArray firstObject];
        ProvinceOrStateInfos *firstProvince = [firstCountry.provinceOrStateInfos firstObject];
        CityInfo *firstCity = [firstProvince.cities firstObject];
        [dic_CountryInfo setValue:firstCity forKey:@"chooseCity"];
        [dic_CountryInfo setValue:firstProvince forKey:@"chooseProvince"];
        [dic_CountryInfo setValue:firstCountry forKey:@"chooseCountry"];
        return dic_CountryInfo;
    }
    return nil;
}

@end
