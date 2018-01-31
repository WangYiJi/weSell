//
//  EditTextViewController.m
//  WyjDemo
//
//  Created by wyj on 16/1/15.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "EditTextViewController.h"
#import "UploadUserInfoEntity.h"
#import "NetworkEngine.h"
#import "ResponseUserAccount.h"
#import "BaseUserInfo.h"
#import "UserMember.h"

@interface EditTextViewController ()

@end

@implementation EditTextViewController
@synthesize sMsg;
@synthesize infoType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(didPressedDone)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.txt.text = sMsg;
    
    [self.txt becomeFirstResponder];
    
    self.title = @"修改昵称";
    
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(didPressedBack)];
    self.navigationItem.leftBarButtonItem = backBar;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)didPressedBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didPressedDone
{
    if (self.txt.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入昵称"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [NetworkEngine showMbDialog:self.view title:@"正在上传"];
        
        UploadUserInfoEntity *entity = [[UploadUserInfoEntity alloc] init];
        entity.displayName = self.txt.text;
        [NetworkEngine putUserInfoWithEntity:entity success:^(id json) {
            [NetworkEngine hiddenDialog];
            BaseUserInfo *user = [[BaseUserInfo alloc] initWithDic:json];
            [UserMember getInstance].baseUserInfo = user;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改成功"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            alert.tag = 777;
            [alert show];
        } fail:^(NSError *error) {
            [NetworkEngine hiddenDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 777) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
