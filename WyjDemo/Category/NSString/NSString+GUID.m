//
//  NSString+GUID.m
//  TCTCategory
//
//  Created by maxfong on 15/5/7.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//

#import "NSString+GUID.h"

@implementation NSString (GUID)

+ (NSString *)GUIDString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *str = (__bridge NSString *)(string);
    CFRelease(string);
    return str;
}



@end
