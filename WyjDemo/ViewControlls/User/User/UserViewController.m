//
//  UsersViewController.m
//  WyjDemo
//
//  Created by 霍霍 on 15/10/17.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "Global.h"
#import "UserMember.h"
#import "UserInfoViewController.h"
#import "MyAdvertisementViewController.h"
#import "ShareViewController.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

#define helpJianURL @"http://sell68.com/help/?variant=zh-hans"
#define helpFanURL @"http://sell68.com/help/?variant=zh-hant"

#define AboutJianURL @"http://sell68.com/about/?variant=zh-hans"
#define AboutFanURL @"http://sell68.com/about/?variant=zh-hant"


@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshUserStats];
    [self refreshTitle];
}

-(void)refreshUserStats
{
    //裁剪头像
    _imgvHeader.clipsToBounds = YES;
    _imgvHeader.layer.cornerRadius = 28;
    if ([UserMember getInstance].isLogin) {
        //登入
        _lblUserName.text = [UserMember getInstance].baseUserInfo.displayName;
        _lblEmail.text = [UserMember getInstance].baseUserInfo.email;
        _imgvEmail.hidden = NO;
        
        
        if ([UserMember getInstance].baseUserInfo.avatarUrl.length > 0) {
            [_imgvHeader sd_setImageWithURL:[NSURL URLWithString:[UserMember getInstance].baseUserInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"default"]];
        } else {
            _imgvHeader.image = [UIImage imageNamed:@"default"];
        }
        
    } else {
        //登出
        _lblUserName.text = CustomLocalizedString(@"您还没有登录，点击登录", nil);
        _lblEmail.text = nil;
        _imgvEmail.hidden = YES;
        _imgvHeader.image = nil;
    }
}

- (void)createView{
    self.navigationItem.title = CustomLocalizedString(@"我的", nil);
    
    [_mainTableview setTableHeaderView:_HeaderView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    [headview setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return headview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return _cellMyAdv;
            break;
        case 1:
            return _cellHelpCenter;
            break;
        case 2:
            return _cellInviteFriend;
            break;
        case 4:
            return _cellLanguage;
        default:
            return _cellAboutAPP;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if ([UserMember getInstance].isLogin) {
                [self pushToMyAdv];
            } else {
                //1.未登录
                [self pushToLoginVC];
            }
        }
            break;
        case 2:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"邀请好友"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"短信",@"邮件",@"取消", nil];
            sheet.tag = 889;
            [sheet showInView:self.view];
        }
            break;
        case 4:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"切换语言"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"简体",@"繁体", nil];
            sheet.tag = 888;
            [sheet showInView:self.view];
        }
            break;
        default:
        {
            WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
            NSString *sLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage];
            BOOL bJianTi = NO;
            if (sLanguage.length <= 0) {
                bJianTi = YES;
            }
            else if ([sLanguage isEqualToString:@"zh-Hans"]) {
                bJianTi = YES;
            }
            else if ([sLanguage isEqualToString:@"zh-Hant"]) {
                bJianTi = NO;
            }
            
            
            if (indexPath.row == 1) {
                webVC.sURL = bJianTi?helpJianURL:helpFanURL;
            }
            else if (indexPath.row == 3) {
                webVC.sURL = bJianTi?AboutJianURL:AboutFanURL;
            }
            
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 888) {
        if (buttonIndex == 0) {
            //简体
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if (buttonIndex == 1) {
            //繁体
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:AppLanguage];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self refreshTitle];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"RefreshShaiXuan" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else if (actionSheet.tag == 889) {
        if (buttonIndex == 0) {
            //调短信
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"]];
            if( [MFMessageComposeViewController canSendText] )
            {
                MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
                //controller.recipients = phones;
                //controller.navigationBar.tintColor = [UIColor redColor];
                controller.body = AppDelegateEntity.sAddFriendTemplate;
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
            
            [mailPicker setMessageBody:AppDelegateEntity.sAddFriendTemplate isHTML:NO];
            
            [self presentViewController:mailPicker animated:YES completion:^{
                
            }];
            

            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:"]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button
- (IBAction)didPressLogin:(id)sender {
    if ([UserMember getInstance].isLogin) {
        [self pushToUserInfo];
    } else {
        //1.未登录
        [self pushToLoginVC];
    }

}


#pragma mark - push
- (void)pushToUserInfo{
    UserInfoViewController *userVC = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    userVC.navigationItem.title = CustomLocalizedString(@"个人信息", nil);
    userVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)pushToLoginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.navigationItem.title = CustomLocalizedString(@"登录", nil);
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)pushToMyAdv{
    MyAdvertisementViewController *vc = [[MyAdvertisementViewController alloc] initWithNibName:@"MyAdvertisementViewController" bundle:nil];
    vc.navigationItem.title = CustomLocalizedString(@"我的广告", nil);
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshTitle
{
    _lblMyAdv.text = CustomLocalizedString(@"我的广告", nil);
    _lblHelpCenten.text = CustomLocalizedString(@"帮助中心", nil);
    _lblAddFriend.text = CustomLocalizedString(@"邀请朋友", nil);
    _lblAbount.text = CustomLocalizedString(@"关于APP", nil);
    _lblLaunage.text = CustomLocalizedString(@"语言", nil);
    if (![UserMember getInstance].isLogin) {
        _lblUserName.text = CustomLocalizedString(@"您还没有登录，点击登录", nil);
    }
}
@end
