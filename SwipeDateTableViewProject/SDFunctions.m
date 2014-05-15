//
//  SDFunctions.m
//  SwipeDateTableViewProject
//
//  Created by Benji on 14/05/2014.
//  Copyright (c) 2014 BC. All rights reserved.
//

#import "SDFunctions.h"

@implementation SDFunctions

+ (UIImage *)grabView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if ([view class] == [UITableView class]) {
        CGPoint contentOffset = [(UITableView *)view contentOffset];
        CGContextTranslateCTM(ctx, 0, -contentOffset.y);
    }
    else {
        CGContextTranslateCTM(ctx, 0, 0);
    }
    
    [view.layer renderInContext:ctx];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

+ (NSInteger)daysDifferenceBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2
{
    date1 = [self dateLessTime:date1];
    date2 = [self dateLessTime:date2];
    
    //Get days difference
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    
    return [components day];
}

+ (NSDate *)dateLessTime:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    return [calendar dateFromComponents:components];
}

@end