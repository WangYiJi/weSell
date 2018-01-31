//
//  PhotoCheckViewController.m
//  WyjDemo
//
//  Created by Alex on 16/2/15.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "PhotoCheckViewController.h"
#import "UIImageView+WebCache.h"
#import "ChatTools.h"
#import "UIImage+LK.h"
#import "Masonry.h"

@interface PhotoCheckViewController ()

@end

@implementation PhotoCheckViewController
@synthesize imageView;
@synthesize bIsLocal;
@synthesize historyItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    CGSize size;
    
    __weak typeof(self) weakself = self;
    if ([self.historyItem.isLocal boolValue]) {
        //加载本地图片
        NSString *sPath = [NSString stringWithFormat:@"%@/%@", [ChatTools getInstance].sImageFilePath,self.historyItem.msg];
        if ([[NSFileManager defaultManager] fileExistsAtPath:sPath]) {
            UIImage *img = [UIImage imageWithContentsOfFile:sPath];
            size = img.size;
            self.imageView.image = img;
            [self updateImageView:size];
        }
    } else {
        //加载网络图片
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:historyItem.msg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                weakself.imageView.image = image;
                [weakself updateImageView:image.size];
            }
        }];
    }
    

    

    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(didPressedBack)];
    self.navigationItem.leftBarButtonItem = backBar;

    // Do any additional setup after loading the view from its nib.
}

-(void)updateImageView:(CGSize)size
{
    if (size.width > self.view.frame.size.width) {
        float fX = self.view.frame.size.width / size.width;
        size = CGSizeMake(self.view.frame.size.width, size.height*fX);
    }
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
}

-(void)didPressedBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
