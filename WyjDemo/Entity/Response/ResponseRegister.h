//
//  ResponseRegister.h
//  WyjDemo
//
//  Created by 霍霍 on 15/12/8.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseRegister : NSObject
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *displayName;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *avatarUrl;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *authType;
@property (nonatomic,strong) NSString *status;

-(id)initwithJson:(id)dic;
@end
