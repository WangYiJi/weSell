//
//  ResponseSellPost.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseSellPosts.h"

//@implementation Coordination
//@synthesize Coordination;
//@synthesize lattitude;
//
//@end

//@implementation Address
//@synthesize streetLine1;
//@synthesize streetLine2;
//@synthesize city;
//@synthesize cityId;
//@synthesize provinceOrStateCode;
//@synthesize countryCode;
//@synthesize postalCode;
//
//@end
//
//@implementation Price
//@synthesize value;
//@synthesize currency;
//
//@end

@implementation SellPost
@synthesize postId;
@synthesize categoryPath;
@synthesize title;
@synthesize description;
@synthesize thumbnailUrl;
@synthesize photoUrls;
@synthesize price;
@synthesize conditionLevel;
@synthesize tags;
@synthesize address;
@synthesize coordination;
@synthesize status;
@synthesize sellType;
@synthesize userId;
@synthesize userDiapName;
@synthesize createdAt;
@synthesize modifiedAt;
@synthesize favoriteCnt;
@synthesize firmPrice;

@end

@implementation ResponseSellPosts
@synthesize responseSellPostsArray;

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSArray class]]) {
            self.responseSellPostsArray = [[NSMutableArray alloc] init];
            NSArray *a = (NSArray*)dic;
            for (NSDictionary *d in a) {
                SellPost *c = [[SellPost alloc] init];
                c.postId = [d objectForKey:@"postId"];
                c.categoryPath = [d objectForKey:@"categoryPath"];
                c.title = [d objectForKey:@"title"];
                c.description = [d objectForKey:@"description"];
                c.thumbnailUrl = [d objectForKey:@"thumbnailUrl"];
                c.photoUrls = [d objectForKey:@"photoUrls"];
//                c.price = [d objectForKey:@"price"];
                c.conditionLevel = [d objectForKey:@"conditionLevel"];
                c.tags = [d objectForKey:@"tags"];
//                c.address = [d objectForKey:@"address"];
//                c.coordination = [d objectForKey:@"coordination"];
                c.status = [d objectForKey:@"status"];
                c.sellType = [d objectForKey:@"sellType"];
                c.userId = [d objectForKey:@"userId"];
                c.userDiapName = [d objectForKey:@"userDiapName"];
                c.createdAt = [d objectForKey:@"createdAt"];
                c.modifiedAt = [d objectForKey:@"modifiedAt"];
                c.favoriteCnt = [[d objectForKey:@"favoriteCnt"] integerValue];
                c.firmPrice = [NSNumber numberWithBool:[[d objectForKey:@"firmPrice"] boolValue]];
                [self.responseSellPostsArray addObject:c];
            }
        }
    }
    return self;
}

@end
