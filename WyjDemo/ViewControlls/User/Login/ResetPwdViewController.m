//
//  ResetPwdViewController.m
//  WyjDemo
//
//  Created by wyj on 16/1/22.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "ResetPasswordEntity.h"
#import "NetworkEngine.h"
#import "PublicUI.h"

@interface ResetPwdViewController ()

@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.txtEmail.text = @"wang300687@sina.com";
    [self.txtEmail becomeFirstResponder];
    
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(didPressedBack) addtarget:self];
    self.title = @"找回密码";
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(didPressedDone)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)didPressedBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didPressedDone
{
    [self resetPwd];
}

-(void)resetPwd
{
    if (self.txtEmail.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入邮箱"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        ResetPasswordEntity *entity = [[ResetPasswordEntity alloc] init];
        entity.email = self.txtEmail.text;
        [NetworkEngine putPasswordWithEntity:entity
                                    success:^(id json) {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请查收邮箱"
                                                                                        message:nil
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"确定"
                                                                              otherButtonTitles:nil];
                                        alert.tag = 777;
                                        [alert show];
                                    } fail:^(NSError *error) {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败"
                                                                                        message:nil
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"确定"
                                                                              otherButtonTitles:nil];
                                        [alert show];
                                    }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 777) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
