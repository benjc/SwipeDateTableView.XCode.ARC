//
//  SDTableViewCellDateView.h
//  Cinetimes
//
//  Created by Benji on 06/05/2014.
//  Copyright (c) 2014 Benji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDDateView : UIView {
    CGFloat scale;
    CGFloat scaleMax;
    CGFloat scaleMin;

    CGFloat dateViewWidth;

    CGFloat weekdayHeight;
    CGFloat weekdayTopSmallest;
    CGFloat weekdayTopLargest;

    CGFloat dateHeight;
    CGFloat dateTopSmallest;
    CGFloat dateTopLargest;

    CGFloat todayHeight;
    CGFloat todayTopSmallest;
    CGFloat todayTopLargest;

    BOOL _selected;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *todayLabel;
@property (nonatomic) BOOL _enabled;

- (id)initWithFrame:(CGRect)frame andDate:(NSDate *)date;

- (void)scaleTo:(CGFloat)newScale;

- (void)setEnabled:(BOOL)enabled;

- (void)setSelected:(BOOL)selected;

@end