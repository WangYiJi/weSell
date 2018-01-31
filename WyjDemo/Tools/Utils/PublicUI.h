//
//  PublicUI.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/14.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicUI : UIView
+ (UIBarButtonItem *)getBackButtonandMethod:(SEL)button_method addtarget:(id)target;//返回各页面导航栏的返回键
@end
