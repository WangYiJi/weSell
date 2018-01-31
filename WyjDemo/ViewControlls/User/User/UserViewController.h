//
//  UsersViewController.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/17.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController
<
    UIActionSheetDelegate
>
{

}
@property (weak, nonatomic) IBOutlet UITableView *mainTableview;
//头部view
@property (strong, nonatomic) IBOutlet UIView *HeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgvEmail;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellMyAdv;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellHelpCenter;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellInviteFriend;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellAboutAPP;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellLanguage;

@property (weak, nonatomic) IBOutlet UILabel *lblMyAdv;
@property (weak, nonatomic) IBOutlet UILabel *lblHelpCenten;
@property (weak, nonatomic) IBOutlet UILabel *lblAddFriend;
@property (weak, nonatomic) IBOutlet UILabel *lblAbount;
@property (weak, nonatomic) IBOutlet UILabel *lblLaunage;

- (IBAction)didPressLogin:(id)sender;

@end
