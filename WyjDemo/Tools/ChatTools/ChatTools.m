//
//  ChatTools.m
//  WyjDemo
//
//  Created by wyj on 15/11/5.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ChatTools.h"
#import "NSString+SHA256HMAC.h"
#import "UserMember.h"
#import "NSString+GUID.h"
#import "Global.h"
#import "DBhelper.h"
#import "ChatHistoryEntity.h"
#import "ChatContactsEntity.h"



#define def_ChatURL             @"ws://52.91.218.82:8020/chat"
#define def_quyHistory          @"QUERY_CHAT_HISTORY"
#define def_quyContacts         @"QUERY_CONTACTLIST"


//wyj userId fe8c4e6aaa814f5f93a2050a42bfde52
//

@interface ChatTools ()


@end

@implementation ChatTools
@synthesize _webSocket;
@synthesize delegate;
@synthesize contactsArray;
@synthesize sImageFilePath;
@synthesize dateFormatter;

+(ChatTools*)getInstance
{
    static ChatTools *chatInstance = nil;
    if (!chatInstance) {
        chatInstance = [[ChatTools alloc] init];
        chatInstance.contactsArray = [DBhelper searchBy:def_DB_ChatContacts];
        chatInstance.sImageFilePath = [ChatTools getImageFilePath];
        chatInstance.dateFormatter = [[NSDateFormatter alloc] init];
        [chatInstance.dateFormatter setDateFormat:def_serverTimeDF];
    }
    return chatInstance;
}

#pragma mark - Socket Action
-(void)openSocket
{
    if ([UserMember getInstance].isLogin) {
        if (self._webSocket.readyState != SR_OPEN) {
            [self._webSocket open];
        }
    }
}

-(void)setToken
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:def_ChatURL]];
    if ([UserMember getInstance].isLogin) {
        NSString *sToken = [ChatTools createChatToken:[UserMember getInstance].userId
                                           reportTime:[[NSDate date] timeIntervalSince1970]
                                           signingKey:[UserMember getInstance].signingKey];
        
        [request setValue:sToken forHTTPHeaderField:@"Authorization"];
        NSLog(@"token %@",sToken);
    }
    
    self._webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    self._webSocket.delegate = self;
}

#pragma makr - Chat Method
+(NSString*)createChatToken:(NSString*)userId reportTime:(NSTimeInterval)sReportTime signingKey:(NSString*)sSigningKey
{
    NSString *sToken = [NSString stringWithFormat:@"USER:%@:%ld",userId,(long)sReportTime];
    NSString *sSHA = [sToken SHA256HMACWithKey:sSigningKey];
    NSString *sFinal = [NSString stringWithFormat:@"%@:%@",sToken,sSHA];
    return sFinal;
}

+(NSMutableDictionary*)createSendMsgDic:(NSString*)sMsg toUserId:(NSString*)sToUserId isImg:(BOOL)bIsImg
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString GUIDString] forKey:@"MsgId"];
    [dic setValue:sToUserId forKey:@"To"];
    [dic setValue:bIsImg?def_chat_get_Img_result:def_chat_result forKey:@"Type"];
    [dic setValue:sMsg forKey:@"Payload"];
    return dic;
}

+(ChatHistoryEntity*)sendMessage:(NSString*)sMsg toUserId:(NSString*)sToUserId contacts:(ChatContactsEntity*)contact isImg:(BOOL)bIsImg
{
    if ([ChatTools getInstance]._webSocket.readyState == SR_OPEN) {
        NSMutableDictionary *dic = [ChatTools createSendMsgDic:sMsg toUserId:sToUserId isImg:bIsImg];
        
        if ([NSJSONSerialization isValidJSONObject:dic])
        {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[ChatTools getInstance]._webSocket send:json];
            [ChatTools refreshSendTime];
        }
        ChatHistoryEntity *entity = [ChatHistoryEntity saveWithSendChatDictonary:dic contacts:contact];
        return entity;
    } else {
        return nil;
    }
}

+(NSArray*)sendImgMessage:(NSString*)sMsg toUserId:(NSString*)sToUserId contacts:(ChatContactsEntity*)contact isImg:(BOOL)bIsImg
{
    NSMutableDictionary *dic = [ChatTools createSendMsgDic:sMsg toUserId:sToUserId isImg:bIsImg];
    ChatHistoryEntity *entity = [ChatHistoryEntity saveWithSendChatDictonary:dic contacts:contact];
    
    return @[entity,dic];
}

+(void)upDataMsgAndSend:(NSString*)sUrl structs:(NSMutableDictionary*)structs
{
    [structs setValue:sUrl forKey:@"Payload"];
    if ([NSJSONSerialization isValidJSONObject:structs])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:structs options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [[ChatTools getInstance]._webSocket send:json];
        [ChatTools refreshSendTime];
    }
    [DBhelper Save];
}

#pragma makr - DataBase Action
-(void)getHistory
{
    [self chatSearch:def_quyHistory];
}

-(void)getContacts
{
    [self chatSearch:def_quyContacts];
}

-(void)chatSearch:(NSString*)sSearchType
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString GUIDString] forKey:@"MsgId"];
    [dic setValue:sSearchType forKey:@"Type"];
    
    NSString *sDate = [[NSUserDefaults standardUserDefaults] objectForKey:def_lastChatTime];
    if (sDate.length) {
        [dic setValue:sDate forKey:@"Payload"];
    } else {
        [dic setValue:@"2015-10-02T15:00:00Z" forKey:@"Payload"];
   }

    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [[ChatTools getInstance]._webSocket send:json];
    }
}

-(void)saveContactsToDB:(ChatQueryResponse*)response
{
    for (chatContacts *item in response.Payload) {
        NSMutableArray *contacts = [ChatContactsEntity getContactsByUserId:item.UserId];
        //插入联系人
        if (contacts.count <= 0) {
            ChatContactsEntity *cEntity = [ChatContactsEntity insertContactsByChatContacts:item];
            NSLog(@"%@",cEntity);
        }
    }
    [DBhelper Save];
}

-(void)saveHistoryToDB:(ChatQueryResponse*)response
{
    for (chatHistory *hItem in response.Payload) {
        NSMutableArray *array = [ChatHistoryEntity getHistoryEntityByMsgId:hItem.MsgId];
        //插入聊天历史
        if (array.count <= 0) {
            
            NSString *sUserId = @"";
            if ([hItem.From isEqualToString:[UserMember getInstance].userId]) {
                sUserId = hItem.To;
            }
            else if([hItem.To isEqualToString:[UserMember getInstance].userId])  {
                sUserId = hItem.From;
            }
            
            ChatContactsEntity *cEntity = [ChatContactsEntity insertContactsByUserId:sUserId];
            
            ChatHistoryEntity *hEntity = [ChatHistoryEntity saveWithChatHistory:hItem];
            //关联联系人
            hEntity.contactsShip = cEntity;
            //填充最后消息
            if ([hItem.Type isEqualToString:def_chat_get_Img_result]) {
                cEntity.lastMsg = @"[图片]";
            } else {
                cEntity.lastMsg = hItem.Payload;
            }
            cEntity.lastTime = hItem.ReceivedAt;
        }
    }
    [DBhelper Save];
}

-(ChatHistoryEntity*)saveChatToDB:(NSDictionary*)response isImg:(BOOL)bIsImg
{
    ChatHistoryEntity *hItem = [ChatHistoryEntity saveWithChatDictonary:response];
    
    NSMutableArray *contacts = [ChatContactsEntity getContactsByUserId:[response objectForKey:@"From"]];
    ChatContactsEntity *cItem = nil;
    //根据toId查询联系人记录(找得到的情况)
    if (contacts.count > 0)
    {
        cItem = [contacts lastObject];
    }
    //找不到contacts的情况下 创建本地contacts
    else
    {
        cItem = [ChatContactsEntity insertContactsByUserId:[response objectForKey:@"From"]];
    }
    cItem.lastMsg = bIsImg?@"[图片]":hItem.msg;
    hItem.contactsShip = cItem;
    
    [DBhelper Save];
    return hItem;
}

-(void)refreshDB
{
    [self.contactsArray removeAllObjects];
    self.contactsArray = [ChatContactsEntity getContactsSortByTime];
}

+(void)refreshSendTime
{
    NSString *sSendTime = [[ChatTools getInstance].dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"updata Send Time %@",sSendTime);
    [[NSUserDefaults standardUserDefaults] setValue:sSendTime forKey:def_lastChatTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Document Action
//将选取的图片保存到目录文件夹下
+(NSString*)saveToDocument:(UIImage *)image
{
    NSString *strName = [NSString stringWithFormat:@"%@.png",[NSString GUIDString]];
    NSString *strPath = [ChatTools imageSavedPath:strName];
    
    if ((image == nil) || (strPath == nil) || [strPath isEqualToString:@""]) {
        return @"";
    }
    
    @try {
        NSData *imageData = nil;
        //获取文件扩展名
        NSString *extention = [strPath pathExtension];
        if ([extention isEqualToString:@"png"]) {
            //返回PNG格式的图片数据
            imageData = UIImagePNGRepresentation(image);
        }else{
            //返回JPG格式的图片数据，第二个参数为压缩质量：0:best 1:lost
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        if (imageData == nil || [imageData length] <= 0) {
            return @"";
        }
        //将图片写入指定路径
        [imageData writeToFile:strPath atomically:YES];
        return  strName;
    }
    @catch (NSException *exception) {
        NSLog(@"保存图片失败");
    }
    
    return @"";
    
}

//根据图片名将图片保存到ImageFile文件夹中
+(NSString*)imageSavedPath:(NSString *)imageName
{
    NSString *imageDocPath = [ChatTools getInstance].sImageFilePath;
    //获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建ImageFile文件夹
    [fileManager createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    //返回保存图片的路径（图片保存在ImageFile文件夹下）
    NSString * imagePath = [imageDocPath stringByAppendingPathComponent:imageName];
    return imagePath;
}

+(NSString*)getImageFilePath
{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    return imageDocPath;
}

#pragma mark - Socket Delegate Mehthod

//获取到信息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
        NSLog(@"websocket didReceiveMessage type %@",message);
    NSData* jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    NSString *sType = [dic objectForKey:@"Type"];
    
    ChatQueryResponse *response = [[ChatQueryResponse alloc] initWithJson:dic];
    
    if ([sType isEqualToString:def_history_result]) {
        //获取到聊天历史
        [self saveHistoryToDB:response];
        [self refreshDB];
        [ChatTools refreshSendTime];
        [[NSNotificationCenter defaultCenter] postNotificationName:def_postChatHistory object:self];
    }
    else if ([sType isEqualToString:def_contant_result]) {
        //获取到聊天联系人

        //请求聊天历史
        [self saveContactsToDB:response];
        [self getHistory];
        [[NSNotificationCenter defaultCenter] postNotificationName:def_postChatContant object:self];
    }
    else if ([sType isEqualToString:def_chat_result]) {
        //接收到消息
        ChatHistoryEntity *hItem = [self saveChatToDB:dic isImg:NO];
        [ChatTools refreshSendTime];
        [[NSNotificationCenter defaultCenter] postNotificationName:def_postChatMsg object:hItem];
    }
    else if ([sType isEqualToString:def_chat_get_Img_result]) {
        //接收到图片消息
        ChatHistoryEntity *hItem = [self saveChatToDB:dic isImg:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:def_postChatMsg object:hItem];
    }
    else if ([sType isEqualToString:def_chat_ERROR]) {
        //发生错误，断掉重连

        [self._webSocket close];
        
        [self._webSocket open];
    }
    

}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"webSocket DidOpen");
    if ([self.delegate respondsToSelector:@selector(sendMessageError)]) {
        [self.delegate socketOpenDelegate];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:def_connectFinish object:nil];
    //开启后首先获取联系人列表
    [self getContacts];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"websocket didFailWithError %@",error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"websocket didCloseWithCode");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    NSLog(@"websocket didReceivePong");
}

@end
