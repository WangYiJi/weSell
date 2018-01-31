//
//  ResponseAbuseReport.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseAbuseReport : NSObject
@property (nonatomic,copy)NSString *aid;
@property (nonatomic,copy)NSString *abuseItemType;
@property (nonatomic,copy)NSString *abuseItemId;
@property (nonatomic,copy)NSString *abuseType;
@property (nonatomic,copy)NSString *abuseTypeMessage;
@property (nonatomic,copy)NSString *reportedBy;
@property (nonatomic,copy)NSString *reportedAt;
@property (nonatomic,copy)NSString *currentStatus;
@property (nonatomic,copy)NSString *lastProcessedAt;
@property (nonatomic,copy)NSString *lastProcessedBy;
@property (nonatomic,copy)NSString *currentAssignee;

-(id)initwithJson:(id)dic;

@end
