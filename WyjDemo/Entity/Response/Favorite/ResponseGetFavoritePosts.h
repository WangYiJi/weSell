//
//  ResponseGetFavoritePosts.h
//  WyjDemo
//
//  Created by Jabir on 16/2/28.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritePost : NSObject
@property (nonatomic,copy)NSString *favoriteId;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *sellPostId;
@property (nonatomic,copy)NSString *type;

@end

@interface ResponseGetFavoritePosts : NSObject
@property (nonatomic,strong) NSMutableArray *result;
@property (nonatomic,strong) NSString *hasNext;
@property (nonatomic,strong) NSString *page;
@property (nonatomic,strong) NSString *pageSize;
-(id)initwithJson:(id)dic;
@end
