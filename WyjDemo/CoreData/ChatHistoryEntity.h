//
//  ChatHistoryEntity.h
//  WyjDemo
//
//  Created by wyj on 15/12/22.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ChatQueryResponse.h"

@class ChatContactsEntity;

NS_ASSUME_NONNULL_BEGIN

@interface ChatHistoryEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(NSMutableArray*)getHistoryEntityByMsgId:(NSString*)sId;

+(ChatHistoryEntity*)saveWithChatDictonary:(NSDictionary*)dic;

+(ChatHistoryEntity*)saveWithSendChatDictonary:(NSDictionary*)dic contacts:(ChatContactsEntity*)contact;

+(ChatHistoryEntity*)saveWithChatHistory:(chatHistory*)history;
@end

NS_ASSUME_NONNULL_END

#import "ChatHistoryEntity+CoreDataProperties.h"
