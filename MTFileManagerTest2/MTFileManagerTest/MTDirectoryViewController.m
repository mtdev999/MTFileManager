//
//  MTDirectoryViewController.m
//  MTFileManagerTest
//
//  Created by Mark Tezza on 27.02.16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import "MTDirectoryViewController.h"

#import "MTFileViewCell.h"
#import "UITableView+MTExtensions.h"
#import "UIView+MTExtensions.h"


@interface MTDirectoryViewController ()

@property (nonatomic, strong)   NSArray     *contents;
@property (nonatomic, strong)   NSString    *selectedPath;

@end

@implementation MTDirectoryViewController

#pragma mark -
#pragma mark Initialization and Deallocations

- (id)initWithFolder:(NSString *)path {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
    }
    
    return self;
}

- (void)setPath:(NSString *)path {
    _path = path;
    
    NSError *error = nil;
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    [self.tableView reloadData];
    
    self.navigationItem.title = [self.path lastPathComponent];
}

- (void)dealloc {
    NSLog(@":::controller with path: %@ has been dealocated", self.path);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path) {
        self.path  = @"/Users/Kuzmenko";
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back To Root"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBackToRoot:)];
        
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%@", self.path);
    NSLog(@"view controllers: %lu", [self.navigationController.viewControllers count]);
    NSLog(@"index on stack: %lu", [self.navigationController.viewControllers indexOfObject:self]);
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
    NSString *filPath = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:filPath isDirectory:&isDirectory];
    
    return isDirectory;
}

- (IBAction)actionInfoCell:(id)sender {
    UITableViewCell *cell = [sender superCell];
    
    if (cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSString *actionAlertString = [NSString stringWithFormat:@"section: %ld, row: %ld", indexPath.section, indexPath.row];
        [self actionAlertInfoWithString:actionAlertString];
        
    }
}
// вывод алерт вью
- (void)actionAlertInfoWithString:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Info!"
                                                                   message:string
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handel your yes please button action here
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// получаем форматированную строку для размера файла
- (NSString *)fileSizeFromValue:(unsigned long long)size {
    static NSString *units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    static int unitsCount = 5;
    int index = 0;
    double fileSize = (double)size;
    
    while (fileSize > 1024 && index < unitsCount) {
        fileSize /= 1024;
        index++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
}

// форматирование строки для вывода данных о файле
- (NSString *)dateStringWithAttributes:(NSDictionary *)attributes {
    NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yy hh:mm a"];
    }
    
    return [dateFormatter stringFromDate:[attributes fileModificationDate]];
}

#pragma mark
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *folderIdentifier = @"FoderCell";
    static NSString *fileIdentifier = @"FileCell";
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:folderIdentifier];
    }
    
    cell.textLabel.text = fileName;
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        cell.imageView.image = [UIImage imageNamed:@"folder"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"file"];
    }
     */
 
    if ([self isDirectoryAtIndexPath:indexPath]) {
        UITableViewCell *cell = [tableView dequeueCellWithStyle:UITableViewCellStyleDefault
                                                     identifier:folderIdentifier];
        cell.textLabel.text = fileName;
        cell.imageView.image = [UIImage imageNamed:@"folder"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
    } else {
        
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                    error:nil];
        
        MTFileViewCell *cell = [tableView dequeueCellWithStyle:UITableViewCellStyleDefault
                                                    identifier:fileIdentifier];
        
        cell.nameLabel.text = fileName;
        cell.sizeLabel.text = [self fileSizeFromValue:[attributes fileSize]];
        cell.dateLabel.text = [self dateStringWithAttributes:attributes];
        
        return cell;
    }

    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDirectoryAtIndexPath:indexPath]) {
        return 44.f;
    } else {
        return 80.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isDirectoryAtIndexPath:indexPath]) {
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
        
        // расматриваем разные варианты создания котроллера на стеке и передачи ему параметров:
        /*
        MTDirectoryViewController *vc = [[MTDirectoryViewController alloc] initWithFolder:path];
        [self.navigationController pushViewController:vc animated:YES];
        */
        
        /*
         // этот способ более приемлем в данном случае:
        UIStoryboard *storyboard = self.storyboard;
        MTDirectoryViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MTDirectoryViewController"];
        vc.path = path;
        [self.navigationController pushViewController:vc animated:YES];
         */
        
        self.selectedPath = path;
        [self performSegueWithIdentifier:@"navigationDeep" sender:nil];
    }
}

#pragma mark -
#pragma mark Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    MTDirectoryViewController *vc = segue.destinationViewController;
    vc.path = self.selectedPath;
}

@end
