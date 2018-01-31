//
//  AbuseViewController.h
//  WyjDemo
//
//  Created by 霍霍 on 16/2/5.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextView.h"

@interface AbuseViewController : UIViewController
<
    UIAlertViewDelegate,
    UITextViewDelegate
>
{

}
@property (strong, nonatomic) IBOutlet UITableView *abuseTableview;

@property (nonatomic,strong) NSString *postId;

@property (strong, nonatomic) IBOutlet UIToolbar *myToolbar;
@property (strong, nonatomic) IBOutlet CBTextView *tvMessage;
- (IBAction)DidPressedHideKeyboard:(id)sender;

- (IBAction)didPressedSubmitAbuse:(id)sender;
@end
