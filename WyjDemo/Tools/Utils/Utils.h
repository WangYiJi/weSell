//
//  Utils.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/14.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    cityType_Country = 0,
    cityType_Province = 1,
    cityType_City = 2
}cityType;

@interface Utils : NSObject
+(id)DictionaryToObject:(NSString*)classname dic:(NSDictionary*)dic;
//时间戳换算成日期
+(NSString *)DateStringFromDateSp:(NSString *)sTimeSp;
+(BOOL)isBlankString:(NSString *)string;//判断字符串是不是空
@end
