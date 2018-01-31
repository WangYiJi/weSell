//
//  ResponseInlineModel.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseInlineModel.h"

@implementation UserAccountPublicInfo
@synthesize userId;
@synthesize displayName;
@synthesize avatarUrl;

@end

@implementation ResponseInlineModel
@synthesize responseInlineModelArray;

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSArray class]]) {
            self.responseInlineModelArray = [[NSMutableArray alloc] init];
            NSArray *a = (NSArray*)dic;
            for (NSDictionary *d in a) {
                UserAccountPublicInfo *c = [[UserAccountPublicInfo alloc] init];
                c.userId = [d objectForKey:@"userId"];
                c.displayName = [d objectForKey:@"displayName"];
                c.avatarUrl = [d objectForKey:@"avatarUrl"];
                [self.responseInlineModelArray addObject:c];
            }
        }
    }
    return self;
}

@end
