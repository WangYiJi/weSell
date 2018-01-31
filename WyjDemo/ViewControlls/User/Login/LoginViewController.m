//
//  LoginViewController.m
//  WyjDemo
//
//  Created by wyj on 15/10/30.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginEntity.h"
#import "NetworkEngine.h"
#import "ResponseLoginInfo.h"
#import "UserMember.h"
#import "PublicUI.h"
#import "ResetPwdViewController.h"
#import "AppDelegate.h"

@interface LoginViewController (){
    BOOL bSecure;
}
@end

@implementation LoginViewController
@synthesize bBackTabFirst;
- (void)viewDidLoad {
    [super viewDidLoad];
    bSecure = YES;
    [self createView];
}

- (void)createView{
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(back) addtarget:self];
}

- (void)back{
    if (bBackTabFirst) {
        AppDelegateEntity.tabVC.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressedLogin:(id)sender {
    NSString *sError = @"";
    if (self.txtEmail.text.length <= 0) {
        sError = @"账号不能为空";
    }else if(self.txtPWD.text.length <= 0){
        sError = @"密码不能为空";
    }
    if (sError.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:sError
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        LoginEntity *login = [[LoginEntity alloc] init];
        login.email = self.txtEmail.text;
        login.password = self.txtPWD.text;
        login.mobilePlatform = @"IPHONE";
        
        [NetworkEngine showMbDialog:self.view title:@"请稍后"];
        
        __weak typeof(self) weakSelf = self;
        [NetworkEngine postLoginRequestEntity:login success:^(id json) {
            [NetworkEngine hiddenDialog];
            //保存登录信息
            BaseUserInfo *user = [[BaseUserInfo alloc] initWithDic:json];
            [UserMember getInstance].baseUserInfo = user;
            
            [UserMember getInstance].isLogin = YES;
            [UserMember getInstance].userId = user.userId;
            [UserMember getInstance].signingKey = user.signingKey;
            
            [[NSUserDefaults standardUserDefaults] setObject:self.txtEmail.text forKey:@"UserName"];
            [[NSUserDefaults standardUserDefaults] setObject:self.txtPWD.text forKey:@"UserPWD"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSNotification *notification =[NSNotification notificationWithName:@"openSocketNotification" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } fail:^(NSError *error) {
            [NetworkEngine hiddenDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"登录失败"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (IBAction)pushToRegister:(id)sender {
    RegisterViewController *rVc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    rVc.delegate = self;
    [self.navigationController pushViewController:rVc animated:YES];
}

- (IBAction)didPressedshowPwd:(id)sender {
    bSecure = !bSecure;
    _txtPWD.secureTextEntry = bSecure;
}

- (IBAction)didPressedResetPwd:(id)sender
{
    ResetPwdViewController *vc = [[ResetPwdViewController alloc] initWithNibName:@"ResetPwdViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 注册回调
-(void)didUserRegisterDone
{
    [self.navigationController popViewControllerAnimated:NO];
}
@end
