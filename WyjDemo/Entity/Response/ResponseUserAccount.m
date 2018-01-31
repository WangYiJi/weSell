//
//  ResponseUserAccount.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseUserAccount.h"

@implementation ResponseUserAccount
@synthesize userId;
@synthesize displayName;
@synthesize firstName;
@synthesize lastName;
@synthesize avatarUrl;
@synthesize email;
@synthesize authType;
@synthesize status;
@synthesize avatarSmallUrl;
@synthesize avatarLargeUrl;
@synthesize lastSelectedCityId;
@synthesize goodSeller;
@synthesize guaranteedSeller;

- (id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.userId= [dic objectForKey:@"userId"];
            self.displayName = [dic objectForKey:@"displayName"];
            self.firstName = [dic objectForKey:@"firstName"];
            self.lastName = [dic objectForKey:@"lastName"];
            self.avatarUrl = [dic objectForKey:@"avatarUrl"];
            self.email = [dic objectForKey:@"email"];
            self.authType = [dic objectForKey:@"authType"];
            self.status = [dic objectForKey:@"status"];
            self.avatarSmallUrl = [dic objectForKey:@"avatarSmallUrl"];
            self.avatarLargeUrl = [dic objectForKey:@"avatarLargeUrl"];
            self.lastSelectedCityId = [dic objectForKey:@"lastSelectedCityId"];
            self.goodSeller = [dic objectForKey:@"goodSeller"];
            self.guaranteedSeller = [dic objectForKey:@"guaranteedSeller"];
        }
    }
    return self;
}

@end
