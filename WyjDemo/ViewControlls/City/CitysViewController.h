//
//  CitysViewController.h
//  WyjDemo
//
//  Created by Alex on 16/4/15.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitysViewController : UIViewController
<
    UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate
>
{
    IBOutlet UITableView *mainTableview;
}

@property (nonatomic,strong) NSMutableArray *cityArr;
@end
