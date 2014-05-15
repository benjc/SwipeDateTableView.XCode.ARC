//
//  SDTableViewCell.h
//  Cinetimes
//
//  Created by Benji on 06/05/2014.
//  Copyright (c) 2014 Benji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SDTableViewCellDelegate <NSObject>

@optional
- (void)swipeDateTableViewCell:(UITableViewCell *)cell didTriggerStep:(NSInteger)step;
- (void)swipeDateTableViewCellBeganDragging:(UITableViewCell *)cell;
- (void)swipeDateTableViewCellEndedDragging:(UITableViewCell *)cell;
@end

@interface SDTableViewCell : UITableViewCell <UIGestureRecognizerDelegate> {
    CGFloat scaleableAreaWidth;
    CGFloat maxSizeArea;

    BOOL isInActiveArea;
    
    CGFloat frameWidth;
    CGFloat frameHeight;

    CGFloat timelineDateHeight;
    CGFloat timelineDateWidth;
    CGFloat _timelinePadding;
    CGFloat _timelineDatePadding;

    CGFloat timelineFocus;
    NSMutableArray *timelineDateViews;

    NSDate *fromDate;
    NSDate *toDate;
    
    NSInteger selectedDateIndex;
    BOOL begunDrag;
    CGFloat startX;
}

@property (nonatomic, weak) id <SDTableViewCellDelegate> delegate;

@property (nonatomic, retain) UIImageView *fakeCellImageView;
@property (nonatomic, retain) UIView *fakeCellImageViewOverlayView;
@property (nonatomic, retain) UIView *timelineLeftShadowView;
@property (nonatomic, retain) UIView *timelineRightShadowView;
@property (nonatomic, retain) UIView *timelineView;

@property (nonatomic) CGFloat timelineScrollingMultiplier;

-(void)setTimelineRangeFrom:(NSDate *)newFromDate to:(NSDate *)newToDate;
-(void)setTimelinePadding:(CGFloat)timelinePadding;
-(void)setTimelineDatePadding:(CGFloat)timelineDatePadding;
-(void)setDateEnabled:(BOOL)enabled atIndex:(NSInteger)index;

@end