//
//  ChatQueryResponse.h
//  WyjDemo
//
//  Created by wyj on 15/12/13.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define def_history_result          @"CHAT_HISTORY_RESULT"
#define def_contant_result          @"CONTACTLIST_RESULT"
#define def_chat_result             @"CHAT"
#define def_chat_get_Img_result     @"IMAGELINK"
#define def_chat_ERROR              @"ERROR"


@interface chatContacts : NSObject
@property (nonatomic,copy) NSString *UserId;
@property (nonatomic,copy) NSNumber *IsBlackListed;
@end

@interface chatHistory : NSObject
@property (nonatomic,copy) NSString *MsgId;
@property (nonatomic,copy) NSString *From;
@property (nonatomic,copy) NSString *To;
@property (nonatomic,copy) NSString *Type;
@property (nonatomic,copy) NSString *Payload;
@property (nonatomic,copy) NSString *Topic;
@property (nonatomic,copy) NSString *ReceivedAt;
@end



@interface ChatQueryResponse : NSObject
@property (nonatomic,copy) NSString *MsgId;
@property (nonatomic,copy) NSString *From;
@property (nonatomic,copy) NSString *To;
@property (nonatomic,copy) NSString *Type;
@property (nonatomic,copy) NSString *ReceivedAt;
@property (nonatomic,copy) NSString *Topic;
@property (nonatomic,copy) NSMutableArray *Payload;

-(id)initWithJson:(NSDictionary*)dic;

@end
