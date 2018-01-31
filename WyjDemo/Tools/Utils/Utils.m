//
//  Utils.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/14.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(id)DictionaryToObject:(NSString*)classname dic:(NSDictionary*)dic{
    Class c = NSClassFromString(classname);
    id responseObject = c.new;
    if ((NSNull *)dic != [NSNull null]) {
        for (NSString *key in dic) {
            if ([responseObject respondsToSelector:NSSelectorFromString(key)]){
                id dd = [dic valueForKey:key];
                if ((NSNull *)dd != [NSNull null]) {
                   [responseObject setValue:[dic valueForKey:key] forKey:key];
                }else {
                    [responseObject setValue:@"" forKey:key];
                }
                
            }
        }
        return responseObject;
    }
    return nil;
    
}

+(NSString *)DateStringFromDateSp:(NSString *)sTimeSp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[sTimeSp floatValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}
@end
