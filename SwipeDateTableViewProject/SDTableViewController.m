//
//  SDTableViewController.m
//  SwipeDateTableViewProject
//
//  Created by Benji on 07/05/2014.
//  Copyright (c) 2014 BC. All rights reserved.
//

#import "SDTableViewController.h"

@implementation SDTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Basic SDTableViewCell implementation code

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SDTableViewCell";
    
    SDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.delegate = self;

    //Set timeline date range for this cell
    NSDate *fromDate = [NSDate date];   //Now
    NSDate *toDate = [fromDate dateByAddingTimeInterval:(60 * 60 * 24) * 3];    //Three days on from now
    
    [cell setTimelineRangeFrom:fromDate to:toDate];
    
    //By default, all dates are enabled/selectable- use this call to override the default
    [cell setDateEnabled:NO atIndex:1];

    //Set timeline properties for this cell
    //These aren't required as they already have default values- only modify these if you need more/less space around timeline dates
    //or need to adjust the distance travelled by the timeline in relation to the user drag
    [cell setTimelinePadding:60];
    [cell setTimelineDatePadding:0];
    [cell setTimelineScrollingMultiplier:1.5];

    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(void)swipeDateTableViewCell:(SDTableViewCell *)cell didTriggerStep:(NSInteger)step
{
    NSLog(@"Selected day %ld", (long)step);
}

@end