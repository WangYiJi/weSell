//
//  ResponseLoginInfo.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseLoginInfo.h"

@implementation ResponseLoginInfo
@synthesize userId;
@synthesize displayName;
@synthesize firstName;
@synthesize lastName;
@synthesize avatarUrl;
@synthesize email;
@synthesize authType;
@synthesize status;
@synthesize signingKey;
@synthesize scopes;
@synthesize avatarLargeUrl;
@synthesize avatarSmallUrl;
@synthesize goodSeller;
@synthesize guaranteedSeller;
@synthesize lastSelectedCityId;

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
            self.signingKey = [dic objectForKey:@"signingKey"];
            self.scopes = [dic objectForKey:@"scopes"];
            self.avatarLargeUrl = [dic objectForKey:@"avatarLargeUrl"];
            self.avatarSmallUrl = [dic objectForKey:@"avatarSmallUrl"];
            self.goodSeller = [dic objectForKey:@"goodSeller"];
            self.guaranteedSeller = [dic objectForKey:@"guaranteedSeller"];
            self.lastSelectedCityId = [dic objectForKey:@"lastSelectedCityId"];
        }
    }
    return self;
}

@end
