//
//  ChangePwdViewController.h
//  WyjDemo
//
//  Created by Alex on 16/2/24.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePwdViewController : UIViewController
<
    UIAlertViewDelegate
>
{

}

@property (weak, nonatomic) IBOutlet UITextField *txtOPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtNPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirm;

-(NSString*)sErrorMsg;

@end
