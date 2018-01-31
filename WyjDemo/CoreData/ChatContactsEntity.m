//
//  ChatContactsEntity.m
//  WyjDemo
//
//  Created by wyj on 15/12/22.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ChatContactsEntity.h"
#import "ChatHistoryEntity.h"
#import "DBhelper.h"
#import "Global.h"
#import "UserMember.h"
#import "PublicUserEntity.h"
#import "NetworkEngine.h"
#import "ResponseInlineModel.h"

@implementation ChatContactsEntity

// Insert code here to add functionality to your managed object subclass

//By Response
+(ChatContactsEntity*)insertContactsByChatContacts:(chatContacts*)cc
{
    NSMutableArray *contacts = [ChatContactsEntity getContactsByUserId:cc.UserId];
    if (contacts.count <= 0) {
        ChatContactsEntity *cEntity = [DBhelper insertWithEntity:def_DB_ChatContacts];
        cEntity.userId = cc.UserId;
        cEntity.owner = [UserMember getInstance].userId;
        
        [ChatContactsEntity upDataUserName:cc.UserId contacts:cEntity];
        
        return cEntity;
    } else {
        return [contacts lastObject];
    }
}

+(void)upDataUserName:(NSString*)sUserId contacts:(ChatContactsEntity*)cEntity
{
    PublicUserEntity *entity = [[PublicUserEntity alloc] init];
    entity.userIds = sUserId;
    [NetworkEngine getJSONWithUrl:entity success:^(id json) {
        ResponseInlineModel *response = [[ResponseInlineModel alloc] initwithJson:json];
        UserAccountPublicInfo *item = [response.responseInlineModelArray lastObject];
        
        cEntity.userName = item.displayName;
        cEntity.logoName = item.avatarUrl;
        
        [DBhelper Save];
    } fail:^(NSError *error) {
        
    }];
}

//By UserId
+(ChatContactsEntity*)insertContactsByUserId:(NSString*)sId
{
    NSMutableArray *contacts = [ChatContactsEntity getContactsByUserId:sId];
    if (contacts.count <= 0) {
        ChatContactsEntity *cEntity = [DBhelper insertWithEntity:def_DB_ChatContacts];
        cEntity.userId = sId;
        cEntity.owner = [UserMember getInstance].userId;
        [ChatContactsEntity upDataUserName:sId contacts:cEntity];
        return cEntity;
    } else {
        return [contacts lastObject];
    }
}

+(NSMutableArray*)getContactsSortByTime
{
    //只查询当前用户的记录
    NSPredicate *p = [NSPredicate predicateWithFormat:@"owner == %@",[UserMember getInstance].userId];
    NSMutableArray *contactTemp = [DBhelper searchWithPredicateByEntity:def_DB_ChatContacts withKeys:p];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"lastTime" ascending:YES];
    [contactTemp sortUsingDescriptors:[NSArray arrayWithObject:sd]];
    return contactTemp;
}

+(NSMutableArray*)getContactsByUserId:(NSString*)sUserId
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"userId == %@ AND owner == %@",sUserId,[UserMember getInstance].userId];
    NSMutableArray *a = [DBhelper searchWithPredicateByEntity:def_DB_ChatContacts withKeys:p];
    return a;
}

+(NSMutableArray*)getHistorySortByTime:(NSSet*)history
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[history allObjects]];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"sendTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    
    [array sortUsingDescriptors:sortDescriptors];
    //[array sortedArrayUsingDescriptors:sortDescriptors];
    return array;
}
@end
