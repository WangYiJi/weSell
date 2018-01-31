//
//  ReponseToken.h
//  WyjDemo
//
//  Created by 霍霍 on 15/10/20.
//  Copyright © 2015年 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReponseToken : NSObject
@property (nonatomic,copy)NSString *userId;

-(id)initwithJson:(id)dic;

@end
