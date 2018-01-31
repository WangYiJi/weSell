//
//  ContactListViewController.h
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseChatContactsWithPostId.h"
#import "ResponseSellPostQuery.h"

@interface ContactListViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>
{

}

@property (strong, nonatomic) IBOutlet UIView *viewPostInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgPost;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (nonatomic,strong) ResponseChatContactsWithPostId *chatList;
@property (nonatomic,strong) SellPostQueryResult *choosePost;


@property (weak, nonatomic) IBOutlet UITableView *mainTableview;
@property (nonatomic,strong) NSMutableArray *chatContantsList;


@end
