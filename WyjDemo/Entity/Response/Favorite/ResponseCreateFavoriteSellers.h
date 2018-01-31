//
//  ResponseCreateFavoriteSellers.h
//  WyjDemo
//
//  Created by Jabir on 16/2/23.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseCreateFavoriteSellers : NSObject
@property (nonatomic,copy) NSString *favoriteId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *sellUserId;
@property (nonatomic,copy) NSString *type;
-(id)initwithJson:(id)dic;
@end
