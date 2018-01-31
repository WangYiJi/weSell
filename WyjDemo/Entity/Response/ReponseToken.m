//
//  ReponseToken.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ReponseToken.h"

@implementation ReponseToken
@synthesize userId;

- (id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.userId= [dic objectForKey:@"userId"];
        }
    }
    return self;
}

@end
