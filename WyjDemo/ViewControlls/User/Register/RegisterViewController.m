//
//  RegisterViewController.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/1.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "RegisterViewController.h"
#import "Global.h"
#import "RegisterEntity.h"
#import "NetworkEngine.h"
#import "PublicUI.h"
#import "ResponseRegister.h"
#import "UserMember.h"
#import "AppDelegate.h"
#define btnblue RGBA(60,115,181,1)
#define btnGray RGBA(212,213,214,1)


@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBaseView];
    
}

- (void)createBaseView{
    self.navigationItem.title = CustomLocalizedString(@"注册", nil);
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(back) addtarget:self];
    
    _btnSubmit.enabled =NO;
    
    [self createContent];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建按钮下面内容
- (void)createContent{
    //编辑可变字符

    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"注册即视为同意本App的服务协议，如有疑问请联系cs@sell68.com。", nil)];
    //把电话号码和服务协议变为蓝色
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:btnblue
                        range:NSMakeRange(12, 4)];
    
//    [attriString addAttribute:NSForegroundColorAttributeName
//                        value:btnblue
//                        range:NSMakeRange(24, 11)];
    //添加字符
    _lblContent.attributedText = attriString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_txtEmail.text.length > 0 && _txtPassword.text.length > 0 && _txtPasswordAgain.text.length > 0) {
        _btnSubmit.enabled = YES;
        [_btnSubmit setBackgroundColor:PressYellow];
    }else {
        _btnSubmit.enabled = NO;
        [_btnSubmit setBackgroundColor:CannotPressGray];
    }
    return YES;
}
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didPressedSubmit:(id)sender {
    NSString *sMsg = @"";
    if (_txtEmail.text.length <= 0) {
        sMsg = @"邮箱不能为空";
    }
    else if (_txtPassword.text.length <= 0) {
        sMsg = @"密码不能为空";
    }
    else if (_txtPasswordAgain.text.length <= 0) {
        sMsg = @"密码验证不能为空";
    }
    else if (![_txtPasswordAgain.text isEqualToString:_txtPassword.text]) {
        sMsg = @"两次密码不一致";
    }
    
    if (sMsg.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sMsg
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        RegisterEntity *request = [[RegisterEntity alloc] init];
        request.displayName = _txtEmail.text;
        request.firstName = @"";
        request.lastName = @"";
        request.avatarSmallUrl = @"";
        request.avatarUrl = @"";
        request.avatarLargeUrl = @"";
        
        request.email = _txtEmail.text;
        request.authType = @"EMAILPASSWD";
        request.authToken = _txtPassword.text;
        request.acceptedLanguage = @"";
        
        [NetworkEngine showMbDialog:self.view title:@""];

        
        [NetworkEngine postForRegisterRequestEntity:request contentType:
         @"application/json" success:^(id json) {
             [NetworkEngine hiddenDialog];
             if (json) {
                 NSLog(@"json:%@",json);
                 
                 BaseUserInfo *user = [[BaseUserInfo alloc] initWithDic:json];
                 [UserMember getInstance].baseUserInfo = user;
                 
                 [UserMember getInstance].isLogin = YES;
                 [UserMember getInstance].userId = user.userId;
                 
                 [[NSUserDefaults standardUserDefaults] setObject:self.txtEmail.text forKey:@"UserName"];
                 [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:@"UserPWD"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [AppDelegateEntity autoLogin];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"注册成功，您必须登陆您的邮箱验证后才能发帖"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                 alert.tag = 112;
                 [alert show];
             } else {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"该账号已经注册过了"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                 alert.tag = 556;
                 [alert show];
             }
         } fail:^(NSError *error) {
             [NetworkEngine hiddenDialog];
             NSLog(@"erron:%@",error);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:error.description
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles: nil];
             [alert show];
         }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 112) {
        //注册成功
        [self.navigationController popViewControllerAnimated:NO];
        
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didUserRegisterDone)]) {
            [self.delegate didUserRegisterDone];
        }
    }
}


@end
