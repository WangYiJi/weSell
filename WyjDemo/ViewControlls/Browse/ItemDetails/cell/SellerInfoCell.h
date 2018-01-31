//
//  SellerInfoCell.h
//  WyjDemo
//
//  Created by zjb on 16/3/8.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseByIds.h"
#import "UIImageView+WebCache.h"

@protocol SellerInfoCellDelegate <NSObject>

- (void)sellerInfoAbuse:(NSString *)sPostId;
- (void)sellerInfoContact:(SellPostQueryResult *)postQueryResult;

@end

@interface SellerInfoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnAttention;
@property (strong, nonatomic) IBOutlet UIButton *btnAbuse;
@property (strong, nonatomic) IBOutlet UIButton *btnContact;
@property (weak,nonatomic) id<SellerInfoCellDelegate>delegate;

@property (nonatomic,strong) SellPostQueryResult *postQueryResult;
@property (nonatomic,strong) UIView *superview;
- (void)loadPostInfo:(SellPostQueryResult *)post superview:(UIView *)superview;
- (IBAction)didPressedAttention:(id)sender;
- (IBAction)didPressedAbuse:(id)sender;
- (IBAction)didPressedContact:(id)sender;
@end
