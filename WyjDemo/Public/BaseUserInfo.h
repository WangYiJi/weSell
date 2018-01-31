//
//  BaseUserInfo.h
//  WyjDemo
//
//  Created by wyj on 16/1/22.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseUserInfo : NSObject
@property (nonatomic,copy) NSString *authType;
@property (nonatomic,copy) NSString *avatarLargeUrl;
@property (nonatomic,copy) NSString *avatarSmallUrl;
@property (nonatomic,copy) NSString *avatarUrl;
@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *goodSeller;
@property (nonatomic,copy) NSString *guaranteedSeller;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *lastSelectedCityId;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *signingKey;
@property (nonatomic,copy) NSString *scopes;
@property (nonatomic,copy) NSString *maxNumberOfPicturesPerPost;

-(id)initWithDic:(NSMutableDictionary*)dic;


@end
