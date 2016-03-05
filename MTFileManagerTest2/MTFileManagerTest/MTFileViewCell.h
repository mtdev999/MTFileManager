//
//  MTFileViewCell.h
//  MTFileManagerTest
//
//  Created by Mark Tezza on 28.02.16.
//  Copyright © 2016 Mark Tezza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTFileViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel  *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel  *sizeLabel;
@property (nonatomic, strong) IBOutlet UILabel  *dateLabel;

@end
