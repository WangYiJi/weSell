//
//  UIImage+LK.h
//  SeeYouV2
//
//  Created by upin on 13-7-2.
//  Copyright (c) 2013年 灵感方舟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UIImageGrayLevelTypeHalfGray    = 0,
    UIImageGrayLevelTypeGrayLevel   = 1,
    UIImageGrayLevelTypeDarkBrown   = 2,
    UIImageGrayLevelTypeInverse     = 3
} UIImageGrayLevelType;

@interface UIImage (LK)

// 图片处理 0 半灰色  1 灰度   2 深棕色    3 反色
+(UIImage*)imageWithImage:(UIImage*)image grayLevelType:(UIImageGrayLevelType)type;

//色值 变暗多少 0.0 - 1.0
+(UIImage*)imageWithImage:(UIImage*)image darkValue:(float)darkValue;

/** 
    获取网络图片的Size, 先通过文件头来获取图片大小 
    如果失败 会下载完整的图片Data 来计算大小 所以最好别放在主线程
    如果你有使用SDWebImage就会先看下 SDWebImage有缓存过改图片没有
    支持文件头大小的格式 png、gif、jpg   http://www.cocoachina.com/bbs/read.php?tid=165823
 */
+(CGSize)downloadImageSizeWithURL:(id)imageURL;

@end
