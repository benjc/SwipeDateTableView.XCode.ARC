//
//  SDFunctions.h
//  SwipeDateTableViewProject
//
//  Created by Benji on 14/05/2014.
//  Copyright (c) 2014 BC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDFunctions : NSObject

+ (UIImage *)grabView:(UIView *)view;
+ (NSInteger)daysDifferenceBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;
+ (NSDate *)dateLessTime:(NSDate *)date;

@end