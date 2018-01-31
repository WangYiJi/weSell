//
//  ResponseRegister.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/8.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseRegister.h"

@implementation ResponseRegister
@synthesize userId;
@synthesize displayName;
@synthesize firstName;
@synthesize lastName;
@synthesize avatarUrl;
@synthesize email;
@synthesize authType;
@synthesize status;

-(id)initwithJson:(id)dic{
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
        }
    }
    return self;
}
@end
