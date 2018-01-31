//
//  ResponseSlicedSellPostResult.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseSlicedSellPostResult.h"

@implementation ResponseSlicedSellPostResult

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.page = [[dic objectForKey:@"page"] integerValue];
            self.pageSize = [[dic objectForKey:@"pageSize"] integerValue];
            self.hasNext = [[dic objectForKey:@"hasNext"] boolValue];
            self.result = [self arrayWithJson:[dic objectForKey:@"result"]];
        }
    }
    return self;
}

- (NSMutableArray *)arrayWithJson:(NSArray *)arr{
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in arr) {
        SellPost *sellPost = [[SellPost alloc] init];
        sellPost.postId = [dic objectForKey:@"postId"];
        sellPost.categoryPath = [dic objectForKey:@"categoryPath"];
        sellPost.title = [dic objectForKey:@"title"];
        sellPost.description = [dic objectForKey:@"description"];
        sellPost.thumbnailUrl = [dic objectForKey:@"thumbnailUrl"];
        sellPost.photoUrls = [dic objectForKey:@"photoUrls"];
        //                sellPost.price = [dic objectForKey:@"price"];
        sellPost.conditionLevel = [dic objectForKey:@"conditionLevel"];
        sellPost.tags = [dic objectForKey:@"tags"];
        //                sellPost.address = [dic objectForKey:@"address"];
        //                sellPost.coordination = [dic objectForKey:@"coordination"];
        sellPost.status = [dic objectForKey:@"status"];
        sellPost.sellType = [dic objectForKey:@"sellType"];
        sellPost.userId = [dic objectForKey:@"userId"];
        sellPost.userDiapName = [dic objectForKey:@"userDiapName"];
        sellPost.createdAt = [dic objectForKey:@"createdAt"];
        sellPost.modifiedAt = [dic objectForKey:@"modifiedAt"];
        sellPost.favoriteCnt = [[dic objectForKey:@"favoriteCnt"] integerValue];
        sellPost.firmPrice = [NSNumber numberWithBool:[[dic objectForKey:@"firmPrice"] boolValue]];
    }
    
    return resultArr;
}

@end
