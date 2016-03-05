//
//  UITableView+MTExtensions.m
//  Task#2
//
//  Created by Mark Tezza on 21.09.15.
//  Copyright © 2015 Mark Tezza. All rights reserved.
//

#import "UITableView+MTExtensions.h"

//#import "MTChangeModel.h"
//#import "MTChangeModelOneIndex.h"
//#import "MTChangeModelTwoIndexes.h"

//#import "UINib+MTExtensions.h"
//#import "MTChangeModel+UITableView.h"

@implementation UITableView (MTExtensions)

#pragma mark -
#pragma mark Public Method

- (id)dequeueCellWithClass:(Class)class {
    id cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(class)];
    if (!cell) {
        //cell = [UINib objectWithClass:class];
    }
    
    return cell;
}

- (id)dequeueCellWithStyle:(UITableViewCellStyle)style identifier:(NSString *)string {
    id cell = [self dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:string];
    }
    
    return cell;
}

//- (void)updateChangeWithModel:(MTChangeModel *)model {
//    [self updateChangeWithModel:model rowAnimation:UITableViewRowAnimationAutomatic];
//}
//
//- (void)updateChangeWithModel:(MTChangeModel *)model rowAnimation:(UITableViewRowAnimation)rowAnimation {
//    [self beginUpdates];
//    [model applyToTableView:self rowAnimation:rowAnimation];
//    [self endUpdates];
//}

@end
