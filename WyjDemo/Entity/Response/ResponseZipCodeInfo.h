//
//  ResponseZipCodeInfo.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseCountry.h"
#import "ResponseSellPosts.h"

@interface ResponseZipCodeInfo : NSObject
@property (nonatomic,copy)NSString *zipCode;
@property (nonatomic,strong)CityInfo *cityData;
@property (nonatomic,copy)NSString *countryCode;
@property (nonatomic,strong)Coordination *coordination;

-(id)initwithJson:(id)dic;

@end
