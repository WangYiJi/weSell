//
//  CreateFavoriteSeller.h
//  WyjDemo
//
//  Created by Jabir on 16/2/23.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface CreateFavoriteSeller : BaseRequest
@property (nonatomic,copy) NSString *sellUserId;
@property (nonatomic,copy) NSString *status;
@end
