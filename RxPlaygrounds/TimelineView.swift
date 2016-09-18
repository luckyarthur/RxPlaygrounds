//
//  TimelineView.swift
//  RxPlaygrounds
//
//  Created by 杨弘宇 on 2016/9/17.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class MarbleView: UIView {
    
    var position: Int8!
    
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.clipsToBounds = true
        
        self.textLabel = UILabel(frame: CGRect.zero)
        self.addSubview(self.textLabel)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
        self.textLabel.sizeToFit()
        self.textLabel.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    
    @objc func didPan(sender: UIPanGestureRecognizer?) {
        if (self.superview as? TimelineView)?.editable != true {
            return
        }
        
        guard let panGestureRecognizer = sender else {
            return
        }
        
        switch panGestureRecognizer.state {
        case .began:
            self.didBeginPan(with: panGestureRecognizer)
            break
        case .changed:
            self.didChangePan(with: panGestureRecognizer)
            break
        case .ended, .cancelled:
            self.didEndPan(with: panGestureRecognizer)
            break
        default:
            break
        }
    }
    
    func didBeginPan(with panGestureRecognizer: UIPanGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.4, y: 1.4)
            self.alpha = 0.72
        }
    }
    
    func didChangePan(with panGestureRecognizer: UIPanGestureRecognizer) {
        var location = panGestureRecognizer.location(in: self.superview!)
        let superviewBound = (self.superview?.bounds.insetBy(dx: 20, dy: 0))!
        
        // Clamp location
        if location.x < superviewBound.minX {
            location.x = superviewBound.minX
        }
        
        if location.x > superviewBound.maxX {
            location.x = superviewBound.maxX
        }
        
        self.position = Int8(((location.x - 20) / superviewBound.width) * CGFloat(100))
        
        self.superview?.setNeedsLayout()
        self.setNeedsLayout()
    }
    
    func didEndPan(with panGestureRecognizer: UIPanGestureRecognizer) {
        if let timelineView = self.superview as? TimelineView {
            timelineView.delegate?.timelineView(marblesDidChange: timelineView)
        }
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }) { _ in
            self.setNeedsLayout()
        }
    }
    
}


protocol TimelineViewDelegate: NSObjectProtocol {
    
    func timelineView(marblesDidChange view: TimelineView)
    
}


class TimelineView: UIView {

    var lineLayer: CAShapeLayer!
    var arrowLayer: CAShapeLayer!
    var cursorLayer: CAShapeLayer!
    
    var marbles = [MarbleView]()
    
    var editable = true
    var cursorPosition: Int8 = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    weak var delegate: TimelineViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.lineLayer = CAShapeLayer()
        self.lineLayer.lineWidth = 2
        self.lineLayer.strokeColor = UIColor.black.cgColor
        
        let arrowPath = CGMutablePath()
        arrowPath.move(to: CGPoint(x: 0, y: 0))
        arrowPath.addLine(to: CGPoint(x: 20, y: 10))
        arrowPath.move(to: CGPoint(x: 0, y: 20))
        arrowPath.addLine(to: CGPoint(x: 20, y: 10))
        
        self.arrowLayer = CAShapeLayer()
        self.arrowLayer.lineWidth = 2
        self.arrowLayer.strokeColor = UIColor.black.cgColor
        self.arrowLayer.path = arrowPath
        
        let cursorPath = CGMutablePath()
        cursorPath.move(to: CGPoint(x: 0, y: 0))
        cursorPath.addLine(to: CGPoint(x: 0, y: 20))
        
        self.cursorLayer = CAShapeLayer()
        self.cursorLayer.lineWidth = 2
        self.cursorLayer.strokeColor = UIColor.black.cgColor
        self.cursorLayer.path = cursorPath
        
        self.layer.addSublayer(self.lineLayer)
        self.layer.addSublayer(self.arrowLayer)
        self.layer.addSublayer(self.cursorLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let linePath = CGMutablePath()
        linePath.move(to: CGPoint.zero)
        linePath.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        
        self.lineLayer.path = linePath
        self.lineLayer.frame = CGRect(x: 0, y: (self.bounds.height - 2) / 2, width: self.bounds.width, height: 2)
        
        self.arrowLayer.frame = CGRect(x: self.bounds.width - 20, y: (self.bounds.height - 22) / 2, width: 20, height: 20)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.cursorLayer.frame = CGRect(x: ((self.bounds.width - 40) / 100) * CGFloat(self.cursorPosition) + 20, y: (self.bounds.height - 20) / 2, width: 2, height: 20)
        CATransaction.commit()
        
        self.marbles.forEach { marble in
            if marble.bounds.width != 30 {
                marble.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
            }
            marble.center = CGPoint(x: ((self.bounds.width - 40) / 100) * CGFloat(marble.position) + 20, y: self.bounds.height / 2)
        }
    }
    
    func addMarble(_ marble: MarbleView) {
        self.marbles.append(marble)
        self.addSubview(marble)
        
        self.setNeedsLayout()
        
        marble.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        marble.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .beginFromCurrentState, animations: { 
            marble.transform = CGAffineTransform.identity
            marble.alpha = 1
            }, completion: nil)
    }
    
    func clearMarbles() {
        self.marbles.forEach { marble in
            marble.removeFromSuperview()
        }
        
        self.marbles.removeAll()
    }

}
