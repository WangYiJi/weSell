//
//  PhotoCheckViewController.h
//  WyjDemo
//
//  Created by Alex on 16/2/15.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatHistoryEntity.h"

@interface PhotoCheckViewController : UIViewController
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic) BOOL bIsLocal;
@property (nonatomic,strong) ChatHistoryEntity *historyItem;

-(void)updateImageView:(CGSize)size;
@end
