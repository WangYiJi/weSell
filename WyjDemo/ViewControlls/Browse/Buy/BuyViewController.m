//
//  BuyViewController.m
//  WyjDemo
//
//  Created by zjb on 16/2/25.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BuyViewController.h"
#import "Global.h"
#import "Utils.h"
#import "PublicUI.h"
#import "RequestChatConnect.h"
#import "NetworkEngine.h"
#import "ChatRecordViewController.h"
#import "UserMember.h"

#define scoll_image_height 320

@interface BuyViewController ()

@end

@implementation BuyViewController
@synthesize chooseSellPost;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    [self createView];
}

- (void)createView{
    self.navigationItem.title = CustomLocalizedString(@"出价购买", nil);
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(back) addtarget:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    [self loadImageHeaderCell];
    [self loadSellerInfo];
}

- (void)loadImageHeaderCell
{
    if (self.chooseSellPost.photos.count > 0) {
        for (int i=0;i<[self.chooseSellPost.photos count];i++) {
            UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, scoll_image_height)];
            Photos *p = [self.chooseSellPost.photos objectAtIndex:i];
            [v sd_setImageWithURL:[NSURL URLWithString:p.imageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
            v.contentMode = UIViewContentModeScaleAspectFit;
            [_imageScroll addSubview:v];
            
        }
        
        _ADVPageControl.hidden = NO;
        _ADVPageControl.numberOfPages = self.chooseSellPost.photos.count;
        _ADVPageControl.currentPage = 0;
        [_ADVPageControl addTarget:self action:@selector(didPressedchangePage:) forControlEvents:UIControlEventValueChanged];
        
        _imageScroll.delegate = self;
        _imageScroll.showsHorizontalScrollIndicator = NO;//水平不显示
        [_imageScroll setContentSize:CGSizeMake(SCREEN_WIDTH*self.chooseSellPost.photos.count, _cellImageScroll.frame.size.height)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _imageScroll) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = scrollView.contentOffset.x/pageWidth;
        _ADVPageControl.currentPage = page;
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

- (void)loadSellerInfo{
    _imgHeader.image = [UIImage imageNamed:@"default"];
    _lblName.text = self.chooseSellPost.userDiapName;
    _lbldate.text = [Utils DateStringFromDateSp:self.chooseSellPost.createdAt];
    _lblPrice.text = [NSString stringWithFormat:@"%@%.2f",self.chooseSellPost.price.currencySymbol,[self.chooseSellPost.price.value floatValue]];
    
    if ([self.chooseSellPost.firmPrice boolValue]) {
        _lblComfirm.text = @"卖主接受议价";
    }else {
        _lblComfirm.text = @"卖主不接受议价";
    }
    
    _txtMyPrice.inputAccessoryView = _myToolBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didPressedDone:(id)sender
{
    [_txtMyPrice resignFirstResponder];
}

-(IBAction)didPressedBuyNow:(id)sender
{
    
    if ([self.chooseSellPost.userId isEqualToString:[UserMember getInstance].userId]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您不能联系自己发布的物品"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        if (_txtMyPrice.text.length > 0) {
            [NetworkEngine showMbDialog:self.view title:@"请稍后"];
            RequestChatConnect *request = [[RequestChatConnect alloc] init];
            request.userId2 = self.chooseSellPost.userId;
            request.postId = self.chooseSellPost.postId;
            [NetworkEngine postRequestEntity:request contentType:@"application/x-www-form-urlencoded" success:^(id json) {
                [NetworkEngine hiddenDialog];
                NSString *final = [NSString stringWithFormat:@"你好，我对你贴的广告有兴趣，我的出价是%@，谢谢!",_txtMyPrice.text];
                ChatRecordViewController *vc = [[ChatRecordViewController alloc] initWithNibName:@"ChatRecordViewController" bundle:nil];
                vc.bBuyNow = YES;
                vc.sBuyNowUserId = self.chooseSellPost.userId;
                vc.sBuyNowMsg =final;

                vc.sPostId = self.chooseSellPost.postId;
                vc.sPostName = self.chooseSellPost.title;
                if ([self.chooseSellPost.photos count] > 0) {
                    Photos *p = [self.chooseSellPost.photos objectAtIndex:0];
                    vc.sImg = p.imageUrl;
                }
                vc.sPrice = [NSString stringWithFormat:@"%@%.2f",self.chooseSellPost.price.currencySymbol,[self.chooseSellPost.price.value floatValue]];
                
                
                
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
}

#pragma mark -  ----------------UITableViewDataSource-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return _cellImageScroll;
            break;
        case 1:
            return _cellSellerInfo;
            break;
        default:
            return _cellMyPrice;
            break;

    }
    
}

#pragma mark - -----------------UITableViewDelegate-----------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return _cellImageScroll.frame.size.height;
            break;
        case 1:
            return _cellSellerInfo.frame.size.height;
            break;
        default:
            return _cellMyPrice.frame.size.height;
            break;
            
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 22.5;
    }
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITextFeild delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_txtMyPrice endEditing:YES];
    return YES;
}

#pragma mark - keyboard notification
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        CGFloat deltaY= keyBoardRect.size.height;
        _mainTableview.frame = CGRectMake(0.0f, -deltaY,_mainTableview.frame.size.width,_mainTableview.frame.size.height);
    }];
}

-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _mainTableview.frame = CGRectMake(0.0f, 0,_mainTableview.frame.size.width,_mainTableview.frame.size.height);
    }];
}

@end
