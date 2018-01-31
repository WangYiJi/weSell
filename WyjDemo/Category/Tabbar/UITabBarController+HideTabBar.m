//
//  UITabBarController+HideTabBar.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/22.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "UITabBarController+HideTabBar.h"
#define kAnimationDuration .3

CGRect tmpRect;
@implementation UITabBarController (HideTabBar)
- (BOOL)isTabBarHidden {
    CGRect viewFrame = self.view.frame;
    CGRect tabBarFrame = self.tabBar.frame;
    return tabBarFrame.origin.y >= viewFrame.size.height;
}

- (void)setTabBarFrame
{
    CGRect tabBarFrame = self.tabBar.frame;
    tabBarFrame.origin.y = self.view.frame.size.height - tabBarFrame.size.height;
}


- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}


- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    BOOL isHidden = self.tabBarHidden;
    UIView *transitionView = [[[self.view.subviews reverseObjectEnumerator] allObjects] lastObject];
    if(hidden == isHidden){
        transitionView.frame = tmpRect;
        return;
    }
    
    if(transitionView == nil) {
        NSLog(@"could not get the container view!");
        return;
    }
    
    
    CGRect viewFrame = self.view.frame;
    CGRect tabBarFrame = self.tabBar.frame;
    CGRect containerFrame = transitionView.frame;
    
    tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    containerFrame.size.height = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    tmpRect = containerFrame;
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.tabBar.frame = tabBarFrame;
                         transitionView.frame = containerFrame;
                     }
     ];
}
@end
