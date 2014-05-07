//
//  AddTaskViewController.h
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol AddTaskViewControllerDelegate <NSObject>

@required
-(void)didCancel;
-(void)didAddTask:(Task *)task;

@end

@interface AddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) id <AddTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (strong, nonatomic) IBOutlet UITextView *taskDetailTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *taskDatePicker;

- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end
