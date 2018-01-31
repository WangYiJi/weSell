//
//  ResponseChatContactsWithPostId.h
//  WyjDemo
//
//  Created by Alex on 16/3/3.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseChatContactsWithPostId : NSObject
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *pageSize;
@property (nonatomic,copy) NSString *hasNext;
@property (nonatomic,copy) NSMutableArray *chatList;

-(id)initWithJson:(NSDictionary*)dic;

@end

@interface chatItem : NSObject
@property (nonatomic,copy,getter=gId,setter=sId:) NSString *id;
@property (nonatomic,copy) NSString *userId1;
@property (nonatomic,copy) NSString *userId2;
@property (nonatomic,copy) NSString *postId;
@property (nonatomic,copy) NSString *postOwner;
@property (nonatomic,copy) NSString *lastChatted;
@end
