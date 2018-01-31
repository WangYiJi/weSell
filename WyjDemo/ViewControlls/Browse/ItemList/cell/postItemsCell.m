//
//  postItemsCell.m
//  WyjDemo
//
//  Created by 霍霍 on 15/12/13.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "postItemsCell.h"
#import "Global.h"
#import "Utils.h"

@implementation postItemsCell
@synthesize sellPostQueryResult;
- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"postItemsCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)setSellPostQueryResult:(SellPostQueryResult *)_sellPostQueryResult{
    _imgvTag.hidden = YES;
    _lblName.text = _sellPostQueryResult.title;
    _lblPrice.text = [NSString stringWithFormat:@"%@%.2f",_sellPostQueryResult.price.currencySymbol,[_sellPostQueryResult.price.value floatValue]];
    _lblPeopleNumber.text = [NSString stringWithFormat:@"%ld",[_sellPostQueryResult.favoriteCnt integerValue]];

    if (![Utils isBlankString:_sellPostQueryResult.thumbnailPhoto.smallImageUrl]) {
        [_imgvLogo sd_setImageWithURL:[NSURL URLWithString:_sellPostQueryResult.thumbnailPhoto.smallImageUrl] placeholderImage:nil];
    }else if (![Utils isBlankString:_sellPostQueryResult.thumbnailPhoto.imageUrl]) {
        [_imgvLogo sd_setImageWithURL:[NSURL URLWithString:_sellPostQueryResult.thumbnailPhoto.imageUrl] placeholderImage:nil];
    }else {
        _imgvLogo.image = nil;
    }
    
    if ([_sellPostQueryResult.status isEqualToString:@"SOLD"]) {
        _soldView.hidden = NO;
    }else{
        _soldView.hidden = YES;
    }
  
}

- (void)showImgvTag:(NSString *)sStatus{
    if ([sStatus isEqualToString:@"SOLD"]) {
        _soldView.hidden = YES;
        _imgvTag.hidden = NO;
        _imgvTag.image = [UIImage imageNamed:@"chushou1"];
    }else if ([sStatus isEqualToString:@"UNLISTED"]) {
        _soldView.hidden = YES;
        _imgvTag.hidden = NO;
        _imgvTag.image = [UIImage imageNamed:@"xiajia"];
    }else {
        _imgvTag.hidden = YES;
    }
}
@end
