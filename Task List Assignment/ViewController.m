//
//  ViewController.m
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Lazy Instantiation of Properties

-(NSMutableArray *)addedTasks
{
    if (!_addedTasks) {
        _addedTasks = [[NSMutableArray alloc] init];
    }
    return _addedTasks;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.taskTableView.delegate = self;
    self.taskTableView.dataSource = self;
    
    NSArray *myTasksAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:TASK_ADDED_TASKS_KEY];
    
    for (NSDictionary *dictionary in myTasksAsPropertyLists) {
        Task *task = [self TaskForDictionary:dictionary];
        [self.addedTasks addObject:task];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self saveAddedTasksInUserDefaults];
    [self.taskTableView reloadData]; // to reload selected cell
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Modal to Add Task"])
    {
        AddTaskViewController *addVC = segue.destinationViewController;
        addVC.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"Push to Task Details"])
    {
        DetailTaskViewController *detailVC = segue.destinationViewController;
        NSIndexPath *senderIndex = sender;
        detailVC.detailTask = self.addedTasks[senderIndex.row];
        detailVC.sourceIndexPath = senderIndex;
    }
    if ([segue.identifier isEqualToString:@"Push to Edit Task"])
    {
        EditTaskViewController *editVC = segue.destinationViewController;
        editVC.delegate = self;
    }
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addedTasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    Task *tempTask = self.addedTasks[indexPath.row];
    
    cell.textLabel.text = tempTask.taskTitle;
    
    //Format the date Swedish style;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *seLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    [dateFormatter setLocale:seLocale];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    NSString *dateString = [dateFormatter stringFromDate:tempTask.taskDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", dateString];
    
    NSDate *today = [[NSDate alloc] init];
    double dateDifference = [tempTask.taskDate timeIntervalSinceDate:today];
    
    if (!tempTask.taskCompletion)
    {
        if (dateDifference < 0)
        {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        }
        else if (dateDifference >= 0 && dateDifference < 86400)
        {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.7 blue:0.2 alpha:(1/(dateDifference/3600))];
        }
        else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:0.7 green:1.0 blue:0.7 alpha:1.0];
    }
    
    
    if (tempTask.taskCompletion) [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    
    cell.showsReorderControl = YES;
    
    return cell;
}

#pragma mark - Helper Methods

- (NSDictionary *)TaskAsPropertyList:(Task *)task
{
    NSDictionary *dictionary = @{TASK_TITLE : task.taskTitle, TASK_DESCRIPTION : task.taskDescription, TASK_DATE : task.taskDate, TASK_COMPLETION : @(task.taskCompletion)};
    
    return dictionary;
}

- (Task *)TaskForDictionary:(NSDictionary *)dictionary
{
    Task *task = [[Task alloc] initWithData:dictionary];
    
    return task;
}

- (void)saveAddedTasksInUserDefaults
{
    NSMutableArray *newSavedTaskData = [[NSMutableArray alloc] init];
    for (Task *task in self.addedTasks) {
        [newSavedTaskData addObject:[self TaskAsPropertyList:task]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:newSavedTaskData forKey:TASK_ADDED_TASKS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Push to Task Details" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Task *selectedTask = self.addedTasks[indexPath.row];
    [self.addedTasks removeObjectAtIndex:indexPath.row];
    selectedTask.taskCompletion = !selectedTask.taskCompletion;
    [self.addedTasks insertObject:selectedTask atIndex:indexPath.row];
    
    [self saveAddedTasksInUserDefaults];
    
    [self.taskTableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Task *reorderdTask = self.addedTasks[sourceIndexPath.row];
    [self.addedTasks removeObjectAtIndex:sourceIndexPath.row];
    [self.addedTasks insertObject:reorderdTask atIndex:destinationIndexPath.row];
    [self saveAddedTasksInUserDefaults];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.addedTasks removeObjectAtIndex:indexPath.row];
        
        [self saveAddedTasksInUserDefaults];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - IBActions

- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"Modal to Add Task" sender:sender];
}

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender
{
    [self.taskTableView setEditing:!self.taskTableView.editing animated:YES];
    if (self.taskTableView.editing) self.reorderButton.title = @"Done";
    else self.reorderButton.title = @"Reorder";
}

#pragma mark - AddTaskVC Delegates

- (void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didAddTask:(Task *)task
{
    [self.addedTasks addObject:task];
    [self saveAddedTasksInUserDefaults];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.taskTableView reloadData];
}

#pragma mark - EditTaskVC Delegate

- (void) didSaveEdit:(Task *)editedTask destinationIndexPath:(NSIndexPath *)indexPath
{
    [self.addedTasks removeObjectAtIndex:indexPath.row];
    [self.addedTasks insertObject:editedTask atIndex:indexPath.row];
    [self saveAddedTasksInUserDefaults];
}

@end
