//
//  ResponseSellPostQuery.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/12.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseSellPostQuery.h"
#import "Utils.h"
@implementation ResponseSellPostQuery
//@synthesize hasNext;
//@synthesize page;
//@synthesize pageSize;
@synthesize result;

- (id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]){
            self.hasNext = [dic objectForKey:@"hasNext"];
            self.page = [dic objectForKey:@"page"];
            self.pageSize = [dic objectForKey:@"pageSize"];
        
            self.result = [[NSMutableArray alloc] init];
            NSArray *results = [dic objectForKey:@"result"];
            for (NSDictionary *d in results) {
                SellPostQueryResult *sPQR = [self SellPostQueryResultFromDic:d];
                [self.result addObject:sPQR];
            }
        }
        
    }
    return self;
    
}

- (SellPostQueryResult *)SellPostQueryResultFromDic:(NSDictionary *)d{
    SellPostQueryResult *sPQR = [[SellPostQueryResult alloc] init];
    for (NSString *key in d) {
        if ([sPQR respondsToSelector:NSSelectorFromString(key)]) {
            if ([key isEqualToString:@"thumbnailPhoto"]){
                NSDictionary *dic_thumbnailPhoto = [d objectForKey:key];
                sPQR.thumbnailPhoto = [Utils DictionaryToObject:@"ThumbnailPhoto" dic:dic_thumbnailPhoto];
            }else if ([key isEqualToString:@"address"]){
                NSDictionary *dic_address = [d objectForKey:key];
                sPQR.address = [Utils DictionaryToObject:@"Address" dic:dic_address];
            }else if ([key isEqualToString:@"coordination"]){
                NSDictionary *dic_coordination = [d objectForKey:key];
                sPQR.coordination = [Utils DictionaryToObject:@"Coordination" dic:dic_coordination];
            }else if ([key isEqualToString:@"conditionLevel"]){
                NSDictionary *dic_conditionLevel = [d objectForKey:key];
                sPQR.conditionLevel = [Utils DictionaryToObject:@"conditionLevel" dic:dic_conditionLevel];
            }else if ([key isEqualToString:@"price"]){
                NSDictionary *dic_price = [d objectForKey:key];
                sPQR.price = [Utils DictionaryToObject:@"Price" dic:dic_price];
            }else if ([key isEqualToString:@"photos"]){
                NSArray *arr_photos = [d objectForKey:key];
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                if ((NSNull *)arr_photos != [NSNull null]) {
                    if (arr_photos.count >0) {
                        for (NSDictionary *tempDic in arr_photos) {
                            Photos *p = [Utils DictionaryToObject:@"Photos" dic:tempDic];
                            [tempArr addObject:p];
                        }
                    }
                }
                sPQR.photos = tempArr;
            }else if ([key isEqualToString:@"sponsoredAds"]){
                NSArray *arr_photos = [d objectForKey:key];
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                if ((NSNull *)arr_photos != [NSNull null]) {
                    if (arr_photos.count >0) {
                        for (NSDictionary *tempDic in arr_photos) {
                            SellPostQueryResult *p = [self SellPostQueryResultFromDic:tempDic];
                            [tempArr addObject:p];
                        }
                    }
                }
                sPQR.sponsoredAds = tempArr;
            }else {
                [sPQR setValue:[d valueForKey:key] forKey:key];
            }
        }
    }
    return sPQR;
}
@end

@implementation Address
//@synthesize city;
@synthesize cityId;
@synthesize countryCode;
@synthesize postalCode;
@synthesize provinceOrStateCode;
@synthesize streetLine1;
@synthesize streetLine2;
@end

@implementation Photos
@synthesize height;
@synthesize width;
@synthesize imageUrl;
@synthesize smallImageUrl;

@end

@implementation Price
@synthesize currency;
@synthesize currencySymbol;
@synthesize value;

@end

@implementation ThumbnailPhoto
@synthesize height;
@synthesize width;
@synthesize imageUrl;
@synthesize smallImageUrl;

@end

@implementation Coordination
@synthesize longitude;
@synthesize lattitude;

@end

@implementation SellPostQueryResult
@synthesize address;
@synthesize categoryPath;
@synthesize conditionLevel;
@synthesize coordination;
@synthesize createdAt;
@synthesize details;
@synthesize favoriteCnt;
@synthesize firmPrice;
@synthesize modifiedAt;
@synthesize photos;
@synthesize postId;
@synthesize price;
@synthesize sellType;
@synthesize sponsoredAds;
@synthesize status;
@synthesize tags;
@synthesize title;
@synthesize userDiapName;
@synthesize userId;
@synthesize thumbnailPhoto;
@end