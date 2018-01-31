//
//  ImageScrollerViewController.m
//  WyjDemo
//
//  Created by Alex on 16/5/20.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ImageScrollerViewController.h"
#import "Global.h"
#import "UIImageView+WebCache.h"
#import "PublicUI.h"

@interface ImageScrollerViewController ()

@end

@implementation ImageScrollerViewController
@synthesize sellPostQueryResult;
@synthesize imageScroller;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(didPressedBack) addtarget:self];
    
    [self loadImageHeaderCell];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didPressedBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadImageHeaderCell{
    if (self.sellPostQueryResult.photos.count > 0) {
        for (int i=0;i<[self.sellPostQueryResult.photos count];i++) {
            UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, imageScroller.frame.size.height)];
            Photos *p = [self.sellPostQueryResult.photos objectAtIndex:i];
            [v sd_setImageWithURL:[NSURL URLWithString:p.imageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
            v.contentMode = UIViewContentModeScaleAspectFit;
            
            [self.imageScroller addSubview:v];
            
        }
        
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = self.sellPostQueryResult.photos.count;
        self.pageControl.currentPage = 0;
        //[self.pageControl addTarget:self action:@selector(didPressedchangePage:) forControlEvents:UIControlEventValueChanged];
        
        self.imageScroller.delegate = self;
        self.imageScroller.showsHorizontalScrollIndicator = NO;//水平不显示
        [self.imageScroller setContentSize:CGSizeMake(SCREEN_WIDTH*self.sellPostQueryResult.photos.count, self.imageScroller.frame.size.height)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
