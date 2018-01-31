//
//  ChatListCell.h
//  WyjDemo
//
//  Created by wyj on 15/10/25.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatContactsEntity.h"

@interface ChatListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgChatHead;
@property (weak, nonatomic) IBOutlet UILabel *lblFriendName;
@property (weak, nonatomic) IBOutlet UILabel *lblChatMsg;
@property (weak, nonatomic) IBOutlet UILabel *lblChatTime;
@property (nonatomic,strong) ChatContactsEntity *contactEntity;

@end
