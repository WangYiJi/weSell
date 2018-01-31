//
//  ItemsListViewController.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/17.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManger.h"

@interface ItemListViewController : UIViewController
<
    LocationManagerDelegate
>{
    NSArray *categoryArr;//存储分类选择信息
}
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

//筛选页面
@property (strong, nonatomic) IBOutlet UIButton *btnShaixuan;
@property (weak, nonatomic) IBOutlet UITableView *shaixuanTableview;
@property (strong, nonatomic) IBOutlet UIView *shaixuanHeaderview;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellShaiXuanCity;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellShaiXuanDistance;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellShaiXuanPrice;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellShaiXuanButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellShaiXuanSortOptions;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellShaiXuanConditions;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellShaiXuanCategory;
@property (strong, nonatomic) IBOutlet UIView *viewShaiXuan;
@property (weak, nonatomic) IBOutlet UILabel *lblSXCity;
@property (weak, nonatomic) IBOutlet UIButton *btnSXCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSXRfresh;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceThird;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceForth;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceFifth;
@property (weak, nonatomic) IBOutlet UITextField *txtPriceFrom;
@property (weak, nonatomic) IBOutlet UITextField *txtFromTo;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyUnit;

@property (weak, nonatomic) IBOutlet UILabel *lblShaixuanTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnSetDone;

//类别页
@property (strong, nonatomic) IBOutlet UITableView *categoryTableview;
@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (strong, nonatomic) IBOutlet UITextField *txtCategory;
@property (strong, nonatomic) IBOutlet UISlider *sliderDistance;

//城市选择
@property (strong, nonatomic) IBOutlet UITableView *cityTableview;
@property (strong, nonatomic) IBOutlet UIView *cityView;
- (IBAction)didPressedBackCity:(id)sender;
- (IBAction)didPressedCountry:(id)sender;
- (IBAction)didPressedShaiXuan:(id)sender;
- (IBAction)didPressedShaiXuanDone:(id)sender;
- (IBAction)didSliderDistanceValue:(id)sender;
- (void)didPressedConditions:(UIButton *)sender;
- (IBAction)didCancelShaixuan:(id)sender;
- (IBAction)didPressedResetShaiXuan:(id)sender;
- (IBAction)didCancelKeyboard:(id)sender;
- (IBAction)didPressedCategory:(id)sender;

-(void)showCityList;

@end
