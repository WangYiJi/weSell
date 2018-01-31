//
//  ResponseAddFriendTemplate.m
//  WyjDemo
//
//  Created by Alex on 16/6/17.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResponseAddFriendTemplate.h"

@implementation ResponseAddFriendTemplate
@synthesize messageTemplateId;
@synthesize displayName;

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in dic){
                if ([self respondsToSelector:NSSelectorFromString(key)]){
                    [self setValue:[dic valueForKey:key] forKey:key];
                }
            }
            
        }
    }
    return self;
}
@end
