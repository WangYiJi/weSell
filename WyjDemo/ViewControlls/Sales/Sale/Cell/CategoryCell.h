//
//  CategoryCell.h
//  WyjDemo
//
//  Created by 霍霍 on 15/12/21.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseCategory.h"

@interface CategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSelect;

@property (nonatomic,strong)CategoryInfo *categoryInfo;
@end
