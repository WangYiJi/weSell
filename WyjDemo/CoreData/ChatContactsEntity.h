//
//  ChatContactsEntity.h
//  WyjDemo
//
//  Created by wyj on 15/12/22.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ChatQueryResponse.h"

@class ChatHistoryEntity;

NS_ASSUME_NONNULL_BEGIN

@interface ChatContactsEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(ChatContactsEntity*)insertContactsByChatContacts:(chatContacts*)cc;
+(ChatContactsEntity*)insertContactsByUserId:(NSString*)sId;

+(NSMutableArray*)getContactsSortByTime;
+(NSMutableArray*)getContactsByUserId:(NSString*)sUserId;
+(NSMutableArray*)getHistorySortByTime:(NSSet*)history;
@end

NS_ASSUME_NONNULL_END

#import "ChatContactsEntity+CoreDataProperties.h"
