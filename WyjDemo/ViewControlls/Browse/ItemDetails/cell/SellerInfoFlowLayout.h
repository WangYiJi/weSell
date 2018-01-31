//
//  SellerInfoFlowLayout.h
//  WyjDemo
//
//  Created by zjb on 16/3/8.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseSellPostQuery.h"
@interface SellerInfoFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,assign) NSInteger itemCount;//cell的个数
@property (nonatomic,strong)ResponseSellPostQuery *responseSellPostQuery;
@end
