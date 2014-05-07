//
//  AddTaskViewController.m
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import "AddTaskViewController.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.taskTitleTextField.delegate = self;
    self.taskDetailTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addTaskButtonPressed:(UIButton *)sender
{
    Task *newTask = [[Task alloc] initWithData:@{TASK_TITLE: self.taskTitleTextField.text, TASK_DESCRIPTION: self.taskDetailTextView.text, TASK_DATE: self.taskDatePicker.date, TASK_COMPLETION: @NO}];
    [self.delegate didAddTask:newTask];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self.delegate didCancel];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView Delegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

@end
