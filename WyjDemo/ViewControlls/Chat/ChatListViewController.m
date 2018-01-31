//
//  ChatListViewController.m
//  WyjDemo
//
//  Created by wyj on 15/10/25.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import "ChatListViewController.h"
#import "UITableView+CustomCell.h"
#import "ChatListCell.h"
#import "ChatRecordViewController.h"
#import "ChatTools.h"
#import "UserMember.h"
#import "ChatContactsEntity.h"
#import "ChatHistoryEntity.h"
#import "Global.h"
#import "LoginViewController.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController
@synthesize chatSources;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = CustomLocalizedString(@"消息中心", nil);
    
    [self setTitleMsg];
    
    
    //监听打开连接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTitleMsg) name:def_connectFinish object:nil];
    //监听获取聊天记录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContactsList) name:def_postChatHistory object:nil];
    //监听聊天
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContactsList) name:def_postChatMsg object:nil];

    
    //self.edgesForExtendedLayout = UIRectEdgeNone;//scrollview适配
    // Do any additional setup after loading the view from its nib.
}

-(void)setTitleMsg
{
    NSString *sTitle = @"";
    if ([UserMember getInstance].isLogin) {
        switch ([ChatTools getInstance]._webSocket.readyState) {
            case SR_CONNECTING:
                sTitle = @"连接中";
                break;
            case SR_OPEN:
                sTitle = @"消息中心";
                break;
            case SR_CLOSED:
                sTitle = @"连接中";
                break;
            case SR_CLOSING:
                sTitle = @"连接中";
                break;
                
            default:
                break;
        }
    } else {
        sTitle = @"消息中心";
    }

    self.navigationItem.title = CustomLocalizedString(sTitle, nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserMember getInstance].isLogin) {
        [[ChatTools getInstance] refreshDB];
    }

    [tableview reloadData];
    if (![UserMember getInstance].isLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.bBackTabFirst = YES;
        loginVC.navigationItem.title = CustomLocalizedString(@"登录", nil);
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadContactsList
{
    NSLog(@"notification ChatContactsReload");
    for (ChatContactsEntity *item in [ChatTools getInstance].contactsArray) {
        NSLog(@"Last msg %@",item.lastMsg);
    }
    [tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ChatTools getInstance].contactsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ChatListCell";
    ChatListCell *cell = (ChatListCell*)[tableView customdq:identifier];
    ChatContactsEntity *item = [[ChatTools getInstance].contactsArray objectAtIndex:indexPath.row];
    cell.contactEntity = item;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatRecordViewController *chatVC = [[ChatRecordViewController alloc] initWithNibName:@"ChatRecordViewController" bundle:nil];
    ChatContactsEntity *item = [[ChatTools getInstance].contactsArray objectAtIndex:indexPath.row];
    chatVC.contactsEntity = item;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:def_postChatHistory object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:def_postChatMsg object:nil];
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
