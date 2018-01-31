//
//  ResponseAbuseType.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseAbuseType.h"

@implementation AbuseType
@synthesize aid;
@synthesize abuseItemType;
@synthesize abuseType;
@synthesize displayName;
@end

@implementation ResponseAbuseType
@synthesize responseAbuseTypeArray;
-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSArray class]]) {
            self.responseAbuseTypeArray = [[NSMutableArray alloc] init];
            NSArray *a = (NSArray*)dic;
            for (NSDictionary *d in a) {
                AbuseType *c = [[AbuseType alloc] init];
                c.aid = [d objectForKey:@"id"];
                c.abuseItemType = [d objectForKey:@"abuseItemType"];
                c.abuseType = [d objectForKey:@"abuseType"];
                c.displayName = [d objectForKey:@"displayName"];
                [self.responseAbuseTypeArray addObject:c];
            }
        }
    }
    return self;
}

@end
