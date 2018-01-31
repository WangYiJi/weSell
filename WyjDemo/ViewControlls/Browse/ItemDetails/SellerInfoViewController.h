//
//  SellerInfoViewController.h
//  WyjDemo
//
//  Created by zjb on 16/3/3.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseByIds.h"
#import "SellerInfoCell.h"
@interface SellerInfoViewController : UIViewController
<
SellerInfoCellDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@property (nonatomic,strong) SellPostQueryResult *sellPostQueryResult; 
@end
