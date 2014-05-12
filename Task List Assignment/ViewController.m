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

- (NSMutableArray *)addedTasks
{
    if (!_addedTasks) {
        _addedTasks = [[NSMutableArray alloc] init];
    }
    return _addedTasks;
}

- (NSMutableArray *)compleatedTasks
{
    if (!_compleatedTasks) {
        _compleatedTasks = [[NSMutableArray alloc] init];
    }
    return _compleatedTasks;
}

- (NSMutableArray *)overdueTasks
{
    if (!_overdueTasks) {
        _overdueTasks = [[NSMutableArray alloc] init];
    }
    return _overdueTasks;
}

- (NSMutableArray *)toDoTasks
{
    if (!_toDoTasks) {
        _toDoTasks = [[NSMutableArray alloc] init];
    }
    return _toDoTasks;
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
    
    [self sortTasksIntoArrays];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sortTasksIntoArrays];
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
        
        switch (senderIndex.section)
        {
            case 0:
                detailVC.detailTask = self.overdueTasks[senderIndex.row];
                [self.overdueTasks removeObjectAtIndex:senderIndex.row];
                break;
                
            case 1:
                detailVC.detailTask = self.toDoTasks[senderIndex.row];
                [self.toDoTasks removeObjectAtIndex:senderIndex.row];
                break;
                
            case 2:
                detailVC.detailTask = self.compleatedTasks[senderIndex.row];
                [self.compleatedTasks removeObjectAtIndex:senderIndex.row];
                break;
                
            default:
                break;
        }
        
        detailVC.sourceIndexPath = senderIndex;
        detailVC.delegate = self;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [self.overdueTasks count];
            break;
            
        case 1:
            return [self.toDoTasks count];
            break;
            
        case 2:
            return [self.compleatedTasks count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self sortTasksIntoArrays];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    Task *tempTask = [[Task alloc] init];
    
    switch (indexPath.section)
    {
        case 0:
            tempTask = self.overdueTasks[indexPath.row];
            break;
        
        case 1:
            tempTask = self.toDoTasks[indexPath.row];
            break;
            
        case 2:
            tempTask = self.compleatedTasks[indexPath.row];
            break;
            
        default:
            break;
    }
    
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
            cell.backgroundColor = [UIColor colorWithHue:0.0 saturation:1.0 brightness:0.8 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:12]];
        }
        else if (dateDifference >= 0 && dateDifference < 86400)
        {
            //cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.7 blue:0.2 alpha:(1/(dateDifference/3600))];
            cell.backgroundColor = [UIColor colorWithHue:(0.19 - (864/dateDifference)) saturation:1.0 brightness:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        }
        else
        {
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        }
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:0.7 green:1.0 blue:0.7 alpha:1.0];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
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

- (void)sortTasksIntoArrays
{
    [self.compleatedTasks removeAllObjects];
    [self.overdueTasks removeAllObjects];
    [self.toDoTasks removeAllObjects];
    
    for (Task *task in self.addedTasks) {
        if (task.taskCompletion) {
            [self.compleatedTasks addObject:task];
        }
        else
        {
            NSDate *today = [[NSDate alloc] init];
            double dateDifference = [task.taskDate timeIntervalSinceDate:today];
            
            if (dateDifference < 0)
            {
                [self.overdueTasks addObject:task];
            }
            else
            {
                [self.toDoTasks addObject:task];
            }
        }
    }
}

- (void)mergeTaskArraysIntoAddedTasksArray
{
    [self.addedTasks removeAllObjects];
    for (Task *task in self.overdueTasks) {
        [self.addedTasks addObject:task];
    }
    for (Task *task in self.toDoTasks) {
        [self.addedTasks addObject:task];
    }
    for (Task *task in self.compleatedTasks) {
        [self.addedTasks addObject:task];
    }
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Push to Task Details" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Task *selectedTask = [[Task alloc] init];
    
    switch (indexPath.section)
    {
        case 0:
            selectedTask = self.overdueTasks[indexPath.row];
            [self.overdueTasks removeObjectAtIndex:indexPath.row];
            selectedTask.taskCompletion = YES;
            [self.compleatedTasks insertObject:selectedTask atIndex:0];
            break;
            
        case 1:
            selectedTask = self.toDoTasks[indexPath.row];
            [self.toDoTasks removeObjectAtIndex:indexPath.row];
            selectedTask.taskCompletion = YES;
            [self.compleatedTasks insertObject:selectedTask atIndex:0];
            break;
            
        case 2:
        {
            selectedTask = self.compleatedTasks[indexPath.row];
            [self.compleatedTasks removeObjectAtIndex:indexPath.row];
            selectedTask.taskCompletion = NO;
            NSDate *today = [[NSDate alloc] init];
            double dateDifference = [selectedTask.taskDate timeIntervalSinceDate:today];
            if (dateDifference < 0)
            {
                [self.overdueTasks insertObject:selectedTask atIndex:0];
            }
            else
            {
                [self.toDoTasks insertObject:selectedTask atIndex:0];
            }
            break;
        }
        
        default:
            break;
    }
    
    [self mergeTaskArraysIntoAddedTasksArray];
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
    Task *reorderdTask = [[Task alloc] init];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        switch (sourceIndexPath.section)
        {
            case 0:
                reorderdTask = self.overdueTasks[sourceIndexPath.row];
                [self.overdueTasks removeObjectAtIndex:sourceIndexPath.row];
                [self.overdueTasks insertObject:reorderdTask atIndex:destinationIndexPath.row];
                break;
                
            case 1:
                reorderdTask = self.toDoTasks[sourceIndexPath.row];
                [self.toDoTasks removeObjectAtIndex:sourceIndexPath.row];
                [self.toDoTasks insertObject:reorderdTask atIndex:destinationIndexPath.row];
                break;
                
            case 2:
                reorderdTask = self.compleatedTasks[sourceIndexPath.row];
                [self.compleatedTasks removeObjectAtIndex:sourceIndexPath.row];
                [self.compleatedTasks insertObject:reorderdTask atIndex:destinationIndexPath.row];
                break;
                
            default:
                break;
        }
    }
    
    
    [self mergeTaskArraysIntoAddedTasksArray];
    [self saveAddedTasksInUserDefaults];
    
    [self.taskTableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        switch (indexPath.section)
        {
            case 0:
                [self.overdueTasks removeObjectAtIndex:indexPath.row];
                break;
                
            case 1:
                [self.toDoTasks removeObjectAtIndex:indexPath.row];
                break;
                
            case 2:
                [self.compleatedTasks removeObjectAtIndex:indexPath.row];
                break;
                
            default:
                break;
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self mergeTaskArraysIntoAddedTasksArray];
        [self saveAddedTasksInUserDefaults];
        
        [self.taskTableView reloadData];
        
        //
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
    [self sortTasksIntoArrays];
    [self.taskTableView reloadData];
}

#pragma mark - EditTaskVC Delegate

- (void) didSaveEdit:(Task *)editedTask destinationIndexPath:(NSIndexPath *)indexPath
{
    if (editedTask.taskCompletion) {
        [self.compleatedTasks insertObject:editedTask atIndex:0];
    }
    else
    {
        NSDate *today = [[NSDate alloc] init];
        double dateDifference = [editedTask.taskDate timeIntervalSinceDate:today];
        
        if (dateDifference < 0)
        {
            [self.overdueTasks insertObject:editedTask atIndex:0];
        }
        else
        {
            [self.toDoTasks insertObject:editedTask atIndex:0];
        }
    }
    
    [self mergeTaskArraysIntoAddedTasksArray];
    [self saveAddedTasksInUserDefaults];
    
    [self.taskTableView reloadData];
}

#pragma mark - DetailTaskVC Delegate

- (Task *)getUpdatedDetails:(NSIndexPath *)forIndexPath
{
    switch (forIndexPath.section)
    {
        case 0:
            return self.overdueTasks[forIndexPath.row];
            break;
            
        case 1:
            return self.toDoTasks[forIndexPath.row];
            break;
            
        case 2:
            return self.compleatedTasks[forIndexPath.row];
            break;
            
        default:
            return [[Task alloc] initWithData:nil];
            break;
    }
}

@end
