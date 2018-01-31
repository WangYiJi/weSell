//
//  ResponseFileUpload.h
//  WyjDemo
//
//  Created by 霍霍 on 15/12/27.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseFileUpload : NSObject
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *method;
@property (nonatomic,copy) NSString *contentType;
@property (nonatomic,copy) NSString *accessUrl;
-(id)initwithJson:(id)dic;
@end
