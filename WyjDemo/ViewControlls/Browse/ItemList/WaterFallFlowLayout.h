//
//  WaterFallFlowLayout.h
//  TestUI
//
//  Created by 霍霍 on 15/12/13.
//  Copyright © 2015年 Jabir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseSellPostQuery.h"

@interface WaterFallFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,assign) NSInteger itemCount;//cell的个数
@property (nonatomic,strong)ResponseSellPostQuery *responseSellPostQuery;
@end
