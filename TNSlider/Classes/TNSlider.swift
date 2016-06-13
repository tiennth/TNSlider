//
//  TNSlider.swift
//  TNSlider
//
//  Created by Tien on 6/9/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

public class TNSlider: UIControl {
    
    private var _value: Float = 0
    // default 0.0. this value will be pinned to min/max
    public var value: Float {
        set {
//            if (newValue < _minimumValue) {
//                _minimumValue = newValue
//            } else if (newValue > _maximumValue) {
//                _maximumValue = newValue
//            }
            if (newValue < _minimumValue) {
                _value = _minimumValue
            } else if (newValue > _maximumValue) {
                _value = _maximumValue
            } else {
                _value = newValue
            }
            
            reinitComponentValues()
            redrawLayers()
        }
        
        get {
            return _value
        }
    }
    
    private var _minimumValue: Float = 0 // default 0.0. the current value may change if outside new min value
    public var minimumValue: Float {
        set {
            if (newValue > _maximumValue) {
                _maximumValue = newValue
            }
            _minimumValue = newValue
            
            if (value < _minimumValue) {
                _value = _minimumValue
            } else if (_value > _maximumValue) {
                _value = _maximumValue
            }
            
            reinitComponentValues()
            redrawLayers()
        }
        
        get {
            return _minimumValue
        }
    }
    
    private var _maximumValue: Float = 1 // default 1.0. the current value may change if outside new max value
    public var maximumValue: Float {
        set {
            if (newValue < _minimumValue) {
                _minimumValue = newValue
            }
            _maximumValue = newValue
            
            if (value < _minimumValue) {
                _value = _minimumValue
            } else if (_value > _maximumValue) {
                _value = _maximumValue
            }
            
            reinitComponentValues()
            redrawLayers()
        }
        
        get {
            return _maximumValue
        }
    }
    
    @IBInspectable public var trackMinColor: UIColor? {
        didSet {
            trackLayer.trackMinColor = trackMinColor
            redrawLayers()
        }
    }
    
    @IBInspectable public var trackMaxColor: UIColor? {
        didSet {
            trackLayer.trackMaxColor = trackMaxColor
            redrawLayers()
        }
    }

    @IBInspectable public var thumbBackgroundColor: UIColor = UIColor.whiteColor() {
        didSet {
            thumbLayer.backgroundColor = thumbBackgroundColor.CGColor
            redrawLayers()
        }
    }
    
    @IBInspectable public var thumbTextColor: UIColor = UIColor.blackColor() {
        didSet {
            thumbLayer.foregroundColor = thumbTextColor.CGColor
            redrawLayers()
        }
    }
    
    @IBInspectable public var continuous: Bool // if set, value change events are generated any time the value changes due to dragging. default = YES
    
    private var trackLayer: TNTrackLayer
    private var thumbLayer: CATextLayer
    
    private var previousTouchPoint = CGPointZero
    private var usableTrackingLength: CGFloat = 0
    
    private let trackHeight: CGFloat = 4
    private let trackInset: CGFloat = 0
    private let thumbHeight: CGFloat = 16
    private let thumbWidth: CGFloat = 38
    
    
    required public override init(frame: CGRect) {
        continuous = true
        
        trackLayer = TNTrackLayer()
        thumbLayer = TNTextLayer()
        
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        layer.addSublayer(trackLayer)
        layer.addSublayer(thumbLayer)
        
        initLayers()
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        continuous = true
        trackLayer = TNTrackLayer()
        thumbLayer = TNTextLayer()
        
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
        layer.addSublayer(trackLayer)
        layer.addSublayer(thumbLayer)

        initLayers()
        commonInit()
    }
    
    // MARK: - Init functions
    func initLayers() {
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        trackLayer.frame = trackRectForBound(bounds)
        trackLayer.setNeedsDisplay()
        
        initThumbLayer()
    }
    
    func initThumbLayer() {
        thumbLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        thumbLayer.bounds = CGRectMake(0, 0, thumbWidth, thumbHeight)
        thumbLayer.position = CGPoint(x: positionForValue(minimumValue), y: bounds.size.height / 2)
        thumbLayer.foregroundColor = UIColor.blackColor().CGColor
        thumbLayer.cornerRadius = thumbHeight / 2
        thumbLayer.fontSize = 11
        thumbLayer.backgroundColor = UIColor.whiteColor().CGColor
        thumbLayer.alignmentMode = kCAAlignmentCenter
        thumbLayer.contentsScale = UIScreen.mainScreen().scale
        
        thumbLayer.masksToBounds = false
        thumbLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        thumbLayer.shadowColor = UIColor.blackColor().CGColor
        thumbLayer.shadowRadius = 2
        thumbLayer.shadowOpacity = 0.125
        thumbLayer.shadowPath = UIBezierPath(roundedRect: thumbLayer.bounds, cornerRadius: thumbHeight / 2).CGPath
        
    }
    
    func commonInit() {
        usableTrackingLength = bounds.size.width - thumbWidth
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Update functions
    func reinitComponentValues() {
        trackLayer.minimumValue = _minimumValue
        trackLayer.maximumValue = _maximumValue
        trackLayer.value = _value
        
        thumbLayer.string = textForValue(_value)
    }
    
    func redrawLayers() {
        thumbLayer.setNeedsDisplay()
        trackLayer.setNeedsDisplay()
    }
    
    func updateLayersPosition() {
        let thumbCenterX = positionForValue(_value)
        thumbLayer.position = CGPoint(x: thumbCenterX, y: bounds.size.height / 2)
    }
   
    func updateLayersValue() {
        thumbLayer.string = textForValue(_value)
        trackLayer.value = _value
    }
    
    func positionForValue(value: Float) -> CGFloat {
        return usableTrackingLength * CGFloat((value - _minimumValue) / (_maximumValue - _minimumValue)) + thumbWidth / 2
    }
    
    // MARK: - Touch handling functions
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousTouchPoint = touch.locationInView(self)
        print(previousTouchPoint)
        if CGRectContainsPoint(thumbLayer.frame, previousTouchPoint) {
            return true
        }
        return false
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        let touchPoint = touch.locationInView(self)
        let delta = touchPoint.x - previousTouchPoint.x
        let valueDelta = (maximumValue - minimumValue) * Float(delta / usableTrackingLength)
        
        var tempValue = _value + valueDelta
        if (tempValue > _maximumValue) {
            tempValue = _maximumValue
        } else if (tempValue < _minimumValue) {
            tempValue = _minimumValue
        }
        
        if (tempValue == _value) {
            // Do nothing and return
            return true
        }
        _value = tempValue
        previousTouchPoint = touchPoint
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayersPosition()
        updateLayersValue()
        trackLayer.setNeedsDisplay()
        CATransaction.commit()

        if continuous {
            sendActionsForControlEvents(.ValueChanged)
        }
        
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        if !continuous {
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    // MARK: - Auto layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        trackLayer.frame = trackRectForBound(bounds)
        commonInit()
        updateLayersPosition()
        redrawLayers()
    }
    
    // MARK: - Helper functions
    func trackRectForBound(bound: CGRect) -> CGRect {
        return CGRectMake(trackInset, (bound.size.height - trackHeight) / 2, bound.size.width - 2 * trackInset, trackHeight)
    }
    
    func textForValue(value: Float) -> String {
        return "\(Int(value))"
    }
    
}
