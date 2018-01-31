//
//  ItemViewController.h
//  WyjDemo
//
//  Created by 霍霍 on 15/12/28.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"
#import "CBTextView.h"
#import "ResponseByIds.h"

@interface ItemViewController : UIViewController
<
   UIScrollViewDelegate,
    UIActionSheetDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellImageScroll;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellItemInfo;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellMap;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellADV;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *ADVPageControl;

//cellItemInfo
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPostDate;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblItemPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblItemDescription;

//cellMap
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//cellADV
@property (strong, nonatomic) IBOutlet UIImageView *imgADV;
@property (strong, nonatomic) IBOutlet UILabel *lblADVTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblADVDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblADVPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblADVDate;

//bottomView
@property (weak, nonatomic) IBOutlet UILabel *lblFavourtecnt;
@property (weak, nonatomic) IBOutlet UIImageView *imgFavorte;

@property (weak, nonatomic) IBOutlet UIButton *btnFave;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (weak, nonatomic) IBOutlet UIButton *btnJuBao;


//传入参数
@property (strong, nonatomic) NSString *sPostId;
@property (nonatomic,strong) SellPostQueryResult *sellPostQueryResult;

- (IBAction)didPressedShare:(id)sender;
- (IBAction)didPressedInform:(id)sender;
- (IBAction)didPressedChat:(id)sender;
- (IBAction)didPressedFavorite:(id)sender;
- (IBAction)didPressedBuyNow:(id)sender;
- (IBAction)didPressedToSellerInfo:(id)sender;

@end
