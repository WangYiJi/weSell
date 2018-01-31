//
//  UITabBarController+HideTabBar.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/22.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (HideTabBar)
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
