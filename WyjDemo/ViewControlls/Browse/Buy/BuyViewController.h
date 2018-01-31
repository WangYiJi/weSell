//
//  BuyViewController.h
//  WyjDemo
//
//  Created by zjb on 16/2/25.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseSellPostQuery.h"
#import "UIImageView+WebCache.h"
@interface BuyViewController : UIViewController
<
UIScrollViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *mainTableview;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellImageScroll;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellSellerInfo;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellMyPrice;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *ADVPageControl;

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblComfirm;
@property (weak, nonatomic) IBOutlet UILabel *lbldate;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;

@property (weak, nonatomic) IBOutlet UITextField *txtMyPrice;

//传入参数
@property (strong,nonatomic)SellPostQueryResult *chooseSellPost;

-(IBAction)didPressedBuyNow:(id)sender;
-(IBAction)didPressedDone:(id)sender;

@end
