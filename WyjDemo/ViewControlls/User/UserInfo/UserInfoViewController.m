//
//  UserInfoViewController.m
//  WyjDemo
//
//  Created by 霍霍 on 15/11/8.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UITableView+CustomCell.h"
#import "UserInfoCell.h"
#import "NetworkEngine.h"
#import "UserInfoEntity.h"
#import "UserMember.h"
#import "ResponseUserAccount.h"
#import "PublicUI.h"
#import "LoginOutEntity.h"
#import "EditTextViewController.h"
#import "ChatTools.h"
#import "FileUploadEntity.h"
#import "ResponseFileUpload.h"
#import "UploadUserInfoEntity.h"
#import "UIImageView+WebCache.h"
#import "ChangePwdViewController.h"
#import "ConfirmationEmailEntity.h"

@interface UserInfoViewController ()
{
    NSArray *arrayTitle;
    NSArray *arrayContent;
}
@property (nonatomic,strong) ResponseUserAccount *responseUserAccount;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(didPressedBack) addtarget:self];
    
    [self refreshUserInfo];
}

-(void)didPressedBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    [_mainTableview reloadData];
}

-(void)refreshUserInfo
{
    UserInfoEntity *userInfo = [[UserInfoEntity alloc]init];
    
    __weak typeof(self) weakSelf = self;
    [NetworkEngine getJSONWithUrl:userInfo success:^(id json) {
        BaseUserInfo *info = [[BaseUserInfo alloc] initWithDic:json];
        [UserMember getInstance].baseUserInfo = info;
        
        [weakSelf loadData];
    } fail:^(NSError *error) {
        
    }];
}

- (void)loadData{
    
    arrayTitle = [[NSArray alloc] initWithObjects:@"昵称",@"邮箱",@"邮箱验证",@"密码", nil];
    arrayContent = [[NSArray alloc] initWithObjects:@"",@"",@"",@"", nil];
    NSString *sStatus = @"未验证";
    if ([[UserMember getInstance].baseUserInfo.status isEqualToString:@"ACTIVE"]) {
        sStatus = @"已验证";
    }
    arrayContent = [[NSArray alloc] initWithObjects:[UserMember getInstance].baseUserInfo.displayName,
                    [UserMember getInstance].baseUserInfo.email,sStatus,@"******", nil];
    if ([UserMember getInstance].isLogin) {
        if ([UserMember getInstance].baseUserInfo.avatarUrl.length > 0) {
            [_imgvHeader sd_setImageWithURL:[NSURL URLWithString:[UserMember getInstance].baseUserInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"default"]];
        } else {
            _imgvHeader.image = [UIImage imageNamed:@"default"];
        }
    } else {
        _imgvHeader.image = nil;
    }
}

- (void)createView{
    self.navigationItem.title = CustomLocalizedString(@"个人信息", nil);
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(back) addtarget:self];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }else {
        return 44;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return _cellHeader;
    }else {
        NSString *cellIdentify = @"UserInfoCell";
        UserInfoCell* cell = (UserInfoCell *)[tableView customdq:cellIdentify];
        
        cell.lblTitle.text = [arrayTitle objectAtIndex:(indexPath.row - 1)];
        cell.lblContent.text = [arrayContent objectAtIndex:(indexPath.row - 1)];
        if (indexPath.row == 3) {
            cell.lblContent.textColor = RGBA(246, 14, 37, 1);
        }
        if (indexPath.row == 2 || indexPath.row == 3) {
            cell.imgArrow.hidden = YES;
        } else {
            cell.imgArrow.hidden = NO;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍照",@"选取相册", nil];
        sheet.tag = 777;
        [sheet showInView:self.view];
    } else {
        
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
            {
                EditTextViewController *vc = [[EditTextViewController alloc] initWithNibName:@"EditTextViewController" bundle:nil];
                //昵称
                vc.infoType = DisplayNameType;
                vc.sMsg = [UserMember getInstance].baseUserInfo.displayName;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
                //邮箱
                break;
            case 3:
                //邮箱验证
                if (![[UserMember getInstance].baseUserInfo.status isEqualToString:@"ACTIVE"]) {
                    [self confirmEmail];
                }
                
                break;
            case 4:
                //密码
            {
                ChangePwdViewController *vc = [[ChangePwdViewController alloc] initWithNibName:@"ChangePwdViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }

    }
}

- (void)confirmEmail{
    [NetworkEngine showMbDialog:self.view title:@"请稍等"];
    ConfirmationEmailEntity *entity = [[ConfirmationEmailEntity alloc] init];
    entity.authType = @"EMAILPASSWD";
    [NetworkEngine putPasswordWithEntity:entity success:^(id json) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件已发出，请进入邮箱验证"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [NetworkEngine hiddenDialog];
    } fail:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取邮件失败"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [NetworkEngine hiddenDialog];
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 777) {
        if (buttonIndex == 0) {
            //拍照
            [self takePhoto];
        }
        else if (buttonIndex == 1) {
            //相册
            [self LocalPhoto];
        }
    }
}

//开始拍照
-(void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//PicketView Choose
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imgChoose = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self createUploadUrl:imgChoose];
    }];
}

//上传图片
-(void)createUploadUrl:(UIImage*)image
{
    [NetworkEngine showMbDialog:self.view title:@"正在上传"];
    //NSString *sPath = [ChatTools saveToDocument:image];
    

    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
    [imageArray addObject:image];
    NSData *smallImage = UIImageJPEGRepresentation(image, 0.5);
    [imageArray addObject:[UIImage imageWithData:smallImage]];
    
    for (int i = 0;i < 2;i++) {
        FileUploadEntity *fileUploadEntity = [[FileUploadEntity alloc] init];
        fileUploadEntity.userId = [UserMember getInstance].userId;
        fileUploadEntity.fileType = @"jpg";
        fileUploadEntity.from = @"post";
        
        [NetworkEngine postLoginRequestEntity:fileUploadEntity success:^(id json) {
            ResponseFileUpload *responseFileUpload = [[ResponseFileUpload alloc] initwithJson:json];
            [responseArray addObject:responseFileUpload];
            
            [self uploadImage:imageArray urls:responseArray];
        } fail:^(NSError *error) {
            NSLog(@"error:%@",error);
        }];
    }
}

-(void)uploadImage:(NSMutableArray*)imageArray urls:(NSMutableArray*)urlArray
{
    if (urlArray.count == 2) {
        [NetworkEngine putUploadSomeImages:urlArray
                                imageArray:imageArray
                                   success:^(NSMutableArray *aUrl) {
                                       //获取到链接后更新用户信息。
                                       [self updataUserInfo:[aUrl objectAtIndex:0] smallImg:[aUrl objectAtIndex:1]];
                                       _imgvHeader.image = [imageArray objectAtIndex:0];
                                       [NetworkEngine hiddenDialog];
                                       NSLog(@"send Success %@",[aUrl lastObject]);
                                   } fail:^(NSError *error) {
                                       NSLog(@"fail");
                                       [NetworkEngine hiddenDialog];
                                   } progress:^(NSInteger i) {
                                       NSLog(@"正在上传第%ld张图片",i);
                                   }];
    }
}

-(void)updataUserInfo:(NSString*)sURL smallImg:(NSString*)sSmallImg
{
    UploadUserInfoEntity *entity = [[UploadUserInfoEntity alloc] init];
    entity.avatarUrl = sURL;
    entity.avatarLargeUrl = sURL;
    entity.avatarSmallUrl = sSmallImg;
    [NetworkEngine putUserInfoWithEntity:entity success:^(id json) {
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didPressedQuit:(id)sender {
    [NetworkEngine showMbDialog:self.view title:@"请稍等"];
    LoginOutEntity *loginOutEntity = [[LoginOutEntity alloc] init];
    [NetworkEngine postRequestEntity:loginOutEntity contentType:
     @"application/json" success:^(id json) {
        [NetworkEngine hiddenDialog];
        [UserMember getInstance].isLogin = NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserPWD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];

        [[ChatTools getInstance].contactsArray removeAllObjects];
         
         if ([ChatTools getInstance]._webSocket) {
             [[ChatTools getInstance]._webSocket close];
         }
         
         [ChatTools getInstance]._webSocket = nil;
         
         
    } fail:^(NSError *error) {
        [NetworkEngine hiddenDialog];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"登出失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
    
}
@end
