//
//  EditTaskViewController.h
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol EditTaskViewControllerDelegate <NSObject>

@required

- (void)didSaveEdit:(Task *)editedTask destinationIndexPath:(NSIndexPath *)indexPath;

@end

@interface EditTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) id <EditTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (strong, nonatomic) IBOutlet UITextView *taskInfoTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *taskDatePicker;
@property (strong, nonatomic) IBOutlet UIButton *completeTaskButton;

@property (strong, nonatomic) Task *editTask;
@property (strong, nonatomic) NSIndexPath *sourceIndexPath;

- (IBAction)saveEditTaskButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)completeTaskButtonPressed:(UIButton *)sender;

@end
