//
//  SDCollectionViewController.m
//  SwipeDateTableViewProject
//
//  Created by Benji on 09/05/2014.
//  Copyright (c) 2014 BC. All rights reserved.
//

#import "SDCollectionViewController.h"

@implementation SDCollectionViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Basic SDCollectionViewCell implementation code

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SDCollectionViewCell" forIndexPath:indexPath];
    
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
    [cell setTimelineDatePadding:-6];
    [cell setTimelineScrollingMultiplier:2];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

-(void)swipeDateCollectionViewCell:(SDCollectionViewCell *)cell didTriggerStep:(NSInteger)step
{
    NSLog(@"Selected day %ld", (long)step);
}

@end