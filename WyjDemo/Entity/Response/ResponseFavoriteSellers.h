//
//  ResponseFavoriteSellers.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/19.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteSeller : NSObject
@property (nonatomic,copy)NSString *favoriteId;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *sellUserId;
@property (nonatomic,copy)NSString *type;
@end

@interface ResponseFavoriteSellers : NSObject
@property (nonatomic,strong)NSMutableArray *responseFavoriteSellersArray;

-(id)initwithJson:(id)dic;

@end
