//
//  ResponseGetFavoritePosts.m
//  WyjDemo
//
//  Created by Jabir on 16/2/28.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResponseGetFavoritePosts.h"

@implementation FavoritePost
@synthesize favoriteId;
@synthesize userId;
@synthesize sellPostId;
@synthesize type;

@end

@implementation ResponseGetFavoritePosts
-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.hasNext = [dic objectForKey:@"hasNext"];
            self.page = [dic objectForKey:@"page"];
            self.pageSize = [dic objectForKey:@"pageSize"];
            self.result = [[NSMutableArray alloc] init];
            NSArray *a = [dic objectForKey:@"result"];
            for (NSDictionary *d in a) {
                FavoritePost *c = [[FavoritePost alloc] init];
                c.favoriteId = [d objectForKey:@"favoriteId"];
                c.userId = [d objectForKey:@"userId"];
                c.sellPostId = [d objectForKey:@"sellPostId"];
                c.type = [d objectForKey:@"type"];
                [self.result addObject:c];
            }
        }
    }
    return self;
}
@end
