//
//  ResponseChatConnect.m
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResponseChatConnect.h"

@implementation ResponseChatConnect
@synthesize id;
@synthesize userId1;
@synthesize userId2;
@synthesize postId;
@synthesize postOwner;
@synthesize lastChatted;

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in dic){
                if ([key isEqualToString:@"id"]) {
                    [self setChati:[dic objectForKey:@"id"]];
                }else {
                    [self setValue:[dic valueForKey:key] forKey:key];
                }
            }
        }
    }
    return self;
}


@end
