//
//  ResponseFavoriteSeller.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/19.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "ResponseFavoriteSellers.h"

@interface ResponseFavoriteSeller : NSObject
@property (nonatomic,strong)FavoriteSeller *favoriteSeller;

-(id)initwithJson:(id)dic;

@end
