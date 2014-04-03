PWParallaxScrollView
====================

PWParallaxScrollView is a library that provide a simple way to implement sliding menu of WWF-like style

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/git/screenshot.gif)

##Usage

#####import header

```
#import "PWParallaxScrollView.h"
```

#####follow PWParallaxScrollViewDataSource protocol

```
@interface ViewController <PWParallaxScrollViewDataSource>
```

#####implement PWParallaxScrollViewDataSource methods 

```
- (NSInteger)numberOfItemsInScrollView:(PWParallaxScrollView *)scrollView;
- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView;
- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView;

```
#####setting ForegroundScreenEdgeInsets



##About ForegroundScreenEdgeInsets
###custom your parallax offset

##### foregroundScreenEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 100);

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/git/edgeinsets.gif)

#####sample code

```
    self.scrollView = [[PWParallaxScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 100);
    [self.view insertSubview:_scrollView atIndex:0];
    
```
```
- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 300, 70)];

	...
	    
    return label;
}
```
###Normal

##### foregroundScreenEdgeInsets = UIEdgeInsetsZero;

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/git/edgeinsets1.gif)

#####sample code

```
    self.scrollView = [[PWParallaxScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsZero;
    [self.view insertSubview:_scrollView atIndex:0];
    
```
```
- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 300, 70)];

	...
	    
    return label;
}
```

##hit test

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/git/screenshot1.gif)

```
- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 300, 70)];
	...
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	...
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    ...
    [label addSubview:button];
    
    return label;
}
```

##moveToIndex , prev , next

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/git/screenshot3.gif)
#####sample code

```
    [scrollView moveToIndex:3];
```

```
    [scrollView prevItem];
```

```
    [scrollView nextItem];
```

##background view only

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/git/screenshot4.gif)

#####just not implement the foregroundViewAtIndex:scrollView: method (or return nil)

```
- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView;


```


## MIT License
see license file
