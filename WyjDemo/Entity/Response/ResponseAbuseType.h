//
//  ResponseAbuseType.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AbuseType : NSObject
@property (nonatomic,copy)NSString *aid;
@property (nonatomic,copy)NSString *abuseItemType;
@property (nonatomic,copy)NSString *abuseType;
@property (nonatomic,copy)NSString *displayName;

@end

@interface ResponseAbuseType : NSObject
@property (nonatomic,strong) NSMutableArray *responseAbuseTypeArray;
-(id)initwithJson:(NSDictionary*)dic;
@end
