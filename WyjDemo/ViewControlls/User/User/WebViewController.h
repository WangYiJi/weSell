//
//  WebViewController.h
//  WyjDemo
//
//  Created by Alex on 16/6/7.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
<
    UIWebViewDelegate
>
@property (nonatomic,retain) IBOutlet UIWebView *mainWeb;
@property (nonatomic,strong) NSString *sURL;
@end
