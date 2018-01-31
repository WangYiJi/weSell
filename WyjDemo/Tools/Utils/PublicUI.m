//
//  PublicUI.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/14.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "PublicUI.h"

@implementation PublicUI
+ (UIBarButtonItem *)getBackButtonandMethod:(SEL)button_method addtarget:(nullable id)target{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 13, 30);
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:target action:button_method forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barItem;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
