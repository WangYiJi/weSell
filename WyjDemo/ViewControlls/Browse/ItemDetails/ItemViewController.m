//
//  ItemViewController.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/28.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ItemViewController.h"
#import "PublicUI.h"
#import "NetworkEngine.h"
#import "SellByIdEntity.h"
#import "ResponseSellPostQuery.h"
#import "Utils.h"
#import "AbuseViewController.h"
#import "AbuseTypeCell.h"
#import "ChatRecordViewController.h"
#import "CreateFavoritePost.h"
#import "BuyViewController.h"
#import "DeleteFavoritePost.h"
#import "UserMember.h"
#import "SellerInfoViewController.h"
#import "RequestChatConnect.h"
#import "ResponseChatConnect.h"
#import "LoginViewController.h"
#import "ImageScrollerViewController.h"
#import "ShareViewController.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

#define scoll_image_height 320

@interface ItemViewController ()
{
    BOOL bFavorite;//判断是否收藏过
    NSString *sFavId;
}

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    [self loadData];
}

- (void)createView{
    
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(back) addtarget:self];
    [_btnChat setTitle:CustomLocalizedString(@"联系卖家", nil) forState:UIControlStateNormal];
    [_btnBuy setTitle:CustomLocalizedString(@"立即购买", nil) forState:UIControlStateNormal];
    _lblPriceInfo.text = CustomLocalizedString(@"卖主接受协议", nil);
    [_btnJuBao setTitle:CustomLocalizedString(@"举报", nil) forState:UIControlStateNormal];
    self.title = CustomLocalizedString(@"商品详情", nil);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)loadData{
    if (!self.sellPostQueryResult) {
        [NetworkEngine showMbDialog:self.view title:@"正在加载"];
        _mainTableView.hidden = YES;
        SellByIdEntity *sellByIdEntity = [[SellByIdEntity alloc] init];
        sellByIdEntity.postIds = self.sPostId;
        sellByIdEntity.viewerId = [UserMember getInstance].userId;
        
        __weak typeof(self) weakSelf = self;
        [NetworkEngine getJSONWithUrl:sellByIdEntity success:^(id json) {
            [NetworkEngine hiddenDialog];
            _mainTableView.hidden = NO;
            ResponseByIds *responseByIds = [[ResponseByIds alloc] initwithJson:json];
            weakSelf.sellPostQueryResult = [responseByIds.ArraySellPost objectAtIndex:0];
            
            [weakSelf loadImageHeaderCell];
            [weakSelf loadItemInfoCell];
            [weakSelf loadMapView];
            [weakSelf loadBottomView];
            [weakSelf loadADV];
            
            bFavorite = [self.sellPostQueryResult.favorited boolValue];
            if (bFavorite) {
                _imgFavorte.image = [UIImage imageNamed:@"favSel"];
            } else {
                _imgFavorte.image = [UIImage imageNamed:@"Star"];
            }
            [_mainTableView reloadData];
        } fail:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请求失败"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
            [NetworkEngine hiddenDialog];
            [_mainTableView reloadData];
        }];
    }else {
        [self loadImageHeaderCell];
        [self loadItemInfoCell];
        [self loadMapView];
        [self loadBottomView];
        [self loadADV];
        [_mainTableView reloadData];
    }
    
//    if ([UserMember getInstance].isLogin) {
//        self.btnBuy.enabled = YES;
//        self.btnChat.enabled = YES;
//        self.btnFave.enabled = YES;
//    } else {
//        self.btnBuy.enabled = NO;
//        self.btnChat.enabled = NO;
//        self.btnFave.enabled = NO;
//    }
}

- (void)loadBottomView{
    _lblFavourtecnt.text = [NSString stringWithFormat:@"%ld",[self.sellPostQueryResult.favoriteCnt integerValue]];
}

- (void)loadImageHeaderCell{
    if (self.sellPostQueryResult.photos.count > 0) {
        for (int i=0;i<[self.sellPostQueryResult.photos count];i++) {
            UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, scoll_image_height)];
            Photos *p = [self.sellPostQueryResult.photos objectAtIndex:i];
            [v sd_setImageWithURL:[NSURL URLWithString:p.imageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
            v.contentMode = UIViewContentModeScaleAspectFit;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, scoll_image_height);
            [btn addTarget:self action:@selector(tapTopImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [_imageScroll addSubview:v];
            
            [_imageScroll addSubview:btn];
            
        }
        
        _ADVPageControl.hidden = NO;
        _ADVPageControl.numberOfPages = self.sellPostQueryResult.photos.count;
        _ADVPageControl.currentPage = 0;
        [_ADVPageControl addTarget:self action:@selector(didPressedchangePage:) forControlEvents:UIControlEventValueChanged];
        
        _imageScroll.delegate = self;
        _imageScroll.showsHorizontalScrollIndicator = NO;//水平不显示
        [_imageScroll setContentSize:CGSizeMake(SCREEN_WIDTH*self.sellPostQueryResult.photos.count, _cellImageScroll.frame.size.height)];
    }
}

#warning wyj test
-(void)tapTopImage:(UIButton*)b
{
    ImageScrollerViewController *vc = [[ImageScrollerViewController alloc] initWithNibName:@"ImageScrollerViewController" bundle:nil];
    vc.sellPostQueryResult = self.sellPostQueryResult;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _imageScroll) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = scrollView.contentOffset.x/pageWidth;
        _ADVPageControl.currentPage = page;
    }
    
}

//加载商品头部信息
- (void)loadItemInfoCell{
    [_imgHeader sd_setImageWithURL:[NSURL URLWithString:self.sellPostQueryResult.userAvatarSmallUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    _lblName.text = self.sellPostQueryResult.userDiapName;
    _lblPostDate.text = [Utils DateStringFromDateSp:self.sellPostQueryResult.createdAt];
    _lblItemName.text = self.sellPostQueryResult.title;
    _lblItemPrice.text = [NSString stringWithFormat:@"%@%.2f",_sellPostQueryResult.price.currencySymbol,[self.sellPostQueryResult.price.value floatValue]];
    _lblItemDescription.text = self.sellPostQueryResult.details;
    if (self.sellPostQueryResult.address.streetLine1.length > 0) {
        _lblLocation.text = self.sellPostQueryResult.address.streetLine1;
    }
    else if (self.sellPostQueryResult.address.streetLine2.length > 0) {
        _lblLocation.text = self.self.sellPostQueryResult.address.streetLine2;
    }
    else {
        _lblLocation.text = @"未知";
    }
    
    if ([self.sellPostQueryResult.firmPrice boolValue]) {
        _lblPriceInfo.text = @"卖主接受议价";
    }else {
        _lblPriceInfo.text = @"卖主不接受议价";
    }
}

- (void)loadMapView{
    if (self.sellPostQueryResult.coordination) {
        CLLocationCoordinate2D mapCoordination = CLLocationCoordinate2DMake([self.sellPostQueryResult.coordination.lattitude floatValue], [self.sellPostQueryResult.coordination.longitude floatValue]);
        //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
        MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
        MKCoordinateRegion region=MKCoordinateRegionMake(mapCoordination, span);
        [_mapView setRegion:region animated:NO];
        [_mapView addOverlays:[self createOverlay:mapCoordination] level:MKOverlayLevelAboveRoads];
    }
}

//生成覆盖位置
- (NSArray *) createOverlay:(CLLocationCoordinate2D)mapCoordination{
    NSMutableArray *overlayArray = [[NSMutableArray alloc] init];
        
    MKCircle *mCircle = [MKCircle circleWithCenterCoordinate:mapCoordination radius:200.0];
    [overlayArray addObject:mCircle];
    
    return overlayArray;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer* circleView = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        circleView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        circleView.lineWidth = 3.0; return circleView;
    }
    return nil;
}

- (void)loadADV{
    SellPostQueryResult *sADV = [self.sellPostQueryResult.sponsoredAds objectAtIndex:0];
    [_imgADV sd_setImageWithURL:[NSURL URLWithString:sADV.thumbnailPhoto.smallImageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    _lblADVTitle.text = sADV.title;
    _lblADVDate.text = [Utils DateStringFromDateSp:sADV.createdAt];
    _lblADVPrice.text = [NSString stringWithFormat:@"%@%.2f",sADV.price.currencySymbol,[sADV.price.value floatValue]];
    _lblADVDescription.text = sADV.details;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return _cellImageScroll;
            break;
        case 1:
            return _cellItemInfo;
            break;
        case 2:
            return _cellMap;
            break;
        case 3:
            return _cellADV;
            break;
        default:
            return _cellButton;
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return _cellImageScroll.frame.size.height;
            break;
        case 1:
            return _cellItemInfo.frame.size.height;
            break;
        case 2:
            return _cellMap.frame.size.height;
            break;
        case 3:
        {
            if (self.sellPostQueryResult.sponsoredAds.count >0) {
                return _cellADV.frame.size.height;
            }else {
                return 0;
            }
        }
            break;
        default:
            return _cellButton.frame.size.height;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        //赞助广告
        ItemViewController *iVC = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
        iVC.sellPostQueryResult = [self.sellPostQueryResult.sponsoredAds objectAtIndex:0];
        iVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:iVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else if (section == 3){
        if (self.sellPostQueryResult.sponsoredAds.count >0) {
            return 10;
        }else {
            return 0;
        }
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return footview;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - mapview
#pragma mark 添加大头针
-(void)addAnnotation:(CLLocationCoordinate2D)coordinate{
//    MKAnnotationView *annotation1=[[MKAnnotationView alloc]init];
//    annotation1.title=@"CMJ Studio";
//    annotation1.subtitle=@"Kenshin Cui's Studios";
//    annotation1.coordinate=location1;
//    [_mapView addAnnotation:annotation1];
}

#pragma mark - Button
- (IBAction)didPressedChat:(id)sender
{
    if (![UserMember getInstance].isLogin) {
        [self pushToLoginVC];
    } else {
        if ([UserMember getInstance].isLogin) {
            if ([self.sellPostQueryResult.userId isEqualToString:[UserMember getInstance].userId]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"您不能联系自己发布的物品"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                [NetworkEngine showMbDialog:self.view title:@"请稍后"];
                RequestChatConnect *request = [[RequestChatConnect alloc] init];
                request.userId2 = self.sellPostQueryResult.userId;
                request.postId = self.sellPostQueryResult.postId;
                [NetworkEngine postRequestEntity:request contentType:@"application/x-www-form-urlencoded" success:^(id json) {
                    [NetworkEngine hiddenDialog];
                    ResponseChatConnect *response = [[ResponseChatConnect alloc] initwithJson:json];
                    
                    NSString *final = [NSString stringWithFormat:@"你好，我对你贴的广告有兴趣，我的出价是%@%.2f，谢谢!",self.sellPostQueryResult.price.currencySymbol,[self.sellPostQueryResult.price.value floatValue]];
                    ChatRecordViewController *vc = [[ChatRecordViewController alloc] initWithNibName:@"ChatRecordViewController" bundle:nil];
                    vc.bBuyNow = YES;
                    vc.sBuyNowMsg =final;
                    vc.sPostId = self.sellPostQueryResult.postId;
                    vc.sPostName = self.sellPostQueryResult.title;
                    if ([self.sellPostQueryResult.photos count] > 0) {
                        Photos *p = [self.sellPostQueryResult.photos objectAtIndex:0];
                        vc.sImg = p.imageUrl;
                    }
                    vc.sPrice = [NSString stringWithFormat:@"%@%.2f",self.sellPostQueryResult.price.currencySymbol,[self.sellPostQueryResult.price.value floatValue]];
                    
                    
                    if ([response.postOwner isEqualToString:@"USER2"]) {
                        vc.sBuyNowUserId = response.userId2;
                    } else {
                        vc.sBuyNowUserId = response.userId1;
                    }
                    
                    [self.navigationController pushViewController:vc animated:YES];
                } fail:^(NSError *error) {
                    [NetworkEngine hiddenDialog];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系失败"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }];
            }
        } else {
            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginVC.navigationItem.title = CustomLocalizedString(@"登录", nil);
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}

- (IBAction)didPressedFavorite:(id)sender {
    
    if (![UserMember getInstance].isLogin) {
        [self pushToLoginVC];
    }else {
        if ([self.sellPostQueryResult.userId isEqualToString:[UserMember getInstance].userId]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您不能收藏自己发布的物品"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }else {
            [NetworkEngine showMbDialog:self.view title:@"请稍后"];
            if (!bFavorite) {
                CreateFavoritePost *createFavoriteEntity = [[CreateFavoritePost alloc] init];
                createFavoriteEntity.postId = self.sellPostQueryResult.postId;
                createFavoriteEntity.type = @"INTERESTED";
                
                [NetworkEngine postRequestEntity:createFavoriteEntity contentType:@"application/x-www-form-urlencoded" success:^(id json) {
                    [NetworkEngine hiddenDialog];
                    sFavId = [json objectForKey:@"favoriteId"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"收藏成功"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                    _imgFavorte.image = [UIImage imageNamed:@"favSel"];
                    bFavorite = !bFavorite;
                } fail:^(NSError *error) {
                    [NetworkEngine hiddenDialog];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"收藏失败"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }];
            }else {
                //取消收藏
                DeleteFavoritePost *request = [[DeleteFavoritePost alloc] init];
                request.favId = sFavId;
                [NetworkEngine deleteRequest:request success:^(id json) {
                    [NetworkEngine hiddenDialog];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"取消收藏成功"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                    bFavorite = !bFavorite;
                    _imgFavorte.image = [UIImage imageNamed:@"Star"];
                } fail:^(NSError *error) {
                    [NetworkEngine hiddenDialog];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"取消收藏失败"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }];
            }
        }
        
    }
    
}

- (void)pushToLoginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.navigationItem.title = CustomLocalizedString(@"登录", nil);
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)didPressedBuyNow:(id)sender {
    if ([UserMember getInstance].isLogin) {
        if ([self.sellPostQueryResult.userId isEqualToString:[UserMember getInstance].userId]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您不能联系自己发布的物品"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }else {
            BuyViewController *bVc = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
            bVc.chooseSellPost = self.sellPostQueryResult;
            bVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bVc animated:YES];
        }
        
    } else {
         [self pushToLoginVC];
    }
}

- (IBAction)didPressedToSellerInfo:(id)sender {
    SellerInfoViewController *vc = [[SellerInfoViewController alloc] initWithNibName:@"SellerInfoViewController" bundle:nil];
    vc.sellPostQueryResult = self.sellPostQueryResult;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressedShare:(id)sender {
    //分享
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
            NSString *sFinal = [AppDelegateEntity.sShareTemplate stringByReplacingOccurrencesOfString:@"[%s]" withString:self.sellPostQueryResult.title];
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

//举报
- (IBAction)didPressedInform:(id)sender {
    if ([self.sellPostQueryResult.userId isEqualToString:[UserMember getInstance].userId]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您不能举报自己发布的物品"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }else {
        
        if ([UserMember getInstance].isLogin) {
            AbuseViewController *aVC = [[AbuseViewController alloc] initWithNibName:@"AbuseViewController" bundle:nil];
            aVC.postId = self.sPostId;
            [self.navigationController pushViewController:aVC animated:YES];
        } else {
            if (![UserMember getInstance].isLogin) {
                LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                loginVC.navigationItem.title = CustomLocalizedString(@"登录", nil);
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
    }
    
}

//点击pagecontrol事件
-(void)didPressedchangePage:(id)sender{
    NSInteger page = _ADVPageControl.currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = _imageScroll.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_imageScroll scrollRectToVisible:frame animated:YES];
}
@end
