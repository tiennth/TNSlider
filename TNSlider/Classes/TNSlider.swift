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
    @IBInspectable public var value: Float {
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
    @IBInspectable public var minimumValue: Float {
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
    @IBInspectable public var maximumValue: Float {
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
    
    @IBInspectable public var trackMinColor: UIColor = TNConstants.trackMinColor {
        didSet {
            trackLayer.trackMinColor = trackMinColor
            redrawLayers()
        }
    }
    
    @IBInspectable public var trackMaxColor: UIColor = TNConstants.trackMaxColor {
        didSet {
            trackLayer.trackMaxColor = trackMaxColor
            redrawLayers()
        }
    }

    @IBInspectable public var thumbBackgroundColor: UIColor = TNConstants.thumbBackgroundColor {
        didSet {
            thumbLayer.backgroundColor = thumbBackgroundColor.cgColor
            redrawLayers()
        }
    }
    
    @IBInspectable public var thumbTextColor: UIColor = TNConstants.thumbTextColor {
        didSet {
            thumbLayer.foregroundColor = thumbTextColor.cgColor
            redrawLayers()
        }
    }
    
    @IBInspectable public var continuous: Bool // if set, value change events are generated any time the value changes due to dragging. default = YES
    
    private var trackLayer: TNTrackLayer
    private var thumbLayer: CATextLayer
    
    private var previousTouchPoint = CGPoint.zero
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
        trackLayer.contentsScale = UIScreen.main.scale
        trackLayer.frame = trackRectForBound(bounds)
        trackLayer.setNeedsDisplay()
        
        initThumbLayer()
    }
    
    func initThumbLayer() {
        thumbLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        thumbLayer.bounds = CGRect(x: 0, y: 0, width: thumbWidth, height: thumbHeight)
        thumbLayer.position = CGPoint(x: positionForValue(value: minimumValue), y: bounds.size.height / 2)
        thumbLayer.foregroundColor = UIColor.black.cgColor
        thumbLayer.cornerRadius = thumbHeight / 2
        thumbLayer.fontSize = 11
        thumbLayer.backgroundColor = UIColor.white.cgColor
        thumbLayer.alignmentMode = kCAAlignmentCenter
        thumbLayer.contentsScale = UIScreen.main.scale
        
        thumbLayer.masksToBounds = false
        thumbLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        thumbLayer.shadowColor = UIColor.black.cgColor
        thumbLayer.shadowRadius = 2
        thumbLayer.shadowOpacity = 0.125
        thumbLayer.shadowPath = UIBezierPath(roundedRect: thumbLayer.bounds, cornerRadius: thumbHeight / 2).cgPath
        
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
        let thumbCenterX = positionForValue(value: _value)
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
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousTouchPoint = touch.location(in: self)
        print(previousTouchPoint)
        if thumbLayer.frame.contains(previousTouchPoint) {
            return true
        }
        return false
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let touchPoint = touch.location(in: self)
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
            sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if !continuous {
            sendActions(for: .valueChanged)
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
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 31)
    }
    
    public override func prepareForInterfaceBuilder() {
        trackLayer.frame = trackRectForBound(bounds)
        commonInit()
        updateLayersPosition()
        redrawLayers()
    }
    
    // MARK: - Helper functions
    func trackRectForBound(_ bound: CGRect) -> CGRect {
        return CGRect(x: trackInset, y: (bound.size.height - trackHeight) / 2, width: bound.size.width - 2 * trackInset, height: trackHeight)
    }
    
    func textForValue(_ value: Float) -> String {
        return "\(Int(value))"
    }
    
}
