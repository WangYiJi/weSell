//
//  ResponseDeviceKey.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/19.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseDeviceKey.h"

@implementation ResponseDeviceKey
@synthesize dId;
@synthesize mobilePlatform;
@synthesize deviceId;
@synthesize signingKey;

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.dId = [dic objectForKey:@"id"];
            self.mobilePlatform = [dic objectForKey:@"mobilePlatform"];
            self.deviceId = [dic objectForKey:@"deviceId"];
            self.signingKey = [dic objectForKey:@"signingKey"];
        }
    }
    return self;
}
@end
