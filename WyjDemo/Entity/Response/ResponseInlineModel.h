//
//  ResponseInlineModel.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccountPublicInfo : NSObject
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *displayName;
@property (nonatomic,copy)NSString *avatarUrl;

@end

@interface ResponseInlineModel : NSObject
@property (nonatomic,strong)NSMutableArray *responseInlineModelArray;

-(id)initwithJson:(id)dic;

@end
