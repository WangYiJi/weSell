//
//  ResponseGetChatUsers.m
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResponseGetChatUsers.h"

@implementation ResponseGetChatUsers
@synthesize page;
@synthesize pageSize;
@synthesize hasNex;
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
                        if ([self respondsToSelector:NSSelectorFromString(key)]){
                            if ([key isEqualToString:@"id"]) {
                                [user setChati:[d objectForKey:@"id"]];
                            }else {
                                [user setValue:[d valueForKey:key] forKey:key];
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


@implementation ChattedUser
@synthesize id;
@synthesize userId1;
@synthesize userId2;
@synthesize postId;
@synthesize postOwner;
@synthesize lastChatted;
@end