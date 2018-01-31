//
//  SellerInfoCell.m
//  WyjDemo
//
//  Created by zjb on 16/3/8.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "SellerInfoCell.h"
#import "Utils.h"
#import "Global.h"
#import "CreateFavoriteSeller.h"
#import "NetworkEngine.h"
@implementation SellerInfoCell
- (void)awakeFromNib {
    // Initialization code
    //给按钮加边框
    [self reSetButtonYellowBorder:_btnAttention];
    [self reSetButtonGrayBorder:_btnAbuse];
    [self reSetButtonGrayBorder:_btnContact];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SellerInfoCell" owner:self options:nil];
        
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

//- (void)setPostQueryResult:(SellPostQueryResult *)postQueryResult{
//    [_imgHeader setImageWithURL:[NSURL URLWithString:postQueryResult.userAvatarSmallUrl] placeholderImage:[UIImage imageNamed:@"default"]];
//    _lblName.text = postQueryResult.userDiapName;
//    _lblLocation.text = postQueryResult.address.streetLine1;
//    _lblTime.text = [Utils DateStringFromDateSp:postQueryResult.createdAt];
//    self.postQueryResult = postQueryResult;
//    
//}

- (void)loadPostInfo:(SellPostQueryResult *)post superview:(UIView *)superview{
    [_imgHeader sd_setImageWithURL:[NSURL URLWithString:post.userAvatarSmallUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    _lblName.text = post.userDiapName;
    _lblLocation.text = post.address.streetLine1;
    _lblTime.text = [Utils DateStringFromDateSp:post.createdAt];
    self.postQueryResult = post;
    self.superview = superview;
}

- (IBAction)didPressedAttention:(id)sender {
    [self reSetButtonYellowBorder:_btnAttention];
    [self reSetButtonGrayBorder:_btnAbuse];
    [self reSetButtonGrayBorder:_btnContact];
    
    [NetworkEngine showMbDialog:self.superview title:@"请稍后"];
    
//    if (!bFavorite) {
        CreateFavoriteSeller *createFavoriteEntity = [[CreateFavoriteSeller alloc] init];
        createFavoriteEntity.sellUserId = self.postQueryResult.userId;
        createFavoriteEntity.status = @"INTERESTED";
        
        [NetworkEngine postRequestEntity:createFavoriteEntity contentType:@"application/x-www-form-urlencoded" success:^(id json) {
            [NetworkEngine hiddenDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"收藏成功"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [_btnAttention setImage:[UIImage imageNamed:@"favSel"] forState:UIControlStateNormal];
//            bFavorite = !bFavorite;
        } fail:^(NSError *error) {
            [NetworkEngine hiddenDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"收藏失败"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
//    }else {
//        //取消收藏
//        DeleteFavoritePost *request = [[DeleteFavoritePost alloc] init];
//        request.favId = sFavId;
//        [NetworkEngine deleteRequest:request success:^(id json) {
//            [NetworkEngine hiddenDialog];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"取消收藏成功"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            bFavorite = !bFavorite;
//        } fail:^(NSError *error) {
//            [NetworkEngine hiddenDialog];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"取消收藏失败"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }];
//    }
}

- (IBAction)didPressedAbuse:(id)sender {
    [self reSetButtonYellowBorder:_btnAbuse];
    [self reSetButtonGrayBorder:_btnAttention];
    [self reSetButtonGrayBorder:_btnContact];
    if ([self.delegate respondsToSelector:@selector(sellerInfoAbuse:)]) {
        [self.delegate sellerInfoAbuse:self.postQueryResult.postId];
    }
}

- (IBAction)didPressedContact:(id)sender {
    [self reSetButtonYellowBorder:_btnContact];
    [self reSetButtonGrayBorder:_btnAttention];
    [self reSetButtonGrayBorder:_btnAbuse];
    //联系卖家
    if ([self.delegate respondsToSelector:@selector(sellerInfoContact:)]) {
        [self.delegate sellerInfoContact:self.postQueryResult];
    }
}

- (void)reSetButtonYellowBorder:(UIButton *)btn{
    CALayer *ButtonLayer = [btn layer];
    [ButtonLayer setMasksToBounds:YES];
    [ButtonLayer setCornerRadius:2.0];
    [ButtonLayer setBorderWidth:1.0];
    [ButtonLayer setBorderColor:[RGBA(255, 218, 68, 1) CGColor]];
    [btn setBackgroundColor:RGBA(255, 218, 68, 1)];
}

- (void)reSetButtonGrayBorder:(UIButton *)btn{
    CALayer *ButtonLayer = [btn layer];
    [ButtonLayer setMasksToBounds:YES];
    [ButtonLayer setCornerRadius:2.0];
    [ButtonLayer setBorderWidth:1.0];
    [ButtonLayer setBorderColor:[[UIColor grayColor] CGColor]];
    [btn setBackgroundColor:[UIColor clearColor]];
}
@end
