//
//  ResponseCountryCode.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseCountryCode.h"

@implementation ResponseCountryCode
@synthesize countryInfo;
-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.countryInfo = [[CountryInfo alloc] init];
            self.countryInfo.countryCode = [dic objectForKey:@"countryCode"];
            
        }
    }
    return self;
}

@end
