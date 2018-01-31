//
//  UserInfoCell.h
//  WyjDemo
//
//  Created by 霍霍 on 15/11/8.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;

@end
