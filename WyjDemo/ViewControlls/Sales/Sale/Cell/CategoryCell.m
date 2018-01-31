//
//  CategoryCell.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/21.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell
@synthesize categoryInfo;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCategoryInfo:(CategoryInfo *)_categoryInfo{
    _lblCategoryName.text = _categoryInfo.displayName;
}
@end
