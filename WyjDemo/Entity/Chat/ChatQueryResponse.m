//
//  ChatQueryResponse.m
//  WyjDemo
//
//  Created by wyj on 15/12/13.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ChatQueryResponse.h"



@implementation chatContacts
@synthesize UserId;
@synthesize IsBlackListed;
@end

@implementation chatHistory
@synthesize MsgId;
@synthesize From;
@synthesize To;
@synthesize Type;
@synthesize Payload;
@synthesize Topic;
@synthesize ReceivedAt;
@end

@implementation ChatQueryResponse
@synthesize MsgId;
@synthesize From;
@synthesize To;
@synthesize Type;
@synthesize ReceivedAt;
@synthesize Topic;
@synthesize Payload;

-(id)initWithJson:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.From = [dic objectForKey:@"From"];
        self.MsgId = [dic objectForKey:@"MsgId"];
        self.ReceivedAt = [dic objectForKey:@"ReceivedAt"];
        self.To = [dic objectForKey:@"To"];
        self.Type = [dic objectForKey:@"Type"];
        self.Topic = [dic objectForKey:@"Topic"];
        
        NSString *sArray = [dic objectForKey:@"Payload"];
        
        NSData *msgData = [sArray dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * msgArray= [NSJSONSerialization JSONObjectWithData:msgData options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableArray *tempChats = [[NSMutableArray alloc] init];
        
        for (NSDictionary *itemDic in msgArray) {
            id item = nil;
            if ([self.Type isEqualToString:def_history_result]||[self.Type isEqualToString:def_chat_result]) {
                item = [[chatHistory alloc] init];
            }
            else if ([self.Type isEqualToString:def_contant_result]) {
                item = [[chatContacts alloc] init];
            }
            
            for (NSString *key in [itemDic allKeys]) {
                if ([item respondsToSelector:NSSelectorFromString(key)]) {
                    [item setValue:[itemDic valueForKey:key] forKey:key];
                }
            }
            [tempChats addObject:item];
        }
        
        self.Payload = [[NSMutableArray alloc] initWithArray:tempChats];
    }
    return self;
}
@end
