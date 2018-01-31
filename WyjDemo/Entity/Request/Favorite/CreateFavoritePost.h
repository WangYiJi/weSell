//
//  CreateFavoritePost.h
//  WyjDemo
//
//  Created by Jabir on 16/2/23.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "BaseRequest.h"

@interface CreateFavoritePost : BaseRequest
@property (nonatomic,copy) NSString *postId;
@property (nonatomic,copy) NSString *type;
@end
