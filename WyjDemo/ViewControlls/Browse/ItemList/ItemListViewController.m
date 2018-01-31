//
//  ItemsListViewController.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/17.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ItemListViewController.h"
#import "NetworkEngine.h"
#import "UserMember.h"
#import "SellPostQueryEntity.h"
#import "ResponseSellPostQuery.h"
#import "postItemsCell.h"
#import "WaterFallFlowLayout.h"
#import "CountryEntity.h"
#import "ResponseCountry.h"
#import "ItemViewController.h"
#import "Utils.h"
#import "CityCell.h"
#import "UITableView+CustomCell.h"
#import "MJRefresh.h"
#import "CategoryAndCountryInfo.h"
#import "CategoryEntity.h"
#import "CitysViewController.h"
#import "LocationManger.h"
#import "UserMember.h"
#import "CategoryCell.h"

#define categoryTag 88888
#define SortOptionsTag 99999
#define ConditionsTag 77777

@interface ItemListViewController (){
    WaterFallFlowLayout *layoutFlow;
    cityType iCityType;//城市类型
    NSMutableArray *cityArr;
    NSInteger sliderValue;
    NSInteger page;
    NSString *sLanguage;
    BOOL bHideShaiXuan;//改变语言后让筛选菜单不自动出来
}
@property (nonatomic,strong) ResponseSellPostQuery *responseSellPostQuery;
@property (nonatomic,strong) ResponseCountry *responseCountry;
@property (nonatomic,strong) CountryInfo *chooseContryInfo;
@property (strong,nonatomic) ProvinceOrStateInfos *chooseProvince;//选中省份
@property (strong,nonatomic) CityInfo *chooseCity;//选中城市
@property (strong,nonatomic) ConditionLevelInfo *chooseCondition;//选择新旧程度
@property (strong,nonatomic) sortOptions *chooseSortOptions;
@property (strong,nonatomic) CategoryInfo *chooseCategory;
@property (strong,nonatomic) SellPostQueryEntity *postsRequest;
@end

@implementation ItemListViewController

- (void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sLanguage = [[NSUserDefaults standardUserDefaults] valueForKey:AppLanguage];
    
    [self createView];
    
    [self loadData];
    
}

- (void)refreshShaixuan{
    bHideShaiXuan = YES;
    sLanguage = [[NSUserDefaults standardUserDefaults] valueForKey:AppLanguage];
    [self didPressedResetShaiXuan:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self loadData];
    
    _txtSearch.placeholder = CustomLocalizedString(@"搜搜看", nil);
    [_btnShaixuan setTitle:CustomLocalizedString(@"筛选", nil) forState:UIControlStateNormal];
    _lblShaixuanTitle.text = CustomLocalizedString(@"筛选", nil);
    _lblPriceTitle.text = CustomLocalizedString(@"价格", nil);
    _lblCategory.text = CustomLocalizedString(@"分类", nil);
    _lblDistance.text = CustomLocalizedString(@"距离", nil);
    [_btnSetDone setTitle:CustomLocalizedString(@"设置筛选", nil) forState:UIControlStateNormal];
    NSString *stitle = CustomLocalizedString(@"卖了吧", nil);
    self.navigationItem.title = stitle;
    //判断语言变化
    if (![sLanguage isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:AppLanguage]]) {
        [self refreshShaixuan];
    }
}

- (void)createView{
    NSLog(@"11:%@",CustomLocalizedString(@"卖了吧", nil));
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//scrollview适配
    
    self.txtPriceFrom.inputAccessoryView = self.myToolBar;
    self.txtFromTo.inputAccessoryView = self.myToolBar;
    
    layoutFlow = [[WaterFallFlowLayout alloc]init];
    layoutFlow.itemCount = self.responseSellPostQuery.result.count;
    layoutFlow.responseSellPostQuery = self.responseSellPostQuery;
    [_mainCollectionView setCollectionViewLayout:layoutFlow];
    [_mainCollectionView registerClass:[postItemsCell class] forCellWithReuseIdentifier:@"postItemsCell"];

    //上拉加载
    _mainCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page = [self.responseSellPostQuery.page integerValue] + 1;
        _postsRequest.page = [NSString stringWithFormat:@"%zd",page];
        [self getSellPost];
        
    }];
    
    //下拉刷新
    _mainCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [NetworkEngine showMbDialog:self.view title:@"正在加载"];
        page = 1;
        _postsRequest.page = [NSString stringWithFormat:@"%zd",page];
        self.responseSellPostQuery = nil;
        [self getSellPost];
    }];
    

}

- (void)loadData{
    page = 1;
    _postsRequest = [[SellPostQueryEntity alloc] init];

    _postsRequest.page = [NSString stringWithFormat:@"%ld",(long)page];
    _postsRequest.pageSize = @"20";
//    _postsRequest.status = @"AVAILABLE|SOLD";
    
    [self asynRequests];
    
    [LocationManger getInstance].delegate = self;
}

//异步请求监控
- (void)asynRequests{
    [NetworkEngine showMbDialog:self.view title:@"正在加载"];
    
    __block NSError *_error;
    __weak typeof(self) weakSelf = self;
    __block ResponseSellPostQuery *tempResponse;
    dispatch_group_t downloadGroup = dispatch_group_create();
    //第一个异步请求
    dispatch_group_enter(downloadGroup);
    [NetworkEngine getJSONWithUrl:_postsRequest success:^(id json) {
        tempResponse = [[ResponseSellPostQuery alloc] initwithJson:json];
        dispatch_group_leave(downloadGroup);
    } fail:^(NSError *error) {
        _error = error;
        dispatch_group_leave(downloadGroup);
    }];
    //第二个异步请求
    dispatch_group_enter(downloadGroup);
    CountryEntity *countryEntity = [[CountryEntity alloc] init];
    [NetworkEngine getJSONWithUrl:countryEntity success:^(id json) {
        [CategoryAndCountryInfo getInstance].countryInfo = [[ResponseCountry alloc] initwithJson:json];
        [self showCityList];
        dispatch_group_leave(downloadGroup);
    } fail:^(NSError *error) {
        dispatch_group_leave(downloadGroup);
    }];
    
    //第三个异步请求
    dispatch_group_enter(downloadGroup);
    CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
    [NetworkEngine getJSONWithUrl:categoryEntity success:^(id json) {
        [CategoryAndCountryInfo getInstance].categoryInfo = [[ResponseCategory alloc] initwithJson:json];
        dispatch_group_leave(downloadGroup);
    } fail:^(NSError *error) {
//        _error = error;
        dispatch_group_leave(downloadGroup);
    }];
    
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        [NetworkEngine hiddenDialog];
        if (!_error) {
            if (weakSelf.responseSellPostQuery.result > 0) {
                weakSelf.responseSellPostQuery.page = tempResponse.page;
                weakSelf.responseSellPostQuery.hasNext = tempResponse.hasNext;
                [weakSelf.responseSellPostQuery.result addObjectsFromArray:tempResponse.result];
            }else {
                weakSelf.responseSellPostQuery = tempResponse;
            }
            //如果没有下一页隐藏下拉加载更多
            if ([weakSelf.responseSellPostQuery.hasNext integerValue] !=1) {
                weakSelf.mainCollectionView.footer.hidden = YES;
            }else {
                weakSelf.mainCollectionView.footer.hidden = NO;
            }
            
            layoutFlow.responseSellPostQuery = weakSelf.responseSellPostQuery;
            layoutFlow.itemCount = weakSelf.responseSellPostQuery.result.count;
            
            [weakSelf.mainCollectionView.footer endRefreshing];
            [weakSelf.mainCollectionView.header endRefreshing];
            [weakSelf.mainCollectionView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请求失败"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
            [weakSelf.mainCollectionView.footer endRefreshing];
            [weakSelf.mainCollectionView.header endRefreshing];
        }
        
    });
}

-(void)lmGetLocationFaild:(NSString *)sError
{
    [self showCityList];
}

-(void)showCityList
{
    NSString *s = [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseCity"];
    NSString *sId = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCityId"];
    if ((s && s.length >0) || (sId && sId.length > 0)) {
        //nothing to do
    } else {
        if ([LocationManger getInstance].iAllow == 2 && [CategoryAndCountryInfo getInstance].countryInfo) {
            CitysViewController *vc = [[CitysViewController alloc] initWithNibName:@"CitysViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:^{
                
            }];
        }
    }
}

- (void)getSellPost{
    [NetworkEngine showMbDialog:self.view title:@"正在加载"];
    __weak typeof(self) weakSelf = self;
    [NetworkEngine getJSONWithUrl:_postsRequest success:^(id json) {
        [NetworkEngine hiddenDialog];
        if (weakSelf.responseSellPostQuery.result > 0) {
            ResponseSellPostQuery *tempResponse = [[ResponseSellPostQuery alloc] initwithJson:json];
            weakSelf.responseSellPostQuery.page = tempResponse.page;
            weakSelf.responseSellPostQuery.hasNext = tempResponse.hasNext;
            [weakSelf.responseSellPostQuery.result addObjectsFromArray:tempResponse.result];
        }else {
            weakSelf.responseSellPostQuery = [[ResponseSellPostQuery alloc] initwithJson:json];
        }
        //如果没有下一页隐藏下拉加载更多
        if ([weakSelf.responseSellPostQuery.hasNext integerValue] !=1) {
            _mainCollectionView.footer.hidden = YES;
        }else {
            _mainCollectionView.footer.hidden = NO;
        }
        
        layoutFlow.responseSellPostQuery = weakSelf.responseSellPostQuery;
        layoutFlow.itemCount = weakSelf.responseSellPostQuery.result.count;
        
        [_mainCollectionView.footer endRefreshing];
        [_mainCollectionView.header endRefreshing];
        [_mainCollectionView reloadData];
    } fail:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请求失败"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        [NetworkEngine hiddenDialog];
        [_mainCollectionView.footer endRefreshing];
        [_mainCollectionView.header endRefreshing];
    }];
}

- (void)getCountry{
   
}

- (void)initPostRequest{
    _postsRequest = nil;
    _postsRequest = [[SellPostQueryEntity alloc] init];
    page = 1;
    _postsRequest.page = [NSString stringWithFormat:@"%ld",(long)page];
    _postsRequest.pageSize = @"20";
//    _postsRequest.status = @"AVAILABLE|SOLD";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SellPostQueryResult *sellPost = [self.responseSellPostQuery.result objectAtIndex:indexPath.row];
    ItemViewController *vc = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    vc.sPostId = sellPost.postId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

///* 定义每个UICollectionView 的大小 */
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    SellPostQueryResult *sellPost = [self.responseSellPostQuery.result objectAtIndex:indexPath.row];
//    float fwidth = (SCREEN_WIDTH-15)/2;
//    float fheight = (fwidth/[sellPost.thumbnailPhoto.width floatValue])*[sellPost.thumbnailPhoto.height floatValue];
//    return CGSizeMake(fwidth, fheight+42);
//}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//上 左 下 右
}

#pragma mark - 按钮
- (IBAction)didPressedShaiXuan:(id)sender {
    if ([CategoryAndCountryInfo getInstance].countryInfo) {
        self.responseCountry = [CategoryAndCountryInfo getInstance].countryInfo;
        [self loadShaiXuanInfo];
    }else {
        [NetworkEngine showMbDialog:self.view title:@"正在加载"];
        CountryEntity *countryEntity = [[CountryEntity alloc] init];
        __weak typeof(self) weakSelf = self;
        [NetworkEngine getJSONWithUrl:countryEntity success:^(id json) {
            [CategoryAndCountryInfo getInstance].countryInfo = [[ResponseCountry alloc] initwithJson:json];
            weakSelf.responseCountry = [CategoryAndCountryInfo getInstance].countryInfo;
            
            [self loadShaiXuanInfo];
            [NetworkEngine hiddenDialog];
        } fail:^(NSError *error) {
            [NetworkEngine hiddenDialog];
        }];
    }
    
}

//确认筛选
- (IBAction)didPressedShaiXuanDone:(id)sender {
    if (_txtPriceFrom.text.length > 0 && _txtFromTo.text.length > 0 && ([_txtPriceFrom.text floatValue] > [_txtFromTo.text floatValue])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请输入正确的价格范围"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }else {
        [NetworkEngine showMbDialog:self.navigationController.view title:@"正在加载"];
        
        [self initPostRequest];
        
        //    _postsRequest.conditionLevelId = self.chooseCondition.conditionLevelId;
        _postsRequest.keywords = _txtSearch.text;
        _postsRequest.cityId = self.chooseCity.cityId;
        _postsRequest.sort = self.chooseSortOptions.sortOptionId;
        
        if ((sliderValue/20) <= self.chooseContryInfo.searchDistances.count) {
            if ([self.chooseContryInfo.distanceUnit isEqualToString:@"KM"]) {
                _postsRequest.distanceInKm = [self.chooseContryInfo.searchDistances objectAtIndex:(sliderValue/20)];
            }else {
                _postsRequest.distanceInMiles = [self.chooseContryInfo.searchDistances objectAtIndex:(sliderValue/20)];
            }
            
        }else {
            //距离不限
            if ([self.chooseContryInfo.distanceUnit isEqualToString:@"KM"]) {
                _postsRequest.distanceInKm = @"100";
            }else {
                _postsRequest.distanceInMiles = @"100";
            }
        }
        if (_txtPriceFrom.text.length == 0) {
            _postsRequest.priceRange = [NSString stringWithFormat:@"[0 TO %@]",_txtFromTo.text];
        }else if (_txtFromTo.text.length == 0) {
            _postsRequest.priceRange = [NSString stringWithFormat:@"[%@ TO *]",_txtPriceFrom.text];
        }else if (_txtPriceFrom.text.length > 0 && _txtFromTo.text.length > 0) {
            _postsRequest.priceRange = [NSString stringWithFormat:@"[%@ TO %@]",_txtPriceFrom.text,_txtFromTo.text];
        }
        
        if ([LocationManger getInstance].fLatitude != 0) {
            _postsRequest.latitude = [NSString stringWithFormat:@"%f",[LocationManger getInstance].fLatitude];
            _postsRequest.longitude = [NSString stringWithFormat:@"%f",[LocationManger getInstance].fLongitude];
        }
        
        if (self.chooseCategory.categoryPath.length > 0) {
            _postsRequest.categoryPath = self.chooseCategory.categoryPath;
        }
        if (_txtSearch.text.length > 0) {
            _postsRequest.keywords = _txtSearch.text;
        }
        __weak typeof(self) weakSelf = self;
        [NetworkEngine getJSONWithUrl:_postsRequest success:^(id json) {
            [NetworkEngine hiddenDialog];
            weakSelf.responseSellPostQuery = [[ResponseSellPostQuery alloc] initwithJson:json];
            layoutFlow.responseSellPostQuery = weakSelf.responseSellPostQuery;
            layoutFlow.itemCount = weakSelf.responseSellPostQuery.result.count;
            
            [self hideShaiXuanView];
            [_mainCollectionView reloadData];
        } fail:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请求失败"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
            [self hideShaiXuanView];
            [NetworkEngine hiddenDialog];
        }];
    }
}

//距离拖拉条
- (IBAction)didSliderDistanceValue:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (slider.value < 20) {
        _lblDistanceFirst.textColor = [UIColor redColor];
        _lblDistanceSecond.textColor = [UIColor blackColor];
        _lblDistanceThird.textColor = [UIColor blackColor];
        _lblDistanceForth.textColor = [UIColor blackColor];
        _lblDistanceFifth.textColor = [UIColor blackColor];
        sliderValue = 0;
    }else if (slider.value <40) {
        sliderValue = 20;
        _lblDistanceFirst.textColor = [UIColor blackColor];
        _lblDistanceSecond.textColor = [UIColor redColor];
        _lblDistanceThird.textColor = [UIColor blackColor];
        _lblDistanceForth.textColor = [UIColor blackColor];
        _lblDistanceFifth.textColor = [UIColor blackColor];
    }else if (slider.value < 60) {
        sliderValue = 40;
        _lblDistanceFirst.textColor = [UIColor blackColor];
        _lblDistanceSecond.textColor = [UIColor blackColor];
        _lblDistanceThird.textColor = [UIColor redColor];
        _lblDistanceForth.textColor = [UIColor blackColor];
        _lblDistanceFifth.textColor = [UIColor blackColor];
    }else if (slider.value < 80) {
        sliderValue = 60;
        _lblDistanceFirst.textColor = [UIColor blackColor];
        _lblDistanceSecond.textColor = [UIColor blackColor];
        _lblDistanceThird.textColor = [UIColor blackColor];
        _lblDistanceForth.textColor = [UIColor redColor];
        _lblDistanceFifth.textColor = [UIColor blackColor];
    }else if (slider.value <= 100) {
        sliderValue = 80;
        _lblDistanceFirst.textColor = [UIColor blackColor];
        _lblDistanceSecond.textColor = [UIColor blackColor];
        _lblDistanceThird.textColor = [UIColor blackColor];
        _lblDistanceForth.textColor = [UIColor blackColor];
        _lblDistanceFifth.textColor = [UIColor redColor];
    }
}

- (void)didPressedConditions:(UIButton *)sender; {
    //初始化按钮状态
    for (UIButton *tempButton in _cellShaiXuanConditions.contentView.subviews) {
        [self setCustomButtonStyle:tempButton];
    }
    
    self.chooseCondition = [self.chooseContryInfo.conditionLevels objectAtIndex:sender.tag-ConditionsTag];
    [self setSelectButtonStyle:sender];
}

- (IBAction)didCancelShaixuan:(id)sender {
    [self hideShaiXuanView];
}

- (IBAction)didPressedResetShaiXuan:(id)sender {
    [NetworkEngine showMbDialog:self.navigationController.view title:@"正在加载"];
    __block NSError *_error;
    __weak typeof(self) weakSelf = self;

    dispatch_group_t downloadGroup = dispatch_group_create();
    //第一个异步请求
    dispatch_group_enter(downloadGroup);
    CountryEntity *countryEntity = [[CountryEntity alloc] init];
    [NetworkEngine getJSONWithUrl:countryEntity success:^(id json) {
        [CategoryAndCountryInfo getInstance].countryInfo = [[ResponseCountry alloc] initwithJson:json];
        [weakSelf showCityList];
        dispatch_group_leave(downloadGroup);
    } fail:^(NSError *error) {
        dispatch_group_leave(downloadGroup);
    }];
    
    //第二个异步请求
    dispatch_group_enter(downloadGroup);
    CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
    [NetworkEngine getJSONWithUrl:categoryEntity success:^(id json) {
        [NetworkEngine hiddenDialog];
        [CategoryAndCountryInfo getInstance].categoryInfo = [[ResponseCategory alloc] initwithJson:json];
        dispatch_group_leave(downloadGroup);
    } fail:^(NSError *error) {
        //        _error = error;
        dispatch_group_leave(downloadGroup);
    }];
    
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        
        [NetworkEngine hiddenDialog];
        if (!_error) {
            //重置
            _txtFromTo.text = nil;
            _txtPriceFrom.text = nil;
            self.chooseCategory = nil;
            self.chooseSortOptions = nil;
//            self.chooseCondition = nil;
            _txtCategory.text = nil;
            _sliderDistance.value = 100;
            sliderValue = 80;
            _lblDistanceFirst.textColor = [UIColor blackColor];
            _lblDistanceSecond.textColor = [UIColor blackColor];
            _lblDistanceThird.textColor = [UIColor blackColor];
            _lblDistanceForth.textColor = [UIColor blackColor];
            _lblDistanceFifth.textColor = [UIColor redColor];
            [self loadShaiXuanInfo];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"筛选重置失败"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    });
}

- (IBAction)didCancelKeyboard:(id)sender {
    [self.txtFromTo resignFirstResponder];
    [self.txtPriceFrom resignFirstResponder];
}

- (IBAction)didPressedCategory:(id)sender {
    if ([CategoryAndCountryInfo getInstance].categoryInfo) {
        [_categoryTableview reloadData];
        [self showCateGoryTabelview];
    }else{
        [NetworkEngine showMbDialog:self.view title:@"请稍后"];
        CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
        __weak typeof(self) weakSelf = self;
        [NetworkEngine getJSONWithUrl:categoryEntity success:^(id json) {
            [NetworkEngine hiddenDialog];
            [CategoryAndCountryInfo getInstance].categoryInfo = [[ResponseCategory alloc] initwithJson:json];
            [weakSelf.categoryTableview reloadData];
            [weakSelf showCateGoryTabelview];
        } fail:^(NSError *error) {
            
        }];
    }
}

//加载筛选页面
- (void)loadShaiXuanInfo{
    NSString *sLocalCityId = @"";//空字符串可获得默认也就是第一个国家对象
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"localCityId"]) {
        sLocalCityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCityId"];
    }
    NSMutableDictionary *dic_country = [[CategoryAndCountryInfo getInstance] getCountryInfoWithCityId:sLocalCityId];
    self.chooseContryInfo = [dic_country objectForKey:@"chooseCountry"];
    self.chooseProvince = [dic_country objectForKey:@"chooseProvince"];
    self.chooseCity = [dic_country objectForKey:@"chooseCity"];
    _lblSXCity.text = self.chooseCity.displayName;
    
    //防御，判断是否有对象。没有就不显示筛选页面
    if (self.chooseContryInfo && !bHideShaiXuan) {
//        [self loadCondition:self.chooseContryInfo];
        [self loadDistance:self.chooseContryInfo];
        [self loadsortOptions:self.chooseContryInfo];
        [self showShaiXuanView];
    }
    bHideShaiXuan = NO;
}

- (void)loadsortOptions:(CountryInfo *)c{
    for (UIButton *tempButton in _cellShaiXuanSortOptions.contentView.subviews) {
        [tempButton removeFromSuperview];
    }
    
    if (c.sortOptions.count > 0) {
        if (!self.chooseSortOptions) {
            self.chooseSortOptions = [c.sortOptions firstObject];
        }
        for (int i = 0; i<c.sortOptions.count; i++) {
            sortOptions *sortOption = [c.sortOptions objectAtIndex:i];
            UIButton *btnSortOptions = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnSortOptions setTitle:sortOption.displayName forState:UIControlStateNormal];
            if ([self.chooseSortOptions.sortOptionId isEqualToString:sortOption.sortOptionId]) {
                [self setSelectButtonStyle:btnSortOptions];
            }else {
                [self setCustomButtonStyle:btnSortOptions];
            }
            int m = i/2;
            int n = i%2;
            btnSortOptions.frame = CGRectMake(15+n*(115+20), 15+m*(15+30), 115, 30);
            btnSortOptions.tag = SortOptionsTag + i;
            [_cellShaiXuanSortOptions.contentView addSubview:btnSortOptions];
            [btnSortOptions addTarget:self action:@selector(didPressedSortOptions:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)didPressedSortOptions:(UIButton *)sender{
    //初始化按钮状态
    for (UIButton *tempButton in _cellShaiXuanSortOptions.contentView.subviews) {
        [self setCustomButtonStyle:tempButton];
    }
    self.chooseSortOptions = [self.chooseContryInfo.sortOptions objectAtIndex:sender.tag-SortOptionsTag];
    [self setSelectButtonStyle:sender];
}

//设置普通按钮style
- (void)setCustomButtonStyle:(UIButton *)customButton{
    CALayer * ButtonLayer = [customButton layer];
    [ButtonLayer setMasksToBounds:YES];
    [ButtonLayer setCornerRadius:2.0];
    [ButtonLayer setBorderWidth:1.0];
    [ButtonLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    customButton.titleLabel.font = [UIFont systemFontOfSize:14.5];
    [customButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

//设置选中按钮style
- (void)setSelectButtonStyle:(UIButton *)selectButton{
    CALayer * ButtonLayer = [selectButton layer];
    [ButtonLayer setMasksToBounds:YES];
    [ButtonLayer setCornerRadius:2.0];
    [ButtonLayer setBorderWidth:1.0];
    [ButtonLayer setBorderColor:[[UIColor redColor] CGColor]];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:14.5];
    [selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (void)loadCondition:(CountryInfo *)c{
    for (UIButton *tempButton in _cellShaiXuanConditions.contentView.subviews) {
        [tempButton removeFromSuperview];
    }
    
    if (c.conditionLevels.count > 0) {
        self.chooseCondition = [c.conditionLevels firstObject];
        for (int i = 0; i<c.conditionLevels.count; i++) {
            ConditionLevelInfo *con = [c.conditionLevels objectAtIndex:i];
            UIButton *btnCondition = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnCondition setTitle:con.displayName forState:UIControlStateNormal];
            if (i == 0) {
                [self setSelectButtonStyle:btnCondition];
            }else {
                [self setCustomButtonStyle:btnCondition];
            }
            int m = i/2;
            int n = i%2;
            btnCondition.frame = CGRectMake(15+n*(115+20), 15+m*(15+30), 115, 30);
            btnCondition.tag = ConditionsTag + i;
            [_cellShaiXuanConditions.contentView addSubview:btnCondition];
            [btnCondition addTarget:self action:@selector(didPressedConditions:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (void)loadDistance:(CountryInfo *)c{

    _lblMoneyUnit.text =  c.currencySymbol;
    
//    if ([c.distanceUnit isEqualToString:@"KM"]) {
//        _lblDistanceUnit.text = CustomLocalizedString(@"/公里", nil);
//    }else if ([c.distanceUnit isEqualToString:@"Miles"]){
//        _lblDistanceUnit.text = CustomLocalizedString(@"/英里", nil);
//    }
    
    _lblDistanceUnit.text = c.distanceUnit;
    if (sliderValue > 0) {
        
    }
//    _sliderDistance.value = 100;
////    if (sliderValue ) {
////        <#statements#>
////    }
//    sliderValue = 80;
    for (int i = 0; i < c.searchDistances.count; i++) {
        NSNumber *sDistance = [c.searchDistances objectAtIndex:i];
        switch (i) {
            case 0:
            {
                _lblDistanceFirst.text = [NSString stringWithFormat:@"%@",sDistance];
            }
                break;
            case 1:
            {
                _lblDistanceSecond.text = [NSString stringWithFormat:@"%@",sDistance];
            }
                break;
            case 2:
            {
                _lblDistanceThird.text = [NSString stringWithFormat:@"%@",sDistance];
            }
                break;
            case 3:
            {
                _lblDistanceForth.text = [NSString stringWithFormat:@"%@",sDistance];
            }
                break;
            case 4:
            {
                _lblDistanceFifth.text = [NSString stringWithFormat:@"%@",sDistance];
            }
                break;
            default:
                break;
        }
    }
}

- (void)showShaiXuanView{
    UIView *view = [self.navigationController.view viewWithTag:999];
    if (!view.superview) {
        UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        mainview.tag = 999;
        mainview.backgroundColor = [UIColor clearColor];
        mainview.alpha = 1;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6;
        [mainview addSubview:backView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [button addTarget:self action:@selector(hideShaiXuanView) forControlEvents:UIControlEventTouchDown];
        [mainview addSubview:button];
        [mainview addSubview:_viewShaiXuan];
        _viewShaiXuan.frame = CGRectMake(SCREEN_WIDTH, 0, 280, SCREEN_HEIGHT - 49 + 20);
        [self.navigationController.view addSubview:mainview];
        _shaixuanTableview.tableHeaderView = _shaixuanHeaderview;
        
        [UIView animateWithDuration:0.25 animations:^{
            _viewShaiXuan.frame = CGRectMake(SCREEN_WIDTH-280, 0, 280, SCREEN_HEIGHT - 49 + 20);
        }];
    }else {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 + 20);
    }
}

- (void)hideShaiXuanView{
    UIView *view = [self.navigationController.view viewWithTag:999];
    [UIView animateWithDuration:0.25 animations:^{
        _viewShaiXuan.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

#pragma mark - UITextFeild
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //beginEdit
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [NetworkEngine showMbDialog:self.view title:@"正在加载"];
    page = 1;
    _postsRequest.page = [NSString stringWithFormat:@"%zd",page];
    self.responseSellPostQuery = nil;
    if (textField.text.length > 0) {
        _postsRequest.keywords = _txtSearch.text;
    }
    self.responseSellPostQuery = nil;
    [self getSellPost];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Button
- (IBAction)didPressedBackCity:(id)sender {
    switch (iCityType) {
        case cityType_Country:
        {
            [self hideCityView];
        }
            break;
        case cityType_Province:
        {
            iCityType = cityType_Country;
            cityArr = self.responseCountry.responseCountryInfoArray;
            [_cityTableview reloadData];
        }
            break;
        case cityType_City:
        {
            iCityType = cityType_Province;
            cityArr = self.chooseContryInfo.provinceOrStateInfos;
            [_cityTableview reloadData];
        }
            break;
        default:
            break;
    }
}

- (IBAction)didPressedCountry:(id)sender {
    cityArr = self.responseCountry.responseCountryInfoArray;
    [_cityTableview reloadData];
    
    [self showCityTableview];
}

- (void)showCityTableview{
    iCityType = cityType_Country;
    if (self.responseCountry.responseCountryInfoArray.count > 0) {
        cityArr = self.responseCountry.responseCountryInfoArray;
    }
    
    UIView *view = [self.navigationController.view viewWithTag:1888];
    if (!view.superview) {
        UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        mainview.tag = 1888;
        mainview.backgroundColor = [UIColor clearColor];
        mainview.alpha = 1;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6;
        [mainview addSubview:backView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [button addTarget:self action:@selector(hideCityView) forControlEvents:UIControlEventTouchDown];
        [mainview addSubview:button];
        [mainview addSubview:_cityView];
        _cityView.frame = CGRectMake(SCREEN_WIDTH, 0, 280, SCREEN_HEIGHT - 49 + 20);
        [self.navigationController.view addSubview:mainview];
        
        [UIView animateWithDuration:0.25 animations:^{
            _cityView.frame = CGRectMake(SCREEN_WIDTH-280, 0, 280, SCREEN_HEIGHT - 49 + 20);
        }];
    }else {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 + 20);
    }
    
    
}

- (void)hideCityView{
    UIView *view = [self.navigationController.view viewWithTag:1888];
    [UIView animateWithDuration:0.25 animations:^{
        _cityView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

#pragma mark - UITableView Delegate
#pragma mark - Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _cityTableview) {
        return 1;
    }else if(tableView == _shaixuanTableview) {
        return 6;
    }else if (tableView == _categoryTableview) {
        return [CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _cityTableview) {
        return 44;
    }else if(tableView == _shaixuanTableview){
        switch (indexPath.section) {
            case 0:
                return 44;
                break;
            case 1:
                return 105;
                break;
            case 2:
                return 95;
                break;
            case 3:
                return 50;
            case 4:
                return [self heightWithButtonCount:self.chooseContryInfo.sortOptions.count];
                break;
            default:
                return 70;
                break;
        }
    }else if (tableView == _categoryTableview) {
        return 44;
    }
    return 0;
}

- (float)heightWithButtonCount:(NSInteger)iCount{
    if (self.chooseContryInfo) {
        NSInteger num = iCount%2 == 0 ? iCount/2 : (iCount/2 + 1);
        return 30+30*num+15*(num-1);
    }
    return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _categoryTableview) {
        return 44;
    }else if (tableView == _shaixuanTableview) {
        if (section != 0 && section != 5) {
            return 10;
        }
    }
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _cityTableview) {
        return cityArr.count;
    } else if (tableView == _shaixuanTableview) {
        return 1;
    }else if (tableView == _categoryTableview) {
        if (categoryArr.count > 0) {
            if (section == [[categoryArr objectAtIndex:0] integerValue]) {
                return [[categoryArr objectAtIndex:1] integerValue];
            }
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (tableView == _cityTableview) {
        NSString *cellIdentify = @"CityCell";
        CityCell *cell = (CityCell *)[tableView customdq:cellIdentify];
        
        switch (iCityType) {
            case cityType_Country:
            {
                if (cityArr.count > 0) {
                    CountryInfo *c = [cityArr objectAtIndex:indexPath.row];
                    cell.lblName.text = c.displayName;
                }
            }
                break;
            case cityType_Province:
            {
                if (cityArr.count > 0) {
                    ProvinceOrStateInfos *pro = [cityArr objectAtIndex:indexPath.row];
                    cell.lblName.text = pro.displayName;
                }
            }
                break;
            case cityType_City:
            {
                if (cityArr.count > 0) {
                    CityInfo *city = [cityArr objectAtIndex:indexPath.row];
                    cell.lblName.text = city.displayName;
                }
            }
                break;
            default:
                break;
        }
        return cell;
   }else if (tableView == _shaixuanTableview) {
       switch (indexPath.section) {
           case 0:
               return _cellShaiXuanCity;
               break;
           case 1:
               return _cellShaiXuanDistance;
               break;
           case 2:
               return _cellShaiXuanPrice;
               break;
           case 3:
               return _cellShaiXuanCategory;
               break;
           case 4:
               return _cellShaiXuanSortOptions;
               break;
           default:
               return _cellShaiXuanButton;
               break;
       }
   }else if (tableView == _categoryTableview) {
       if (categoryArr.count > 0) {
           if (indexPath.section == [[categoryArr objectAtIndex:0] integerValue]) {
               NSString *cellIdentify = @"CategoryCell";
               CategoryCell *cell = (CategoryCell *)[tableView customdq:cellIdentify];
               CategoryInfo *c = [[CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray objectAtIndex:indexPath.section];
               CategoryInfo *c1 = [c.childCategories objectAtIndex:indexPath.row];
               cell.categoryInfo = c1;
               
               return cell;
           }
           
       }
   }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cityTableview) {
        if (iCityType == cityType_Country) {
            self.chooseContryInfo = [self.responseCountry.responseCountryInfoArray objectAtIndex:indexPath.row];
            if (self.chooseContryInfo.provinceOrStateInfos.count > 0) {
                iCityType = cityType_Province;
                cityArr = self.chooseContryInfo.provinceOrStateInfos;
                [_cityTableview reloadData];
                return;
            }else {
                //选中国家
                _lblSXCity.text = self.chooseContryInfo.displayName;
                [self hideCityView];
                return;
            }
        }else if (iCityType == cityType_Province) {
            self.chooseProvince = [cityArr objectAtIndex:indexPath.row];
            if (self.chooseProvince.cities.count > 0) {
                iCityType  = cityType_City;
                cityArr = self.chooseProvince.cities;
                [_cityTableview reloadData];
                return;
            }else {
                //选中省份
                _lblSXCity.text = self.chooseProvince.displayName;
                [self hideCityView];
                return;
            }
        }else if (iCityType == cityType_City) {
            //选中城市了
            self.chooseCity = [cityArr objectAtIndex:indexPath.row];
            _lblSXCity.text = self.chooseCity.displayName;
            [[NSUserDefaults standardUserDefaults] setValue:self.chooseCity.cityId forKey:@"localCityId"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"chooseCity"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self loadCondition:self.chooseContryInfo];
            [self loadDistance:self.chooseContryInfo];
            [self hideCityView];
            return;
        }
    }else if (tableView == _categoryTableview) {
        CategoryInfo *c = [[CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray objectAtIndex:indexPath.section];
        CategoryInfo *c1 = [c.childCategories objectAtIndex:indexPath.row];
        _txtCategory.text = c1.displayName;
        self.chooseCategory = c1;
        [self hideCategoryView];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _categoryTableview) {
        //代码创建headerview也就是一级菜单
        UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        headerview.backgroundColor = [UIColor whiteColor];
        
        UIImageView *line1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_all"]];
        UIImageView *line2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_all"]];
        line1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        line2.frame = CGRectMake(0, 44, SCREEN_WIDTH, 1);
        [headerview addSubview:line1];
        [headerview addSubview:line2];
        
        UIImageView *imgvArrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-14-15, (44-8)/2, 14, 8)];
        if (categoryArr.count > 0) {
            if (section == [[categoryArr objectAtIndex:0] integerValue]) {
                imgvArrow.image = [UIImage imageNamed:@"arrow_top"];
            }else {
                imgvArrow.image = [UIImage imageNamed:@"arrow_down"];
            }
        }else {
            imgvArrow.image = [UIImage imageNamed:@"arrow_down"];
        }
        [headerview addSubview:imgvArrow];
        
        CategoryInfo *c = [[CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray objectAtIndex:section];
        UILabel *lblCategoryName = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-15-15-20, 20)];
        lblCategoryName.text = c.displayName;
        lblCategoryName.font = [UIFont systemFontOfSize:14.5];
        [headerview addSubview:lblCategoryName];
        
        UIButton *btn_list = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, headerview.frame.size.width, headerview.frame.size.height)];
        btn_list.tag = section;
        [btn_list addTarget:self action:@selector(showSecondCategory:) forControlEvents:UIControlEventTouchDown];
        [headerview addSubview:btn_list];
        
        return headerview;
    } else if (tableView == _shaixuanTableview) {
        UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        headerview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return headerview;
    }
    return nil;
}

- (void)showSecondCategory:(UIButton *)sender{
    //选中后保存类别信息，第一个是section，第二个保存section里返回几行cell
    //判断是否已经选择过
    if (categoryArr.count > 0) {
        //判断是否点击的是已选择过的
        if (sender.tag == [[categoryArr objectAtIndex:0] integerValue]) {
            categoryArr = nil;
        }else {
            CategoryInfo *c = [[CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray objectAtIndex:sender.tag];
            categoryArr = nil;
            categoryArr = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%ld",(long)sender.tag],[NSString stringWithFormat:@"%ld",(long)c.childCategories.count],nil];
        }
    }else {
        CategoryInfo *c = [[CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray objectAtIndex:sender.tag];
        categoryArr = nil;
        categoryArr = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%ld",(long)sender.tag],[NSString stringWithFormat:@"%ld",(long)c.childCategories.count],nil];
    }
    
    float height = 0;
    if (categoryArr.count > 0) {
        height = [[categoryArr objectAtIndex:1] floatValue];
    }
    
    //根据列表数量调整列表高度
    float fheight = SCREEN_HEIGHT - 44*([CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray.count+1+height) - 30;
    if (fheight > 0) {
        _categoryView.frame = CGRectMake(0, (SCREEN_HEIGHT - 44*([CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray.count+1+height) - 30), SCREEN_WIDTH,44*([CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray.count+1+height) );
    }else {
        _categoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30);
    }
    
    [_categoryTableview reloadData];
}

- (void)showCateGoryTabelview{
    UIView *view = [self.navigationController.view viewWithTag:categoryTag];
    if (!view.superview) {
        UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        mainview.tag = categoryTag;
        mainview.backgroundColor = [UIColor clearColor];
        mainview.alpha = 1;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6;
        [mainview addSubview:backView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [button addTarget:self action:@selector(hideCategoryView) forControlEvents:UIControlEventTouchDown];
        [mainview addSubview:button];
        [mainview addSubview:_categoryView];
        _categoryView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _categoryTableview.frame.size.height);
        [self.navigationController.view addSubview:mainview];
        float tY = SCREEN_HEIGHT - 44*([CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray.count+1) - 30;
        
        [UIView animateWithDuration:0.25 animations:^{
            if (tY > 0) {
                _categoryView.frame = CGRectMake(0, tY, SCREEN_WIDTH, 44*[CategoryAndCountryInfo getInstance].categoryInfo.responseCategoryArray.count+44);
            }else {
                _categoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30);
            }
        }];
    }else {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
}

- (void)hideCategoryView{
    UIView *view = [self.navigationController.view viewWithTag:categoryTag];
    [UIView animateWithDuration:0.25 animations:^{
        _categoryView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
}

@end
