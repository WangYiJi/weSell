//
//  ChatHistoryEntity.m
//  WyjDemo
//
//  Created by wyj on 15/12/22.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ChatHistoryEntity.h"
#import "ChatContactsEntity.h"
#import "DBhelper.h"
#import "Global.h"
#import "UserMember.h"

@implementation ChatHistoryEntity

// Insert code here to add functionality to your managed object subclass

+(NSMutableArray*)getHistoryEntityByMsgId:(NSString*)sId
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"msgId == %@ AND owner == %@",sId,[UserMember getInstance].userId];
    NSMutableArray *a = [DBhelper searchWithPredicateByEntity:def_DB_ChatHistory withKeys:p];
    return a;
}

+(ChatHistoryEntity*)saveWithChatDictonary:(NSDictionary*)dic
{
    NSMutableArray *array = [ChatHistoryEntity getHistoryEntityByMsgId:[dic objectForKey:@"MsgId"]];
    ChatHistoryEntity *entity = nil;
    if (array.count <= 0) {
        entity = [DBhelper insertWithEntity:def_DB_ChatHistory];
    } else {
        entity = [array lastObject];
    }

    entity.isImg = [NSNumber numberWithBool:[[dic objectForKey:@"Type"] isEqualToString:def_chat_get_Img_result]];
    
    entity.userFromId = [dic objectForKey:@"From"];
    entity.msgId = [dic objectForKey:@"MsgId"];
    entity.msg = [dic objectForKey:@"Payload"];
    entity.sendTime = [dic objectForKey:@"ReceivedAt"];
    entity.userToId = [dic objectForKey:@"To"];
    entity.owner = [UserMember getInstance].userId;
    return entity;
}

+(ChatHistoryEntity*)saveWithSendChatDictonary:(NSDictionary*)dic contacts:(ChatContactsEntity*)contact
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:def_serverTimeDF];
    
    ChatHistoryEntity *entity = [DBhelper insertWithEntity:@"ChatHistoryEntity"];
    
    entity.isImg = [NSNumber numberWithBool:[[dic objectForKey:@"Type"] isEqualToString:def_chat_get_Img_result]];
    entity.isLocal = [NSNumber numberWithBool:[[dic objectForKey:@"Type"] isEqualToString:def_chat_get_Img_result]];
    entity.msgId = [dic objectForKey:@"MsgId"];
    entity.userFromId = [UserMember getInstance].userId;
    entity.userToId = [dic objectForKey:@"To"];
    entity.msg = [dic objectForKey:@"Payload"];
    entity.owner = [UserMember getInstance].userId;
    entity.sendTime = [df stringFromDate:[NSDate date]];
    
    if ([entity.isImg boolValue]) {
        contact.lastMsg = @"[图片]";
    } else {
        contact.lastMsg = [dic objectForKey:@"Payload"];
    }
    contact.lastTime = entity.sendTime;
    entity.contactsShip = contact;
    
    [DBhelper Save];
    return entity;
}

+(ChatHistoryEntity*)saveWithChatHistory:(chatHistory*)history
{
    NSMutableArray *array = [ChatHistoryEntity getHistoryEntityByMsgId:history.MsgId];
    ChatHistoryEntity *hEntity = nil;
    if (array.count <= 0) {
        hEntity = [DBhelper insertWithEntity:def_DB_ChatHistory];
    } else {
        hEntity = [array lastObject];
    }
    
    hEntity.isImg = [NSNumber numberWithBool:[history.Type isEqualToString:def_chat_get_Img_result]];
    
    hEntity.msgId = history.MsgId;
    hEntity.userFromId = history.From;
    hEntity.userToId = history.To;
    hEntity.msg = history.Payload;
    hEntity.sendTime = history.ReceivedAt;
    hEntity.owner = [UserMember getInstance].userId;
    return hEntity;
}


@end
