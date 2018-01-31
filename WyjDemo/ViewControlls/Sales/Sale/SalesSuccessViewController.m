//
//  SalesSuccessViewController.m
//  WyjDemo
//
//  Created by Jabir on 16/2/16.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "SalesSuccessViewController.h"
#import "Global.h"
#import "MyAdvertisementViewController.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
@interface SalesSuccessViewController ()

@end

@implementation SalesSuccessViewController
@synthesize delegate;
@synthesize sTitle;

+(SalesSuccessViewController *)shareManageWithFrame:(CGRect)frame{
    static dispatch_once_t onceToken;
    static SalesSuccessViewController *ssVC;
    dispatch_once(&onceToken, ^{
        ssVC = [[SalesSuccessViewController alloc] initWithNibName:@"SalesSuccessViewController" bundle:nil];
    });
    ssVC.view.frame = frame;
    return ssVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView{
    [self loadNotice];
}

//加载说明
- (void)loadNotice{
    NSString *sContent = [NSString stringWithFormat:@"恭喜您发布成功！如您还有二手闲置物品。您还可以再卖一个>"];

    //对齐方式
    _lblContent.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    _lblContent.delegate = self; // Delegate
    
    //NO 不显示下划线
    _lblContent.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    [_lblContent setText:sContent afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //设置可点击文字的范围
        NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"再卖一个>" options:NSCaseInsensitiveSearch];
        
        //设定可点击文字的的大小
        UIFont *boldSystemFont = [UIFont systemFontOfSize:13.5];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        
        if (font) {
            
            //设置可点击文本的大小
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
            
            //设置可点击文本的颜色
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor yellowColor] CGColor] range:boldRange];
            
            CFRelease(font);
            
        }
        return mutableAttributedString;
    }];
    //设置链接的url
    [_lblContent addLinkToURL:[NSURL URLWithString:@""] withRange:NSMakeRange(23, 5)];
}

-(IBAction)didPressedClose:(id)sender
{
    [self.delegate resetBefore:YES];
    [self didBack];
    
}

- (IBAction)didPressedToMyAdv:(id)sender {
    [self.delegate resetBefore:NO];
    MyAdvertisementViewController *vc = [[MyAdvertisementViewController alloc] initWithNibName:@"MyAdvertisementViewController" bundle:nil];
    vc.navigationItem.title = CustomLocalizedString(@"我的广告", nil);
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [self didBack];
}

- (IBAction)didPressedShare:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享给好友"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"短信",@"邮件",@"取消", nil];
    sheet.tag = 889;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 889) {
        if (actionSheet.tag == 889) {
            NSString *sFinal = [AppDelegateEntity.sShareTemplate stringByReplacingOccurrencesOfString:@"[%s]" withString:self.sTitle];
            if (buttonIndex == 0) {
                //调短信
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"]];
                if( [MFMessageComposeViewController canSendText] )
                {
                    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
                    //controller.recipients = phones;
                    //controller.navigationBar.tintColor = [UIColor redColor];
                    controller.body = sFinal;
                    controller.messageComposeDelegate = self;
                    [self presentViewController:controller animated:YES completion:nil];
                    //[[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"该设备不支持短信功能"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            else if (buttonIndex == 1) {
                //调邮件
                MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];     //创建邮件controller
                
                mailPicker.mailComposeDelegate = self;  //设置邮件代理
                
                [mailPicker setSubject:@""]; //邮件主题
                
                [mailPicker setMessageBody:sFinal isHTML:NO];
                
                [self presentViewController:mailPicker animated:YES completion:^{
                    
                }];
                
                
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:"]];
            }
        }
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result

                        error:(NSError*)error

{
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark - TTAttributedLabel delegate
- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    [self.delegate resetBefore:NO];
    [self didBack];
}

- (void)didBack{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
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

@end
