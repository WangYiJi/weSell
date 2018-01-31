//
//  ChatHistoryEntity+CoreDataProperties.h
//  WyjDemo
//
//  Created by Alex on 16/2/4.
//  Copyright © 2016年 wyj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatHistoryEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatHistoryEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isImg;
@property (nullable, nonatomic, retain) NSNumber *isLocal;
@property (nullable, nonatomic, retain) NSString *msg;
@property (nullable, nonatomic, retain) NSString *msgId;
@property (nullable, nonatomic, retain) NSString *owner;
@property (nullable, nonatomic, retain) NSString *sendTime;
@property (nullable, nonatomic, retain) NSString *userFromId;
@property (nullable, nonatomic, retain) NSString *userFromName;
@property (nullable, nonatomic, retain) NSString *userToId;
@property (nullable, nonatomic, retain) NSString *userToName;
@property (nullable, nonatomic, retain) ChatContactsEntity *contactsShip;

@end

NS_ASSUME_NONNULL_END
