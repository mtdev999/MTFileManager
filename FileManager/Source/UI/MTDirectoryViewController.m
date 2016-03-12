//
//  MTDirectoryViewController.m
//  FileManager
//
//  Created by Mark Tezza on 07/03/16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import "MTDirectoryViewController.h"

#import "MTDirectoryView.h"

@interface MTDirectoryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MTDirectoryView *directView;
@property (nonatomic, strong) NSArray         *barButtonItems;

@end

@implementation MTDirectoryViewController
@dynamic directView;

#pragma mark -
#pragma mark Initializations And Deallocations

- (instancetype)initWithFolderPath:(NSString *)path {
    self = [super init];
    if (self) {
        self.path = path;
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setPath:(NSString *)path {
    _path = path;
    
    NSError *error = nil;
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (MTDirectoryView *)directView {
    if ([self isViewLoaded] && [self.view isKindOfClass:[MTDirectoryView class]]) {
        return (MTDirectoryView *)self.view;
    }
    
    return nil;
}

#pragma mark -
#pragma marklife Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path) {
        self.path = @"/Users/Kuzmenko/Desktop/FileManager";
    }
    
    [self.directView setVisibleHomeButtonWithController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.contents];
    NSString *novalidFile = @".DS_Store";
    if ([tempArray containsObject:novalidFile]) {
        [tempArray removeObject:novalidFile];
    }
    self.contents = tempArray;
    
    [self sortedArrayContents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Actions

- (IBAction)actionEditButton:(UIBarButtonItem *)sender {
    self.directView.editing = !self.directView.editing;
}

- (IBAction)actionHomeButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionAddFolderButton:(UIButton *)sender {
    NSString *newFile = [NSString stringWithFormat:@"New Folder %lu", self.contents.count];
    
    [self.directView createNewFolderWithName:newFile viewController:self];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *nameOfHeader = [NSString stringWithFormat:@"..%@", [self.path lastPathComponent]];
    
    return nameOfHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    //NSString *path = [self.path stringByAppendingPathComponent:fileName];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        cell.imageView.image = [UIImage imageNamed:@"folder_28x28"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"file_28x28"];
    }
    
    cell.textLabel.text = fileName;
    cell.detailTextLabel.text = @"info";
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Moving/reordering
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Data manipulation - reorder / moving support
- (void)            tableView:(UITableView *)tableView
           moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                  toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.contents];
    NSString *fileName = [self.contents objectAtIndex:sourceIndexPath.row];
    
    [tempArray removeObject:fileName];
    [tempArray insertObject:fileName atIndex:destinationIndexPath.row];
    self.contents = tempArray;
}

// Delete

- (void)            tableView:(UITableView *)tableView
           commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    NSString *path = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isFolder;
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path isDirectory:&isFolder]) {
        if (![manager removeItemAtPath:path error:&error]) {
            NSLog(@"Delete folder failed %@", path);
        }
    }
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.contents];
    
    [tempArray removeObjectAtIndex:indexPath.row];
    self.contents = tempArray;
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [tableView endUpdates];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
        
        MTDirectoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MTDirectoryViewController"];
        vc.path = path;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark Private

- (void)sortedArrayContents {
    NSArray *sortedArray = [self.contents sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if ([self isFile:obj1] && [self isFile:obj2]) {
            return [obj1 compare:obj2];
        } else if ([self isFile:obj1] && ![self isFile:obj2]) {
            return NSOrderedDescending;
        } else {
            return ![obj1 compare:obj2];
        }
    }];
    
    self.contents = sortedArray;
}

- (BOOL)isFile:(id)obj {
    BOOL isFile = NO;
    
    NSString *path = [self.path stringByAppendingPathComponent:obj];
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isFile];
    
    return !isFile;
}

- (BOOL)isDirectoryAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    NSString *path = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    return isDirectory;
}

@end
