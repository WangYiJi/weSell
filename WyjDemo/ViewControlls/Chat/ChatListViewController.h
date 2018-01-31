//
//  ChatListViewController.h
//  WyjDemo
//
//  Created by wyj on 15/10/25.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChatListViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    IBOutlet UITableView *tableview;
}

@property (nonatomic,strong) NSMutableArray *chatSources;

@end
