//
//  SaleViewController.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/17.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextView.h"
#import "UIImagePickerController+HiddenAPIs.h"
#import "LocationManger.h"
#import "SalesSuccessViewController.h"
#import "ResponseSellPostQuery.h"

@interface SaleViewController : UIViewController
<
UIImagePickerControllerHiddenAPIDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UITextViewDelegate,
LocationManagerDelegate,
SaleSuccessDelegate,
UIAlertViewDelegate
>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (weak, nonatomic) IBOutlet UIImageView *imgvArrowOne;
@property (weak, nonatomic) IBOutlet UIImageView *imgvArrowTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnMakePrice;
@property (weak, nonatomic) IBOutlet UIButton *btnNextPage;
//箭头的距离动量
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcArrowwidth2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcArrowwidth1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcBottom;
//没有选择图片时的按钮
@property (weak, nonatomic) IBOutlet UIButton *btnUploadPic;
@property (weak, nonatomic) IBOutlet UILabel *lblUploadPic;
//collectionview
@property (weak, nonatomic) IBOutlet UICollectionView *picCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *categoryTableview;
@property (strong, nonatomic) IBOutlet UITableView *cityTableview;
@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (strong, nonatomic) IBOutlet UIView *cityView;
//城市列表的返回按钮
@property (strong, nonatomic) IBOutlet UIButton *btnCityBack;

//描述页面控件
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet CBTextView *tvDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;

//第三个页面控件
@property (strong, nonatomic) IBOutlet UIToolbar *myToolbar;
@property (strong, nonatomic) IBOutlet UITextField *txtPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtNewOld;
@property (strong, nonatomic) IBOutlet UISwitch *switchPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;

@property (strong, nonatomic) IBOutlet UIView *viewStepFirst;
@property (strong, nonatomic) IBOutlet UIView *viewStepSecond;
@property (strong, nonatomic) IBOutlet UIView *viewStepThird;

@property (weak, nonatomic) IBOutlet UILabel *lblTopic;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblShiFouYiJiaTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblQuGuoDiDianTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNewOldTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblUploadTitle;





//选择新旧程度
@property (strong, nonatomic) IBOutlet UITableView *conditionTableview;
@property (strong, nonatomic) IBOutlet UIView *conditionHeaderview;

//传入参数
@property (strong, nonatomic) SellPostQueryResult *chooseSellPost;

- (IBAction)didPressedFirstPage:(id)sender;
- (IBAction)didPressedSecondPage:(id)sender;
- (IBAction)didPressedThirdPage:(id)sender;
- (IBAction)didPressedNextPage:(id)sender;
- (IBAction)didPressedChoosePic:(id)sender;
- (IBAction)didPressedCategory:(id)sender;
- (IBAction)didPressedCountry:(id)sender;
- (IBAction)didPressedBackCity:(id)sender;
- (IBAction)didPressedNewOld:(id)sender;
- (IBAction)didPressedFinishInputPrice:(id)sender;

-(NSString*)getErrorMsgByPage:(NSInteger)page;

@end


