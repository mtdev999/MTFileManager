//
//  MTDirectoryViewController.h
//  FileManager
//
//  Created by Mark Tezza on 07/03/16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDirectoryViewController : UIViewController
@property (nonatomic, strong)   NSString        *path;
@property (nonatomic, strong)   NSArray         *contents;

- (IBAction)actionEditButton:(UIButton *)sender;
- (IBAction)actionHomeButton:(UIButton *)sender;
- (IBAction)actionAddFolderButton:(UIButton *)sender;

@end
