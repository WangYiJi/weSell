//
//  FileUploadEntity.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/26.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "FileUploadEntity.h"
#import "NetworkEngine.h"

@implementation FileUploadEntity
@synthesize userId;
@synthesize fileType;
@synthesize from;

-(instancetype)init
{
    self = [super init];
    self.bCloseParams = YES;
    self.sUrl = [NSString stringWithFormat:@"%@/posts-public/api/files",PostServer];
    return self;
}
@end
