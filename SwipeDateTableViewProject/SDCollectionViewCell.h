//
//  SDCollectionViewCell.h
//  SwipeDateTableViewProject
//
//  Created by Benji on 09/05/2014.
//  Copyright (c) 2014 BC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SDCollectionViewCellDelegate <NSObject>

@optional
- (void)swipeDateCollectionViewCell:(UICollectionViewCell *)cell didTriggerStep:(NSInteger)step;
- (void)swipeDateCollectionViewCellBeganDragging:(UICollectionViewCell *)cell;
- (void)swipeDateCollectionViewCellEndedDragging:(UICollectionViewCell *)cell;
@end

@interface SDCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate> {
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

@property (nonatomic, weak) id <SDCollectionViewCellDelegate> delegate;

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