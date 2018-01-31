//
//  MyADVRefreshTool.m
//  WyjDemo
//
//  Created by Jabir on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "MyADVRefreshTool.h"
#import "NetworkEngine.h"
#import "UserMember.h"

#define ADVPageSize 20
@implementation MyADVRefreshTool

- (void)refreshList:(NSInteger)page type:(MyADVType)type superview:(UIView *)superView;{
    self.page = page;
    self.superView = superView;
    switch (type) {
        case MyADVType_InSales:
        {
            [self getInSalesList];
        }
            break;
        case MyADVType_WantToBuy:
        {
            [self getWantToBuyList];
        }
            break;
        case MyADVType_Collection:
        {
            [self getCollectionList];
        }
            break;
        default:
            break;
    }
}

- (void)getInSalesList{
    [NetworkEngine showMbDialog:self.superView title:@"正在加载"];
    GetSelfSellPostsEntity *sellPostQueryEntity = [[GetSelfSellPostsEntity alloc] init];
    
    sellPostQueryEntity.userId = [UserMember getInstance].userId;
    sellPostQueryEntity.page = [NSString stringWithFormat:@"%ld",(long)self.page];
    sellPostQueryEntity.pageSize = [NSString stringWithFormat:@"%d",ADVPageSize];
    sellPostQueryEntity.status = @"AVAILABLE|SOLD|UNLISTED";
    
    __weak typeof(self) weakSelf = self;
    [NetworkEngine getJSONWithUrl:sellPostQueryEntity success:^(id json) {
        [NetworkEngine hiddenDialog];
        ResponseSellPostQuery *responseSellPostQuery = [[ResponseSellPostQuery alloc] initwithJson:json];
        if ([weakSelf.delegate respondsToSelector:@selector(getMyAdvRefreshResponse:dic:)]) {
            [weakSelf.delegate getMyAdvRefreshResponse:responseSellPostQuery dic:nil];
        }
    } fail:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请求失败"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        [NetworkEngine hiddenDialog];
        if ([weakSelf.delegate respondsToSelector:@selector(getMyAdvRefreshResponseFail:)]) {
            [weakSelf.delegate getMyAdvRefreshResponseFail:error];
        }
        
    }];
}

- (void)getWantToBuyList{
    [NetworkEngine showMbDialog:self.superView title:@"正在加载"];
    RequestGetChatUserAsBuyer *entity = [[RequestGetChatUserAsBuyer alloc] init];
    entity.pageSize = [NSString stringWithFormat:@"%d",ADVPageSize];
    entity.page = [NSString stringWithFormat:@"%ld",(long)self.page];
    
    __weak typeof(self) weakSelf = self;
    [NetworkEngine getJSONWithUrl:entity success:^(id json) {
        ResponseGetChatUserAsBuyer *responseGetChatUserAsBuyer = [[ResponseGetChatUserAsBuyer alloc] initwithJson:json];
        SellByIdEntity *sellByIdEntity = [[SellByIdEntity alloc] init];
        sellByIdEntity.postIds = [self postIdsWithResponseGetChatUserAsBuyer:responseGetChatUserAsBuyer];
        
        [NetworkEngine getJSONWithUrl:sellByIdEntity success:^(id json) {
            [NetworkEngine hiddenDialog];
            ResponseByIds *responseByIds = [[ResponseByIds alloc] initwithJson:json];
            ResponseSellPostQuery *responseSellPostQuery = [weakSelf ResponseSellPostQueryWithByid:responseByIds ResponseGetChatUserAsBuyer:responseGetChatUserAsBuyer];
            if ([weakSelf.delegate respondsToSelector:@selector(getMyAdvRefreshResponse:dic:)]) {
                [weakSelf.delegate getMyAdvRefreshResponse:responseSellPostQuery dic:nil];
            }
            
        } fail:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请求失败"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
            [NetworkEngine hiddenDialog];
            if ([weakSelf.delegate respondsToSelector:@selector(getMyAdvRefreshResponseFail:)]) {
                [weakSelf.delegate getMyAdvRefreshResponseFail:error];
            }
        }];
        
        
    } fail:^(NSError *error) {
        [NetworkEngine hiddenDialog];
        if ([weakSelf.delegate respondsToSelector:@selector(getMyAdvRefreshResponseFail:)]) {
            [weakSelf.delegate getMyAdvRefreshResponseFail:error];
        }
    }];
}

- (void)getCollectionList{
    [NetworkEngine showMbDialog:self.superView title:@"正在加载"];
    GetFavoritePostEntity *entity = [[GetFavoritePostEntity alloc] init];
    entity.type = @"INTERESTED";
    entity.pageSize = [NSString stringWithFormat:@"%d",ADVPageSize];
    entity.page = [NSString stringWithFormat:@"%zd",self.page];
    __weak typeof(self) weakSelf = self;
    [NetworkEngine getJSONWithUrl:entity success:^(id json) {
        ResponseGetFavoritePosts *responseGetFavoritePosts = [[ResponseGetFavoritePosts alloc] initwithJson:json];
        SellByIdEntity *sellByIdEntity = [[SellByIdEntity alloc] init];
        sellByIdEntity.postIds = [weakSelf postIdsWithResponseGetFavoritePosts:responseGetFavoritePosts];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        for (FavoritePost *faEntity in responseGetFavoritePosts.result) {
            [dic setValue:faEntity.favoriteId forKey:faEntity.sellPostId];
        }
        
        [NetworkEngine getJSONWithUrl:sellByIdEntity success:^(id json) {
            [NetworkEngine hiddenDialog];
            ResponseByIds *responseByIds = [[ResponseByIds alloc] initwithJson:json];
            ResponseSellPostQuery *responseSellPostQuery = [weakSelf ResponseSellPostQueryWithByid:responseByIds ResponseGetFavoritePosts:responseGetFavoritePosts];
            if ([weakSelf.delegate respondsToSelector:@selector(getMyAdvRefreshResponse:dic:)]) {
                [weakSelf.delegate getMyAdvRefreshResponse:responseSellPostQuery dic:dic];
            }
        } fail:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请求失败"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
            [NetworkEngine hiddenDialog];
            if ([weakSelf.delegate respondsToSelector:@selector(getMyAdvRefreshResponseFail:)]) {
                [weakSelf.delegate getMyAdvRefreshResponseFail:error];
            }
        }];
        
        
    } fail:^(NSError *error) {
        [NetworkEngine hiddenDialog];
        if ([weakSelf.delegate respondsToSelector:@selector(getMyAdvRefreshResponseFail:)]) {
            [weakSelf.delegate getMyAdvRefreshResponseFail:error];
        }
    }];
}

//拼接多个postids
- (NSString *)postIdsWithResponseGetChatUserAsBuyer:(ResponseGetChatUserAsBuyer *)responseGetChatUserAsBuyer{
    NSString *sPostIds = @"";
    for (ChattedUser *c in responseGetChatUserAsBuyer.resultArray) {
        sPostIds = [sPostIds stringByAppendingString:[NSString stringWithFormat:@"%@,",c.postId]];
    }
    
    if (sPostIds.length > 0) {
        sPostIds = [sPostIds substringWithRange:NSMakeRange(0, sPostIds.length-1)];//截取范围类的字符串
    }
    return sPostIds;
}

//拼接多个postids
- (NSString *)postIdsWithResponseGetFavoritePosts:(ResponseGetFavoritePosts *)responseGetFavoritePosts{
    NSString *sPostIds = @"";
    for (FavoritePost *f in responseGetFavoritePosts.result) {
        sPostIds = [sPostIds stringByAppendingString:[NSString stringWithFormat:@"%@,",f.sellPostId]];
    }
    
    if (sPostIds.length > 0) {
        sPostIds = [sPostIds substringWithRange:NSMakeRange(0, sPostIds.length-1)];//截取范围类的字符串
    }
    return sPostIds;
}

//组建对象
- (ResponseSellPostQuery *)ResponseSellPostQueryWithByid:(ResponseByIds *)responseByIds ResponseGetFavoritePosts:(ResponseGetFavoritePosts *)responseGetFavoritePosts{
    ResponseSellPostQuery *tempResponseSellPostQuery = [[ResponseSellPostQuery alloc] init];
    tempResponseSellPostQuery.hasNext = responseGetFavoritePosts.hasNext;
    tempResponseSellPostQuery.page = responseGetFavoritePosts.page;
    tempResponseSellPostQuery.pageSize = responseGetFavoritePosts.pageSize;
    tempResponseSellPostQuery.result = [[NSMutableArray alloc] initWithArray:responseByIds.ArraySellPost];
    
    return tempResponseSellPostQuery;
}

//组建对象
- (ResponseSellPostQuery *)ResponseSellPostQueryWithByid:(ResponseByIds *)responseByIds ResponseGetChatUserAsBuyer:(ResponseGetChatUserAsBuyer *)responseGetChatUserAsBuyer{
    ResponseSellPostQuery *tempResponseSellPostQuery = [[ResponseSellPostQuery alloc] init];
    tempResponseSellPostQuery.hasNext = responseGetChatUserAsBuyer.hasNext;
    tempResponseSellPostQuery.page = responseGetChatUserAsBuyer.page;
    tempResponseSellPostQuery.pageSize = responseGetChatUserAsBuyer.pageSize;
    tempResponseSellPostQuery.result = [[NSMutableArray alloc] initWithArray:responseByIds.ArraySellPost];
    
    return tempResponseSellPostQuery;
}

@end
