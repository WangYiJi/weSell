//
//  ChatRecordViewController.m
//  WyjDemo
//
//  Created by wyj on 15/11/16.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ChatRecordViewController.h"
#import "PublicUI.h"
#import "UITableView+CustomCell.h"
#import "ChatTools.h"
#import "UserMember.h"
#import "DBhelper.h"
#import "Global.h"
#import "ChatItemCell.h"
#import "NetworkEngine.h"
#import "FileUploadEntity.h"
#import "ResponseFileUpload.h"
#import "UIImageView+WebCache.h"
#import "PhotoCheckViewController.h"
#import "ItemViewController.h"
#import "UIImage+LK.h"
#import "UserInfoEntity.h"
#import "DBhelper.h"

#define keyBoardHeight 253

@interface ChatRecordViewController ()
{
    BOOL bScrollerIng;
    BOOL bShowPhoto;
}

@end

@implementation ChatRecordViewController
@synthesize contactsEntity;
@synthesize historys;
@synthesize bBuyNow;
@synthesize sBuyNowMsg;
@synthesize sBuyNowUserId;
@synthesize sPostId;
@synthesize sImg;
@synthesize sPostName;
@synthesize sPrice;

#pragma mark - System Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setIPHeight:0];
    
    
    if (self.bBuyNow) {
        [self loadBuyNow];
    } else {
        if (self.sBuyNowUserId.length > 0) {
            NSMutableArray *contacts = [ChatContactsEntity getContactsByUserId:self.sBuyNowUserId];
            if (contacts.count <= 0) {
                self.contactsEntity = [ChatContactsEntity insertContactsByUserId:self.sBuyNowUserId];
            } else {
                self.contactsEntity = [contacts objectAtIndex:0];
            }
        }
    }
    self.historys = [ChatContactsEntity getHistorySortByTime:self.contactsEntity.historyShip];
    for (ChatHistoryEntity *chat in self.historys) {
        NSLog(@"%@ %@",chat.msg,chat.sendTime);
    }
    
    if (self.contactsEntity.userName.length <= 0) {
        UserInfoEntity *userInfo = [[UserInfoEntity alloc]init];
        
        __weak typeof(self) weakSelf = self;
        [NetworkEngine getJSONWithUrl:userInfo success:^(id json) {
            BaseUserInfo *info = [[BaseUserInfo alloc] initWithDic:json];
            weakSelf.contactsEntity.logoName = info.avatarUrl;
            weakSelf.contactsEntity.userName = info.displayName;
            [DBhelper Save];
        } fail:^(NSError *error) {
            
        }];
    } else {
        self.title = self.contactsEntity.userName;
    }
    
    UIBarButtonItem *bar = [PublicUI getBackButtonandMethod:@selector(didPressedBack) addtarget:self];
    self.navigationItem.leftBarButtonItem = bar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChatRecordList:) name:def_postChatHistory object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChatRecordList:) name:def_postChatMsg object:nil];
}

-(void)loadBuyNow
{
    
    [_imagePic sd_setImageWithURL:[NSURL URLWithString:self.sImg]];
    _lblPrice.text = self.sPrice;
    _lblTitle.text = self.sPostName;
    
    NSMutableArray *contacts = [ChatContactsEntity getContactsByUserId:self.sBuyNowUserId];
    if (contacts.count <= 0) {
        self.contactsEntity = [ChatContactsEntity insertContactsByUserId:self.sBuyNowUserId];
    } else {
        self.contactsEntity = [contacts objectAtIndex:0];
    }
    ChatHistoryEntity *historyItem = [ChatTools sendMessage:self.sBuyNowMsg toUserId:self.sBuyNowUserId contacts:self.contactsEntity isImg:NO];
    NSLog(@"buy now %@",historyItem);
    [_tableview setTableHeaderView:_infoHeadView];
}

-(void)didPressedBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Server  Action
//接收到服务端来的消息
-(void)reloadChatRecordList:(NSNotification*)hItem
{
    NSLog(@"notification ChatRecordReload");
    ChatHistoryEntity *item = [hItem object];
    
    if (item && [item isKindOfClass:[ChatHistoryEntity class]]) {
        [self addCellWithAnimation:item fromSelf:NO];
    }
    //[self.tableview reloadData];
    [self scrollerToButtom:NO];
}


#pragma mark - Chat List View  Action
//会话增加一行
-(void)addCellWithAnimation:(ChatHistoryEntity*)his fromSelf:(BOOL)bFromSelf
{
    [self.historys addObject:his];
    [self.tableview beginUpdates];
    [self.tableview insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.historys.count-1 inSection:0]]
                          withRowAnimation:bFromSelf?UITableViewRowAnimationRight:UITableViewRowAnimationLeft];
    [self.tableview endUpdates];
    
}

//列表滑动至底部
-(void)scrollerToButtom:(BOOL)bAnimated
{
    [self disableScrollerHiddenKeyBoard];
    __weak typeof(self) weakSelf = self;
    if (historys.count > 0) {
        dispatch_async(dispatch_get_main_queue(),^{
            [weakSelf.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:historys.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:bAnimated];
        });
    }
}

//标记Scroller正在滑动
-(void)disableScrollerHiddenKeyBoard
{
    bScrollerIng = YES;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        bScrollerIng = NO;
    });
}

//抬高TextField
-(void)setIPHeight:(CGFloat)fHeight
{
    self.iPhotoHeight.constant = fHeight;
    [UIView animateWithDuration:0.3 animations:^{
        //[self.view layoutIfNeeded];
    }];
    
    if (fHeight == 0) {
        [self.txtSendMsg resignFirstResponder];
    }
}

#pragma mark - Text Send Action
//发送文字
-(void)sendText
{
    if (self.txtSendMsg.text.length > 0) {
        
        ChatHistoryEntity *entity = [ChatTools sendMessage:self.txtSendMsg.text toUserId:self.contactsEntity.userId contacts:contactsEntity isImg:NO];

        if (entity) {
            [self addCellWithAnimation:entity fromSelf:YES];
            [self scrollerToButtom:YES];
            self.txtSendMsg.text = @"";
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"连接中断"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

#pragma mark - Image Send Action
//点开图片Sheet
- (IBAction)didPressedRight:(id)sender
{
    [self setIPHeight:0];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"发送图片"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"选择相册",@"拍照",nil];
    sheet.tag = 777;
    [sheet showInView:self.view];
}

-(IBAction)didPressedPostInfo:(id)sender
{
    ItemViewController *vc = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    vc.sPostId = self.sPostId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//ActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 777) {
        if (buttonIndex == 0) {
            [self localPhoto];
        }
        else if (buttonIndex == 1) {
            [self takePhoto];
        }
    }
}

//打开Camera
-(void)takePhoto
{
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

//打开Photo
-(void)localPhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//上传图片
-(void)uploadImage:(UIImage*)image
{
    NSString *sPath = [ChatTools saveToDocument:image];
    
    NSArray *array = [ChatTools sendImgMessage:sPath toUserId:self.contactsEntity.userId contacts:contactsEntity isImg:YES];
    
    ChatHistoryEntity *entity = array[0];
    [self addCellWithAnimation:entity fromSelf:YES];
    [self scrollerToButtom:YES];
    
    FileUploadEntity *fileUploadEntity = [[FileUploadEntity alloc] init];
    fileUploadEntity.userId = [UserMember getInstance].userId;
    fileUploadEntity.fileType = @"jpg";
    fileUploadEntity.from = @"chat";
    
    [NetworkEngine postLoginRequestEntity:fileUploadEntity success:^(id json) {
        ResponseFileUpload *responseFileUpload = [[ResponseFileUpload alloc] initwithJson:json];
        
        [NetworkEngine putUploadSomeImages:[NSMutableArray arrayWithObject:responseFileUpload]
                                imageArray:[NSMutableArray arrayWithObject:image]
                                   success:^(NSMutableArray *aUrl) {
                                       //获取到链接后发送。
                                       [ChatTools upDataMsgAndSend:[aUrl lastObject] structs:array[1]];
                                       NSLog(@"send Success %@",[aUrl lastObject]);
                                   } fail:^(NSError *error) {
                                       NSLog(@"fail");
                                   } progress:^(NSInteger i) {
                                       NSLog(@"正在上传第%ld张图片",i);
                                   }];
    } fail:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

//PicketView Choose
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imgChoose = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *imgFinal = [self fixOrientation:imgChoose];
        
        [self uploadImage:imgFinal];
    }];
}

//PicketView Cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sid = @"ChatItemCell";
    ChatHistoryEntity *item = [self.historys objectAtIndex:indexPath.row];
    
    ChatItemCell* cell = (ChatItemCell*)[tableView dequeueReusableCellWithIdentifier:sid];
    if (!cell) {
        cell = [[ChatItemCell alloc] init];
    }
    
    cell.historyItem = item;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatHistoryEntity *item = [self.historys objectAtIndex:indexPath.row];
    if ([item.isImg boolValue]) {
        PhotoCheckViewController *pVC = [[PhotoCheckViewController alloc] initWithNibName:@"PhotoCheckViewController" bundle:nil];
        pVC.historyItem = item;
        [self.navigationController pushViewController:pVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatHistoryEntity *item = [historys objectAtIndex:indexPath.row];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    if ([item.isImg boolValue]) {
//        UIImage *tempImage = item.msg;
//        CGSize size = [UIImage downloadImageSizeWithURL:[NSURL URLWithString:item.msg]];
//        return size.width > 0 ? size.height*100/(size.width)+40 : 170;
        return 170;
    } else {
        CGSize size = [item.msg boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40 - 15, 2000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return size.height + 56;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.txtSendMsg isFirstResponder] && !bScrollerIng) {
        [self setIPHeight:0];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField.text.length > 0) {
            [self sendText];
        }
    }
    return YES;
}

#pragma mark - 处理图片防止旋转90度
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//在遇到有输入的情况下。由于现在键盘的高度是动态变化的。中文输入与英文输入时高度不同。所以输入框的位置也要做出相应的变化
#pragma mark - keyboardHight
-(void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];

    [self scrollerToButtom:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
}

//键盘出来后
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [self setIPHeight:kbSize.height];
    [self scrollerToButtom:YES];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"height %f",kbSize.height);
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [_txtSendMsg becomeFirstResponder];
    [self setIPHeight:0];
}


//(TextView) 当键盘开始输入前。时行计算与动画加载
-(void)textViewDidBeginEditing:(UITextView *)textView
{
//    NSLog(@"gegin animation");
//    sendMsgTextView =textView;
//    resultCommunityTableview.frame = CGRectMake(0, 36, 320, 150);
//    //动画加载
//    [self begainMoveUpAnimation:0.0 ];
    
}

//输入结束时调用动画（把按键。背景。输入框都移下去）
-(void)textViewDidEndEditing:(UITextView *)textView
{
    //释放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


//判断当前输入法
-(void)textViewDidChangeSelection:(UITextView *)textView
{
//    NSLog(@"wewe:%@",[[UITextInputMode currentInputMode] primaryLanguage]);
    /*
     if ([[UITextInputMode currentInputMode] primaryLanguage] == @"en-US") {
     NSLog(@"en-US");
     }
     else
     {
     NSLog(@"zh-hans");
     }
     */
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:def_postChatHistory object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:def_postChatMsg object:nil];
}

@end
