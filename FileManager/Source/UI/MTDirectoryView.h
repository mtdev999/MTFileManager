//
//  MTDirectoryView.h
//  FileManager
//
//  Created by Mark Tezza on 07/03/16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  MTDirectoryViewController;

@interface MTDirectoryView : UIView
@property (nonatomic, strong)   IBOutlet UITableView        *tableView;
@property (nonatomic, strong)   IBOutlet UIButton           *editButton;
@property (nonatomic, strong)   IBOutlet UIButton           *homeButton;
@property (nonatomic, strong)   IBOutlet UIButton           *addFolderButton;
@property (nonatomic, strong)   NSString                    *textField;

@property (nonatomic, assign, getter=isEditing)    BOOL    editing;

- (void)setVisibleHomeButtonWithController:(UIViewController *)controller;
- (void)createNewFolderWithName:(NSString *)name viewController:(MTDirectoryViewController *)controller;


@end
