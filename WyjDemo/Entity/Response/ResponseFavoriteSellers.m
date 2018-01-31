//
//  ResponseFavoriteSellers.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/19.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseFavoriteSellers.h"

@implementation FavoriteSeller
@synthesize favoriteId;
@synthesize userId;
@synthesize sellUserId;
@synthesize type;
@end

@implementation ResponseFavoriteSellers
@synthesize responseFavoriteSellersArray;

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSArray class]]) {
            self.responseFavoriteSellersArray = [[NSMutableArray alloc] init];
            NSArray *a = (NSArray*)dic;
            for (NSDictionary *d in a) {
                FavoriteSeller *c = [[FavoriteSeller alloc] init];
                c.favoriteId = [d objectForKey:@"favoriteId"];
                c.userId = [d objectForKey:@"userId"];
                c.sellUserId = [d objectForKey:@"sellUserId"];
                c.type = [d objectForKey:@"type"];
                [self.responseFavoriteSellersArray addObject:c];
            }
        }
    }
    return self;
}

@end
