//
//  SellerInfoFlowLayout.m
//  WyjDemo
//
//  Created by zjb on 16/3/8.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "SellerInfoFlowLayout.h"
#import "Global.h"

@implementation SellerInfoFlowLayout
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
    //计算每一个item的宽度
    //    float WIDTH = (SCREEN_WIDTH-10)/2;
    float WIDTH = ([UIScreen mainScreen].bounds.size.width-self.sectionInset.left-self.sectionInset.right-self.minimumInteritemSpacing)/2;
    //定义数组保存每一列的高度
    //这个数组的主要作用是保存每一列的总高度，这样在布局时，我们可以始终将下一个Item放在最短的列下面
    CGFloat colHight[2]={self.sectionInset.top,self.sectionInset.bottom};
    //itemCount是外界传进来的item的个数 遍历来设置每一个item的布局
    for (int i=0; i<_itemCount; i++) {
        if (i == 0) {
            //设置每个item的位置等相关属性
            NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
            //创建一个布局属性类，通过indexPath来创建
            UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
            //设置item的位置
            attris.frame = CGRectMake(self.sectionInset.left, self.sectionInset.top, ([UIScreen mainScreen].bounds.size.width-self.sectionInset.left-self.sectionInset.right), 200);
            colHight[0] = colHight[1] = 200;
            [_attributeAttay addObject:attris];
        }else {
            //设置每个item的位置等相关属性
            NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
            //创建一个布局属性类，通过indexPath来创建
            UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
            
            SellPostQueryResult *sellPostQueryResult = [_responseSellPostQuery.result objectAtIndex:index.row-1];
            //高度
            CGFloat hight = 200;//没有图片的时候设个默认高
            if ([sellPostQueryResult.thumbnailPhoto.width integerValue] > 0 &&[sellPostQueryResult.thumbnailPhoto.height integerValue] > 0) {
                NSInteger iWidth = [sellPostQueryResult.thumbnailPhoto.width intValue];
                NSInteger iHeight = [sellPostQueryResult.thumbnailPhoto.height intValue];
#warning cpu 100
                
                hight =  (WIDTH/iWidth)*iHeight+42;
            }
            
            //哪一列高度小 则放到那一列下面
            //标记最短的列
            int width=0;
            if (colHight[0]<colHight[1]) {
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
    }
    
    //设置itemSize来确保滑动范围的正确 这里是通过将所有的item高度平均化，计算出来的(以最高的列位标准)
    if (colHight[0]>colHight[1]) {
        self.itemSize = CGSizeMake(WIDTH, (colHight[0]-self.sectionInset.top)*2/(_itemCount+1) -self.minimumLineSpacing);
        
    }else{
        self.itemSize = CGSizeMake(WIDTH, (colHight[1]-self.sectionInset.top)*2/(_itemCount+1) -self.minimumLineSpacing);
    }
    
}
//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributeAttay;
}

@end
