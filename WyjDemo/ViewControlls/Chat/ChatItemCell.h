//
//  ChatItemCell.h
//  WyjDemo
//
//  Created by wyj on 15/12/30.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatHistoryEntity.h"

@interface ChatItemCell : UITableViewCell

@property (nonatomic,strong) UILabel *txtMsg;
@property (nonatomic,strong) UIImageView *imgChatHead;
@property (nonatomic,strong) UIImageView *imgBg;
@property (nonatomic,strong) UIImageView *imgPic;



@property (nonatomic,strong) ChatHistoryEntity *historyItem;



-(void)updateImageView:(CGSize)size isSelf:(BOOL)bIsSelf;
@end
