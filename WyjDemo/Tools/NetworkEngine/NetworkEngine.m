//
//  NetworkEngine.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/17.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "NetworkEngine.h"
#import <objc/message.h>
#import "ChatTools.h"
#import "UserMember.h"
#import "AppDelegate.h"
#import "Global.h"
#import "ResponseFileUpload.h"

@implementation NetworkEngine
@synthesize successBlock;
@synthesize failedBlock;
@synthesize uploadBlock;

// post + application/x-www-form-urlencoded
+ (void)postLoginRequestEntity:(BaseRequest *)entity success:(HttpSuccess)success fail:(HttpFailure)fail
{
    //Parament
    NSMutableDictionary *parameters = [NetworkEngine dictionaryWithObject:entity];
    
    if (entity.bCloseParams) {
        parameters = nil;
        NSString *sParameters = [self urlWithObject:entity];
        entity.sUrl = [entity.sUrl stringByAppendingString:sParameters];
    }
    //Request
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[entity sUrl]
                                                                                parameters:parameters
                                                                                     error:&error];
    if ([UserMember getInstance].isLogin && [UserMember getInstance].signingKey.length > 0) {
        NSString *sToken = [ChatTools createChatToken:[UserMember getInstance].userId
                                           reportTime:[[NSDate date] timeIntervalSince1970]
                                           signingKey:[UserMember getInstance].signingKey];
        
        [request setValue:sToken forHTTPHeaderField:@"Authorization"];
    }
    [request setValue:[NetworkEngine getLanguage] forHTTPHeaderField:@"Accepted-Language"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];

    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request
               completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                   //NSLog(@"success %@  error %@",responseObject,error);
                   if (error) {
                       fail(error);
                   }else {
                       success(responseObject);
                   }
               }];
    [task resume];

}

//post
+ (void)postRequestEntity:(BaseRequest *)entity contentType:(NSString *)sContentType success:(HttpSuccess)success fail:(HttpFailure)fail
{
    //生成parament
    NSMutableDictionary *parameters = [NetworkEngine dictionaryWithObject:entity];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if ([UserMember getInstance].isLogin && [UserMember getInstance].signingKey.length > 0) {
        NSString *sToken = [ChatTools createChatToken:[UserMember getInstance].userId
                                           reportTime:[[NSDate date] timeIntervalSince1970]
                                           signingKey:[UserMember getInstance].signingKey];
        
        [manager.requestSerializer setValue:sToken forHTTPHeaderField:@"Authorization"];
    }
    [manager.requestSerializer setValue:sContentType forHTTPHeaderField:@"Content-Type"];
   // [manager.requestSerializer setValue:@"zh_HANS" forHTTPHeaderField:@"Accepted-Language"];
    if (entity.bCloseParams) {
        parameters = nil;
        NSString *sParameters = [self urlWithObject:entity];
        entity.sUrl = [entity.sUrl stringByAppendingString:sParameters];
        
    }
    NSLog(@"%@",parameters);
    [manager POST:[entity sUrl]
       parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
                 success(responseObject);
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (error) {
                 fail(error);
             }
         }];
}

+(void)postForRegisterRequestEntity:(BaseRequest *)entity contentType:(NSString *)sContentType success:(HttpSuccess)success fail:(HttpFailure)fail
{
    //生成parament
    NSMutableDictionary *parameters = [NetworkEngine dictionaryWithObject:entity];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if ([UserMember getInstance].isLogin && [UserMember getInstance].signingKey.length > 0) {
        NSString *sToken = [ChatTools createChatToken:[UserMember getInstance].userId
                                           reportTime:[[NSDate date] timeIntervalSince1970]
                                           signingKey:[UserMember getInstance].signingKey];
        
        [manager.requestSerializer setValue:sToken forHTTPHeaderField:@"Authorization"];
    }
    [manager.requestSerializer setValue:sContentType forHTTPHeaderField:@"Content-Type"];

    if (entity.bCloseParams) {
        parameters = nil;
        NSString *sParameters = [self urlWithObject:entity];
        entity.sUrl = [entity.sUrl stringByAppendingString:sParameters];
        
    }
    
    [manager POST:[entity sUrl]
       parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
                 success(responseObject);
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             if (error) {
                 NSString *sError = @"com.alamofire.serialization.response.error.data";
                 id obj = [error.userInfo objectForKey:sError];
                 NSString *s = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                 NSLog(@"err obj %@",s);
                 if (s.length > 0) {
                     NSMutableDictionary *errorDic = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers error:nil];
                     NSString *sCode = [errorDic valueForKey:@"errorCode"];
                     if ([sCode isEqualToString:@"USER_ACCOUNT_EXISTED"]) {
                         success(nil);
                     }
                 } else {
                     fail(error);
                 }
             } else {
                 fail(error);
             }
         }];
}

//get + json
+ (void)getJSONWithUrl:(BaseRequest *)entity success:(HttpSuccess)success fail:(HttpFailure)fail
{
    //1.管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if ([UserMember getInstance].isLogin && [UserMember getInstance].signingKey.length > 0) {
        NSString *sToken = [ChatTools createChatToken:[UserMember getInstance].userId
                                           reportTime:[[NSDate date] timeIntervalSince1970]
                                           signingKey:[UserMember getInstance].signingKey];
        
        [manager.requestSerializer setValue:sToken forHTTPHeaderField:@"Authorization"];
//        NSLog(@"user:++++%@",sToken);
    }
    
    [manager.requestSerializer setValue:[NetworkEngine getLanguage] forHTTPHeaderField:@"Accepted-Language"];
    
    
    //2.设置参数
    NSString *url = entity.sUrl;
    
    if (!entity.bCloseParams) {
        NSString *sParameters = [self urlWithObject:entity];
        url = [entity.sUrl stringByAppendingString:sParameters];
    }
    NSLog(@"url:%@",url);
    NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //3.请求
    [manager GET:encodedUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success %@",responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
}

//put方法上传图片
- (void)putUploadImages:(NSString *)sUrl  image:(UIImage *)image type:(NSString*)sType success:(HttpSuccess)success fail:(HttpFailure)fail
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"PUT"
                                                                                   URLString:sUrl
                                                                                  parameters:nil
                                                                   constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                                                       [formData appendPartWithFileData:imageData name:@"media" fileName:@"upload.jpg" mimeType:@"image/jpeg"];

                                                                   } error:&error];
    
    [request setValue:sType forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NetworkEngine getLanguage] forHTTPHeaderField:@"Accepted-Language"];

    NSURLSessionDataTask *task = [manager uploadTaskWithRequest:request
                                                       fromData:imageData
                                                       progress:^(NSProgress * _Nonnull uploadProgress) {

                                                       } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                           if (error) {
                                                               if (fail) {
                                                                   fail(error);
                                                               }
                                                           }else {
                                                               if (success) {
                                                                   success(responseObject);
                                                               }
                                                           }
                                                       }];
    [task resume];
    
}

//批量上传图片
+ (void)putUploadSomeImages:(NSMutableArray *)ArrUpload  imageArray:(NSMutableArray *)imageArray success:(UploadSuccess)success fail:(HttpFailure)fail progress:(UploadIndex)progress
{
    __block int iUploadImage = 0;
    
    for (int i = 0; i < ArrUpload.count; i++) {
        ResponseFileUpload *responseFileUpload = [ArrUpload objectAtIndex:i];
        UIImage *image = [imageArray objectAtIndex:i];
        NetworkEngine *engine = [[NetworkEngine alloc] init];
        
        [engine putUploadImages:responseFileUpload.url image:image type:responseFileUpload.contentType success:^(id json) {
            iUploadImage++;
            if (iUploadImage == ArrUpload.count) {
                if (success) {
                    NSMutableArray *arr = [NetworkEngine getImageUrlFromUpload:ArrUpload];//responseFileUpload.accessUrl;//
                    success(arr);
                }
            } else {
                //进度
                if (progress) {
                    progress(iUploadImage);
                }
            }
            
        } fail:^(NSError *error) {
            if (fail) {
                fail(error);
            }
        }];
    }
}

//put重置密码
+(void)putPasswordWithEntity:(BaseRequest*)entity success:(HttpSuccess)success fail:(HttpFailure)fail
{
    //Manager
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    
    //Parameters
    NSMutableDictionary *parameters = [NetworkEngine dictionaryWithObject:entity];
    
    //Request
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT"
                                                                      URLString:entity.sUrl
                                                                     parameters:parameters
                                                                          error:&error];
    
    if ([UserMember getInstance].isLogin) {
        NSString *sToken = [ChatTools createChatToken:[UserMember getInstance].userId
                                           reportTime:[[NSDate date] timeIntervalSince1970]
                                           signingKey:[UserMember getInstance].signingKey];
        
        [request setValue:sToken forHTTPHeaderField:@"Authorization"];
    }
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NetworkEngine getLanguage] forHTTPHeaderField:@"Accepted-Language"];

    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request
                                            completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                if (error) {
                                                    fail(error);
                                                } else {
                                                    success(responseObject);
                                                }
                                            }];
    [task resume];
}

//put提交个人信息
+(void)putUserInfoWithEntity:(BaseRequest*)entity success:(HttpSuccess)success fail:(HttpFailure)fail
{
    //生成parament
    NSMutableDictionary *parameters = [NetworkEngine dictionaryWithObject:entity];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if ([UserMember getInstance].isLogin) {
        NSString *sToken = [ChatTools createChatToken:[UserMember getInstance].userId
                                           reportTime:[[NSDate date] timeIntervalSince1970]
                                           signingKey:[UserMember getInstance].signingKey];
        
        [manager.requestSerializer setValue:sToken forHTTPHeaderField:@"Authorization"];
    }
    if (entity.bCloseParams) {
        parameters = nil;
        NSString *sParameters = [self urlWithObject:entity];
        entity.sUrl = [entity.sUrl stringByAppendingString:sParameters];
        
    }
    
    NSData *d = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];

    [manager PUT:[entity sUrl]
      parameters:parameters
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             success(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             fail(error);
         }];
}

+(void)deleteRequest:(BaseRequest*)entity success:(HttpSuccess)success fail:(HttpFailure)fail
{
    //生成parament
    //NSMutableDictionary *parameters = [NetworkEngine dictionaryWithObject:entity];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if ([UserMember getInstance].isLogin) {
        NSString *sToken = [ChatTools createChatToken:[UserMember getInstance].userId
                                           reportTime:[[NSDate date] timeIntervalSince1970]
                                           signingKey:[UserMember getInstance].signingKey];
        
        [manager.requestSerializer setValue:sToken forHTTPHeaderField:@"Authorization"];
    }
    
    
    [manager DELETE:[entity sUrl]
         parameters:nil
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                fail(error);
            }];
}



+(NSString*)getLanguage
{
//    [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
    NSString *sLaunguage = [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage];
    if (sLaunguage.length <= 0 || [sLaunguage isEqualToString:@"zh-Hans"]) {
        return @"zh_HANS";
    } else {
        return @"zh_HANT";
    }
}

//将对象转为字典
+ (NSMutableDictionary *)dictionaryWithObject:(id)obj
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    Class requestClass = [obj class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(requestClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        if ([obj valueForKey:propName]) {
            id item = [obj valueForKey:propName];
            if (item) {
                id value = nil;
                if ([item isKindOfClass:[NSObject class]]) {
                    if ([item isKindOfClass:[NSArray class]]) {
                        value = [NetworkEngine arrayWithObject:item];
                    }
                    else if ([item isKindOfClass:[NSNumber class]] ||
                             [item isKindOfClass:[NSString class]] ||
                             [item isKindOfClass:[NSDictionary class]]) {
                        value = item;
                    }else {
                        value = [NetworkEngine dictionaryWithObject:item];
                    }
                }
                [dic setValue:value forKey:propName];
            }
           
        }else {
           [dic setValue:@"" forKey:propName];
        }
    }
    return dic;
}

+ (NSMutableArray *)arrayWithObject:(id)obj
{
    NSMutableArray *arrObject = [[NSMutableArray alloc] init];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *arr = (NSMutableArray *)obj;
        for (int i = 0; i < arr.count; i++) {
            id item = [arr objectAtIndex:i];
             NSMutableDictionary *dic = [NetworkEngine dictionaryWithObject:item];
            [arrObject addObject:dic];
        }
    }
    
    return arrObject;
}

//拼接url
+ (NSString *)urlWithObject:(id)obj
{
    NSString *sUrl = @"?";
    Class requestClass = [obj class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(requestClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        if ([obj valueForKey:propName]) {
            NSString *tempStr;
            if (i < outCount-1) {
                tempStr = [NSString stringWithFormat:@"%@=%@&",propName,[obj valueForKey:propName]];
            }else{
                tempStr = [NSString stringWithFormat:@"%@=%@",propName,[obj valueForKey:propName]];
            }
            
            sUrl = [sUrl stringByAppendingString:tempStr];
        }
        
    }
    return sUrl;
}

//获得上传图片的url
+ (NSMutableArray *)getImageUrlFromUpload:(NSMutableArray *)aUrl
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (ResponseFileUpload *r in aUrl) {
        NSString *surl = r.accessUrl;
        [arr addObject:surl];
    }
    return arr;
}

+(void)showMbDialog:(UIView*)view title:(NSString*)sTitle
{
    if (AppDelegateEntity.HUD) {
        [AppDelegateEntity.HUD removeFromSuperview];
        AppDelegateEntity.HUD = nil;
    }
    AppDelegateEntity.HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:AppDelegateEntity.HUD];
    [view bringSubviewToFront:AppDelegateEntity.HUD];
    AppDelegateEntity.HUD.labelText = sTitle;
    [AppDelegateEntity.HUD show:YES];
}

+(void)hiddenDialog
{
    if (AppDelegateEntity.HUD) {
        [AppDelegateEntity.HUD removeFromSuperview];
        AppDelegateEntity.HUD = nil;
    }
}

+ (void)alertSimpleMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
