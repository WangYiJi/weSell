//
//  ChangePwdViewController.m
//  WyjDemo
//
//  Created by Alex on 16/2/24.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "ChangePasswardEntity.h"
#import "NetworkEngine.h"
#import "UserMember.h"

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密码修改";
    
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(didPressedBack)];
    self.navigationItem.leftBarButtonItem = backBar;
    
    UIBarButtonItem *doneBar = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(didPressedDone)];
    self.navigationItem.rightBarButtonItem = doneBar;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)didPressedDone
{
    NSString *sMsg = [self sErrorMsg];
    if (sMsg.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:sMsg
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确认", nil];
        [alert show];
    } else {
        [NetworkEngine showMbDialog:self.view title:@"请稍后"];
        ChangePasswardEntity *entity = [[ChangePasswardEntity alloc] init];
        entity.userId = [UserMember getInstance].userId;
        entity.currentPassword = _txtOPwd.text;
        entity.newPassword = _txtNPwd.text;
        entity.authType = @"EMAILPASSWD";
        [NetworkEngine putPasswordWithEntity:entity success:^(id json) {
            [NetworkEngine hiddenDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"修改成功"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            alert.tag = 777;
            [alert show];
        } fail:^(NSError *error) {
            [NetworkEngine hiddenDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"密码修改失败"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }];
    }
}

-(NSString*)sErrorMsg
{
    NSString *sTemp = @"";
    if (_txtOPwd.text.length <= 0) {
        sTemp = @"老密码不能为空";
    }
    else if (_txtNPwd.text.length <= 0) {
        sTemp = @"新密码不能为空";
    }
    else if (_txtConfirm.text.length <= 0) {
        sTemp = @"确认密码不能为空";
    }
    else if (![_txtNPwd.text isEqualToString:_txtConfirm.text])
    {
        sTemp = @"确认密码不一致";
    }
    return sTemp;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 777) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)didPressedBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
