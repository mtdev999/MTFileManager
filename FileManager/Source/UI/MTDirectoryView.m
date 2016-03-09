//
//  MTDirectoryView.m
//  FileManager
//
//  Created by Mark Tezza on 07/03/16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import "MTDirectoryView.h"

#import "MTDirectoryViewController.h"

@interface MTDirectoryView ()
@property (nonatomic, strong) MTDirectoryViewController *directViewController;

@end

@implementation MTDirectoryView

#pragma mark -
#pragma mark Accessors

- (void)setEditing:(BOOL)editing {
    [self.tableView setEditing:editing animated:YES];
    
    [self changeButtonTitleForEditing:editing];
}

- (BOOL)isEditing {
    return self.tableView.editing;
}

#pragma mark -
#pragma mark Public

- (void)setVisibleHomeButtonWithController:(MTDirectoryViewController *)controller {
    UIButton *homeButton = self.homeButton;
    
    self.directViewController = controller;
    
    controller.navigationController.viewControllers.count > 1 ? (homeButton.hidden = NO)
                                                              : (homeButton.hidden = YES);
}

- (void)createNewFolderWithName:(NSString *)name viewController:(MTDirectoryViewController *)controller {
    
    
    [self performAlertActionSheet];
}

- (void)addNewFolder {
    
    MTDirectoryViewController *controller = self.directViewController;
    NSUInteger newIndex = 0;
    NSString *path = [controller.path stringByAppendingPathComponent:self.textField];
    
    BOOL isFolder;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:path isDirectory:&isFolder]) {
        if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL]) {
            NSLog(@"Create folder failed %@", path);
        }
    }
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:controller.contents];
    [tempArray insertObject:self.textField atIndex:newIndex];
    controller.contents = tempArray;
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newIndex inSection:newIndex];
    
    UITableView *tableView = self.tableView;
    
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    [tableView endUpdates];
    
    [tableView reloadData];
}

- (void)performAlertActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please"
                                                                           message:@"select an action"
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionCreate = [UIAlertAction actionWithTitle:@"Create New Folder"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            NSLog(@"create new folder");
                                                            [self performAlertTextField];
                                                        }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Crancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            NSLog(@"cancel");
                                                        }];
    
    [alertController addAction:actionCreate];
    [alertController addAction:actionCancel];
    
    [self.directViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)performAlertTextField {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add New Folder"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"Ok!");
                                                             
                                                             
                                                             [self addNewFolder];
                                                             
                                                         }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Crancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"cancel");
                                                         }];
    
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"enter folder's name";
        [textField addTarget:self action:@selector(alertTextFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    }];
    
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    
    [self.directViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(UITextField *)sender {
    self.textField = sender.text;
}

#pragma mark -
#pragma mark Private

- (void)changeButtonTitleForEditing:(BOOL)editing {
    NSString *title = editing ? @"Done" : @"Edit";
    
    [self.editButton setTitle:title forState:UIControlStateNormal];
}

@end
