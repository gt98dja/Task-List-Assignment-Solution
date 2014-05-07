//
//  Task.m
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import "Task.h"

@implementation Task

-(id)init
{
    self = [self initWithData:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    self.taskTitle = data[TASK_TITLE];
    self.taskDescription = data[TASK_DESCRIPTION];
    self.taskDate = data[TASK_DATE];
    self.taskCompletion = [data[TASK_COMPLETION] boolValue];
    
    return self;
}

@end
