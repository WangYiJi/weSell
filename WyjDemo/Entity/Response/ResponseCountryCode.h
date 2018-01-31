//
//  ResponseCountryCode.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseCountry.h"
@interface ResponseCountryCode : NSObject
@property (nonatomic,strong)CountryInfo *countryInfo;

-(id)initwithJson:(id)dic;

@end
