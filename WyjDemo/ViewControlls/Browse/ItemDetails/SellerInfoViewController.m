//
//  SellerInfoViewController.m
//  WyjDemo
//
//  Created by zjb on 16/3/3.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "SellerInfoViewController.h"
#import "GetSelfSellPostsEntity.h"
#import "NetworkEngine.h"
#import "ResponseSellPostQuery.h"
#import "SellerInfoFlowLayout.h"
#import "postItemsCell.h"
#import "ItemViewController.h"
#import "PublicUI.h"
#import "MJRefresh.h"
#import "AbuseViewController.h"
#import "UserMember.h"
#import "RequestChatConnect.h"
#import "ResponseChatConnect.h"
#import "ChatRecordViewController.h"

@interface SellerInfoViewController (){
    SellerInfoFlowLayout *layoutFlow;
}
@property (nonatomic,strong) ResponseSellPostQuery *responseSellPostQuery;
@end

@implementation SellerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self createView];
    [self loadData];
}

- (void)loadData{
    [self getInSalesList];
}

-(void)createView{
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(back) addtarget:self];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//scrollview适配
    
    layoutFlow = [[SellerInfoFlowLayout alloc]init];
    layoutFlow.itemCount = self.responseSellPostQuery.result.count+1;
    layoutFlow.responseSellPostQuery = self.responseSellPostQuery;
    [_mainCollectionView setCollectionViewLayout:layoutFlow];
    [_mainCollectionView registerClass:[postItemsCell class] forCellWithReuseIdentifier:@"postItemsCell"];
    [_mainCollectionView registerClass:[SellerInfoCell class] forCellWithReuseIdentifier:@"SellerInfoCell"];
    
    //下拉刷新
    _mainCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getInSalesList];
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getInSalesList{
    [NetworkEngine showMbDialog:self.view title:@"正在加载"];
    GetSelfSellPostsEntity *sellPostQueryEntity = [[GetSelfSellPostsEntity alloc] init];
    
    sellPostQueryEntity.userId = self.sellPostQueryResult.userId;
    sellPostQueryEntity.page = self.responseSellPostQuery?[NSString stringWithFormat:@"%zd",[self.responseSellPostQuery.page integerValue]+1]:@"1";
    sellPostQueryEntity.pageSize = @"20";
    
    __weak typeof(self) weakSelf = self;
    [NetworkEngine getJSONWithUrl:sellPostQueryEntity success:^(id json) {
        [NetworkEngine hiddenDialog];
        if (weakSelf.responseSellPostQuery.result.count > 0) {
            ResponseSellPostQuery *tempResponse = [[ResponseSellPostQuery alloc] initwithJson:json];
            [weakSelf.responseSellPostQuery.result addObjectsFromArray:tempResponse.result];
            weakSelf.responseSellPostQuery.page = tempResponse.page;
            weakSelf.responseSellPostQuery.pageSize = tempResponse.pageSize;
            weakSelf.responseSellPostQuery.hasNext = tempResponse.hasNext;
        }else {
            weakSelf.responseSellPostQuery = [[ResponseSellPostQuery alloc] initwithJson:json];
        }
        
        layoutFlow.responseSellPostQuery = weakSelf.responseSellPostQuery;
        layoutFlow.itemCount = weakSelf.responseSellPostQuery.result.count + 1;
        
        [weakSelf.mainCollectionView.footer endRefreshing];
        [weakSelf.mainCollectionView reloadData];
        if ([weakSelf.responseSellPostQuery.hasNext integerValue] == 1) {
            weakSelf.mainCollectionView.footer.hidden = NO;
        }else {
            weakSelf.mainCollectionView.footer.hidden = YES;
        }
        
    } fail:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请求失败"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        [NetworkEngine hiddenDialog];
        [weakSelf.mainCollectionView.footer endRefreshing];
        
    }];
}

#pragma mark - collectionView dataSource Or delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.responseSellPostQuery.result count] + 1 ;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SellerInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellerInfoCell" forIndexPath:indexPath];
        [cell loadPostInfo:self.sellPostQueryResult superview:self.view];
        cell.delegate = self;
        return cell;
    }else {
        postItemsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postItemsCell" forIndexPath:indexPath];
        SellPostQueryResult *sellPost = [self.responseSellPostQuery.result objectAtIndex:indexPath.row-1];
        cell.sellPostQueryResult = sellPost;
        
        return cell;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        SellPostQueryResult *sellPost = [self.responseSellPostQuery.result objectAtIndex:indexPath.row-1];
        ItemViewController *vc = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
        vc.sPostId = sellPost.postId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - sellInfo delegate
- (void)sellerInfoAbuse:(NSString *)sPostId{
    AbuseViewController *aVC = [[AbuseViewController alloc] initWithNibName:@"AbuseViewController" bundle:nil];
    aVC.postId = sPostId;
    [self.navigationController pushViewController:aVC animated:YES];
}

- (void)sellerInfoContact:(SellPostQueryResult *)postQueryResult{
    if ([postQueryResult.userId isEqualToString:[UserMember getInstance].userId]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您不能联系自己发布的物品"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [NetworkEngine showMbDialog:self.view title:@"请稍后"];
        RequestChatConnect *request = [[RequestChatConnect alloc] init];
        request.userId2 = postQueryResult.userId;
        request.postId = postQueryResult.postId;
        [NetworkEngine postRequestEntity:request contentType:@"application/x-www-form-urlencoded" success:^(id json) {
            [NetworkEngine hiddenDialog];
            ResponseChatConnect *response = [[ResponseChatConnect alloc] initwithJson:json];
            
            NSString *final = [NSString stringWithFormat:@"你好，我对你贴的广告有兴趣，我的出价是%@%.2f，谢谢!",postQueryResult.price.currencySymbol,
                               [postQueryResult.price.value floatValue]];
            ChatRecordViewController *vc = [[ChatRecordViewController alloc] initWithNibName:@"ChatRecordViewController" bundle:nil];
            vc.bBuyNow = YES;
            vc.sBuyNowMsg =final;
            vc.sPostId = postQueryResult.postId;
            vc.sPostName = postQueryResult.title;
            if ([postQueryResult.photos count] > 0) {
                Photos *p = [postQueryResult.photos objectAtIndex:0];
                vc.sImg = p.imageUrl;
            }
            vc.sPrice = [NSString stringWithFormat:@"%@%.2f",postQueryResult.price.currencySymbol,[postQueryResult.price.value floatValue]];
            
            
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
}

/*
// 定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    SellPostQueryResult *sellPost = [self.responseSellPostQuery.result objectAtIndex:indexPath.row];
//    float fwidth = (SCREEN_WIDTH-15)/2;
//    float fheight = (fwidth/[sellPost.thumbnailPhoto.width floatValue])*[sellPost.thumbnailPhoto.height floatValue];
//    return CGSizeMake(fwidth, fheight+42);
//}
// 定义每个UICollectionView 的边缘
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);//上 左 下 右
//
//}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
