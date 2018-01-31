//
//  UserInfoViewController.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/8.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController
<
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *mainTableview;
//头像cell
@property (strong, nonatomic) IBOutlet UITableViewCell *cellHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgvHeader;

- (IBAction)didPressedQuit:(id)sender;

-(void)takePhoto;
-(void)LocalPhoto;
-(void)createUploadUrl:(UIImage*)image;
-(void)updataUserInfo:(NSString*)sURL smallImg:(NSString*)sSmallImg;

@end
