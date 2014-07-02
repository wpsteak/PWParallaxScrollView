PWParallaxScrollView
====================

PWParallaxScrollView is a library for creating sliding menus with parallax effect inspired by the WWF app

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/gif/screenshot.gif)


##CocoaPods

 ```
pod 'PWParallaxScrollView', '~> 1.1.5'

 ```

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

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/gif/edgeinsets.gif)

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

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/gif/edgeinsets1.gif)

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

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/gif/screenshot1.gif)

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

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/gif/screenshot3.gif)
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

![](https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/gif/screenshot4.gif)

#####just not implement the foregroundViewAtIndex:scrollView: method (or return nil)

```
- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView;


```

##Change Log 1.1.5

add delegate to receive touchScrollViewTapped event

```
- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didRecieveTapAtIndex:(NSInteger)index;
```

####Thanks for contribution

- @Morgan-Kennedy

##Change Log 1.1.0

- add interface builder support (initWithCoder, Outlets)

- add PWParallaxDelegate and provides methods to check whether the current index is changed

####Thanks for contribution

- @matibot

## MIT License

PWParallaxScrollView is released under the MIT License (see the License file)

##Contact

Any suggestions or improvements?

feel free to contact me

wpsteak@gmail.com
