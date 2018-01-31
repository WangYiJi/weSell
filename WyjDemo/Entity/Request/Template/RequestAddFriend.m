//
//  RequestAddFriend.m
//  WyjDemo
//
//  Created by Alex on 16/6/17.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "RequestAddFriend.h"

@implementation RequestAddFriend
-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/messagetemplates/INVITE_FRIEND_IOS/download",PostServer];
    return self;
}
@end
