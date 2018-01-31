//
//  ContactListViewController.m
//  WyjDemo
//
//  Created by Alex on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "ContactListViewController.h"
#import "RequestChatContactsWithPostId.h"
#import "NetworkEngine.h"
#import "UserMember.h"
#import "ChatContactsEntity.h"
#import "ChatListCell.h"
#import "UITableView+CustomCell.h"
#import "UIImageView+WebCache.h"
#import "PublicUI.h"
#import "ChatRecordViewController.h"

@interface ContactListViewController ()

@end

@implementation ContactListViewController
@synthesize chatList;
@synthesize choosePost;
@synthesize chatContantsList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人列表";
    
    UIBarButtonItem *bar = [PublicUI getBackButtonandMethod:@selector(didPressedBack) addtarget:self];
    self.navigationItem.leftBarButtonItem = bar;
    
    self.chatContantsList = [[NSMutableArray alloc] init];
    
    _lblPrice.text = [NSString stringWithFormat:@"%@%.2f",self.choosePost.price.currencySymbol,[self.choosePost.price.value floatValue]];
    _lblTitle.text = self.choosePost.title;
    if (self.choosePost.photos.count > 0) {
        Photos *p = [self.choosePost.photos objectAtIndex:0];
        [_imgPost sd_setImageWithURL:[NSURL URLWithString:p.imageUrl]];
    } else {
        _imgPost.image = [UIImage imageNamed:@"default"];
    }

    [_mainTableview setTableHeaderView:_viewPostInfo];
    
    RequestChatContactsWithPostId *request = [[RequestChatContactsWithPostId alloc] init];
    [request setURL:self.choosePost.postId];
    
    __weak typeof(self) weakself = self;
    [NetworkEngine getJSONWithUrl:request
                          success:^(id json) {
                              ResponseChatContactsWithPostId *response = [[ResponseChatContactsWithPostId alloc] initWithJson:json];
                              

                              for (chatItem *item in response.chatList) {
                                  NSString *sUserId = @"";
                                  if ([[UserMember getInstance].userId isEqualToString:item.userId2]) {
                                      sUserId = item.userId1;
                                  } else {
                                      sUserId = item.userId2;
                                  }
                                  NSMutableArray *contacts = [ChatContactsEntity getContactsByUserId:sUserId];
                                  if (contacts.count > 0) {
                                      ChatContactsEntity *tempContact = [contacts objectAtIndex:0];
                                      [weakself.chatContantsList addObject:tempContact];
                                  }
                              }
                              [_mainTableview reloadData];
                              
                          } fail:^(NSError *error) {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取聊天记录失败"
                                                                              message:nil
                                                                             delegate:nil
                                                                    cancelButtonTitle:nil
                                                                    otherButtonTitles:@"确定", nil];
                              [alert show];
                          }];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)didPressedBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatContantsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ChatListCell";
    ChatListCell *cell = (ChatListCell*)[tableView customdq:identifier];
    ChatContactsEntity *item = [self.chatContantsList objectAtIndex:indexPath.row];
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
