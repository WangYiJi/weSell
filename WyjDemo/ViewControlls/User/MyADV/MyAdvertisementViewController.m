//
//  MyAdvertisementViewController.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/25.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "MyAdvertisementViewController.h"
#import "Global.h"
#import "NetworkEngine.h"
#import "UserMember.h"
#import "SellPostQueryEntity.h"
#import "ResponseSellPostQuery.h"
#import "postItemsCell.h"
#import "WaterFallFlowLayout.h"
#import "postItemsCell.h"
#import "WaterFallFlowLayout.h"
#import "PublicUI.h"
#import "MJRefresh.h"
#import "ItemViewController.h"
#import "PutMarkSoldEntity.h"
#import "UnlistSellPostEntity.h"
#import "RelistSellPostEntity.h"
#import "DeleteSellPostEntity.h"
#import "ShareViewController.h"
#import "ChatRecordViewController.h"
#import "ContactListViewController.h"
#import "SaleViewController.h"
#import "DeleteFavoritePost.h"
#import "RequestDeleteChatUser.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

@interface MyAdvertisementViewController ()
{
    UIView *SlideView;
    WaterFallFlowLayout *layoutFlow;
    NSInteger page;
}

@property (nonatomic,strong) ResponseSellPostQuery *responseSellPostQuery;
@property (nonatomic,assign) MyADVType myADVType;
@property (nonatomic,strong) MyADVRefreshTool *myADVRefreshTool;
@property (nonatomic,strong) SellPostQueryResult *chooseSellPost;
@property (nonatomic,strong) NSMutableDictionary *favouriteDic;
@end

@implementation MyAdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    [self loadData];
}

- (void)createView{
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(back) addtarget:self];
    
    //tab切换底下的蓝线
    SlideView = [[UIView alloc] initWithFrame:CGRectMake(0, 43+64, SCREEN_WIDTH/3, 2)];
    UIView *orangeview = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6-40, 0, 80, 2)];
    orangeview.backgroundColor = selectedOrange;
    [SlideView addSubview:orangeview];
    SlideView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:SlideView];
    
    layoutFlow = [[WaterFallFlowLayout alloc]init];
    layoutFlow.itemCount = self.responseSellPostQuery.result.count;
    layoutFlow.responseSellPostQuery = self.responseSellPostQuery;
    [_mainCollectionView setCollectionViewLayout:layoutFlow];
    [_mainCollectionView registerClass:[postItemsCell class] forCellWithReuseIdentifier:@"postItemsCell"];
    
    //上拉加载
    _mainCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page = [self.responseSellPostQuery.page integerValue] + 1;
        [self.myADVRefreshTool refreshList:page type:self.myADVType superview:self.view];
        
    }];

}

-(void)back{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadData{
    //初始化刷新控制器
    self.myADVRefreshTool = [[MyADVRefreshTool alloc] init];
    self.myADVRefreshTool.delegate = self;
    page = 1;
    [_btnInSales sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshData{
    page = 1;
    [self.myADVRefreshTool refreshList:page type:self.myADVType superview:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressedInSales:(id)sender {
    [self changeTopTab:0];
    if (self.myADVType != MyADVType_InSales) {
        self.myADVType = MyADVType_InSales;
        page = 1;
    }
    
    [self.myADVRefreshTool refreshList:page type:self.myADVType superview:self.view];
}

- (IBAction)didPressedWantToBuy:(id)sender {
    [self changeTopTab:1];
    if (self.myADVType != MyADVType_WantToBuy) {
        self.myADVType = MyADVType_WantToBuy;
        page = 1;
    }
    
    [self.myADVRefreshTool refreshList:page type:self.myADVType superview:self.view];
    
}

- (IBAction)didPressedCollection:(id)sender {
    [self changeTopTab:2];
    if (self.myADVType != MyADVType_Collection) {
        self.myADVType = MyADVType_Collection;
        page = 1;
    }
    
    [self.myADVRefreshTool refreshList:page type:self.myADVType superview:self.view];
    
}

- (IBAction)didPressedCloseMenu:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        _menuOneView.alpha = 0;
    }];
}

- (IBAction)didPressedMenuOneLook:(id)sender {
    [self hideMenuOne];
    ItemViewController *vc = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    vc.sPostId = self.chooseSellPost.postId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressedMenuOneChatRecord:(id)sender {
    //聊天记录
    [self hideMenuOne];
    ChatRecordViewController *vc = [[ChatRecordViewController alloc] initWithNibName:@"ChatRecordViewController" bundle:nil];
    vc.sBuyNowUserId = self.chooseSellPost.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressedMenuOneDelete:(id)sender {
    if (self.myADVType == MyADVType_Collection) {
        //取消收藏
        DeleteFavoritePost *request = [[DeleteFavoritePost alloc] init];
        NSString *favId = [_favouriteDic objectForKey:self.chooseSellPost.postId];
        request.favId = favId;
        
        __weak typeof(self) weakSelf = self;
        [NetworkEngine deleteRequest:request success:^(id json) {
            [NetworkEngine hiddenDialog];
            [weakSelf hideMenuOne];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"取消收藏成功"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [weakSelf refreshData];
        } fail:^(NSError *error) {
            [NetworkEngine hiddenDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"取消收藏失败"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    } else if (self.myADVType == MyADVType_WantToBuy) {
        [NetworkEngine showMbDialog:self.navigationController.view title:@"请稍等"];
        
        RequestDeleteChatUser *request = [[RequestDeleteChatUser alloc] init];
        request.postId = self.chooseSellPost.postId;
        
        __weak typeof(self) weakSelf = self;
        [NetworkEngine deleteRequest:request success:^(id json) {
            [NetworkEngine hiddenDialog];
            [weakSelf hideMenuOne];
            [weakSelf refreshData];
        } fail:^(NSError *error) {
            [NetworkEngine hiddenDialog];
            [NetworkEngine alertSimpleMessage:@"请求失败"];
        }];
    }
    else {
        [NetworkEngine showMbDialog:self.navigationController.view title:@"请稍等"];
        DeleteSellPostEntity *entity = [[DeleteSellPostEntity alloc] init];
        [entity setUrl:self.chooseSellPost.postId];
        
        __weak typeof(self) weakSelf = self;
        [NetworkEngine deleteRequest:entity success:^(id json) {
            [weakSelf hideMenuOne];
            [NetworkEngine hiddenDialog];
            [weakSelf refreshData];
        } fail:^(NSError *error) {
            [weakSelf hideMenuOne];
            [NetworkEngine hiddenDialog];
            [NetworkEngine alertSimpleMessage:@"请求失败"];
        }];
    }

}

- (IBAction)didPressedMuneOneShare:(id)sender {
    //分享
    [self hideMenuOne];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享给好友"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"短信",@"邮件",@"取消", nil];
    sheet.tag = 889;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 889) {
        if (actionSheet.tag == 889) {
            NSString *sFinal = [AppDelegateEntity.sShareTemplate stringByReplacingOccurrencesOfString:@"[%s]" withString:self.chooseSellPost.title];
            if (buttonIndex == 0) {
                //调短信
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"]];
                if( [MFMessageComposeViewController canSendText] )
                {
                    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
                    //controller.recipients = phones;
                    //controller.navigationBar.tintColor = [UIColor redColor];
                    controller.body = sFinal;
                    controller.messageComposeDelegate = self;
                    [self presentViewController:controller animated:YES completion:nil];
                    //[[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"该设备不支持短信功能"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            else if (buttonIndex == 1) {
                //调邮件
                MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];     //创建邮件controller
                
                mailPicker.mailComposeDelegate = self;  //设置邮件代理
                
                [mailPicker setSubject:@""]; //邮件主题
                
                [mailPicker setMessageBody:sFinal isHTML:NO];
                
                [self presentViewController:mailPicker animated:YES completion:^{
                    
                }];
                
                
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:"]];
            }
        }
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result

                        error:(NSError*)error

{
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


- (IBAction)didPressedMenuTwoLook:(id)sender {
    [self hideMenuTwo];
    ItemViewController *vc = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    vc.sPostId = self.chooseSellPost.postId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressedMenuTwoModify:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        _menuTwoView.alpha = 0;
    }];
    //修改
    SaleViewController *sVc = [[SaleViewController alloc] initWithNibName:@"SaleViewController" bundle:nil];
    sVc.chooseSellPost = self.chooseSellPost;
    sVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sVc animated:YES];
}

- (IBAction)didPressedMenuTwoSignLooked:(id)sender {
    [NetworkEngine showMbDialog:self.navigationController.view  title:@"请稍等"];
    PutMarkSoldEntity *entity = [[PutMarkSoldEntity alloc] init];
    [entity setUrl:self.chooseSellPost.postId];
    
    __weak typeof(self) weakSelf = self;
    [NetworkEngine putUserInfoWithEntity:entity success:^(id json) {
        [weakSelf hideMenuTwo];
        [NetworkEngine hiddenDialog];
        [weakSelf refreshData];
    } fail:^(NSError *error) {
        [weakSelf hideMenuTwo];
        [NetworkEngine hiddenDialog];
        [NetworkEngine alertSimpleMessage:@"请求失败"];
    }];
    
}

- (IBAction)didPressedMenuTwoUporDown:(id)sender {
    [NetworkEngine showMbDialog:self.navigationController.view title:@"请稍等"];
    if ([self.chooseSellPost.status isEqualToString:@"AVAILABLE"]) {
        UnlistSellPostEntity *entity = [[UnlistSellPostEntity alloc] init];
        [entity setUrl:self.chooseSellPost.postId];
        
        __weak typeof(self) weakSelf = self;
        [NetworkEngine putUserInfoWithEntity:entity success:^(id json) {
            [weakSelf hideMenuTwo];
            [NetworkEngine hiddenDialog];
            
            [weakSelf refreshData];
        } fail:^(NSError *error) {
            [weakSelf hideMenuTwo];
            [NetworkEngine hiddenDialog];
            [NetworkEngine alertSimpleMessage:@"请求失败"];
        }];
    }else if ([self.chooseSellPost.status isEqualToString:@"UNLISTED"]||[self.chooseSellPost.status isEqualToString:@"SOLD"]) {
        RelistSellPostEntity *entity = [[RelistSellPostEntity alloc] init];
        [entity setUrl:self.chooseSellPost.postId];
        
        __weak typeof(self) weakSelf = self;
        [NetworkEngine putUserInfoWithEntity:entity success:^(id json) {
            [weakSelf hideMenuTwo];
            [NetworkEngine hiddenDialog];
            
            [weakSelf refreshData];
        } fail:^(NSError *error) {
            [weakSelf hideMenuTwo];
            [NetworkEngine hiddenDialog];
            [NetworkEngine alertSimpleMessage:@"请求失败"];
        }];
    }
}

- (IBAction)didPressedMenuTwoDelete:(id)sender {
    [NetworkEngine showMbDialog:self.navigationController.view title:@"请稍等"];
    DeleteSellPostEntity *entity = [[DeleteSellPostEntity alloc] init];
    [entity setUrl:self.chooseSellPost.postId];
    
    __weak typeof(self) weakSelf = self;
    [NetworkEngine deleteRequest:entity success:^(id json) {
        [weakSelf hideMenuTwo];
        [NetworkEngine hiddenDialog];
        [weakSelf refreshData];
    } fail:^(NSError *error) {
        [weakSelf hideMenuTwo];
        [NetworkEngine hiddenDialog];
        [NetworkEngine alertSimpleMessage:@"请求失败"];
    }];
}

- (IBAction)didPressedTwoShare:(id)sender {
    //分享
    [self hideMenuTwo];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享给好友"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"短信",@"邮件",@"取消", nil];
    sheet.tag = 889;
    [sheet showInView:self.view];
}

- (IBAction)didPressedCloseMenuTwo:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        _menuTwoView.alpha = 0;
    }];
}

- (IBAction)didPressedContactLIst:(id)sender {
    //联系人列表
    [self hideMenuTwo];
    ContactListViewController *vc = [[ContactListViewController alloc] initWithNibName:@"ContactListViewController" bundle:nil];
    vc.choosePost = self.chooseSellPost;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)changeTopTab:(NSInteger)i{
    [_btnInSales setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnWantToBuy setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnCollection setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self changeSlide:i];
    
    switch (i) {
        case 0:
        {
            [_btnInSales setTitleColor:selectedOrange forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [_btnWantToBuy setTitleColor:selectedOrange forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_btnCollection setTitleColor:selectedOrange forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)changeSlide:(NSInteger)i{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    switch (i) {
        case 0:
        {
            SlideView.frame = CGRectMake(0, 43+64, SCREEN_WIDTH/3, 2);
        }
            break;
        case 1:
        {
            SlideView.frame = CGRectMake(SCREEN_WIDTH/3, 43+64, SCREEN_WIDTH/3, 2);
        }
            break;
        case 2:
        {
            SlideView.frame = CGRectMake(2*SCREEN_WIDTH/3, 43+64, SCREEN_WIDTH/3, 2);
        }
            break;
        default:
            break;
    }
    
    [UIView commitAnimations];
}

#pragma mark - refresh delegate
- (void)getMyAdvRefreshResponse:(ResponseSellPostQuery *)responseSellPostQuery dic:(NSMutableDictionary *)favDic{
    
    if (favDic) {
        self.favouriteDic = favDic;
    }
    
    if (self.myADVRefreshTool.page > 1) {
        self.responseSellPostQuery.hasNext = responseSellPostQuery.hasNext;
        self.responseSellPostQuery.page = responseSellPostQuery.page;
        self.responseSellPostQuery.pageSize = responseSellPostQuery.pageSize;
        [self.responseSellPostQuery.result addObjectsFromArray:responseSellPostQuery.result];
    }else {
        self.responseSellPostQuery = responseSellPostQuery;
    }
    layoutFlow.responseSellPostQuery = self.responseSellPostQuery;
    layoutFlow.itemCount = self.responseSellPostQuery.result.count;
    
    [_mainCollectionView reloadData];
    [_mainCollectionView.footer endRefreshing];
    
    if ([self.responseSellPostQuery.hasNext integerValue] == 0) {
        _mainCollectionView.footer.hidden = YES;
    }else {
        _mainCollectionView.footer.hidden = NO;
    }
}

- (void)getMyAdvRefreshResponseFail:(NSError *)error{
    [_mainCollectionView.footer endRefreshing];
}

#pragma mark - collectionView dataSource Or delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.responseSellPostQuery.result count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    postItemsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postItemsCell" forIndexPath:indexPath];
    SellPostQueryResult *sellPost = [self.responseSellPostQuery.result objectAtIndex:indexPath.row];
    cell.sellPostQueryResult = sellPost;
    [cell showImgvTag:sellPost.status];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.chooseSellPost = [self.responseSellPostQuery.result objectAtIndex:indexPath.row];
    
    
    if ([self.chooseSellPost.status isEqualToString:@"AVAILABLE"]) {
        //在卖 标记已卖可点 重新上架不可点
        [_btnBiaoJiYiMai setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _btnBiaoJiYiMai.enabled = YES;
        [_btnChongXinShangJia setTitleColor:CannotPressGray forState:UIControlStateNormal];
        _btnChongXinShangJia.enabled = NO;
        
    } else {
        //不在卖 标记已卖不可点
        [_btnBiaoJiYiMai setTitleColor:CannotPressGray forState:UIControlStateNormal];
        _btnBiaoJiYiMai.enabled = NO;
        [_btnChongXinShangJia setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _btnChongXinShangJia.enabled = YES;
    }
    
    switch (self.myADVType) {
        case MyADVType_InSales:
        {
            [self showMenuTwo];
        }
            break;
        case MyADVType_WantToBuy:
        {
            [self showMenuOne];
        }
            break;
        case MyADVType_Collection:
        {
            [self showMenuOne];
        }
            break;
        default:
            break;
    }
}

/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//上 左 下 右
}

#pragma mark - menu show
- (void)showMenuOne{
    _lblMenuOneTitle.text = self.chooseSellPost.title;
    if (!_menuOneView.superview) {
        [self.navigationController.view addSubview:_menuOneView];
        _menuOneView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20);
        _menuOneView.alpha = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _menuOneView.alpha = 1.0;
    }];
}

- (void)showMenuTwo{
    _lblMenuTwoTitle.text = self.chooseSellPost.title;
    if (!_menuTwoView.superview) {
        [self.navigationController.view addSubview:_menuTwoView];
        _menuTwoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20);
        _menuTwoView.alpha = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _menuTwoView.alpha = 1.0;
    }];
}

- (void)hideMenuOne{
    [UIView animateWithDuration:0.25 animations:^{
        _menuOneView.alpha = 0;
    }];
}

- (void)hideMenuTwo{
    [UIView animateWithDuration:0.25 animations:^{
        _menuTwoView.alpha = 0;
    }];
}

#pragma mark - Tableview delegate
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 8;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end
