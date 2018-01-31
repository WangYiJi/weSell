//
//  NetworkEngine.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/17.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BaseRequest.h"
// 验证服务器地址成功后的回调  json 服务器返回的JSON数据
typedef void (^HttpSuccess)(id json);
// 验证服务器地址失败后的回调
typedef void (^HttpFailure)(NSError *error);
//验证上传成功后的回调
typedef void (^UploadSuccess)(NSMutableArray *aUrl);
//上传进度
typedef void (^UploadIndex)(NSInteger i);

@interface NetworkEngine : NSObject
<
   NSURLSessionDelegate,
NSURLSessionDataDelegate,
NSURLSessionTaskDelegate
>
@property (nonatomic,copy) HttpSuccess successBlock;
@property (nonatomic,copy) HttpFailure failedBlock;
@property (nonatomic,copy) UploadSuccess uploadBlock;

//post x-www-form-urlencoded
+ (void)postLoginRequestEntity:(BaseRequest *)entity success:(HttpSuccess)success fail:(HttpFailure)fail;

//一般post
+ (void)postRequestEntity:(BaseRequest *)entity contentType:(NSString *)sContentType success:(HttpSuccess)success fail:(HttpFailure)fail;

//register专用。无奈。
+(void)postForRegisterRequestEntity:(BaseRequest *)entity contentType:(NSString *)sContentType success:(HttpSuccess)success fail:(HttpFailure)fail;

//一般get
+ (void)getJSONWithUrl:(BaseRequest *)entity success:(HttpSuccess)success fail:(HttpFailure)fail;

//put x-www-form-urlencoded
+ (void)putPasswordWithEntity:(BaseRequest*)entity success:(HttpSuccess)success fail:(HttpFailure)fail;

//put json
+ (void)putUserInfoWithEntity:(BaseRequest*)entity success:(HttpSuccess)success fail:(HttpFailure)fail;

//put 图片
- (void)putUploadImages:(NSString *)sUrl  image:(UIImage *)image type:(NSString*)sType success:(HttpSuccess)success fail:(HttpFailure)fail;
+ (void)putUploadSomeImages:(NSMutableArray *)ArrUpload  imageArray:(NSMutableArray *)imageArray success:(UploadSuccess)success fail:(HttpFailure)fail progress:(UploadIndex)progress;//批量上传图片

//delete json
+(void)deleteRequest:(BaseRequest*)entity success:(HttpSuccess)success fail:(HttpFailure)fail;

+ (NSMutableDictionary *)dictionaryWithObject:(id)obj;
+ (NSMutableArray *)arrayWithObject:(id)obj;
+ (NSString *)urlWithObject:(id)obj;
+ (NSMutableArray *)getImageUrlFromUpload:(NSMutableArray *)aUrl;

+(NSString*)DataTOjsonString:(id)object;

+(void)showMbDialog:(UIView*)view title:(NSString*)sTitle;
+(void)hiddenDialog;
+ (void)alertSimpleMessage:(NSString *)message;
@end
