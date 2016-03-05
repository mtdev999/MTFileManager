//
//  UIView+MTExtensions.m
//  MTFileManagerTest
//
//  Created by Mark Tezza on 28.02.16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import "UIView+MTExtensions.h"

@implementation UIView (MTExtensions)

- (UITableViewCell *)superCell {
    
    if (!self.superview) {
        return nil;
    }
    
    if ([self.superview isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)self.superview;
    }
    
    return [self.superview superCell];
    
}

@end
