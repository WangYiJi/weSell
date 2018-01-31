//
//  ResponseByIds.m
//  WyjDemo
//
//  Created by 霍霍 on 16/1/5.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResponseByIds.h"
#import "Utils.h"

@implementation ResponseByIds
@synthesize ArraySellPost;

- (id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSArray class]]){
            
            self.ArraySellPost = [[NSMutableArray alloc] init];
            for (NSDictionary *d in dic) {
                SellPostQueryResult *sPQR = [self SellPostQueryResultFromDic:d];
                [self.ArraySellPost addObject:sPQR];
            }
        }
        
    }
    return self;
    
}

- (SellPostQueryResult *)SellPostQueryResultFromDic:(NSDictionary *)d{
    SellPostQueryResult *sPQR = [[SellPostQueryResult alloc] init];
    for (NSString *key in d) {
        if ([sPQR respondsToSelector:NSSelectorFromString(key)]) {
            NSString *str = [d valueForKey:key];
            if ((NSNull *)str != [NSNull null]) {
                if ([key isEqualToString:@"thumbnailPhoto"]){
                    NSDictionary *dic_thumbnailPhoto = [d objectForKey:key];
                    sPQR.thumbnailPhoto = [Utils DictionaryToObject:@"ThumbnailPhoto" dic:dic_thumbnailPhoto];
                }else if ([key isEqualToString:@"address"]){
                    NSDictionary *dic_address = [d objectForKey:key];
                    sPQR.address = [Utils DictionaryToObject:@"Address" dic:dic_address];
                }else if ([key isEqualToString:@"coordination"]){
                    NSDictionary *dic_coordination = [d objectForKey:key];
                    sPQR.coordination = [Utils DictionaryToObject:@"Coordination" dic:dic_coordination];
                }else if ([key isEqualToString:@"price"]){
                    NSDictionary *dic_price = [d objectForKey:key];
                    sPQR.price = [Utils DictionaryToObject:@"Price" dic:dic_price];
                }else if ([key isEqualToString:@"photos"]){
                    NSArray *arr_photos = [d objectForKey:key];
                    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                    if ((NSNull *)arr_photos != [NSNull null]){
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
    }
    return sPQR;
}
@end
