//
//  MTDirecoryViewController.m
//  MTFileManagerWithStoryBoard
//
//  Created by Mark Tezza on 05/03/16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import "MTDirecoryViewController.h"

@interface MTDirecoryViewController ()
@property (nonatomic, strong)   NSArray *contents;

@end

@implementation MTDirecoryViewController

#pragma mark -
#pragma mark Initialization And Deallocations

- (instancetype)initWithFolderPath:(NSString *)path {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setPath:(NSString *)path {
    if (_path != path) {
        _path = path;
        
        NSError *error = nil;
        
        self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        [self.tableView reloadData];
        self.navigationItem.title = [path lastPathComponent];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path) {
        self.path = @"/Users/Kuzmenko";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self addBarButtonHome];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -
#pragma mark Actions

- (void)actionHomeBarButton:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    cell.textLabel.text = fileName;
    if ([self isDirectoryWithIndexPath:indexPath]) {
        cell.imageView.image = [UIImage imageNamed:@"folder"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"file"];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isDirectoryWithIndexPath:indexPath]) {
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
        
        MTDirecoryViewController *vc = [[MTDirecoryViewController alloc] initWithFolderPath:filePath];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark Private

- (BOOL)isDirectoryWithIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    return isDirectory;
}

- (void)addBarButtonHome {
    UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(actionHomeBarButton:)];
    self.navigationItem.rightBarButtonItem = home;
}

@end
