//
//  MTDirectoryViewController.m
//  MTFileManager
//
//  Created by Mark Tezza on 04/03/16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import "MTDirectoryViewController.h"

@interface MTDirectoryViewController ()
@property (nonatomic, strong)   NSString  *path;
@property (nonatomic, strong)   NSArray   *contents;

@end

@implementation MTDirectoryViewController

- (instancetype)initWithFolderPath:(NSString *)path {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
        
        NSError *error = nil;
        self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [self.path lastPathComponent];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self addBarButtonItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -
#pragma mark Actions

- (void)actionBackToRoot:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)isDirectoryAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    return isDirectory;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *folderCell = @"folderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:folderCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:folderCell];
    }
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        cell.imageView.image = [UIImage imageNamed:@"folder"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"file"];
    }
    
    cell.textLabel.text = fileName;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isDirectoryAtIndexPath:indexPath]) {
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
        
        MTDirectoryViewController *vc = [[MTDirectoryViewController alloc] initWithFolderPath:filePath];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addBarButtonItem {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBackToRoot:)];
    self.navigationItem.rightBarButtonItem = backItem;
}

@end
