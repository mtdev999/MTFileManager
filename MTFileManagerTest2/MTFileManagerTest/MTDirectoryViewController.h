//
//  MTDirectoryViewController.h
//  MTFileManagerTest
//
//  Created by Mark Tezza on 27.02.16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDirectoryViewController : UITableViewController
@property (nonatomic, strong)   NSString    *path;

- (id)initWithFolder:(NSString *)path;

- (IBAction)actionInfoCell:(id)sender;

@end
