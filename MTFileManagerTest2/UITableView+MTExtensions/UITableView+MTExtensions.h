//
//  UITableView+MTExtensions.h
//  Task#2
//
//  Created by Mark Tezza on 21.09.15.
//  Copyright © 2015 Mark Tezza. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class MTChangeModel;

@interface UITableView (MTExtensions)

- (id)dequeueCellWithClass:(Class)cls;
- (id)dequeueCellWithStyle:(UITableViewCellStyle)style identifier:(NSString *)string;
//- (void)updateChangeWithModel:(MTChangeModel *)model;

@end
