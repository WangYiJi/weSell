//
//  ChatRecordViewController.h
//  WyjDemo
//
//  Created by wyj on 15/11/16.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTools.h"
#import "ChatContactsEntity.h"
#import "ChatHistoryEntity.h"

@interface ChatRecordViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
ChatToolsDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
UITextFieldDelegate
>
{
    
}
@property (nonatomic,strong) ChatContactsEntity *contactsEntity;
@property (nonatomic) BOOL bBuyNow;
@property (nonatomic,strong) NSString *sBuyNowMsg;
@property (nonatomic,strong) NSString *sBuyNowUserId;
@property (nonatomic,strong) NSString *sPostId;
@property (nonatomic,strong) NSString *sImg;
@property (nonatomic,strong) NSString *sPostName;
@property (nonatomic,strong) NSString *sPrice;

@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *viewButtom;
@property (weak, nonatomic) IBOutlet UIView *viewPhoto;
@property (weak, nonatomic) IBOutlet UITextField *txtSendMsg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iPhotoHeight;

@property (nonatomic, strong) IBOutlet UIView *infoHeadView;

@property (strong,nonatomic) NSMutableArray *historys;

//**************************************
//Server  Action
//接收到服务端来的消息
-(void)reloadChatRecordList:(NSNotification*)hItem;


//**************************************
//Chat List View  Action
//会话增加一行
-(void)addCellWithAnimation:(ChatHistoryEntity*)his fromSelf:(BOOL)bFromSelf;

//列表滑动至底部
-(void)scrollerToButtom:(BOOL)bAnimated;

//标记Scroller正在滑动
-(void)disableScrollerHiddenKeyBoard;

//抬高TextField
-(void)setIPHeight:(CGFloat)fHeight;

//**************************************
//Text Send Action
//发送文字
-(void)sendText;

-(void)loadBuyNow;


//**************************************
//Image Send Action
//点开图片Sheet
-(IBAction)didPressedRight:(id)sender;

//点击商品
-(IBAction)didPressedPostInfo:(id)sender;

//打开Camera
-(void)takePhoto;

//打开Photo
-(void)localPhoto;

//上传图片
-(void)uploadImage:(UIImage*)image;

- (UIImage *)fixOrientation:(UIImage *)aImage;



@end
