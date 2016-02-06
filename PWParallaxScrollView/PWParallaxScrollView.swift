//
//  PWParallaxScrollView.swift
//  PWParallaxScrollView-Swift
//
//  Created by wpsteak on 12/15/15.
//  Copyright © 2015 Pin Shih Wang. All rights reserved.
//

import UIKit

private let PWInvalidPosition :Int = -1

@objc
public protocol PWParallaxScrollViewDataSource : NSObjectProtocol {
    func numberOfItemsInScrollView(scrollView: PWParallaxScrollView) -> Int
    
    optional func backgroundViewAtIndex(index: Int, scrollView: PWParallaxScrollView) -> UIView?
    optional func foregroundViewAtIndex(index: Int, scrollView: PWParallaxScrollView) -> UIView?
}


@objc
public protocol PWParallaxScrollViewDelegate : NSObjectProtocol {
    
    optional func parallaxScrollView(scrollView: PWParallaxScrollView, didChangeIndex index: Int)
    optional func parallaxScrollView(scrollView: PWParallaxScrollView, didEndDeceleratingAtIndex index: Int)
    optional func parallaxScrollView(scrollView: PWParallaxScrollView, didRecieveTapAtIndex index: Int)
}

@objc
public class PWParallaxScrollView: UIView, UIScrollViewDelegate {
    weak public var dataSource: PWParallaxScrollViewDataSource? {
        didSet {
            reloadData()
        }
    }
    weak public var delegate: PWParallaxScrollViewDelegate?
    
    public var foregroundScreenEdgeInsets: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            foregroundScrollView.frame = UIEdgeInsetsInsetRect(self.bounds, foregroundScreenEdgeInsets)
        }
    }
    
    private var touchScrollView: UIScrollView = UIScrollView()
    private var foregroundScrollView: UIScrollView = UIScrollView()
    private var backgroundScrollView: UIScrollView = UIScrollView()
    
    private var currentBottomView: UIView?
    
    private var numberOfItems: Int = 0
    private var backgroundViewIndex: Int = 0
    private var userHoldingDownIndex: Int = 0
    
    private var currentIndex: Int = 0

    private func setup() {
        self.backgroundColor = UIColor.blackColor()
        self.clipsToBounds = true;

        touchScrollView.frame = self.bounds
        touchScrollView.pagingEnabled = true
        touchScrollView.backgroundColor = UIColor.clearColor()
        touchScrollView.contentOffset = CGPointMake(0, 0)
        touchScrollView.multipleTouchEnabled = true
        touchScrollView.delegate = self
        
        foregroundScrollView.scrollEnabled = false
        foregroundScrollView.clipsToBounds = false
        foregroundScrollView.backgroundColor = UIColor.clearColor()
        foregroundScrollView.contentOffset = CGPointMake(0, 0);
        
        backgroundScrollView.frame = self.bounds
        backgroundScrollView.pagingEnabled = true
        backgroundScrollView.backgroundColor = UIColor.clearColor()
        backgroundScrollView.contentOffset = CGPointMake(0, 0)
        
        self.addSubview(backgroundScrollView)
        self.addSubview(foregroundScrollView)
        self.addSubview(touchScrollView)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func reloadData() {
        backgroundViewIndex = 0
        userHoldingDownIndex = 0
        numberOfItems = self.dataSource?.numberOfItemsInScrollView(self) ?? 0
        
        
        let contentView: UIView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.frame) * CGFloat(numberOfItems), CGRectGetHeight(self.frame)))
        contentView.backgroundColor = UIColor.clearColor()
        
        backgroundScrollView.setContentOffset(CGPointMake(0, 0), animated: false)
        backgroundScrollView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        backgroundScrollView.addSubview(contentView)
        backgroundScrollView.contentSize = contentView.frame.size
        
        foregroundScrollView.setContentOffset(CGPointMake(0, 0), animated: false)
        foregroundScrollView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        foregroundScrollView.contentSize = CGSizeMake(CGRectGetWidth(foregroundScrollView.frame) * CGFloat(numberOfItems), CGRectGetHeight(foregroundScrollView.frame))
        
        touchScrollView.setContentOffset(CGPointMake(0, 0), animated: false)
        touchScrollView.contentSize = contentView.frame.size
        
        loadBackgroundViewAtIndex(0)
        
        for index in 0..<numberOfItems {
            loadForegroundViewAtIndex(index)
        }
    }
    
    public func moveToIndex(index: Int) {
        let newOffsetX: CGFloat = CGFloat(index) * CGRectGetWidth(touchScrollView.frame)
        
        touchScrollView.scrollRectToVisible(CGRectMake(newOffsetX, 0, CGRectGetWidth(touchScrollView.frame), CGRectGetHeight(touchScrollView.frame)), animated: true)
    }
    
    public func prevItem() {
        if (self.currentIndex > 0) {
            moveToIndex(self.currentIndex - 1)
        }
    }

    public func nextItem() {
        if (self.currentIndex < numberOfItems - 1) {
            moveToIndex(self.currentIndex + 1)
        }
    }
    
    private func loadForegroundViewAtIndex(index: Int) {
        if let newParallaxView: UIView = foregroundViewAtIndex(index) {
            foregroundScrollView.addSubview(newParallaxView)
        }
    }

    private func loadBackgroundViewAtIndex(index: Int) {
        backgroundScrollView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        if let newTopView: UIView = backgroundViewAtIndex(index) {
            backgroundScrollView.addSubview(newTopView)
        }
    }
    
    private func foregroundViewAtIndex(index: Int) -> UIView? {

        if (index < 0 || index >= numberOfItems) {
            return nil
        }
        
        if let view: UIView = self.dataSource?.foregroundViewAtIndex?(index, scrollView: self) {
            var newFrame: CGRect = view.frame
            newFrame.origin.x += CGFloat(index) * CGRectGetWidth(foregroundScrollView.frame)
            view.frame = newFrame
            view.tag = index
            
            return view
        }
        else {
            return nil
        }
    }
    
    private func backgroundViewAtIndex(index: Int) -> UIView? {
        
        if (index < 0 || index >= numberOfItems) {
            return nil
        }
        
        let view: UIView? = self.dataSource?.backgroundViewAtIndex?(index, scrollView: self)
        
        view?.frame = CGRectMake((CGFloat)(index * Int(CGRectGetWidth(self.frame))), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
        view?.tag = index
        
        return view
    }
    
    private func determineBackgroundView(offsetX: CGFloat) {
        var newCenterX: CGFloat = 0
        var newBackgroundViewIndex: Int = 0;
        let midPoint: CGFloat = CGRectGetWidth(self.frame) * CGFloat(userHoldingDownIndex);
        
        if (offsetX < midPoint) {
            //moving from left to right
            
            newCenterX = (CGRectGetWidth(self.frame) * CGFloat(userHoldingDownIndex) - offsetX) / 2;
            newBackgroundViewIndex = userHoldingDownIndex - 1;
        }
        else if (offsetX > midPoint) {
            //moving from right to left
            
            let leftSplitWidth: CGFloat = CGRectGetWidth(self.frame) * CGFloat(userHoldingDownIndex + 1) - offsetX;
            let rightSplitWidth: CGFloat = CGRectGetWidth(self.frame) - leftSplitWidth;
            
            newCenterX = rightSplitWidth / 2 + leftSplitWidth;
            newBackgroundViewIndex = userHoldingDownIndex + 1;
        }
        else {
            newCenterX = CGRectGetWidth(self.frame) / 2 ;
            newBackgroundViewIndex = backgroundViewIndex;
        }
        
        let backgroundViewIndexChanged: Bool = (newBackgroundViewIndex == backgroundViewIndex) ? false : true;
        backgroundViewIndex = newBackgroundViewIndex;
        
        if (userHoldingDownIndex >= 0 && userHoldingDownIndex <= numberOfItems) {
            if (backgroundViewIndexChanged) {
                currentBottomView?.removeFromSuperview()
                
                if let newBottomView: UIView = backgroundViewAtIndex(backgroundViewIndex) {
                    currentBottomView = newBottomView;
                    self.insertSubview(newBottomView, atIndex: 0)
                }
            }
        }
        
        let center: CGPoint = CGPointMake(newCenterX, CGRectGetHeight(self.frame) / 2);
        currentBottomView?.center = center;
    }
    
    private func backgroundViewIndexFromOffset(offset: CGPoint) -> Int {
        var index: Int = Int(offset.x / CGRectGetWidth(self.frame))
        
        if (index >= numberOfItems || index < 0) {
            index = PWInvalidPosition;
        }
        
        return index;
    }
    
// MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        backgroundScrollView.contentOffset = scrollView.contentOffset
        
        let factor = foregroundScrollView.contentSize.width / scrollView.contentSize.width
        foregroundScrollView.contentOffset = CGPointMake(factor * scrollView.contentOffset.x, 0)
        
        let offsetX = scrollView.contentOffset.x
        determineBackgroundView(offsetX)
        
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        
        let width: CGFloat = CGRectGetWidth(scrollView.frame);
        let userPenRect = CGRect(origin: CGPointMake(CGFloat(Int(width) * userHoldingDownIndex), 0), size: scrollView.bounds.size)
        
        if (!CGRectIntersectsRect(visibleRect, userPenRect)) {
            if (CGRectGetMinX(visibleRect) - CGRectGetMinX(userPenRect) > 0) {
                userHoldingDownIndex = userHoldingDownIndex + 1
            }
            else {
                userHoldingDownIndex = userHoldingDownIndex - 1
            }
            
            loadBackgroundViewAtIndex(userHoldingDownIndex)
        }
        
        let newCrrentIndex = Int(1.0 * scrollView.contentOffset.x / CGRectGetWidth(self.frame));
        
        if(currentIndex != newCrrentIndex) {
            self.currentIndex = newCrrentIndex;
            
            self.delegate?.parallaxScrollView?(self, didChangeIndex: currentIndex)
        }
    }
    
}
    
