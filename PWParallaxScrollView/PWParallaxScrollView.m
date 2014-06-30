//
//  PWParallaxScrollView.m
//  PWParallaxScrollView
//
//  Created by wpsteak on 13/6/16.
//  Copyright (c) 2013年 wpsteak. All rights reserved.
//

#import "PWParallaxScrollView.h"

static const NSInteger PWInvalidPosition = -1;

@interface PWParallaxScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger backgroundViewIndex;
@property (nonatomic, assign) NSInteger userHoldingDownIndex;

@property (nonatomic, strong) UIScrollView *touchScrollView;
@property (nonatomic, strong) UIScrollView *foregroundScrollView;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;

@property (nonatomic, strong) UIView *currentBottomView;

@property (nonatomic, assign) NSInteger currentIndex;

- (void)touchScrollViewTapped:(id)sender;

@end

@implementation PWParallaxScrollView

#pragma mark

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initControl];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initControl];
    }
    return self;
}

- (void)setDataSource:(id<PWParallaxScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)setForegroundScreenEdgeInsets:(UIEdgeInsets)foregroundScrollViewEdgeInsets
{
    _foregroundScreenEdgeInsets = foregroundScrollViewEdgeInsets;
    [_foregroundScrollView setFrame:UIEdgeInsetsInsetRect(self.bounds, _foregroundScreenEdgeInsets)];
}

- (void)initControl
{
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    
    self.touchScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _touchScrollView.delegate = self;
    _touchScrollView.pagingEnabled = YES;
    _touchScrollView.backgroundColor = [UIColor clearColor];
    _touchScrollView.contentOffset = CGPointMake(0, 0);
    _touchScrollView.multipleTouchEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollViewTapped:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_touchScrollView addGestureRecognizer:tapGestureRecognize];
    
    self.foregroundScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _foregroundScrollView.scrollEnabled = NO;
    _foregroundScrollView.clipsToBounds = NO;
    _foregroundScrollView.backgroundColor = [UIColor clearColor];
    _foregroundScrollView.contentOffset = CGPointMake(0, 0);
    
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _backgroundScrollView.pagingEnabled = YES;
    _backgroundScrollView.backgroundColor = [UIColor clearColor];
    _backgroundScrollView.contentOffset = CGPointMake(0, 0);
    
    [self addSubview:_backgroundScrollView];
    [self addSubview:_foregroundScrollView];
    [self addSubview:_touchScrollView];
}

#pragma mark - public method

- (void)moveToIndex:(NSInteger)index
{
    CGFloat newOffsetX = index * CGRectGetWidth(_touchScrollView.frame);
    [_touchScrollView scrollRectToVisible:CGRectMake(newOffsetX, 0, CGRectGetWidth(_touchScrollView.frame), CGRectGetHeight(_touchScrollView.frame)) animated:YES];
}

- (void)prevItem
{
    if (self.currentIndex > 0) {
        [self moveToIndex:self.currentIndex - 1];
    }
}

- (void)nextItem
{
    if (self.currentIndex < _numberOfItems - 1) {
        [self moveToIndex:self.currentIndex + 1];
    }
}

- (void)reloadData
{
    self.backgroundViewIndex = 0;
    self.userHoldingDownIndex = 0;
    self.numberOfItems = [self.dataSource numberOfItemsInScrollView:self];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) * _numberOfItems, CGRectGetHeight(self.frame))];
    contentView.backgroundColor = [UIColor clearColor];
    
    [_backgroundScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_backgroundScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_backgroundScrollView addSubview:contentView];
    [_backgroundScrollView setContentSize:contentView.frame.size];
    
    [_foregroundScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_foregroundScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_foregroundScrollView setContentSize:CGSizeMake(CGRectGetWidth(_foregroundScrollView.frame) * _numberOfItems, CGRectGetHeight(_foregroundScrollView.frame))];
    
    [_touchScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_touchScrollView setContentSize:contentView.frame.size];
    
    [self loadBackgroundViewAtIndex:0];
    
    for (NSInteger i = 0; i < _numberOfItems; i++) {
        [self loadForegroundViewAtIndex:i];
    }
}

#pragma mark - private method
- (void)touchScrollViewTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(parallaxScrollView:didRecieveTapAtIndex:)]) {
        [self.delegate parallaxScrollView:self didRecieveTapAtIndex:self.currentIndex];
    }
}

- (UIView *)foregroundViewAtIndex:(NSInteger)index
{
    if (index < 0 || index >= _numberOfItems) {
        return nil;
    }
    
    if (![self.dataSource respondsToSelector:@selector(foregroundViewAtIndex:scrollView:)]) {
        return nil;
    }
    
    UIView *view = [self.dataSource foregroundViewAtIndex:index scrollView:self];
    CGRect newFrame = view.frame;
    newFrame.origin.x += index * CGRectGetWidth(_foregroundScrollView.frame);
    [view setFrame:newFrame];
    [view setTag:index];
    
    return view;
}

- (UIView *)backgroundViewAtIndex:(NSInteger)index
{
    if (index < 0 || index >= _numberOfItems) {
        return nil;
    }
    
    UIView *view = [self.dataSource backgroundViewAtIndex:index scrollView:self];
    [view setFrame:CGRectMake(index * CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [view setTag:index];
    
    return view;
}

- (void)loadForegroundViewAtIndex:(NSInteger)index
{
    UIView *newParallaxView = [self foregroundViewAtIndex:index];
    
    [_foregroundScrollView addSubview:newParallaxView];
}

- (void)loadBackgroundViewAtIndex:(NSInteger)index
{
    [[_backgroundScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *newTopView = [self backgroundViewAtIndex:index];
    [_backgroundScrollView addSubview:newTopView];
}

- (void)determineBackgroundView:(float)offsetX
{
    CGFloat newCenterX = 0;
    NSInteger newBackgroundViewIndex = 0;
    NSInteger midPoint = CGRectGetWidth(self.frame) * _userHoldingDownIndex;
    
    if (offsetX < midPoint) {
        //moving from left to right
        
        newCenterX = (CGRectGetWidth(self.frame) * _userHoldingDownIndex - offsetX) / 2;
        newBackgroundViewIndex = _userHoldingDownIndex - 1;
    }
    else if (offsetX > midPoint) {
        //moving from right to left
        
        CGFloat leftSplitWidth = CGRectGetWidth(self.frame) * (_userHoldingDownIndex + 1) - offsetX;
        CGFloat rightSplitWidth = CGRectGetWidth(self.frame) - leftSplitWidth;
        
        newCenterX = rightSplitWidth / 2 + leftSplitWidth;
        newBackgroundViewIndex = _userHoldingDownIndex + 1;
    }
    else {
        newCenterX = CGRectGetWidth(self.frame) / 2 ;
        newBackgroundViewIndex = _backgroundViewIndex;
    }
    
    BOOL backgroundViewIndexChanged = (newBackgroundViewIndex == _backgroundViewIndex) ? NO : YES;
    self.backgroundViewIndex = newBackgroundViewIndex;
    
    if (_userHoldingDownIndex >= 0 && _userHoldingDownIndex <= _numberOfItems) {
        if (backgroundViewIndexChanged) {
            [_currentBottomView removeFromSuperview];
            self.currentBottomView = nil;
            
            UIView *newBottomView = [self backgroundViewAtIndex:_backgroundViewIndex];
            self.currentBottomView = newBottomView;
            [self insertSubview:self.currentBottomView atIndex:0];
        }
    }
    
    CGPoint center = CGPointMake(newCenterX, CGRectGetHeight(self.frame) / 2);
    self.currentBottomView.center = center;
}

- (NSInteger)backgroundViewIndexFromOffset:(CGPoint)offset
{
    NSInteger index = (offset.x / CGRectGetWidth(self.frame));
    
    if (index >= _numberOfItems || index < 0) {
        index = PWInvalidPosition;
    }
    
    return index;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_backgroundScrollView setContentOffset:scrollView.contentOffset];
    
    CGFloat factor = _foregroundScrollView.contentSize.width / scrollView.contentSize.width;
    [_foregroundScrollView setContentOffset:CGPointMake(factor * scrollView.contentOffset.x, 0)];
    
    CGFloat offsetX = scrollView.contentOffset.x;
    [self determineBackgroundView:offsetX];
    
    CGRect visibleRect;
    visibleRect.origin = scrollView.contentOffset;
    visibleRect.size = scrollView.bounds.size;
    
    CGRect userPenRect;
    CGFloat width = CGRectGetWidth(scrollView.frame);
    userPenRect.origin = CGPointMake(width * self.userHoldingDownIndex, 0);
    userPenRect.size = scrollView.bounds.size;
    
    if (!CGRectIntersectsRect(visibleRect, userPenRect)) {
        if (CGRectGetMinX(visibleRect) - CGRectGetMinX(userPenRect) > 0) {
            self.userHoldingDownIndex = _userHoldingDownIndex + 1;
        }
        else {
            self.userHoldingDownIndex = _userHoldingDownIndex - 1;
        }
        
        [self loadBackgroundViewAtIndex:_userHoldingDownIndex];
    }
    
    CGFloat newCrrentIndex = round(1.0f * scrollView.contentOffset.x / CGRectGetWidth(self.frame));
    
    if(_currentIndex != newCrrentIndex) {
        self.currentIndex = newCrrentIndex;
        
        if([self.delegate respondsToSelector:@selector(parallaxScrollView:didChangeIndex:)]){
            [self.delegate parallaxScrollView:self didChangeIndex:self.currentIndex];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(parallaxScrollView:didEndDeceleratingAtIndex:)]){
        [self.delegate parallaxScrollView:self didEndDeceleratingAtIndex:self.currentIndex];
    }
}

#pragma mark hitTest
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *subview in _foregroundScrollView.subviews) {
        CGPoint convertedPoint = [self convertPoint:point toView:subview];
        UIView *result = [subview hitTest:convertedPoint withEvent:event];
        
        if ([result isKindOfClass:[UIButton class]]){
            return result;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

@end
