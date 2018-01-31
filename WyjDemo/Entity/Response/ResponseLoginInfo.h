//
//  ResponseLoginInfo.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseLoginInfo : NSObject
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *displayName;
@property (nonatomic,copy)NSString *firstName;
@property (nonatomic,copy)NSString *lastName;
@property (nonatomic,copy)NSString *avatarUrl;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *authType;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *signingKey;
@property (nonatomic,strong)NSArray *scopes;
@property (nonatomic,copy)NSString *avatarLargeUrl;
@property (nonatomic,copy)NSString *avatarSmallUrl;
@property (nonatomic,assign)BOOL goodSeller;
@property (nonatomic,assign)BOOL guaranteedSeller;
@property (nonatomic,copy)NSString *lastSelectedCityId;

-(id)initwithJson:(id)dic;

@end
