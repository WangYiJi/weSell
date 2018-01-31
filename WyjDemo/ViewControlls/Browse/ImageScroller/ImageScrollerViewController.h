//
//  ImageScrollerViewController.h
//  WyjDemo
//
//  Created by Alex on 16/5/20.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseSellPostQuery.h"

@interface ImageScrollerViewController : UIViewController
{
    SellPostQueryResult *sellPostQueryResult;
}

@property (nonatomic,strong) SellPostQueryResult *sellPostQueryResult;
@property (nonatomic,strong) IBOutlet UIScrollView *imageScroller;
@property (nonatomic,strong) IBOutlet UIPageControl *pageControl;
@end
