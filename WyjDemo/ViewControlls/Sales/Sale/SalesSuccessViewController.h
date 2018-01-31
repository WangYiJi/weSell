//
//  SalesSuccessViewController.h
//  WyjDemo
//
//  Created by Jabir on 16/2/16.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@protocol SaleSuccessDelegate <NSObject>

-(void)resetBefore:(BOOL)bBackHome;//是否回到首页（tab＝0）

@end

@interface SalesSuccessViewController : UIViewController
<
TTTAttributedLabelDelegate,
UIActionSheetDelegate
>

@property (strong, nonatomic) IBOutlet TTTAttributedLabel *lblContent;
@property (nonatomic) id<SaleSuccessDelegate> delegate;
@property (strong,nonatomic) UIViewController *viewController;
@property (strong,nonatomic) NSString *sTitle;

+(SalesSuccessViewController *)shareManageWithFrame:(CGRect)frame;
- (IBAction)didPressedClose:(id)sender;
- (IBAction)didPressedToMyAdv:(id)sender;
- (IBAction)didPressedShare:(id)sender;


@end
