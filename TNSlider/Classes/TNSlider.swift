//
//  TNSlider.swift
//  TNSlider
//
//  Created by Tien on 6/9/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

@objc protocol TNSliderDelegate: class {
    func slider(_ slider: TNSlider, displayTextForValue value: Float) -> String
}

@IBDesignable
public class TNSlider: UIControl {
    
    @IBOutlet weak var delegate: TNSliderDelegate?
    
    // LOGGING
    func log(_ msg: String) {
//        print(msg)
    }
    //
    
    // default 0.0. this value will be pinned to min/max
    @IBInspectable public var value: Float = 0 {
        didSet {
            if (value < minimum) {
                minimum = value
            }
            
            if (value > maximum) {
                maximum = value
            }
            
            reinitComponentValues()
            redrawLayers()
        }
    }
    
    @IBInspectable public var minimum: Float = 0 {
        didSet {
            log("Minimum didSet")
            if (minimum > maximum) {
                maximum = minimum
            }
            
            if (value < minimum) {
                value = minimum
            }
            log("Final minimum: \(minimum)")
            reinitComponentValues()
            redrawLayers()
        }
    }
    
    @IBInspectable public var maximum: Float = 1 {
        didSet {
            log("Maximum didSet")
            if (maximum < minimum) {
                minimum = maximum
            }
            
            if (value > maximum) {
                value = maximum
            }
            log("Final maximum: \(maximum)")
            reinitComponentValues()
            redrawLayers()
        }
    }
    
    // Step == 0 means disable snapping to value.
    @IBInspectable public var step: Float = 0 {
        didSet {
            log("Step didSet")
            if (step < 0) {
                step = 0
            }
            if (step > maximum - minimum) {
                maximum = minimum + step
            }
            
            log("Final step \(step)")
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
    
    // How often valueChanged be triggered.
    // true: valueChanged will be called many times during thumb dragging.
    // false: valueChanged will on called only one time when dragging finished.
    @IBInspectable public var continuous: Bool = true // if set, value change events are generated any time the value changes due to dragging. default = YES
    
    private var trackLayer: TNTrackLayer
    private var thumbLayer: CATextLayer
    
    private var previousTouchPoint = CGPoint.zero
    private var usableTrackingLength: CGFloat = 0
    private var pointsPerValueScale: CGFloat = 1
    
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
        thumbLayer.position = CGPoint(x: positionForValue(value: minimum), y: bounds.size.height / 2)
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
        trackLayer.minimumValue = minimum
        trackLayer.maximumValue = maximum
        trackLayer.value = value
        
        updateThumbLayersText()
        updateThumbLayersPosition()
    }
    
    func redrawLayers() {
        thumbLayer.setNeedsDisplay()
        trackLayer.setNeedsDisplay()
    }
    
    func updateThumbLayersText() {
        thumbLayer.string = textForValue(value)
    }
    
    func updateThumbLayersPosition() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setAnimationDuration(0)
        
        let thumbCenterX = positionForValue(value: value)
        thumbLayer.position = CGPoint(x: thumbCenterX, y: bounds.size.height / 2)
        CATransaction.commit()
    }
   
    func updateLayersValue() {
        updateThumbLayersText()
        trackLayer.value = value
    }
    
    func positionForValue(value: Float) -> CGFloat {
        if (minimum == maximum) {
            return thumbWidth / 2
        }
        
        return usableTrackingLength * CGFloat((value - minimum) / (maximum - minimum)) + thumbWidth / 2
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
        let valueDelta = (maximum - minimum) * Float(delta / usableTrackingLength)
        
        var tempValue = value + valueDelta
        if (tempValue > maximum) {
            tempValue = maximum
        } else if (tempValue < minimum) {
            tempValue = minimum
        }
        
        if (tempValue == value) {
            // Do nothing and return
            return true
        }
        
        value = tempValue
        previousTouchPoint = touchPoint

        if continuous {
            sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        // Snap to value
        if step > 0 {
            let noOfStep = (value/step).rounded(.toNearestOrEven)
            value = noOfStep * step
        }
        
        if !continuous {
            sendActions(for: .valueChanged)
        }
    }
    
    // MARK: - Auto layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        trackLayer.frame = trackRectForBound(bounds)
        commonInit()
        updateThumbLayersPosition()
        redrawLayers()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 118, height: 31)
    }
    
    public override func prepareForInterfaceBuilder() {
        trackLayer.frame = trackRectForBound(bounds)
        commonInit()
        updateThumbLayersPosition()
        redrawLayers()
    }
    
    // MARK: - Helper functions
    func trackRectForBound(_ bound: CGRect) -> CGRect {
        return CGRect(x: trackInset, y: (bound.size.height - trackHeight) / 2, width: bound.size.width - 2 * trackInset, height: trackHeight)
    }
    
    func textForValue(_ value: Float) -> String {
        if let delegate = delegate {
            return delegate.slider(self, displayTextForValue: value)
        } else {
            return String(format: "%.2f", value)
        }
    }
    
}
