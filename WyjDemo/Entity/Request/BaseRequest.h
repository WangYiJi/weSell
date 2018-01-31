//
//  BaseRequest.h
//  WyjDemo
//
//  Created by wyj on 15/10/30.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface BaseRequest : NSObject
@property (nonatomic,copy) NSString *sUrl;
@property (nonatomic,assign) BOOL bCloseParams;//关闭传递参数
@end
