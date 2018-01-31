//
//  ResponseCategory.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/18.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseAbuseType.h"

@interface CategoryInfo : NSObject
@property (nonatomic,copy)NSString *categoryPath;
@property (nonatomic,strong)NSString *displayName;
@property (nonatomic,strong)NSArray *childCategories;

@end

@interface ResponseCategory : NSObject
@property (nonatomic,strong)NSMutableArray *responseCategoryArray;
-(id)initwithJson:(id)dic;
@end
