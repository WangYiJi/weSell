//
//  ChatContactsEntity+CoreDataProperties.h
//  WyjDemo
//
//  Created by Alex on 16/2/4.
//  Copyright © 2016年 wyj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatContactsEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatContactsEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *lastMsg;
@property (nullable, nonatomic, retain) NSString *lastTime;
@property (nullable, nonatomic, retain) NSString *logoName;
@property (nullable, nonatomic, retain) NSString *owner;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSSet<ChatHistoryEntity *> *historyShip;

@end

@interface ChatContactsEntity (CoreDataGeneratedAccessors)

- (void)addHistoryShipObject:(ChatHistoryEntity *)value;
- (void)removeHistoryShipObject:(ChatHistoryEntity *)value;
- (void)addHistoryShip:(NSSet<ChatHistoryEntity *> *)values;
- (void)removeHistoryShip:(NSSet<ChatHistoryEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
