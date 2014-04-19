//
//  ViewController.m
//  PWParallaxScrollView
//
//  Created by wpsteak on 13/9/8.
//  Copyright (c) 2013年 wpsteak. All rights reserved.
//

#import "ViewController.h"
#import "PWParallaxScrollView.h"

@interface ViewController () <PWParallaxScrollViewDataSource, PWParallaxScrollViewDelegate>

@property (nonatomic, strong) PWParallaxScrollView *scrollView;
@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@end

@implementation ViewController

- (IBAction)prev:(id)sender
{
    [_scrollView prevItem];
}

- (IBAction)next:(id)sender
{
    [_scrollView nextItem];
}

- (IBAction)jumpToItem:(id)sender
{
    [_scrollView moveToIndex:3];
}

#pragma mark - PWParallaxScrollViewSource

- (NSInteger)numberOfItemsInScrollView:(PWParallaxScrollView *)scrollView
{
    self.pageControl.numberOfPages = [self.photos count];
    return self.pageControl.numberOfPages;
}

- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.photos[index]]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 300, 70)];
    [label setBackgroundColor:[UIColor blackColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont boldSystemFontOfSize:60.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"Title %@", @(index + 1)]];
    [label setAlpha:0.7f];
    [label setUserInteractionEnabled:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:label.bounds];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview:button];
    
    return label;
}

- (void)test
{
    NSLog(@"hit test");
}

#pragma mark - PWParallaxScrollViewDelegate

- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didChangeIndex:(NSInteger)index
{
    _pageControl.currentPage = index;
}

- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didEndDeceleratingAtIndex:(NSInteger)index
{
    
}

#pragma mark - view's life cycle

- (void)initControl
{
    self.scrollView = [[PWParallaxScrollView alloc] initWithFrame:self.view.bounds];

//    _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsZero;
    _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 100);
    [self.view insertSubview:_scrollView atIndex:0];
}

- (void)setContent:(id)content
{
    self.photos = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg"];
}

- (void)reloadData
{
    _scrollView.delegate = self;
    _scrollView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initControl];
    [self setContent:nil];
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
