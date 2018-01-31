//
//  WaterFallFlowLayout.m
//  TestUI
//
//  Created by 霍霍 on 15/12/13.
//  Copyright © 2015年 Jabir. All rights reserved.
//

#import "WaterFallFlowLayout.h"
#import "Global.h"
@implementation WaterFallFlowLayout
{
    //这个数组就是我们自定义的布局配置数组
    NSMutableArray * _attributeAttay;
}
//数组的相关设置在这个方法中
//布局前的准备会调用这个方法
-(void)prepareLayout{
    _attributeAttay = [[NSMutableArray alloc]init];
    self.minimumInteritemSpacing = 5;
    [super prepareLayout];
    //设置为静态的2列
    //计算每一个item的宽度
//    float WIDTH = (SCREEN_WIDTH-10)/2;
    float WIDTH = ([UIScreen mainScreen].bounds.size.width-self.sectionInset.left-self.sectionInset.right-self.minimumInteritemSpacing)/2;
    //定义数组保存每一列的高度
    //这个数组的主要作用是保存每一列的总高度，这样在布局时，我们可以始终将下一个Item放在最短的列下面
    CGFloat colHight[2]={self.sectionInset.top,self.sectionInset.bottom};
    //itemCount是外界传进来的item的个数 遍历来设置每一个item的布局
    for (int i=0; i<_itemCount; i++) {
        //设置每个item的位置等相关属性
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        //创建一个布局属性类，通过indexPath来创建
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        
        SellPostQueryResult *sellPostQueryResult = [_responseSellPostQuery.result objectAtIndex:index.row];
        //高度
        CGFloat hight = 200;//没有图片的时候设个默认高
        if ([sellPostQueryResult.thumbnailPhoto.width integerValue] > 0 && [sellPostQueryResult.thumbnailPhoto.height integerValue] > 0) {
            NSInteger iWidht = [sellPostQueryResult.thumbnailPhoto.width integerValue];
            NSInteger iHeight = [sellPostQueryResult.thumbnailPhoto.height integerValue];
#warning cpu 100
            hight =  (WIDTH/iWidht)*iHeight+42;
        }

        //哪一列高度小 则放到那一列下面
        //标记最短的列
        int width=0;
        if (colHight[0] <= colHight[1]) {
            //将新的item高度加入到短的一列
            colHight[0] = colHight[0]+hight+self.minimumLineSpacing;
            width=0;
        }else{
            colHight[1] = colHight[1]+hight+self.minimumLineSpacing;
            width=1;
        }
        
        //设置item的位置
        attris.frame = CGRectMake(self.sectionInset.left+(self.minimumInteritemSpacing+WIDTH)*width, colHight[width]-hight-self.minimumLineSpacing, WIDTH, hight);
        [_attributeAttay addObject:attris];
    }
    
    //设置itemSize来确保滑动范围的正确 这里是通过将所有的item高度平均化，计算出来的(以最高的列位标准)
    if (colHight[0]>=colHight[1]) {
        self.itemSize = CGSizeMake(WIDTH, (colHight[0]-self.sectionInset.top)/_itemCount-self.minimumLineSpacing);
        
    }else{
        self.itemSize = CGSizeMake(WIDTH, (colHight[1]-self.sectionInset.top)/_itemCount-self.minimumLineSpacing);
    }
    
}
//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributeAttay;
}

@end