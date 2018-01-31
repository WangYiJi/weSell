//
//  SaleViewController.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/17.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "SaleViewController.h"
#import "Global.h"
#import "PublicUI.h"
#import "SalePicCell.h"
#import "AddPicCollectionCell.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "UITabBarController+HideTabBar.h"
#import "AppDelegate.h"
#import "CategoryEntity.h"
#import "ResponseCategory.h"
#import "NetworkEngine.h"
#import "CategoryCell.h"
#import "UITableView+CustomCell.h"
#import "CountryEntity.h"
#import "ResponseCountry.h"
#import "SellPostEntity.h"
#import "FileUploadEntity.h"
#import "ResponseFileUpload.h"
#import "UserMember.h"
#import "CityCell.h"
#import "Utils.h"
#import "CategoryAndCountryInfo.h"
#import "UIImageView+WebCache.h"
#import "SellPostUpdateEntity.h"
#import "LoginViewController.h"
#import "ConfirmationEmailEntity.h"
#import "UserInfoEntity.h"

#define categoryTag 888
#define cityTag 999
#define conditionTag 777

@interface SaleViewController (){
    UIView *SlideView;
    NSString *filepath;
    BOOL bCamera;//区分是选择相册还是拍照
    NSArray *categoryArr;//存储分类选择信息
    cityType iCityType;//城市类型
    NSMutableArray *cityArr;
}
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) NSMutableArray *PicArray;//保存图片
@property (strong,nonatomic) NSMutableArray *PicArraySmall;
@property (strong,nonatomic) NSMutableArray *PicUrlArray;//保存图片url数组
@property (strong,nonatomic) UIImage *ThumbImage;
@property (strong,nonatomic) UIImage *thumbImageSmall;
@property (assign,nonatomic) NSInteger iPage;//当前页数
@property (strong,nonatomic) ResponseCategory *responseCategory;
@property (strong,nonatomic) ResponseCountry *responseCountry;
@property (strong,nonatomic) ResponseFileUpload *responseFileUpload;
@property (strong,nonatomic) CategoryInfo *chooseCategory;
@property (strong,nonatomic) CountryInfo *chooseCountry;//选中国家
@property (strong,nonatomic) ProvinceOrStateInfos *chooseProvince;//选中省份
@property (strong,nonatomic) CityInfo *chooseCity;//选中城市
@property (strong,nonatomic) ConditionLevelInfo *chooseCondition;//选择新旧程度
@property (strong,nonatomic) NSMutableArray *ArrDidUpLoadPicUrl;//保存已上传的图片的url
@property (assign,nonatomic) NSInteger iMaxNumberOfPicturesPerPost;


@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    [self loadData];
}

- (void)viewWillLayoutSubviews{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![UserMember getInstance].isLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.bBackTabFirst = YES;
        loginVC.navigationItem.title = CustomLocalizedString(@"登录", nil);
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }else {
        if ([[UserMember getInstance].baseUserInfo.status isEqualToString:@"PENDING_CONFIRM"]) {
            [self getUserInfo];
        }
    }
    
    self.navigationItem.title = CustomLocalizedString(@"出售", nil);
    _lblUploadTitle.text = CustomLocalizedString(@"点击上传图片", nil);
    _lblTopic.text = CustomLocalizedString(@"标题", nil);
    _lblCategoryTitle.text = CustomLocalizedString(@"分类", nil);
    _lblPriceTitle.text = CustomLocalizedString(@"宝贝定价", nil);
    _lblShiFouYiJiaTitle.text = CustomLocalizedString(@"是否议价", nil);
    _lblQuGuoDiDianTitle.text = CustomLocalizedString(@"取货地点", nil);
    _lblNewOldTitle.text = CustomLocalizedString(@"新旧程度", nil);
    [_btnTakePhoto setTitle:CustomLocalizedString(@"拍照", nil) forState:UIControlStateNormal];
    [_btnDescription setTitle:CustomLocalizedString(@"描述", nil) forState:UIControlStateNormal];
    [_btnMakePrice setTitle:CustomLocalizedString(@"定价", nil) forState:UIControlStateNormal];
    [_btnNextPage setTitle:CustomLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    //[AppDelegateEntity.tabVC setTabBarHidden:NO animated:NO];
}

- (void)getUserInfo{
    
    UserInfoEntity *userInfo = [[UserInfoEntity alloc]init];
    
    [NetworkEngine getJSONWithUrl:userInfo success:^(id json) {
        BaseUserInfo *info = [[BaseUserInfo alloc] initWithDic:json];
        [UserMember getInstance].baseUserInfo = info;
        if ([[UserMember getInstance].baseUserInfo.status isEqualToString:@"PENDING_CONFIRM"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"出售前需邮箱验证，是否需要邮箱验证"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            alert.tag = 888;
            [alert show];
        }
    } fail:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"网络不给力，是否重试"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 999;
        [alert show];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 888) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [self confirmEmail];
        }
    }else if (alertView.tag == 999) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [self getUserInfo];
        }
    }
}

- (void)confirmEmail{
    [NetworkEngine showMbDialog:self.view title:@"请稍等"];
    ConfirmationEmailEntity *entity = [[ConfirmationEmailEntity alloc] init];
    entity.authType = @"EMAILPASSWD";
    [NetworkEngine putPasswordWithEntity:entity success:^(id json) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件已发出，请进入邮箱验证"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [NetworkEngine hiddenDialog];
    } fail:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取邮件失败"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [NetworkEngine hiddenDialog];
    }];
}

- (void)loadData{
    self.iMaxNumberOfPicturesPerPost = [[UserMember getInstance].baseUserInfo.maxNumberOfPicturesPerPost integerValue];
    _iPage = 0;
    self.PicArray = [[NSMutableArray alloc] init];
    self.PicUrlArray = [[NSMutableArray alloc] init];
    //默认取货地点设为用户上次选择的地点
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"localCityId"]) {
        NSString *sLocalCityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCityId"];
        NSMutableDictionary *dic_country = [[CategoryAndCountryInfo getInstance] getCountryInfoWithCityId:sLocalCityId];
        self.chooseCountry = [dic_country objectForKey:@"chooseCountry"];
        self.chooseProvince = [dic_country objectForKey:@"chooseProvince"];
        self.chooseCity = [dic_country objectForKey:@"chooseCity"];
        self.txtCity.text = self.chooseCity.displayName;
    }
    
    if (self.chooseSellPost) {
        self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(didPressedBack) addtarget:self];
        self.PicUrlArray = [self arrwithPhotos];
        [self asynDownLoadImage];
        
        [self changeTopTab:0];
        [_contentScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        _txtTitle.text = self.chooseSellPost.title;
        [_tvDescription setPrevText:self.chooseSellPost.details];
        _txtPrice.text = [NSString stringWithFormat:@"%@",self.chooseSellPost.price.value];
        _txtNewOld.text = self.chooseSellPost.conditionLevel.displayName;

        //补充数据对象
        self.chooseCategory = [[CategoryAndCountryInfo getInstance] getCategoryWithPath:self.chooseSellPost.categoryPath];
        _txtCategory.text = self.chooseCategory.displayName;
        self.chooseCountry = [[CategoryAndCountryInfo getInstance] getCountryWithCode:self.chooseSellPost.address.countryCode];
        self.chooseCondition = [[CategoryAndCountryInfo getInstance] getConditionWithCode:self.chooseSellPost.conditionLevel.conditionLevelId From:self.chooseCountry];
        self.chooseProvince = [[CategoryAndCountryInfo getInstance] getProvinceWithCode:self.chooseSellPost.address.provinceOrStateCode From:self.chooseCountry];
        self.chooseCity = [[CategoryAndCountryInfo getInstance] getCityInfoWithCode:self.chooseSellPost.address.cityId From:self.chooseProvince];
        _switchPrice.on = [self.chooseSellPost.firmPrice boolValue];
        _txtCity.text = self.chooseCity.displayName;
        
    }
}

//异步下载图片
- (void)asynDownLoadImage{
    if (self.PicUrlArray.count > 0) {
        [NetworkEngine showMbDialog:self.view title:@"正在加载"];
        
        dispatch_group_t downloadGroup = dispatch_group_create();
        for (int i = 0; i < self.PicUrlArray.count; i++) {
            //第一个异步请求
            dispatch_group_enter(downloadGroup);
            NSString *surl = [self.PicUrlArray objectAtIndex:i];
            //单独异步下载一个图片
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:surl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image && finished) {
                    [self.PicArray addObject:image];
                }
                dispatch_group_leave(downloadGroup);
            }];
        }
        
        dispatch_group_enter(downloadGroup);
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.chooseSellPost.thumbnailPhoto.imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image && finished) {
                self.ThumbImage = image;
            }
            dispatch_group_leave(downloadGroup);
        }];
        
        
        dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
            [NetworkEngine hiddenDialog];
            _picCollectionView.hidden = NO;
            _btnNextPage.enabled = YES;
            [_btnNextPage setBackgroundColor:PressYellow];
            [_picCollectionView reloadData];
        });
    }
    
}

- (NSMutableArray *)arrwithPhotos{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if (self.chooseSellPost.photos.count > 0) {
        for (Photos *p in self.chooseSellPost.photos) {
            [tempArr addObject:p.imageUrl];
        }
    }
    return tempArr;
    
}

- (void)createView{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//scrollview适配
    //控制箭头距离
    _lcArrowwidth1.constant = SCREEN_WIDTH/3 - 6;
    _lcArrowwidth2.constant = 2*SCREEN_WIDTH/3 -6;
    //tab切换底下的蓝线
    SlideView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH/3, 2)];
    UIView *orangeview = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6-40, 0, 80, 2)];
    orangeview.backgroundColor = selectedOrange;
    [SlideView addSubview:orangeview];
    SlideView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:SlideView];
    
    [self initScroll];
    
    [self initCollectionCell];
    
    if (self.PicArray.count == 0) {
        _picCollectionView.hidden = YES;
        _btnNextPage.enabled = NO;
        [_btnNextPage setBackgroundColor:CannotPressGray];
    }
    
    _txtPrice.inputAccessoryView = self.myToolbar;
    
    
}

- (void)initScroll{
    [_viewStepFirst setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-45-56-49-44)];
    [_viewStepSecond setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-45-56)];
    [_viewStepThird setFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-45-56)];
    
    _tvDescription.textView.returnKeyType = UIReturnKeyDone;
    _tvDescription.textView.font = [UIFont systemFontOfSize:15];
    _tvDescription.placeHolder = @"请输入详情";
    _tvDescription.placeHolderColor = RGBA(195, 195, 201, 1);
    _tvDescription.aDelegate = self;
    
    [_contentScroll addSubview:_viewStepFirst];
    [_contentScroll addSubview:_viewStepSecond];
    [_contentScroll addSubview:_viewStepThird];
    
    [_contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH*4, 200)];
}

- (void)initCollectionCell{
    [_picCollectionView registerClass:[SalePicCell class] forCellWithReuseIdentifier:@"SalePicCell"];
    [_picCollectionView registerClass:[AddPicCollectionCell class] forCellWithReuseIdentifier:@"AddPicCollectionCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionView dataSource Or delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.PicArray count]+1;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.PicArray.count) {
        SalePicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SalePicCell" forIndexPath:indexPath];
        cell.imgvPic.image = [self.PicArray objectAtIndex:indexPath.row];
        [cell.btnClose addTarget:self action:@selector(didPressedClosePic:) forControlEvents:UIControlEventTouchDown];
        cell.btnClose.tag = indexPath.row;
        //主图label首个cell不隐藏
        if (indexPath.row == 0) {
            cell.lblTag.hidden = NO;
        }else{
            cell.lblTag.hidden = YES;
        }
        
        return cell;
    }else {
        AddPicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddPicCollectionCell" forIndexPath:indexPath];
        return cell;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.PicArray.count) {
        if (self.PicArray.count < self.iMaxNumberOfPicturesPerPost) {
            [self openMenu];
        }else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                           message:[NSString stringWithFormat:@"最多选择%zd张图片",self.iMaxNumberOfPicturesPerPost]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    }
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-20)/3, (SCREEN_WIDTH-20)/3);
}
/* 定义每个UICollectionView 的边缘 */
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 5, 0, 5);//上 左 下 右
//}

#pragma mark - 按钮
- (IBAction)didPressedFirstPage:(id)sender {
    [self changeTopTab:0];
    [_contentScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)didPressedSecondPage:(id)sender {
    [self changeTopTab:1];
    [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH*1, 0) animated:YES];
}

- (IBAction)didPressedThirdPage:(id)sender {
    [self changeTopTab:2];
    [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
}

- (IBAction)didPressedNextPage:(id)sender {
    switch (_iPage) {
        case 0:
            self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(didPressedBack) addtarget:self];
            [self changeTopTab:1];
            [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH*1, 0) animated:YES];
            break;
        case 1:
        {
            NSString *sMsg = [self getErrorMsgByPage:_iPage];
            if (sMsg.length > 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:sMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(didPressedBack) addtarget:self];
            [_btnNextPage setTitle:CustomLocalizedString(@"立即提交", nil) forState:UIControlStateNormal];
                _iPage = 2;
                [self changeTopTab:_iPage];
                [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH*_iPage, 0) animated:YES];
            }
        }

            break;
        case 2:
        {
           

            NSString *sMsg = [self getErrorMsgByPage:_iPage];
            if (sMsg.length > 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:sMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                 [self submitCreatePost];
            }
        }
            break;
        default:
            break;
    }
}

-(NSString*)getErrorMsgByPage:(NSInteger)page
{
    NSString *sMsg = @"";
    switch (page) {
        case 1:
        {
            if (_txtTitle.text.length <= 0) {
                sMsg = @"标题不能为空";
            }
            else if (_tvDescription.textView.text.length <= 0 || [_tvDescription.textView.text isEqualToString:@"请输入详情"]) {
                sMsg = @"描述不能为空";
            }
            else if (_txtCategory.text.length <= 0) {
                sMsg = @"分类不能为空";
            }
        }
            break;
        case 2:
        {
            if (_txtPrice.text.length <= 0) {
                sMsg = @"宝贝价格不能为空";
            }
            else if (_txtNewOld.text.length <= 0) {
                sMsg = @"宝贝新旧程度不能为空";
            }
            else if (_txtCity.text.length <= 0) {
                sMsg = @"取货城市不能为空";
            }
        }
            
        default:
            break;
    }
    return sMsg;
}

- (void)didPressedBack{
    if (_iPage == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (_iPage == 1) {
//        self.navigationItem.leftBarButtonItem = nil;
        [self changeTopTab:0];
        [_btnNextPage setTitle:CustomLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [_contentScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (_iPage == 2) {
        [self changeTopTab:1];
        [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH*1, 0) animated:YES];
    }
    else if (_iPage == 3) {
        [self changeTopTab:2];
        [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
    }
}

#pragma mark - submit Post
- (void)submitCreatePost{
    NSString *sError = [self PostError];
    if (sError.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:sError
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
        [self uploadImage];//开始上传图片
    }
}

- (void)didPressedClosePic:(UIButton *)sender{
    [self.PicArray removeObjectAtIndex:sender.tag];
    //图片全部删除隐藏
    if (self.PicArray.count == 0) {
        _picCollectionView.hidden = YES;
        _btnNextPage.enabled = NO;
        [_btnNextPage setBackgroundColor:CannotPressGray];
    }
    [_picCollectionView reloadData];
}

- (IBAction)didPressedChoosePic:(id)sender {
    [self openMenu];
}

- (IBAction)didPressedCategory:(id)sender {
    
    [self.txtTitle resignFirstResponder];
    [self.tvDescription resignFirstResponder];
    
    if ([CategoryAndCountryInfo getInstance].categoryInfo) {
        self.responseCategory = [CategoryAndCountryInfo getInstance].categoryInfo;
        [_categoryTableview reloadData];
        
        [self showCateGoryTabelview];
    }else{
        [NetworkEngine showMbDialog:self.view title:@"请稍后"];
        CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
        __weak typeof(self) weakSelf = self;
        [NetworkEngine getJSONWithUrl:categoryEntity success:^(id json) {
            [NetworkEngine hiddenDialog];
            [CategoryAndCountryInfo getInstance].categoryInfo = [[ResponseCategory alloc] initwithJson:json];
            weakSelf.responseCategory = [CategoryAndCountryInfo getInstance].categoryInfo;
            [weakSelf.categoryTableview reloadData];
            
            [weakSelf showCateGoryTabelview];
        } fail:^(NSError *error) {
            
        }];
    }
    
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
        float tY = SCREEN_HEIGHT - 44*(self.responseCategory.responseCategoryArray.count+1) - 30;
        
        [UIView animateWithDuration:0.25 animations:^{
            if (tY > 0) {
                _categoryView.frame = CGRectMake(0, tY, SCREEN_WIDTH, 44*self.responseCategory.responseCategoryArray.count+44);
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

- (IBAction)didPressedCountry:(id)sender {
    
    [self.txtPrice resignFirstResponder];
    if ([CategoryAndCountryInfo getInstance].countryInfo) {
        self.responseCountry = [CategoryAndCountryInfo getInstance].countryInfo;
    }else {
        [NetworkEngine showMbDialog:self.view title:@"正在加载"];
        CountryEntity *countryEntity = [[CountryEntity alloc] init];
        __weak typeof(self) weakSelf = self;
        [NetworkEngine getJSONWithUrl:countryEntity success:^(id json) {
            [CategoryAndCountryInfo getInstance].countryInfo = [[ResponseCountry alloc] initwithJson:json];
            weakSelf.responseCountry = [CategoryAndCountryInfo getInstance].countryInfo;
            
            [NetworkEngine hiddenDialog];
        } fail:^(NSError *error) {
            [NetworkEngine hiddenDialog];
        }];
    }
    iCityType = cityType_Country;
    cityArr = self.responseCountry.responseCountryInfoArray;
    [_cityTableview reloadData];
    
    [self showCityTableview];
}

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
            cityArr = self.chooseCountry.provinceOrStateInfos;
            [_cityTableview reloadData];
        }
            break;
        default:
            break;
    }
}

- (void)showCityTableview{
    iCityType = cityType_Country;
    if (self.responseCountry.responseCountryInfoArray.count > 0) {
        cityArr = self.responseCountry.responseCountryInfoArray;
    }
    
    UIView *view = [self.navigationController.view viewWithTag:cityTag];
    if (!view.superview) {
        UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        mainview.tag = cityTag;
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
    UIView *view = [self.navigationController.view viewWithTag:cityTag];
    [UIView animateWithDuration:0.25 animations:^{
        _cityView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (IBAction)didPressedNewOld:(id)sender {
    [_txtPrice resignFirstResponder];
    if (_txtCity.text.length > 0 && self.chooseCountry) {
        [_conditionTableview reloadData];
        [self showConditionTableview];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)didPressedFinishInputPrice:(id)sender {
    [_txtPrice resignFirstResponder];
}

- (void)showConditionTableview{
    UIView *view = [self.navigationController.view viewWithTag:conditionTag];
    if (!view.superview) {
        UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        mainview.tag = conditionTag;
        mainview.backgroundColor = [UIColor clearColor];
        mainview.alpha = 1;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6;
        [mainview addSubview:backView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [button addTarget:self action:@selector(hideConditionView) forControlEvents:UIControlEventTouchDown];
        [mainview addSubview:button];
        [mainview addSubview:_conditionTableview];
        _conditionTableview.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 49 + 20);
        _conditionTableview.tableHeaderView = _conditionHeaderview;
        [self.navigationController.view addSubview:mainview];
        
        [UIView animateWithDuration:0.25 animations:^{
            if ((self.chooseCountry.conditionLevels.count * 44 + 44) > SCREEN_HEIGHT-49+20) {
                _conditionTableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 + 20);
            }else {
                _conditionTableview.frame = CGRectMake(0, SCREEN_HEIGHT-49+20-(self.chooseCountry.conditionLevels.count * 44 + 44), SCREEN_WIDTH, SCREEN_HEIGHT - 49 + 20);
            }
        }];
    }else {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 + 20);
    }
}

- (void)hideConditionView{
    UIView *view = [self.navigationController.view viewWithTag:conditionTag];
    [UIView animateWithDuration:0.25 animations:^{
        _conditionTableview.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 49 + 20);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)changeTopTab:(NSInteger)i{
    _iPage = i;
    [_btnTakePhoto setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnTakePhoto setImage:[UIImage imageNamed:@"dianji"] forState:UIControlStateNormal];
    [_btnDescription setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnDescription setImage:[UIImage imageNamed:@"miaoshu"] forState:UIControlStateNormal];
    [_btnMakePrice setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnMakePrice setImage:[UIImage imageNamed:@"biaojia"] forState:UIControlStateNormal];
    [self changeSlide:i];
    
    switch (i) {
        case 0:
        {
            [_imgvArrowOne setImage:[UIImage imageNamed:@"banck_on"]];
            [_imgvArrowTwo setImage:[UIImage imageNamed:@"hui"]];
            [_btnTakePhoto setTitleColor:selectedOrange forState:UIControlStateNormal];
            [_btnTakePhoto setImage:[UIImage imageNamed:@"dianji_on"] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [_imgvArrowOne setImage:[UIImage imageNamed:@"hui"]];
            [_imgvArrowTwo setImage:[UIImage imageNamed:@"banck_on"]];
            [_btnDescription setTitleColor:selectedOrange forState:UIControlStateNormal];
            [_btnDescription setImage:[UIImage imageNamed:@"miaoshu_on"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_imgvArrowOne setImage:[UIImage imageNamed:@"hui"]];
            [_imgvArrowTwo setImage:[UIImage imageNamed:@"hui"]];
            [_btnMakePrice setTitleColor:selectedOrange forState:UIControlStateNormal];
            [_btnMakePrice setImage:[UIImage imageNamed:@"biaojia_on"] forState:UIControlStateNormal];
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
           SlideView.frame = CGRectMake(0, 43, SCREEN_WIDTH/3, 2);
        }
            break;
        case 1:
        {
            SlideView.frame = CGRectMake(SCREEN_WIDTH/3, 43, SCREEN_WIDTH/3, 2);
        }
            break;
        case 2:
        {
            SlideView.frame = CGRectMake(2*SCREEN_WIDTH/3, 43, SCREEN_WIDTH/3, 2);
        }
            break;
        default:
            break;
    }
    
    [UIView commitAnimations];
}

#pragma mark - 选择照片
#pragma mark -选择拍照还是本地相册
#pragma mark-----------change head image--------------
-(void)openMenu{
    //在这里呼出下方菜单按钮项
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    myActionSheet.tag = 999;
    [myActionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //呼出的菜单按钮点击后的响应
    if (actionSheet.tag == 999) {
        if (buttonIndex == actionSheet.cancelButtonIndex){
            //        NSLog(@"取消");
        }
        switch (buttonIndex){
            case 0:  //打开照相机拍照
                [self takePhoto];
                break;
            case 1:  //打开本地相册
                [self LocalPhoto];
                break;
        }
    }
    
}
//开始拍照
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        bCamera = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开本地相册
-(void)LocalPhoto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.iChosenImagesCount = self.PicArray.count;
    [imagePickerController setAllowsMultipleSelection:YES];
    bCamera = NO;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage* originalImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage* image = [self fixOrientation:originalImg];
        if (bCamera) {
            UIImageWriteToSavedPhotosAlbum(image,self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
        }else {
            [self.PicArray addObject:image];
            _picCollectionView.hidden = NO;
            _btnNextPage.enabled = YES;
            [_btnNextPage setBackgroundColor:PressYellow];
            [_picCollectionView reloadData];
        }
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo{
    if (error){
        // Do anything needed to handle the error or display it to the user
    }else{
        
        [self.PicArray addObject:image];
        _picCollectionView.hidden = NO;
        _btnNextPage.enabled = YES;
        [_btnNextPage setBackgroundColor:PressYellow];
        [_picCollectionView reloadData];
        
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerHiddenAPIDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfoArray:(NSArray *)infoArray
{
    for (NSDictionary *info in infoArray) {
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        //当选择的类型是图片
        if ([type isEqualToString:@"public.image"]){
            //先把图片转成NSData
            UIImage* originalImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            UIImage* image = [self fixOrientation:originalImg];
            [self.PicArray addObject:image];
        }
        
    }
    _picCollectionView.hidden = NO;
    _btnNextPage.enabled = YES;
    [_btnNextPage setBackgroundColor:PressYellow];
    [_picCollectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark - 处理图片防止旋转90度
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - UITableView Delegate
#pragma mark - Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _categoryTableview) {
        return self.responseCategory.responseCategoryArray.count;
    }else if (tableView == _cityTableview) {
        return 1;
    }else if (tableView == _conditionTableview) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _categoryTableview) {
        return 44;
    }else if (tableView == _cityTableview) {
        return 44;
    }else if (tableView == _conditionTableview) {
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _categoryTableview) {
        return 44;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _categoryTableview) {
        if (categoryArr.count > 0) {
            if (section == [[categoryArr objectAtIndex:0] integerValue]) {
                return [[categoryArr objectAtIndex:1] integerValue];
            }
        }
    }else if (tableView == _cityTableview) {
        return cityArr.count;
    }else if (tableView == _conditionTableview) {
        return self.chooseCountry.conditionLevels.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categoryTableview) {
        if (categoryArr.count > 0) {
            if (indexPath.section == [[categoryArr objectAtIndex:0] integerValue]) {
                NSString *cellIdentify = @"CategoryCell";
                CategoryCell *cell = (CategoryCell *)[tableView customdq:cellIdentify];
                CategoryInfo *c = [self.responseCategory.responseCategoryArray objectAtIndex:indexPath.section];
                CategoryInfo *c1 = [c.childCategories objectAtIndex:indexPath.row];
                cell.categoryInfo = c1;
                
                return cell;
            }

        }
    }else if (tableView == _cityTableview) {
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
    }else if (tableView == _conditionTableview) {
        NSString *cellIdentify = @"CityCell";
        CityCell *cell = (CityCell *)[tableView customdq:cellIdentify];
        ConditionLevelInfo *c = [self.chooseCountry.conditionLevels objectAtIndex:indexPath.row];
        cell.lblName.text = c.displayName;
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categoryTableview) {
        CategoryInfo *c = [self.responseCategory.responseCategoryArray objectAtIndex:indexPath.section];
        CategoryInfo *c1 = [c.childCategories objectAtIndex:indexPath.row];
        _txtCategory.text = c1.displayName;
        self.chooseCategory = c1;
        [self hideCategoryView];
    }else if (tableView == _cityTableview) {
        if (iCityType == cityType_Country) {
            self.chooseCountry = [self.responseCountry.responseCountryInfoArray objectAtIndex:indexPath.row];
            if (self.chooseCountry.provinceOrStateInfos.count > 0) {
                iCityType = cityType_Province;
                cityArr = self.chooseCountry.provinceOrStateInfos;
                [_cityTableview reloadData];
                return;
            }else {
                //选中国家
                _txtCity.text = self.chooseCountry.displayName;
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
                _txtCity.text = self.chooseProvince.displayName;
                [self hideCityView];
                return;
            }
        }else if (iCityType == cityType_City) {
            //选中城市了
            self.chooseCity = [cityArr objectAtIndex:indexPath.row];
            _txtCity.text = self.chooseCity.displayName;
            //更新用户最后选择的城市
            [[NSUserDefaults standardUserDefaults] setValue:self.chooseCity.cityId forKey:@"localCityId"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"chooseCity"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [AppDelegateEntity updateLastCityID];
            [self hideCityView];
            return;
        }
    }else if (tableView == _conditionTableview){
        self.chooseCondition = [self.chooseCountry.conditionLevels objectAtIndex:indexPath.row];
        _txtNewOld.text = self.chooseCondition.displayName;
        [self hideConditionView];

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
        
        CategoryInfo *c = [self.responseCategory.responseCategoryArray objectAtIndex:section];
        UILabel *lblCategoryName = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-15-15-20, 20)];
        lblCategoryName.text = c.displayName;
        lblCategoryName.font = [UIFont systemFontOfSize:14.5];
        [headerview addSubview:lblCategoryName];
        
        UIButton *btn_list = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, headerview.frame.size.width, headerview.frame.size.height)];
        btn_list.tag = section;
        [btn_list addTarget:self action:@selector(showSecondCategory:) forControlEvents:UIControlEventTouchDown];
        [headerview addSubview:btn_list];
        
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
            CategoryInfo *c = [self.responseCategory.responseCategoryArray objectAtIndex:sender.tag];
            categoryArr = nil;
            categoryArr = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%ld",(long)sender.tag],[NSString stringWithFormat:@"%ld",(long)c.childCategories.count],nil];
        }
    }else {
        CategoryInfo *c = [self.responseCategory.responseCategoryArray objectAtIndex:sender.tag];
        categoryArr = nil;
        categoryArr = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%ld",(long)sender.tag],[NSString stringWithFormat:@"%ld",(long)c.childCategories.count],nil];
    }
    
    float height = 0;
    if (categoryArr.count > 0) {
        height = [[categoryArr objectAtIndex:1] floatValue];
    }
    
    //根据列表数量调整列表高度
    float fheight = SCREEN_HEIGHT - 44*(self.responseCategory.responseCategoryArray.count+1+height) - 30;
    if (fheight > 0) {
        _categoryView.frame = CGRectMake(0, (SCREEN_HEIGHT - 44*(self.responseCategory.responseCategoryArray.count+1+height) - 30), SCREEN_WIDTH,44*(self.responseCategory.responseCategoryArray.count+1+height) );
    }else {
        _categoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30);
    }
    
    [_categoryTableview reloadData];
}

#pragma mark - Textfiled delegate
//键盘收回
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

#pragma mark - textview
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
}

#pragma mark - 处理请求
//报错原因
- (NSString *)PostError{
    if (_txtCategory.text.length == 0) {
        return @"请选择类别";
    }else if (_txtCity.text.length == 0) {
        return @"请选择城市";
    }else if (_txtNewOld.text.length == 0) {
        return @"请选择新旧程度";
    }
    return @"";
}

- (void)uploadImage{
    [self addThumbnailPhoto];//添加缩略图
    [NetworkEngine showMbDialog:self.view title:@"正在上传"];
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    [imagesArray addObjectsFromArray:self.PicArray];
    [imagesArray addObjectsFromArray:self.PicArraySmall];
    [imagesArray addObject:self.ThumbImage];
    [imagesArray addObject:self.thumbImageSmall];
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < imagesArray.count; i ++) {
        
        FileUploadEntity *fileUploadEntity = [[FileUploadEntity alloc] init];
        fileUploadEntity.userId = [UserMember getInstance].userId;
        fileUploadEntity.fileType = @"jpg";
        fileUploadEntity.from = @"post";
        
        [NetworkEngine postLoginRequestEntity:fileUploadEntity success:^(id json) {
            ResponseFileUpload *responseFileUpload = [[ResponseFileUpload alloc] initwithJson:json];
            
            [urlArray addObject:responseFileUpload];
            
            if (imagesArray.count == urlArray.count) {
                [NetworkEngine putUploadSomeImages:urlArray
                                        imageArray:imagesArray
                                           success:^(NSMutableArray *aUrl) {
                                               [NetworkEngine hiddenDialog];
                                               
                                               self.ArrDidUpLoadPicUrl = aUrl;
                                               [self submitPost];
                                               NSLog(@"%@",aUrl);
                                           } fail:^(NSError *error) {
                                               [NetworkEngine hiddenDialog];
                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                               [alert show];
                                           } progress:^(NSInteger i) {
                                               //[NetworkEngine showMbDialog:weakSelf.view title:[NSString stringWithFormat:@"正在上传照片",i]];
                                               [NetworkEngine showMbDialog:weakSelf.view title:@"正在上传照片"];
                                           }];
            }
        } fail:^(NSError *error) {
            [NetworkEngine hiddenDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"图片上传失败"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }];
    }
}

- (void)submitPost{
//    [[LocationManger getInstanceWithDelegate:self] startUpdataLocation];//开启定位确认位置
    if (!self.chooseSellPost) {
        [self lastSubmitPost];
    }else {
        [self modifyPutSubmit];
    }
}

//最终的提交
- (void)lastSubmitPost{
    if ([[UserMember getInstance].baseUserInfo.status isEqualToString:@"ACTIVE"]) {
        [NetworkEngine showMbDialog:self.view title:@"正在上传"];
        SellPostEntity *sellPostEntity = [[SellPostEntity alloc] init];
        sellPostEntity.categoryPath = self.chooseCategory.categoryPath;
        sellPostEntity.title = _txtTitle.text;
        sellPostEntity.details = _tvDescription.textView.text;
        sellPostEntity.thumbnailPhoto = [self getThumbnailPhotoFromImage:self.ThumbImage url:[self.ArrDidUpLoadPicUrl objectAtIndex:self.ArrDidUpLoadPicUrl.count-2] smallUrl:[self.ArrDidUpLoadPicUrl objectAtIndex:self.ArrDidUpLoadPicUrl.count-1]];
        sellPostEntity.photos = [self arrayPhotoWitsUrl:self.ArrDidUpLoadPicUrl];
        sellPostEntity.price = [self getPriceFromSell];
        sellPostEntity.conditionLevelId = self.chooseCondition.conditionLevelId;
        sellPostEntity.firmPrice = [NSNumber numberWithBool:_switchPrice.on];
        sellPostEntity.address = [self getAdress];
        sellPostEntity.coordination = [self getCoordination];
        sellPostEntity.sellType = @"REGULAR";
        sellPostEntity.tags = @[];
        
        
        [NetworkEngine postForRegisterRequestEntity:sellPostEntity contentType:
         @"application/json" success:^(id json) {
             [NetworkEngine hiddenDialog];
             NSLog(@"%@",json);
             [self pushToSuccess];
         } fail:^(NSError *error) {
             [NetworkEngine hiddenDialog];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"帖子发布失败"
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
             [alert show];
         }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"邮箱未验证"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

- (void)modifyPutSubmit{
    if ([[UserMember getInstance].baseUserInfo.status isEqualToString:@"ACTIVE"]) {
        [NetworkEngine showMbDialog:self.view title:@"正在上传"];
        SellPostUpdateEntity *sellPostEntity = [[SellPostUpdateEntity alloc] init];
        [sellPostEntity setPutUrl:self.chooseSellPost.postId];
        sellPostEntity.categoryPath = self.chooseCategory.categoryPath;
        sellPostEntity.title = _txtTitle.text;
        sellPostEntity.details = _tvDescription.textView.text;
        sellPostEntity.thumbnailPhoto = [self getThumbnailPhotoFromImage:self.ThumbImage url:[self.ArrDidUpLoadPicUrl objectAtIndex:self.ArrDidUpLoadPicUrl.count-2] smallUrl:[self.ArrDidUpLoadPicUrl objectAtIndex:self.ArrDidUpLoadPicUrl.count-1]];
        sellPostEntity.photos = [self arrayPhotoWitsUrl:self.ArrDidUpLoadPicUrl];
        sellPostEntity.price = [self getPriceFromSell];
        sellPostEntity.conditionLevelId = self.chooseCondition.conditionLevelId;
        sellPostEntity.firmPrice = [NSNumber numberWithBool:_switchPrice.on];
        sellPostEntity.address = [self getAdress];
        sellPostEntity.tags = @[];
        //sellPostEntity.isFirmPrice = [NSNumber numberWithBool:_switchPrice.on];
        
        [NetworkEngine putUserInfoWithEntity:sellPostEntity success:^(id json) {
             [NetworkEngine hiddenDialog];
             NSLog(@"%@",json);
             [self pushToSuccess];
         } fail:^(NSError *error) {
             [NetworkEngine hiddenDialog];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"帖子修改失败"
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
             [alert show];
         }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"邮箱未验证"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)pushToSuccess{
    SalesSuccessViewController *vc = [SalesSuccessViewController shareManageWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    vc.viewController = self;
    vc.sTitle = _txtTitle.text;
    vc.delegate = self;
    [self.tabBarController.view addSubview:vc.view];
    [UIView animateWithDuration:0.25 animations:^{
        vc.view.frame = self.tabBarController.view.frame;
    }];
    
}

//生成缩略图
- (void)addThumbnailPhoto{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.PicArraySmall = nil;
    self.PicArraySmall = [[NSMutableArray alloc] init];
    
    //压缩 高宽/7
    for (UIImage *img in self.PicArray) {
        UIImage *imgTemp = [self imageWithImageSimple:img scaledToSize:CGSizeMake(img.size.width/4, img.size.height/4)];
        [tempArray addObject:imgTemp];
        
        UIImage *imgSmall = [self imageWithImageSimple:img scaledToSize:CGSizeMake(img.size.width/6, img.size.height/6)];
        [self.PicArraySmall addObject:imgSmall];
    }
    
    [self.PicArray removeAllObjects];
    [self.PicArray addObjectsFromArray:tempArray];
    
    //取第一张作缩略图
    UIImage *image = [self.PicArray objectAtIndex:0];
    self.ThumbImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(image.size.width/4, image.size.height/4)];
    self.thumbImageSmall = [self imageWithImageSimple:image scaledToSize:CGSizeMake(image.size.width/6, image.size.height/6)];
}

//获得缩略图对象
- (ThumbnailPhoto *)getThumbnailPhotoFromImage:(UIImage *)image url:(NSString *)sUrl smallUrl:(NSString *)smallUrl{
    ThumbnailPhoto *thumbnailPhoto = [[ThumbnailPhoto alloc] init];
    thumbnailPhoto.height = [NSNumber numberWithFloat:image.size.height];
    thumbnailPhoto.width  = [NSNumber numberWithFloat:image.size.width];
    thumbnailPhoto.imageUrl = sUrl;
    thumbnailPhoto.smallImageUrl = smallUrl;
    return thumbnailPhoto;
}

//获得图片对象的数组
- (NSArray *)arrayPhotoWitsUrl:(NSMutableArray *)aUrl{
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.PicArray.count; i++) {
        Photos *photos = [[Photos alloc] init];
        UIImage *image = [self.PicArray objectAtIndex:i];
        photos.height = [NSNumber numberWithFloat:image.size.height];
        photos.width  = [NSNumber numberWithFloat:image.size.width];
        photos.imageUrl = [aUrl objectAtIndex:i];
        photos.smallImageUrl = [aUrl objectAtIndex:i+self.PicArray.count];
        [photoArray addObject:photos];
    }
    NSArray *arr = [photoArray copy];
    return arr;
}

//获得价格对象
- (Price *)getPriceFromSell{
    Price *price = [[Price alloc] init];
    price.value = [NSNumber numberWithFloat:[_txtPrice.text floatValue]];//[NSNumber numberWithInteger:[_txtPrice.text integerValue]];
    price.currency = self.chooseCountry.currency;
    price.currencySymbol = self.chooseCountry.currencySymbol;
    return price;
}

//获得地址对象
- (Address *)getAdress{
    Address *address = [[Address alloc] init];
    //address.city = self.chooseCity.displayName;
    address.countryCode = self.chooseCity.countryCode;
    address.cityId = self.chooseCity.cityId;
    address.provinceOrStateCode = self.chooseCity.provinceOrStateCode;
    
//    address.city = [LocationManger getInstance].sCityName;
//    address.countryCode = [LocationManger getInstance].sCountryCode;
    address.postalCode = @"12345";//[LocationManger getInstance].sPostalCode;
//    address.provinceOrStateCode = [LocationManger getInstance].sProvinceOrStateCode;
    address.streetLine1 = [LocationManger getInstance].streetLine1;
    address.streetLine2 = [LocationManger getInstance].streetLine2;
    
    return address;
}

//获得经纬度对象
- (Coordination *)getCoordination{
    Coordination *coo = [[Coordination alloc] init];
    coo.lattitude = [NSNumber numberWithFloat:[LocationManger getInstance].fLatitude];
    coo.longitude = [NSNumber numberWithFloat:[LocationManger getInstance].fLongitude];
    
    return coo;
}

-(void)resetBefore:(BOOL)bBackHome
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBarHidden = NO;
    [self.PicArray removeAllObjects];
    [self.picCollectionView reloadData];
    self.picCollectionView.hidden = YES;
    
    [self changeTopTab:0];
    [_contentScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    _txtTitle.text = @"";
    _tvDescription.textView.returnKeyType = UIReturnKeyDone;
    _tvDescription.textView.font = [UIFont systemFontOfSize:15];
    [_tvDescription setEmptyText];
    _tvDescription.placeHolder = @"请输入详情";
    _tvDescription.placeHolderColor = RGBA(195, 195, 201, 1);
    _tvDescription.aDelegate = self;
    _txtCategory.text = @"";
    _txtPrice.text = @"";
    _txtNewOld.text = @"";
    _txtCity.text = @"";
    _iPage = 0;
    [_btnNextPage setTitle:CustomLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    if (bBackHome) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - Location Delegate
-(void)lmGetCityNameDelegate
{
    NSLog(@"定位成功");
    [self lastSubmitPost];
}

-(void)lmGetCoordinateDelegate
{
    
}

-(void)lmGetLocationFaild:(NSString *)sError
{
    NSLog(@"定位失败");
    [self lastSubmitPost];
}

@end
