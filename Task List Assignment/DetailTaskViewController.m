//
//  DetailTaskViewController.m
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import "DetailTaskViewController.h"

@interface DetailTaskViewController ()

@end

@implementation DetailTaskViewController

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
    self.taskTitleLabel.text = self.detailTask.taskTitle;
    self.taskDetailView.text = self.detailTask.taskDescription;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *seLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    [dateFormatter setLocale:seLocale];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    NSString *dateString = [dateFormatter stringFromDate:self.detailTask.taskDate];
    self.taskDateLabel.text = [NSString stringWithFormat:@"%@", dateString];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Push to Edit Task"])
    {
        EditTaskViewController *editVC = segue.destinationViewController;
        editVC.editTask = self.detailTask;
        editVC.sourceIndexPath = self.sourceIndexPath;
    }
}


- (IBAction)editTaskButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"Push to Edit Task" sender:sender];
}

@end
