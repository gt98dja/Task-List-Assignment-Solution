//
//  ViewController.h
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTaskViewController.h"
#import "DetailTaskViewController.h"
#import "EditTaskViewController.h"

@interface ViewController : UIViewController <AddTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, EditTaskViewControllerDelegate, DetailTaskViewControllerDelegate>

//IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *taskTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reorderButton;

//Variables
@property (strong, nonatomic) NSMutableArray *addedTasks;
@property (strong, nonatomic) NSMutableArray *compleatedTasks;
@property (strong, nonatomic) NSMutableArray *overdueTasks;
@property (strong, nonatomic) NSMutableArray *toDoTasks;
@property(nonatomic, getter=isEditing) BOOL editing;

//Actions
- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender;

@end
