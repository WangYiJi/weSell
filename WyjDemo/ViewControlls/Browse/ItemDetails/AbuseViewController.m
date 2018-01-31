//
//  AbuseViewController.m
//  WyjDemo
//
//  Created by 霍霍 on 16/2/5.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "AbuseViewController.h"
#import "PublicUI.h"
#import "AbuseTypeEntity.h"
#import "AbuseReportEntity.h"
#import "ResponseAbuseType.h"
#import "NetworkEngine.h"
#import "UITableView+CustomCell.h"
#import "AbuseTypeCell.h"
#import "UserMember.h"
#import "LoginViewController.h"

@interface AbuseViewController ()
@property (nonatomic,strong) ResponseAbuseType *responseAbuseType;
@property (nonatomic,strong) AbuseType *chooseAbuseType;
@end

@implementation AbuseViewController
@synthesize postId;

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
    self.navigationItem.title = CustomLocalizedString(@"举报", nil);
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(back) addtarget:self];
    
    
    _tvMessage.textView.returnKeyType = UIReturnKeyDone;
//    _tvMessage.placeHolder = @"发表您的评论。。。";
    _tvMessage.placeHolderColor = [UIColor lightGrayColor];
    _tvMessage.aDelegate = self;
    _tvMessage.textView.inputAccessoryView = self.myToolbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadData{
    AbuseTypeEntity *abuseEntity = [[AbuseTypeEntity alloc] init];
    abuseEntity.abuseItemType = @"SELLPOST";
    
    __weak typeof(self) weakself = self;
    [NetworkEngine getJSONWithUrl:abuseEntity success:^(id json) {
        weakself.responseAbuseType = [[ResponseAbuseType alloc] initwithJson:json];
        
        [_abuseTableview reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseAbuseType.responseAbuseTypeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentify = @"AbuseTypeCell";
    AbuseTypeCell *cell = (AbuseTypeCell *)[tableView customdq:cellIdentify];
    AbuseType *abuse = [self.responseAbuseType.responseAbuseTypeArray objectAtIndex:indexPath.row];
    cell.lblName.text = abuse.displayName;
    if (self.chooseAbuseType == abuse){
        cell.imgCheck.image = [UIImage imageNamed:@"Check"];
        cell.lblName.textColor = [UIColor redColor];
    }else {
        cell.imgCheck.image = nil;
        cell.lblName.textColor = [UIColor blackColor];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chooseAbuseType = [self.responseAbuseType.responseAbuseTypeArray objectAtIndex:indexPath.row];
    [tableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 778) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Button
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)DidPressedHideKeyboard:(id)sender {
    [_tvMessage resignFirstResponder];
}

- (IBAction)didPressedSubmitAbuse:(id)sender {
    AbuseReportEntity *abuseReport = [[AbuseReportEntity alloc] init];
    abuseReport.abuseItemType = self.chooseAbuseType.abuseItemType;
    abuseReport.abuseItemId = self.postId;
    abuseReport.abuseType = self.chooseAbuseType.abuseType;
    abuseReport.abuseTypeMessage = self.chooseAbuseType.displayName;
    
    [NetworkEngine postForRegisterRequestEntity:abuseReport contentType:
     @"application/json" success:^(id json) {   
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"举报成功"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
         alert.tag = 778;
         [alert show];
    } fail:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"举报失败"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

#pragma mark - keyboard notification
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        CGFloat deltaY= keyBoardRect.size.height;
        weakSelf.view.frame = CGRectMake(0.0f, -deltaY,weakSelf.view.frame.size.width,weakSelf.view.frame.size.height);
    }];
}

-(void)keyboardHide:(NSNotification *)note
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        weakSelf.view.frame = CGRectMake(0.0f, 0,weakSelf.view.frame.size.width,weakSelf.view.frame.size.height);
    }];
}

#pragma mark - textview delegate
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
   [textView resignFirstResponder];
}

@end
