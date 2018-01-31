//
//  ResponseDeviceKey.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/19.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseDeviceKey : NSObject
@property (nonatomic,copy)NSString *dId;
@property (nonatomic,copy)NSString *mobilePlatform;
@property (nonatomic,copy)NSString *deviceId;
@property (nonatomic,copy)NSString *signingKey;

-(id)initwithJson:(id)dic;

@end
