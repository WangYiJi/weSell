//
//  ResetPwdViewController.h
//  WyjDemo
//
//  Created by wyj on 16/1/22.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPwdViewController : UIViewController
<
    UIAlertViewDelegate
>
{

}
@property (nonatomic,strong) IBOutlet UITextField *txtEmail;

-(void)didPressedDone;
-(void)resetPwd;
@end
