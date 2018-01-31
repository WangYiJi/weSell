//
//  UITableView+CustomCell.m
//  CarBaDa
//
//  Created by Alex on 6/9/15.
//  Copyright (c) 2015 wyj. All rights reserved.
//

#import "UITableView+CustomCell.h"

@implementation UITableView (CustomCell)


-(UITableViewCell *)customdq:(NSString *)identifier
{
    UITableViewCell* cell = (UITableViewCell*)[self dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        
        for (id oneObject in nibs)
        {
            if ([oneObject isKindOfClass:NSClassFromString(identifier)])
            {
                cell = oneObject;
            }
        }
    }
    return cell;
}

@end


//tableView注册cell
//UINib *nibImmediatelyCell = [UINib nibWithNibName:NSStringFromClass([immediatelyEmployCell class]) bundle:nil];
//[self.tableDriversList registerNib:nibImmediatelyCell forCellReuseIdentifier:identifierImmdiatelyCell];
