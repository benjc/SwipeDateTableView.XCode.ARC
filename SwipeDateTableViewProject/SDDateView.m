//
//  SDTableViewCellDateView.m
//  Cinetimes
//
//  Created by Benji on 06/05/2014.
//  Copyright (c) 2014 Benji. All rights reserved.
//

#import "SDDateView.h"
#import <CoreText/CoreText.h>

@implementation SDDateView

@synthesize nameLabel;
@synthesize dateLabel;
@synthesize todayLabel;
@synthesize _enabled;

- (id)initWithFrame:(CGRect)frame andDate:(NSDate *)date
{
    self = [super initWithFrame:frame];

    if (self) {
        //Defaults
        scaleMax = 1;
        scaleMin = 0.6f;

        dateViewWidth = frame.size.width;

        weekdayHeight = 14;
        weekdayTopSmallest = 9;
        weekdayTopLargest = 3;

        dateHeight = 40;
        dateTopSmallest = 7;
        dateTopLargest = 8;

        todayHeight = 16;
        todayTopSmallest = 14;
        todayTopLargest = 14;

        [self setEnabled:YES];

        scale = -1;
        
        //Set up labels
        CGRect nameFrame = CGRectMake(0, weekdayTopLargest, dateViewWidth, weekdayHeight);
        nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:nameLabel];

        CGRect dateFrame = CGRectMake(0, dateTopLargest, dateViewWidth, dateHeight);
        dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
        [dateLabel setTextColor:[UIColor whiteColor]];
        [dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:dateLabel];

        CGRect todayFrame = CGRectMake(0, todayTopLargest, dateViewWidth, todayHeight);
        todayLabel = [[UILabel alloc] initWithFrame:todayFrame];
        [todayLabel setText:@"TODAY"];
        [todayLabel setBackgroundColor:[UIColor clearColor]];
        [todayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15]];
        [todayLabel setTextColor:[UIColor whiteColor]];
        [todayLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:todayLabel];
    }

    [self setDate:date];

    return self;
}

-(void)setDate:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:date];

    [dateLabel setText:day];

    //Get today less time data
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [NSDate date];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:today];

    today = [calendar dateFromComponents:components];

    unitFlags = NSMonthCalendarUnit| NSDayCalendarUnit;
    
    components = [calendar components:unitFlags fromDate:today toDate:date options:0];
    NSInteger daysFromToday = [components day];

    switch (daysFromToday) {
        case 0:
            [nameLabel setHidden:YES];
            [dateLabel setHidden:YES];
            [todayLabel setHidden:NO];

            break;

        default: {
            [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [formatter setDateFormat:@"EEEE"];
            NSString *weekDay = [formatter stringFromDate:date];
            weekDay = [[weekDay substringToIndex:3] uppercaseString];

            [nameLabel setText:weekDay];

            [nameLabel setHidden:NO];
            [dateLabel setHidden:NO];
            [todayLabel setHidden:YES];

            break;
        }
    }
}

- (void)scaleTo:(CGFloat)newScale
{
    if (scale != newScale) {
        scale = newScale;

        CGFloat inverseScale = 1 - newScale;

        //Week day label sizing and positioning
        newScale = ((scaleMax - scaleMin) * newScale) + scaleMin;

        CGFloat weekdayTop = ((weekdayTopSmallest - weekdayTopLargest) * inverseScale) + weekdayTopLargest;
        CGRect weekdayFrame = CGRectMake(0, weekdayTop, dateViewWidth, weekdayHeight);
        [nameLabel setFrame:weekdayFrame];
        
        nameLabel.transform = CGAffineTransformMakeScale(newScale, newScale);

        //Date label sizing and positioning
        CGFloat dateTop = ((dateTopSmallest - dateTopLargest) * inverseScale) + dateTopLargest;
        CGRect dateFrame = CGRectMake(0, dateTop, dateViewWidth, dateHeight);
        [dateLabel setFrame:dateFrame];

        dateLabel.transform = CGAffineTransformMakeScale(newScale, newScale);

        //Today label sizing and positioning
        CGFloat todayTop = ((todayTopSmallest - todayTopLargest) * inverseScale) + todayTopLargest;
        CGRect todayFrame = CGRectMake(0, todayTop, dateViewWidth, todayHeight);
        [todayLabel setFrame:todayFrame];
        
        todayLabel.transform = CGAffineTransformMakeScale(newScale, newScale);
    }
}

-(void)setSelected:(BOOL)selected
{
    selected = _enabled && selected;

    if (selected != _selected) {
        _selected = selected;
        
        UILabel *labelToUnderline;
        
        if ([todayLabel isHidden]) {
            labelToUnderline = dateLabel;
        }
        else {
            labelToUnderline = todayLabel;
        }

        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:labelToUnderline.text];

        if (selected) {
            [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                              value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                              range:(NSRange){0, [attString length]}];
        }
        else {
            [attString removeAttribute:(NSString*)kCTUnderlineStyleAttributeName range:(NSRange){0, [attString length]}];
        }

        labelToUnderline.attributedText = attString;
    }
}

-(void)setEnabled:(BOOL)enabled
{
    if (enabled != _enabled) {
        _enabled = enabled;
        
        UIColor *textColour = [UIColor grayColor];
        
        if (enabled) {
            textColour = [UIColor whiteColor];
        }

        [nameLabel setTextColor:textColour];
        [dateLabel setTextColor:textColour];
        [todayLabel setTextColor:textColour];
    }
}

@end