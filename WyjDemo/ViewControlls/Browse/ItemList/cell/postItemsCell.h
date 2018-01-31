//
//  postItemsCell.h
//  WyjDemo
//
//  Created by 霍霍 on 15/12/13.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseSellPostQuery.h"
#import "UIImageView+WebCache.h"

@interface postItemsCell : UICollectionViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *imgItem;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPeopleNumber;
@property (strong, nonatomic) IBOutlet UIImageView *imgvLogo;
@property (nonatomic,strong) IBOutlet UIView *soldView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvTag;

@property (nonatomic,strong) SellPostQueryResult *sellPostQueryResult;

- (void)showImgvTag:(NSString *)sStatus;
@end
