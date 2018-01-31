//
//  ResponseCreateFavoriteSellers.m
//  WyjDemo
//
//  Created by Jabir on 16/2/23.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResponseCreateFavoriteSellers.h"

@implementation ResponseCreateFavoriteSellers
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
