//
//  ResponseZipCodeInfo.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseZipCodeInfo.h"

@implementation ResponseZipCodeInfo
@synthesize zipCode;
@synthesize cityData;
@synthesize coordination;
@synthesize countryCode;

- (id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.zipCode= [dic objectForKey:@"zipCode"];
//            self.cityData = [dic objectForKey:@"cityData"];
            self.countryCode = [dic objectForKey:@"countryCode"];
//            self.coordination = [dic objectForKey:@"coordination"];

        }
    }
    return self;
}
@end
