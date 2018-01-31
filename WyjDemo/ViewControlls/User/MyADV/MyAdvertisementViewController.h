//
//  MyAdvertisementViewController.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/25.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyADVRefreshTool.h"

@interface MyAdvertisementViewController : UIViewController
<
 MyADVRefreshDelegate,
    UIActionSheetDelegate
//    UITableViewDelegate,
//    UITableViewDataSource

>
@property (weak, nonatomic) IBOutlet UIButton *btnInSales;
@property (weak, nonatomic) IBOutlet UIButton *btnWantToBuy;
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) IBOutlet UIView *menuOneView;
@property (strong, nonatomic) IBOutlet UILabel *lblMenuOneTitle;
@property (strong, nonatomic) IBOutlet UIView *menuTwoView;
@property (strong, nonatomic) IBOutlet UILabel *lblMenuTwoTitle;

@property (nonatomic,weak) IBOutlet UIButton *btnBiaoJiYiMai;
@property (nonatomic,weak) IBOutlet UIButton *btnChongXinShangJia;

- (IBAction)didPressedInSales:(id)sender;
- (IBAction)didPressedWantToBuy:(id)sender;
- (IBAction)didPressedCollection:(id)sender;
- (IBAction)didPressedCloseMenu:(id)sender;
- (IBAction)didPressedMenuOneLook:(id)sender;
- (IBAction)didPressedMenuOneChatRecord:(id)sender;
- (IBAction)didPressedMenuOneDelete:(id)sender;
- (IBAction)didPressedMuneOneShare:(id)sender;
- (IBAction)didPressedMenuTwoLook:(id)sender;
- (IBAction)didPressedMenuTwoModify:(id)sender;
- (IBAction)didPressedMenuTwoSignLooked:(id)sender;
- (IBAction)didPressedMenuTwoUporDown:(id)sender;
- (IBAction)didPressedMenuTwoDelete:(id)sender;
- (IBAction)didPressedTwoShare:(id)sender;
- (IBAction)didPressedCloseMenuTwo:(id)sender;
- (IBAction)didPressedContactLIst:(id)sender;

@end
