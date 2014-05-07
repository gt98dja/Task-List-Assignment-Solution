//
//  Task.h
//  Task List Assignment
//
//  Created by Daniel Jansson on 2014-05-06.
//  Copyright (c) 2014 Daniel Jansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (strong, nonatomic) NSString *taskTitle;
@property (strong, nonatomic) NSString *taskDescription;
@property (strong, nonatomic) NSDate *taskDate;
@property (nonatomic) BOOL taskCompletion;

-(id)initWithData:(NSDictionary *)data;

@end
