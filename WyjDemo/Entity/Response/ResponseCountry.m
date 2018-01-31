//
//  ResponseCountry.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseCountry.h"
#import "Utils.h"

@implementation ConditionLevelInfo
@synthesize conditionLevelId;
@synthesize displayName;

@end

@implementation conditionLevel
@synthesize conditionLevelId;
@synthesize displayName;
@end

@implementation CityInfo
@synthesize cityId;
@synthesize countryCode;
@synthesize provinceOrStateCode;
@synthesize displayName;

@end

@implementation ProvinceOrStateInfos
@synthesize id;
@synthesize provinceOrStateCode;
@synthesize countryCode;
@synthesize displayName;
@synthesize cities;

@end

@implementation CountryInfo
@synthesize countryCode;
@synthesize displayName;
@synthesize provinceOrStateInfos;
@synthesize currency;
@synthesize currencySymbol;
@synthesize conditionLevels;
@synthesize distanceUnit;
@synthesize searchDistances;

@end

@implementation sortOptions
@synthesize sortOptionId;
@synthesize displayName;
@end

@implementation ResponseCountry
@synthesize responseCountryInfoArray;
-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSArray class]]) {
            self.responseCountryInfoArray = [[NSMutableArray alloc] init];
            NSArray *a = (NSArray*)dic;
            for (NSDictionary *d in a) {
                CountryInfo *c = [[CountryInfo alloc] init];
                for (NSString *key in d){
                    if ([c respondsToSelector:NSSelectorFromString(key)]) {
                        if ([key isEqualToString:@"conditionLevels"]) {
                            NSArray *arr = [d valueForKey:key];
                            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                            if (arr.count > 0) {
                                for (NSDictionary *tempdic in arr) {
                                    ConditionLevelInfo * cli = [Utils DictionaryToObject:@"ConditionLevelInfo" dic:tempdic];
                                    [tempArr addObject:cli];
                                }
                            }
                            c.conditionLevels = tempArr;
                        }else if([key isEqualToString:@"provinceOrStateInfos"]){
                            NSArray *arr_pro = [d valueForKey:key];
                            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                            if (arr_pro.count > 0) {
                                for (NSDictionary *dic1 in arr_pro) {
                                    ProvinceOrStateInfos *p = [[ProvinceOrStateInfos alloc] init];
                                    for (NSString *key1 in dic1) {
                                        if ([p respondsToSelector:NSSelectorFromString(key1)]) {
                                            if ([key1 isEqualToString:@"cities"]) {
                                                NSArray *arr_cities = [dic1 valueForKey:key1];
                                                NSMutableArray *tempArr1 = [[NSMutableArray alloc] init];
                                                if (arr_cities.count > 0) {
                                                    for (NSDictionary *ddd in arr_cities) {
                                                        CityInfo *ci = [Utils DictionaryToObject:@"CityInfo" dic:ddd];
                                                        [tempArr1 addObject:ci];
                                                    }
                                                }
                                                p.cities = tempArr1;
                                            }else{
                                                [p setValue:[dic1 valueForKey:key1] forKey:key1];
                                            }
                                        }
                                    }
                                    [tempArr addObject:p];
                                }
                            }
                            c.provinceOrStateInfos = tempArr;
                        }else if ([key isEqualToString:@"sortOptions"]) {
                            NSArray *arr_sort = [d valueForKey:key];
                            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                            if (arr_sort.count > 0) {
                                for (NSDictionary *dic1 in arr_sort) {
                                    sortOptions *s = [[sortOptions alloc] init];
                                    for (NSString *key1 in dic1) {
                                        if ([s respondsToSelector:NSSelectorFromString(key1)]) {
                                            [s setValue:[dic1 valueForKey:key1] forKey:key1];
                                        }
                                    }
                                    [tempArr addObject:s];
                                }
                            }
                            c.sortOptions = tempArr;
                        }else{
                           [c setValue:[d valueForKey:key] forKey:key];
                        }
                       
                    }
                }
                [self.responseCountryInfoArray addObject:c];
            }
        }
    }
    return self;
}


@end
