//
//  UploadUserInfoEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 16/1/18.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "UploadUserInfoEntity.h"
#import "UserMember.h"

@implementation UploadUserInfoEntity

@synthesize displayName;
@synthesize firstName;
@synthesize lastName;
@synthesize avatarSmallUrl;
@synthesize avatarUrl;
@synthesize avatarLargeUrl;
@synthesize lastSelectedCityId;
@synthesize acceptedLanguage;

-(instancetype)init
{
    self = [super init];
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/users/%@",PostServer,[UserMember getInstance].userId];
    BaseUserInfo *b = [UserMember getInstance].baseUserInfo;
    displayName = [UserMember getInstance].baseUserInfo.displayName;
    firstName = [UserMember getInstance].baseUserInfo.firstName;
    lastName = [UserMember getInstance].baseUserInfo.lastName;
    lastSelectedCityId = [UserMember getInstance].baseUserInfo.lastSelectedCityId;
    acceptedLanguage = @"";
    avatarUrl = [UserMember getInstance].baseUserInfo.avatarUrl;
    avatarSmallUrl = [UserMember getInstance].baseUserInfo.avatarSmallUrl;
    avatarLargeUrl = [UserMember getInstance].baseUserInfo.avatarLargeUrl;
    
    return self;
}
@end
