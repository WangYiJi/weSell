//
//  ResponseCategory.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseCategory.h"

@implementation CategoryInfo
@synthesize categoryPath;
@synthesize displayName;
@synthesize childCategories;

@end

@implementation ResponseCategory
@synthesize responseCategoryArray;
-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSArray class]]) {
            self.responseCategoryArray = [[NSMutableArray alloc] init];
            NSArray *a = (NSArray*)dic;
            for (NSDictionary *d in a) {
                CategoryInfo *c = [[CategoryInfo alloc] init];
                for (NSString *key in d) {
                    if ([c respondsToSelector:NSSelectorFromString(key)]) {
                        if ([key isEqualToString:@"childCategories"]) {
                            NSArray *arr = [d valueForKey:key];
                            NSMutableArray *temparr = [[NSMutableArray alloc] init];
                            for (NSDictionary *d1 in arr) {
                                CategoryInfo *c1 = [[CategoryInfo alloc] init];
                                for (NSString *key1 in d1) {
                                    if ([c1 respondsToSelector:NSSelectorFromString(key1)]) {
                                        if ([key1 isEqualToString:@"childCategories"]) {
                                            
                                        }else {
                                            [c1 setValue:[d1 valueForKey:key1] forKey:key1];
                                        }
                                    }
                                }
                                [temparr addObject:c1];
                            }
                            c.childCategories = temparr;
                        }else {
                            [c setValue:[d valueForKey:key] forKey:key];
                        }
                    }
                }
                [self.responseCategoryArray addObject:c];
            }
        }
    }
    return self;
}
@end
