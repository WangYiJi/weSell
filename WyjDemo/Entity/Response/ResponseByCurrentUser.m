//
//  ResponseByCurrentUser.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ResponseByCurrentUser.h"

@implementation ResponseByCurrentUser
@synthesize aid;
@synthesize abuseItemType;
@synthesize abuseItemId;
@synthesize abuseType;
@synthesize abuseTypeMessage;
@synthesize reportedBy;
@synthesize reportedAt;
@synthesize currentStatus;
@synthesize lastProcessedAt;
@synthesize lastProcessedBy;
@synthesize currentAssignee;

-(id)initwithJson:(id)dic{
    if ([self init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.aid = [dic objectForKey:@"id"];
            self.abuseItemType = [dic objectForKey:@"abuseItemType"];
            self.abuseItemId = [dic objectForKey:@"abuseItemId"];
            self.abuseType = [dic objectForKey:@"abuseType"];
            self.abuseTypeMessage = [dic objectForKey:@"abuseTypeMessage"];
            self.reportedBy = [dic objectForKey:@"reportedBy"];
            self.reportedAt = [dic objectForKey:@"reportedAt"];
            self.currentStatus = [dic objectForKey:@"currentStatus"];
            self.lastProcessedAt = [dic objectForKey:@"lastProcessedAt"];
            self.lastProcessedBy = [dic objectForKey:@"lastProcessedBy"];
            self.currentAssignee = [dic objectForKey:@"currentAssignee"];
        }
    }
    return self;
}

@end
