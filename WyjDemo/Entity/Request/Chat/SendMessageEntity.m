//
//  SendMessageEntity.m
//  WyjDemo
//
//  Created by wyj on 15/11/6.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "SendMessageEntity.h"

@implementation SendMessageEntity
@synthesize MsgId;
@synthesize To;
@synthesize Type;
@synthesize Payload;

-(instancetype)init
{
    self = [super init];

    return self;
}
@end
