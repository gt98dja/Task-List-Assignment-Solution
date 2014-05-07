//
//  DetailTaskViewController.h
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "EditTaskViewController.h"

@interface DetailTaskViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (strong, nonatomic) IBOutlet UITextView *taskDetailView;

@property (strong, nonatomic) Task *detailTask;
@property (strong, nonatomic) NSIndexPath *sourceIndexPath;

- (IBAction)editTaskButtonPressed:(UIBarButtonItem *)sender;

@end
