//
//  WebViewController.m
//  WyjDemo
//
//  Created by Alex on 16/6/7.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "WebViewController.h"
#import "PublicUI.h"
#import "NetworkEngine.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize sURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainWeb.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [PublicUI getBackButtonandMethod:@selector(back) addtarget:self];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:sURL]];
    [_mainWeb loadRequest:request];
    [NetworkEngine showMbDialog:self.view title:@"请稍后"];
    // Do any additional setup after loading the view from its nib.
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [NetworkEngine hiddenDialog];
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
