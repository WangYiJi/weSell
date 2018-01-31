//
//  ResponseChatConnect.h
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseGetChatUsers.h"

@interface ResponseChatConnect : NSObject
@property (nonatomic,strong,getter=chatId,setter=setChati:) NSString *id;
@property (nonatomic,strong) NSString *userId1;
@property (nonatomic,strong) NSString *userId2;
@property (nonatomic,strong) NSString *postId;
@property (nonatomic,strong) NSString *postOwner;
@property (nonatomic,strong) NSString *lastChatted;

-(id)initwithJson:(id)dic;
@end
