//
//  ResponseFileUpload.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/27.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseFileUpload.h"

@implementation ResponseFileUpload
@synthesize url;
@synthesize method;
@synthesize contentType;
@synthesize accessUrl;

- (id)initwithJson:(id)dic{
    if ([self init]){
        if ([dic isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in dic) {
                if ([self respondsToSelector:NSSelectorFromString(key)]){
                    [self setValue:[dic valueForKey:key] forKey:key];
                }
            }
        }
    
    }
    return self;
}
@end
