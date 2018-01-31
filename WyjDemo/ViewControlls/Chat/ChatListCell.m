//
//  ChatListCell.m
//  WyjDemo
//
//  Created by wyj on 15/10/25.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ChatListCell.h"
#import "PublicUserEntity.h"
#import "NetworkEngine.h"
#import "ResponseInlineModel.h"
#import "DBhelper.h"
#import "UIImageView+WebCache.h"


@interface ChatListCell () {
    BOOL bLoadUserInfo;
}
@end

@implementation ChatListCell
@synthesize contactEntity;

- (void)awakeFromNib {
    // Initialization code
    self.imgChatHead.clipsToBounds = YES;
    self.imgChatHead.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContactEntity:(ChatContactsEntity *)_contactEntity
{
    contactEntity = _contactEntity;
//    [self.imgChatHead setImageWithURL:[NSURL URLWithString:_contactEntity]]
    //基本信息赋值
    PublicUserEntity *entity = [[PublicUserEntity alloc] init];
    entity.userIds = contactEntity.userId;
    if (self.contactEntity.userName.length > 0) {
        self.lblFriendName.text = self.contactEntity.userName;
    }
    
    if (_contactEntity.lastMsg.length > 0) {
        self.lblChatMsg.text = self.contactEntity.lastMsg;
    }

    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:def_serverTimeDF];
 
    NSDate *d = [df dateFromString:self.contactEntity.lastTime];
    [df setDateFormat:@"HH:mm"];
    self.lblChatTime.text = [df stringFromDate:d];
    
    if (_contactEntity.logoName.length <= 0) {
        self.imgChatHead.image = [UIImage imageNamed:@"default"];
    } else {
        self.imgChatHead.image = [UIImage imageNamed:@"default"];
        
        [self.imgChatHead sd_setImageWithURL:[NSURL URLWithString:_contactEntity.logoName]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       
                                   }];
    }
    

}

@end
