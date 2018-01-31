//
//  RegisterViewController.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/1.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterUserDelegate <NSObject>

-(void)didUserRegisterDone;

@end

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswordAgain;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (nonatomic,weak) id<RegisterUserDelegate> delegate;
- (IBAction)didPressedSubmit:(id)sender;
@end
