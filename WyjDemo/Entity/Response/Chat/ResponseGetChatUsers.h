//
//  ResponseGetChatUsers.h
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseGetChatUsers : NSObject
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *pageSize;
@property (nonatomic,copy) NSString *hasNex;
@property (nonatomic,strong) NSMutableArray *resultArray;
@end

@interface ChattedUser : NSObject
@property (nonatomic,strong,getter=chatId,setter=setChati:) NSString *id;
@property (nonatomic,strong) NSString *userId1;
@property (nonatomic,strong) NSString *userId2;
@property (nonatomic,strong) NSString *postId;
@property (nonatomic,strong) NSString *postOwner;
@property (nonatomic,strong) NSString *lastChatted;
@end