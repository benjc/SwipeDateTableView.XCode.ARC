//
//  SDCollectionViewCell.m
//  SwipeDateTableViewProject
//
//  Created by Benji on 09/05/2014.
//  Copyright (c) 2014 BC. All rights reserved.
//

#import "SDCollectionViewCell.h"

#import "SDDateView.h"
#import "SDFunctions.h"

@implementation SDCollectionViewCell

@synthesize delegate;

@synthesize timelineView;
@synthesize timelineLeftShadowView;
@synthesize timelineRightShadowView;
@synthesize fakeCellImageView;
@synthesize fakeCellImageViewOverlayView;

@synthesize timelineScrollingMultiplier;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //Defaults
        _timelinePadding = 60;
        _timelineDatePadding = -6;
        timelineScrollingMultiplier = 2;
        
        timelineDateHeight = 44;
        timelineDateWidth = 40;

        scaleableAreaWidth = 30; //This is the width of the area around the timeline focus where a date is scaled beyond the smallest size
        maxSizeArea = 10; //This is the width of the area around the timeline focus where we lock the day into max size
        
        fromDate = [SDFunctions dateLessTime:[NSDate date]];
        toDate = fromDate;
        
        isInActiveArea = NO;
        
        frameWidth = self.frame.size.width;
        frameHeight = self.frame.size.height;
        
        //Fake cell image view
        fakeCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
        fakeCellImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [fakeCellImageView setClipsToBounds:YES];
        [self addSubview:fakeCellImageView];
        
        //Fake cell image view overlay view (darkens the fake cell image view)
        fakeCellImageViewOverlayView = [[UIImageView alloc] initWithFrame:fakeCellImageView.frame];
        [fakeCellImageViewOverlayView setBackgroundColor:[UIColor blackColor]];
        [fakeCellImageViewOverlayView setAlpha:0];
        [fakeCellImageView addSubview:fakeCellImageViewOverlayView];
        
        //Timeline left shadow view
        timelineLeftShadowView = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth, 0, 4, frameHeight)];
        [timelineLeftShadowView setBackgroundColor:[UIColor blackColor]];
        [timelineLeftShadowView setAlpha:0];
        [self addSubview:timelineLeftShadowView];
        [self sendSubviewToBack:timelineLeftShadowView];
        
        //Timeline right shadow view
        timelineRightShadowView = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth - 4, 0, 4, frameHeight)];
        [timelineRightShadowView setBackgroundColor:[UIColor blackColor]];
        [timelineRightShadowView setAlpha:0];
        [self addSubview:timelineRightShadowView];
        [self sendSubviewToBack:timelineRightShadowView];
        
        //Timeline view
        timelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self timelineWidth], frameHeight)];
        [timelineView setBackgroundColor:[UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1]]; //This sets the background colour beneath the dragged cell
        [timelineView setAlpha:0];
        [self addSubview:timelineView];
        [self sendSubviewToBack:timelineView];
        
        UIPanGestureRecognizer *swipeLeft = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        swipeLeft.delegate = self;
        [self addGestureRecognizer:swipeLeft];
    }
    
    return self;
}

-(CGFloat)timelineWidth
{
    return frameWidth + _timelinePadding + ((timelineDateWidth + _timelineDatePadding) * ([timelineDateViews count] - 1)) + frameWidth;
}

-(void)setTimelineRangeFrom:(NSDate *)newFromDate to:(NSDate *)newToDate
{
    NSInteger daysBetweenFromDates = [SDFunctions daysDifferenceBetweenDate:fromDate andDate:newFromDate];
    NSInteger daysBetweenToDates = [SDFunctions daysDifferenceBetweenDate:toDate andDate:newToDate];
    
    if ((daysBetweenFromDates != 0) || (daysBetweenToDates != 0)) {
        fromDate = newFromDate;
        toDate = newToDate;
        
        for (SDDateView *dateView in timelineDateViews) {
            [dateView removeFromSuperview];
        }
        
        [timelineDateViews removeAllObjects];
        timelineDateViews = [[NSMutableArray alloc] init];

        NSInteger noDaysInRange = [SDFunctions daysDifferenceBetweenDate:fromDate andDate:toDate] + 1;
        
        CGFloat dateViewTop = (frameHeight - timelineDateHeight) / 2;
        
        for (int dateViewIndex = 0; dateViewIndex < noDaysInRange; dateViewIndex++)
        {
            CGFloat dateViewLeft = frameWidth + _timelinePadding + ((timelineDateWidth + _timelineDatePadding) * dateViewIndex);
            NSDate *date = [fromDate dateByAddingTimeInterval:60 * 60 * 24 * dateViewIndex];
            
            SDDateView *dateView = [[SDDateView alloc] initWithFrame:CGRectMake(dateViewLeft, dateViewTop, timelineDateWidth, timelineDateHeight) andDate:date];
            [timelineView addSubview:dateView];
            
            [timelineDateViews addObject:dateView];
        }
        
        [timelineView setFrame:CGRectMake(0, 0, [self timelineWidth], frameHeight)];
    }
}

-(void)setTimelinePadding:(CGFloat)timelinePadding
{
    _timelinePadding = timelinePadding;
    
    [self redrawTimeline];
}

-(void)setTimelineDatePadding:(CGFloat)timelineDatePadding
{
    _timelineDatePadding = timelineDatePadding;
    
    [self redrawTimeline];
}

-(void)redrawTimeline
{
    CGFloat dateViewTop = (frameHeight - timelineDateHeight) / 2;
    
    for (int dateViewIndex = 0; dateViewIndex < [timelineDateViews count]; dateViewIndex++)
    {
        SDDateView *dateView = [timelineDateViews objectAtIndex:dateViewIndex];
        
        CGFloat dateViewLeft = frameWidth + _timelinePadding + ((timelineDateWidth + _timelineDatePadding) * dateViewIndex);
        
        [dateView setFrame:CGRectMake(dateViewLeft, dateViewTop, timelineDateWidth, timelineDateHeight)];
    }
    
    [timelineView setFrame:CGRectMake(0, 0, [self timelineWidth], frameHeight)];
}

-(void)setDateEnabled:(BOOL)enabled atIndex:(NSInteger)index
{
    if (index < [timelineDateViews count]) {
        SDDateView *dateView = [timelineDateViews objectAtIndex:index];
        
        [dateView setEnabled:enabled];
    }
}

-(void)swipeLeft:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self];
    CGFloat currentX = translatedPoint.x;
    CGFloat dragLength = startX - currentX;
    
    if (dragLength < 0) {
        dragLength = 0;
    }
    
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan:
            begunDrag = NO;
            startX = currentX;
            
            if (delegate != nil && [delegate respondsToSelector:@selector(swipeDateCollectionViewCellBeganDragging:)]) {
                [delegate swipeDateCollectionViewCellBeganDragging:self];
            }
            
            break;
            
        case UIGestureRecognizerStateChanged:
            if((!begunDrag) && (dragLength > 0)) {
                [self setSelected:NO];
                [fakeCellImageView setImage:[SDFunctions grabView:self]];
                [fakeCellImageView setAlpha:1];
                [timelineView setAlpha:1];
                [timelineLeftShadowView setAlpha:0.3];
                [timelineRightShadowView setAlpha:0.3];
                [self.contentView setAlpha:0];
                
                CGFloat fakeCellImageViewLeft = frameWidth / 50;
                CGFloat fakeCellImageViewTop = frameHeight / 50;
                CGFloat fakeCellImageViewWidth = (frameWidth / 25) * 24;
                CGFloat fakeCellImageViewHeight = (frameHeight / 25) * 24;
                CGRect fakeCellImageViewFrame = CGRectMake(fakeCellImageViewLeft, fakeCellImageViewTop, fakeCellImageViewWidth, fakeCellImageViewHeight);
                
                [UIView animateWithDuration:0.2f
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [fakeCellImageView setFrame:fakeCellImageViewFrame];
                                     [fakeCellImageViewOverlayView setAlpha:0.22f];
                                 }
                                 completion:Nil
                 ];
                
                begunDrag = YES;
            }
            
            [self drawCellAt:-dragLength];
            
            break;
            
        case UIGestureRecognizerStateEnded: {
            if (delegate != nil && [delegate respondsToSelector:@selector(swipeDateCollectionViewCellEndedDragging:)]) {
                [delegate swipeDateCollectionViewCellEndedDragging:self];
            }
            
            [timelineLeftShadowView setAlpha:0];
            [timelineRightShadowView setAlpha:0];
            
            __weak typeof(self) weakSelf = self;
            
            if (dragLength > 0) {
                CGFloat bounceDistance = -10;
                
                [UIView animateWithDuration:0.2f
                                      delay:0
                                    options:(UIViewAnimationOptionCurveEaseOut)
                                 animations:^{
                                     CGRect frame = self.contentView.frame;
                                     frame.origin.x = -bounceDistance;
                                     [fakeCellImageView setFrame:frame];
                                 }
                                 completion:^(BOOL finished1) {
                                     [UIView animateWithDuration:0.1f
                                                           delay:0
                                                         options:UIViewAnimationOptionCurveEaseIn
                                                      animations:^{
                                                          CGRect frame = self.contentView.frame;
                                                          frame.origin.x = 0;
                                                          frame.origin.y = 0;
                                                          [fakeCellImageView setFrame:frame];
                                                          [fakeCellImageViewOverlayView setAlpha:0];
                                                      }
                                                      completion:^(BOOL finished2) {
                                                          [weakSelf.contentView setAlpha:1];
                                                          [fakeCellImageView setAlpha:0];
                                                          [timelineView setAlpha:0];
                                                          
                                                          SDDateView *dateView = [timelineDateViews objectAtIndex:selectedDateIndex];
                                                          
                                                          if (isInActiveArea) {
                                                              if ([dateView _enabled]) {
                                                                  if (delegate != nil && [delegate respondsToSelector:@selector(swipeDateCollectionViewCell:didTriggerStep:)]) {
                                                                      [delegate swipeDateCollectionViewCell:weakSelf didTriggerStep:selectedDateIndex];
                                                                  }
                                                              }
                                                          }
                                                      }
                                      ];
                                 }
                 ];
            }
            else {
                [UIView animateWithDuration:0.1f
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     CGRect frame = self.contentView.frame;
                                     frame.origin.x = 0;
                                     frame.origin.y = 0;
                                     [fakeCellImageView setFrame:frame];
                                     [fakeCellImageViewOverlayView setAlpha:0];
                                 }
                                 completion:^(BOOL finished2) {
                                     [weakSelf.contentView setAlpha:1];
                                     [fakeCellImageView setAlpha:0];
                                     [timelineView setAlpha:0];
                                 }
                 ];
            }
            
            break;
        }
            
        default:
            break;
    }
}

-(void)drawCellAt:(CGFloat)left
{
    if ([timelineDateViews count] > 0) {
        CGFloat maximumLeftDrag = -(frameWidth / 5) * 4;
        if (left < maximumLeftDrag) {
            left = maximumLeftDrag;
        }
        
        CGFloat leftWithParallax = -left * timelineScrollingMultiplier;
        isInActiveArea = leftWithParallax > _timelinePadding + timelineDateWidth;
        
        CGFloat timelineVisibleWidth = left;
        CGFloat timelineLeftWithParallax = left * timelineScrollingMultiplier;
        CGFloat newTimelineFocus = -(timelineLeftWithParallax - (timelineVisibleWidth / 2));
        
        //Set focus at mid-point of visible timeline
        [self focusTimelineAt:newTimelineFocus];
        
        CGRect timelineFrame = timelineView.frame;
        
        [timelineView setFrame:CGRectMake(timelineLeftWithParallax, timelineFrame.origin.y, timelineFrame.size.width, timelineFrame.size.height)];
        
        CGRect fakeCellImageViewFrame = fakeCellImageView.frame;
        CGFloat fakeCellImageViewLeft = left + (frameWidth / 50);
        fakeCellImageViewFrame = CGRectMake(fakeCellImageViewLeft, fakeCellImageViewFrame.origin.y, fakeCellImageViewFrame.size.width, fakeCellImageViewFrame.size.height);
        
        [fakeCellImageView setFrame:fakeCellImageViewFrame];
        
        [timelineLeftShadowView setFrame:CGRectMake(fakeCellImageViewLeft + fakeCellImageViewFrame.size.width, fakeCellImageViewFrame.origin.y, 4, fakeCellImageViewFrame.size.height)];
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if ([panGestureRecognizer class] == [UIPanGestureRecognizer class]) {
        CGPoint translation = [panGestureRecognizer translationInView:[self superview]];
        
        return fabs(translation.x) > fabs(translation.y);
    }
    else {
        return NO;
    }
}

-(CGFloat)dateProximityToTimelineFocus:(NSInteger)dateIndex
{
    CGFloat dateCentre = _timelinePadding + (dateIndex * (timelineDateWidth + _timelineDatePadding)) + ((timelineDateWidth + _timelineDatePadding) / 2);
    
    return fabs(dateCentre - timelineFocus);
}

-(void)focusTimelineAt:(CGFloat)newTimelineFocus
{
    timelineFocus = newTimelineFocus;
    
    //Ensure first day is scaled fully if we're just starting to show the left edge of the timeline
    CGFloat timelineLeftEdge = _timelinePadding + ((timelineDateWidth + _timelineDatePadding) / 2);
    if (timelineFocus < timelineLeftEdge) {
        timelineFocus = timelineLeftEdge;
    }
    
    //Ensure last day is scaled fully if we've moved beyond the right edge of the timeline
    CGFloat timelineRightEdge = _timelinePadding + ((timelineDateWidth + _timelineDatePadding) * [timelineDateViews count]) - ((timelineDateWidth + _timelineDatePadding) / 2);
    if (timelineFocus > timelineRightEdge) {
        timelineFocus = timelineRightEdge;
    }
    
    CGFloat previousScale = 0;
    
    for (NSInteger dayIndex = 0; dayIndex < [timelineDateViews count]; dayIndex++) {
        CGFloat scale = 0;
        
        //This is how close this day's view centre is to the focus of the timeline
        CGFloat proximity = [self dateProximityToTimelineFocus:dayIndex];
        
        //This is how far inside the scaleable area this day's view is
        CGFloat positionXinScaleableArea = scaleableAreaWidth - proximity;
        
        //Is this day inside the scaleable area?
        if (positionXinScaleableArea > 0) {
            //Resize this day according to how close it is to the focus of the timeline
            //NOTE: We set this day to maximum scale if it's inside the maximum size area
            scale = positionXinScaleableArea / (scaleableAreaWidth - maxSizeArea);
            if (scale > 1) {
                scale = 1;
            }
        }
        
        if (scale > previousScale) {
            previousScale = scale;
            
            selectedDateIndex = dayIndex;
        }
        
        SDDateView *dateView = [timelineDateViews objectAtIndex:dayIndex];
        
        [dateView scaleTo:scale];
    }
    
    //Now select the most scaled up date view
    for (NSInteger dayIndex = 0; dayIndex < [timelineDateViews count]; dayIndex++) {
        SDDateView *selectedDateView = [timelineDateViews objectAtIndex:dayIndex];
        
        [selectedDateView setSelected:(selectedDateIndex == dayIndex)];
    }
}

@end