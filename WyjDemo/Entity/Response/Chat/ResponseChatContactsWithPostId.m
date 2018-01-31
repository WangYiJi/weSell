//
//  ResponseChatContactsWithPostId.m
//  WyjDemo
//
//  Created by Alex on 16/3/3.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResponseChatContactsWithPostId.h"

@implementation ResponseChatContactsWithPostId
@synthesize page;
@synthesize pageSize;
@synthesize hasNext;
@synthesize chatList;
-(id)initWithJson:(NSDictionary*)dic
{
    if (self = [super init]) {
        self.page = [dic objectForKey:@"page"];
        self.pageSize = [dic objectForKey:@"pageSize"];
        self.hasNext = [dic objectForKey:@"hasNext"];
        
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        NSArray *temps = [dic objectForKey:@"result"];
        for (NSDictionary *dic in temps) {
            chatItem *cItem = [[chatItem alloc] init];
            [cItem sId:[dic objectForKey:@"id"]];
            cItem.userId1 = [dic objectForKey:@"userId1"];
            cItem.userId2 = [dic objectForKey:@"userId2"];
            cItem.postId = [dic objectForKey:@"postId"];
            cItem.postOwner = [dic objectForKey:@"postOwner"];
            cItem.lastChatted = [dic objectForKey:@"lastChatted"];
            
            [tempList addObject:cItem];
        }
        self.chatList = [NSMutableArray arrayWithArray:tempList];
        
    }
    return self;
}
@end

@implementation chatItem

@synthesize id;
@synthesize userId1;
@synthesize userId2;
@synthesize postId;
@synthesize postOwner;
@synthesize lastChatted;

@end