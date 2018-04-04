//
//  SwipeScrollManager.swift
//  SwipeScrollManager
//
//  Created by Allan Gonzales on 4/4/18.
//  Copyright © 2018 Allan Gonzales. All rights reserved.
//

import UIKit


enum SwipeDirection: Int {
    case left, right, none
    init(value: Int) {
        switch value {
        case 0: self = .left
        case 2: self = .right
        default: self = .none
        }
    }
}
protocol SwipeScrollManagerDelegate: class {
    func swipeWillMoveCard(direction: SwipeDirection)
    func swipeManagerDidMoveCard(direction: SwipeDirection)
}

class SwipeScrollManager {
    
    fileprivate let cardNumber: CGFloat = 3
    
    fileprivate var _width: CGFloat?
    fileprivate var _height: CGFloat?
    
    var mainView: UIView!
    var extraView: UIView!
    var centerView: UIView!
    var scrollView: UIScrollView!
    
    var direction: SwipeDirection = .none
    
    weak var delegate: SwipeScrollManagerDelegate?
    
    init(centerView: UIView, extraView: UIView, scrollView: UIScrollView) {
        self.extraView = extraView
        self.extraView.frame = self.frame
        self.centerView = centerView
        self.mainView = self.centerView
        self.scrollView = scrollView
        self._width = scrollView.frame.size.width
        self._height = scrollView.frame.size.height
        self.centerView.frame = self.centerFrame
        
        self.scrollView.contentSize = self.size
        self.centerView.backgroundColor = UIColor.yellow
        self.scrollView.isPagingEnabled = true
        self.scrollView.addSubview(centerView)
        self.scrollView.addSubview(extraView)
    }
    
    /**
     Change the computed width and height of the scrollview and each card.
     */
    func change(width: CGFloat, height: CGFloat) {
        self._width = width
        self._height = height
    }
    
    /**
     Returns full height value.
     - returns: CGFloat
     */
    var fullHeight: CGFloat {
        return self.height
    }
    
    /**
     Returns full width value.
     - returns: CGFloat
     */
    var fullWidth: CGFloat {
        return self.width * self.cardNumber
    }
    
    /**
     Returns height value.
     - returns: CGFloat
     */
    var height: CGFloat {
        return _height == nil ? 0: _height!
    }
    
    /**
     Returns width value.
     - returns: CGFloat
     */
    var width: CGFloat {
        return _width == nil ? 0: _width!
    }
    
    /**
     Returns CGRect of each view.
     */
    var frame: CGRect {
        return CGRect(x: 0, y: 0, width: self.width, height: self.height)
    }
    
    /**
     Returns CGRect of first view.
     */
    var firstFrame: CGRect {
        return self.rectForIndex(index: 0)
    }
    
    /**
     Returns CGRect of Center view.
     */
    var centerFrame: CGRect {
        return self.rectForIndex(index: 1)
    }
    
    /**
     Returns CGRect of last view.
     */
    var lastFrame: CGRect {
        return self.rectForIndex(index: 2)
    }
    
    /**
     Returns full CGSize of scrollview.
     */
    var size: CGSize {
        return CGSize(width: self.fullWidth, height: self.fullHeight)
    }
    
    /**
     Returns CGPoint of center of scrollview.
     */
    var centerPoint: CGPoint {
        return CGPoint(x: self.width, y: 0)
    }
    
    /**
     Moved the views to specific index of scrollview.
     
     - parameter index: index of view to move
     */

    func moveCardTo(index: CGFloat) {
        if index != 1 {
            mainView = mainView == extraView ? centerView : extraView
        }
        self.direction = .none
        self.reCenter()
        self.delegate?.swipeManagerDidMoveCard(direction: SwipeDirection(value: Int(index)))
    }
    
    /**
     will move views to specific direction wether its left or right.
     
     - parameter index: index of view to move
     */
    func willMoveCardTo(index: Int) {
        var view = extraView
        if mainView == extraView {
            view = centerView
        }
        let direction = SwipeDirection(value: index == 1 ? 2 : 0)
        switch direction {
        case .left: view!.frame = self.firstFrame
        case .right: view!.frame = self.lastFrame
        case .none: break
        }
        
        if direction != self.direction {
            self.direction = direction
            self.delegate?.swipeWillMoveCard(direction: direction)
        }
    }
    
    /**
     Returns CGRect of the view at specific index.
     
     - parameter index: CGFloat
     - returns: CGRect
     */
    func rectForIndex(index: CGFloat) -> CGRect {
        var rect = self.frame
        rect.origin.x = self.width * index
        return rect
    }
    
    /**
     Recentering the scrollview and recenter frame of the main view
     */
    func reCenter() {
        self.mainView.frame = self.centerFrame
        self.scrollView.setContentOffset(self.centerPoint, animated: false)
    }
    
    /**
     Returns view that's on the center of the scrollview
     */
    func focusView() -> UIView {
        return self.mainView
    }
}
