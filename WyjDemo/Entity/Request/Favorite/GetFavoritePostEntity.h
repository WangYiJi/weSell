//
//  GetFavoritePostEntity.h
//  WyjDemo
//
//  Created by Jabir on 16/2/27.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface GetFavoritePostEntity : BaseRequest
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *pageSize;
@end
