//
//  ResponseFavoriteSeller.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/19.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseFavoriteSeller.h"

@implementation ResponseFavoriteSeller
@synthesize favoriteSeller;

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.favoriteSeller = [[FavoriteSeller alloc] init];
            self.favoriteSeller.favoriteId = [dic objectForKey:@"favoriteId"];
            self.favoriteSeller.userId = [dic objectForKey:@"userId"];
            self.favoriteSeller.sellUserId = [dic objectForKey:@"sellUserId"];
            self.favoriteSeller.type = [dic objectForKey:@"type"];
        }
    }
    return self;
}
@end
