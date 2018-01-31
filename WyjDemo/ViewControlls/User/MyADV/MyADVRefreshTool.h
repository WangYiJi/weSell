//
//  MyADVRefreshTool.h
//  WyjDemo
//
//  Created by Jabir on 16/3/1.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetFavoritePostEntity.h"
#import "ResponseGetFavoritePosts.h"
#import "SellByIdEntity.h"
#import "ResponseByIds.h"
#import "RequestGetChatUserAsBuyer.h"
#import "ResponseGetChatUserAsBuyer.h"
#import "SellPostQueryEntity.h"
#import "ResponseSellPostQuery.h"
#import "GetSelfSellPostsEntity.h"
#import <UIKit/UIKit.h>

typedef enum
{
    MyADVType_InSales = 0,
    MyADVType_WantToBuy = 1,
    MyADVType_Collection = 2
}MyADVType;

@protocol MyADVRefreshDelegate <NSObject>

- (void)getMyAdvRefreshResponse:(ResponseSellPostQuery *)responseSellPostQuery dic:(NSMutableDictionary*)favDic;
- (void)getMyAdvRefreshResponseFail:(NSError *)error;
@end

@interface MyADVRefreshTool : NSObject
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) UIView *superView;
@property (nonatomic,assign) id<MyADVRefreshDelegate> delegate;

- (void)refreshList:(NSInteger)page type:(MyADVType)type superview:(UIView *)superView;
@end
