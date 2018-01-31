//
//  ChatItemCell.m
//  WyjDemo
//
//  Created by wyj on 15/12/30.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ChatItemCell.h"
#import "UserMember.h"
#import "Masonry.h"
#import "Global.h"
#import "UIImageView+WebCache.h"
#import "ChatTools.h"
#import "UIImage+LK.h"
#import "ChatContactsEntity.h"

@implementation ChatItemCell
@synthesize historyItem;

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.txtMsg = [[UILabel alloc] init];
        self.imgBg = [[UIImageView alloc] init];
        self.imgChatHead = [[UIImageView alloc] init];
        self.txtMsg.numberOfLines = 0;
        self.txtMsg.font = [UIFont systemFontOfSize:17];
        self.txtMsg.textAlignment = NSTextAlignmentCenter;
        
        self.imgPic = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_imgBg];
        [self.contentView addSubview:_imgChatHead];
        [self.contentView addSubview:_txtMsg];
        [self.contentView addSubview:_imgPic];
        
        _imgBg.hidden = YES;
        _imgChatHead.hidden = YES;
        _txtMsg.hidden = YES;
        _imgPic.hidden = YES;
        
        _imgChatHead.image = [UIImage imageNamed:@"1"];
        
        self.imgChatHead.clipsToBounds = YES;
        self.imgChatHead.layer.cornerRadius = 20;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHistoryItem:(ChatHistoryEntity *)_historyItem
{
    BOOL bIsSelf = NO;
    if ([_historyItem.userFromId isEqualToString:[UserMember getInstance].userId]) {
        bIsSelf = YES;
    } else {
        bIsSelf = NO;
    }

    float fWidth = SCREEN_WIDTH - 40 - 15;//指定的背景的最大高度
    float txtheight = 0;//消息的高度
    
    if ([_historyItem.isImg boolValue]) {
        fWidth = 100;
        txtheight = 130;
        if ([_historyItem.isLocal boolValue]) {
            NSString *sPath = [NSString stringWithFormat:@"%@/%@", [ChatTools getInstance].sImageFilePath,_historyItem.msg];
            if ([[NSFileManager defaultManager] fileExistsAtPath:sPath]) {
                UIImage *img = [UIImage imageWithContentsOfFile:sPath];
//                txtheight = img.size.height*100/(img.size.width);
                _imgPic.image = img;
            }
        } else {
            //计算图片等比例放小
//            CGSize size = [UIImage downloadImageSizeWithURL:[NSURL URLWithString:_historyItem.msg]];
//            txtheight = size.width > 0 ? size.height*100/(size.width) : 130;
            _imgPic.image = [UIImage imageNamed:@"default"];
            [_imgPic sd_setImageWithURL:[NSURL URLWithString:_historyItem.msg]];
        }
        
        [_imgPic mas_makeConstraints:^(MASConstraintMaker *make) {
            if (bIsSelf) {
                make.right.equalTo(_imgBg.mas_right).with.offset(-13);
            }
            else {
                make.left.equalTo(_imgBg.mas_left).with.offset(13);
            }
            
            make.height.mas_equalTo(txtheight);
            make.width.mas_equalTo(fWidth);
            
            make.centerY.mas_equalTo(_imgBg.mas_centerY);
        }];
        _imgPic.hidden = NO;
    } else {
        //文字消息
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
        CGSize size;
        if (_historyItem.msg.length > 0) {
            size = [_historyItem.msg boundingRectWithSize:CGSizeMake(fWidth-12-5-15, 2000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            if ((size.width + 5 + 12 + 1) < fWidth) {
                fWidth = size.width + 5 + 12 + 1;
            }//消息文本和背景之间两边的距离,一边5一边12
            txtheight = size.height;
        }else {
            fWidth = 10+12+5+1;//无信息的时候给个10
        }
        _txtMsg.text = _historyItem.msg;
        _txtMsg.textColor = bIsSelf?[UIColor whiteColor]:[UIColor grayColor];
        
        [_txtMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_imgBg.mas_right).with.offset(bIsSelf?-12:-5);
            make.left.equalTo(_imgBg.mas_left).with.offset(bIsSelf?5:12);
            make.centerY.mas_equalTo(_imgBg.mas_centerY);
        }];
            _txtMsg.hidden = NO;
    }
    
    UIImage *img = bIsSelf?[UIImage imageNamed:@"green"]:[UIImage imageNamed:@"bai"];
    UIEdgeInsets inserts = UIEdgeInsetsMake(30, 30, 30, 20);
    _imgBg.image = [img resizableImageWithCapInsets:inserts resizingMode:UIImageResizingModeStretch];
    
    
    [_imgChatHead mas_makeConstraints:^(MASConstraintMaker *make) {
        if (bIsSelf) {
            make.right.equalTo(self.mas_right).with.offset(-15);
        } else {
            make.left.equalTo(self.mas_left).with.offset(15);
        }
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@40);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
    }];
    
    
    [_imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        if (bIsSelf) {
            make.right.equalTo(_imgChatHead.mas_left).with.offset(0);
        } else {
            make.left.equalTo(_imgChatHead.mas_right).with.offset(0);
        }

        make.width.mas_equalTo(fWidth+([_historyItem.isImg boolValue]?20:10));
        float f = fWidth+([_historyItem.isImg boolValue]?20:10);
        //NSLog(@"fff:%f",f);
        
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        if (_historyItem.msg.length <= 0) {
            //无文字
            make.height.mas_equalTo(45);
        }else if ([_historyItem.isImg boolValue]){
            make.height.mas_equalTo(txtheight+20);
        }else {
            make.height.mas_equalTo(txtheight+30);
        }
    }];

    _imgBg.hidden = NO;
    _imgChatHead.hidden = NO;
    
    if ([_historyItem.userFromId isEqualToString:[UserMember getInstance].userId]) {
        if ([UserMember getInstance].baseUserInfo.avatarSmallUrl.length <= 0) {
            _imgChatHead.image = [UIImage imageNamed:@"default"];
        } else {
            _imgChatHead.image = [UIImage imageNamed:@"default"];
            [_imgChatHead sd_setImageWithURL:[NSURL URLWithString:[UserMember getInstance].baseUserInfo.avatarSmallUrl]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       
                                   }];
        }
    } else {
        ChatContactsEntity *con = _historyItem.contactsShip;
        if (con.logoName.length <= 0) {
            _imgChatHead.image = [UIImage imageNamed:@"default"];
        } else {
            _imgChatHead.image = [UIImage imageNamed:@"default"];
            
            [_imgChatHead sd_setImageWithURL:[NSURL URLWithString:con.logoName]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       
                                   }];
        }
    }

    historyItem = _historyItem;
}

-(void)updateImageView:(CGSize)size isSelf:(BOOL)bIsSelf
{
    if (size.width > 120) {
        float fX = 120 / size.width;
        size = CGSizeMake(120, size.height*fX);
    }
    
    
    [_imgPic mas_makeConstraints:^(MASConstraintMaker *make) {
        if (bIsSelf) {
            make.right.equalTo(_imgBg.mas_right).with.offset(-12);
        }
        else {
            make.left.equalTo(_imgBg.mas_left).with.offset(12);
        }
        
        make.height.mas_equalTo(size.height);
        make.width.mas_equalTo(size.width);
        
        make.centerY.mas_equalTo(_imgBg.mas_centerY);
    }];
    _imgPic.hidden = NO;
    
}

@end
