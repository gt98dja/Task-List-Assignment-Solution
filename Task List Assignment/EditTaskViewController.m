//
//  EditTaskViewController.m
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import "EditTaskViewController.h"

@interface EditTaskViewController ()

@end

@implementation EditTaskViewController

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
    self.taskTitleTextField.text = self.editTask.taskTitle;
    self.taskInfoTextView.text = self.editTask.taskDescription;
    self.taskDatePicker.date = self.editTask.taskDate;
    self.taskTitleTextField.delegate = self;
    self.taskInfoTextView.delegate = self;
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

- (IBAction)saveEditTaskButtonPressed:(UIBarButtonItem *)sender
{
    self.editTask.taskTitle = self.taskTitleTextField.text;
    self.editTask.taskDescription = self.taskInfoTextView.text;
    self.editTask.taskDate = self.taskDatePicker.date;
    [self.delegate didSaveEdit:self.editTask destinationIndexPath:self.sourceIndexPath];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
