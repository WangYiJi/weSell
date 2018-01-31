//
//  EditTextViewController.h
//  WyjDemo
//
//  Created by wyj on 16/1/15.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface EditTextViewController : UIViewController
<
    UIAlertViewDelegate
>
{

}
@property (weak, nonatomic) IBOutlet UITextField *txt;
@property (nonatomic,copy) NSString *sMsg;
@property (nonatomic,assign) UserInfoTypeed infoType;

@end
