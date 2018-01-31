

//
//  ResponseGetChatUserAsBuyer.m
//  WyjDemo
//
//  Created by zjb on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResponseGetChatUserAsBuyer.h"

@implementation ResponseGetChatUserAsBuyer
@synthesize page;
@synthesize pageSize;
@synthesize hasNext;
@synthesize resultArray;

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in dic){
                if ([key isEqualToString:@"result"]) {
                    self.resultArray = [[NSMutableArray alloc] init];
                    NSMutableArray *results = [dic objectForKey:@"result"];
                    for (NSDictionary *d in results) {
                        ChattedUser *user = [[ChattedUser alloc] init];
                        for (NSString *key1 in d) {
                            if ([user respondsToSelector:NSSelectorFromString(key1)]){
                                if ([key1 isEqualToString:@"id"]) {
                                    [user setChati:[d objectForKey:@"id"]];
                                }else {
                                    [user setValue:[d valueForKey:key1] forKey:key1];
                                }
                            }
                        }
                        
                        [self.resultArray addObject:user];
                    }
                } else {
                    if ([self respondsToSelector:NSSelectorFromString(key)]){
                        [self setValue:[dic valueForKey:key] forKey:key];
                    }
                }
            }
        }
    }
    return self;
}
@end
