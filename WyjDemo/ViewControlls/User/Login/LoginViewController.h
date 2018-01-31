//
//  LoginViewController.h
//  WyjDemo
//
//  Created by wyj on 15/10/30.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"

@interface LoginViewController : UIViewController
<
RegisterUserDelegate
>
@property (weak, nonatomic) IBOutlet UITextField *txtPWD;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (assign,nonatomic) BOOL bBackTabFirst;

- (IBAction)didPressedLogin:(id)sender;
- (IBAction)pushToRegister:(id)sender;
- (IBAction)didPressedshowPwd:(id)sender;
- (IBAction)didPressedResetPwd:(id)sender;

@end
