//
//  ChatTools.h
//  WyjDemo
//
//  Created by wyj on 15/11/5.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "ChatQueryResponse.h"
#import "ChatHistoryEntity.h"
#import <UIKit/UIKit.h>


@protocol ChatToolsDelegate <NSObject>
@optional
-(void)sendMessageError;
-(void)socketOpenDelegate;

@end

@interface ChatTools : NSObject
<
    SRWebSocketDelegate
>
@property (nonatomic,strong) SRWebSocket *_webSocket;
@property (nonatomic,weak) id<ChatToolsDelegate> delegate;
@property (nonatomic,copy) NSString *sImageFilePath;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

//界面用
@property (nonatomic,strong) NSMutableArray *contactsArray;

+(ChatTools*)getInstance;

//*********************************************************
//Socket Action
-(void)openSocket;
-(void)setToken;
//*********************************************************

//*********************************************************
//Chat Action
//创建令牌
+(NSString*)createChatToken:(NSString*)userId reportTime:(NSTimeInterval)sReportTime signingKey:(NSString*)sSigningKey;

//组装发送字典
+(NSMutableDictionary*)createSendMsgDic:(NSString*)sMsg toUserId:(NSString*)sToUserId isImg:(BOOL)bIsImg;

//发送文字
+(ChatHistoryEntity*)sendMessage:(NSString*)sMsg toUserId:(NSString*)sToUserId contacts:(ChatContactsEntity*)contact isImg:(BOOL)bIsImg;

//发送图片(Before)
+(NSArray*)sendImgMessage:(NSString*)sMsg toUserId:(NSString*)sToUserId contacts:(ChatContactsEntity*)contact isImg:(BOOL)bIsImg;

//发送图片(After)
+(void)upDataMsgAndSend:(NSString*)sUrl structs:(NSMutableDictionary*)structs;
//*********************************************************

//*********************************************************
//DataBase Action
-(void)getHistory;
-(void)getContacts;
-(void)saveContactsToDB:(ChatQueryResponse*)response;
-(void)saveHistoryToDB:(ChatQueryResponse*)response;
-(ChatHistoryEntity*)saveChatToDB:(NSDictionary*)response isImg:(BOOL)bIsImg;
-(void)refreshDB;
-(void)chatSearch:(NSString*)sSearchType;
+(void)refreshSendTime;
//*********************************************************

//*********************************************************
//Document Action
+(NSString*)saveToDocument:(UIImage *)image;
+(NSString*)imageSavedPath:(NSString *)imageName;
+(NSString*)getImageFilePath;
//*********************************************************
@end


