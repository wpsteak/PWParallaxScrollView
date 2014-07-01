//
//  PSParallaxScrollView.h
//  PWParallaxScrollView
//
//  Created by wpsteak on 13/6/16.
//  Copyright (c) 2013年 wpsteak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PWParallaxScrollViewDataSource;
@protocol PWParallaxScrollViewDelegate;

@interface PWParallaxScrollView : UIView

@property (nonatomic, assign) IBOutlet id<PWParallaxScrollViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<PWParallaxScrollViewDataSource> dataSource;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, assign) UIEdgeInsets foregroundScreenEdgeInsets;

@property (nonatomic, assign) NSInteger maxAllowableItem;

- (void)prevItem;
- (void)nextItem;
- (void)moveToIndex:(NSInteger)index;
- (void)reloadData;

@end

@protocol PWParallaxScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInScrollView:(PWParallaxScrollView *)scrollView;
- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView;

@optional
- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView;

@end

@protocol PWParallaxScrollViewDelegate <NSObject>

@optional
- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didChangeIndex:(NSInteger)index;
- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didEndDeceleratingAtIndex:(NSInteger)index;
- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didRecieveTapAtIndex:(NSInteger)index;

@end


