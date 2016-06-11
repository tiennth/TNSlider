//
//  TNThumbValueSlider.swift
//  TNThumbValueSlider
//
//  Created by Tien on 6/9/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

public class TNThumbValueSlider: UIControl {
    
    // default 0.0. this value will be pinned to min/max
    public var value: Float {
        didSet {
            trackLayer.value = value
            redrawLayers()
        }
    }
    
    public var minimumValue: Float // default 0.0. the current value may change if outside new min value
    public var maximumValue: Float // default 1.0. the current value may change if outside new max value
    
    public var trackMinColor: UIColor? {
        didSet {
            trackLayer.trackMinColor = trackMinColor
        }
    }
    public var trackMaxColor: UIColor? {
        didSet {
            trackLayer.trackMaxColor = trackMaxColor
        }
    }
    
    public var continuous: Bool // if set, value change events are generated any time the value changes due to dragging. default = YES
    
    private var trackLayer: TNTrackLayer
    private var thumbLayer: CATextLayer
    
    private var previousTouchPoint = CGPointZero
    private var usableTrackingLength: CGFloat = 0
    
    private let trackHeight: CGFloat = 4
    private let trackInset: CGFloat = 0
    private let thumbHeight: CGFloat = 16
    private let thumbWidth: CGFloat = 38
    
    
    override init(frame: CGRect) {
        value = 0.5
        minimumValue = 0.0
        maximumValue = 1.0
        continuous = true
        
        trackLayer = TNTrackLayer()
        thumbLayer = TNTextLayer()
        
        super.init(frame: frame)
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(thumbLayer)
        
        initLayers()
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        value = 0
        minimumValue = 0.0
        maximumValue = 1.0
        continuous = true
        trackLayer = TNTrackLayer()
        thumbLayer = TNTextLayer()
        
        super.init(coder: aDecoder)
        
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
        thumbLayer.shadowRadius = 1
        thumbLayer.shadowOpacity = 0.125
        thumbLayer.shadowPath = UIBezierPath(roundedRect: thumbLayer.bounds, cornerRadius: thumbHeight / 2).CGPath
        
    }
    
    func commonInit() {
        usableTrackingLength = bounds.size.width - thumbWidth
    }
    
    // MARK: - Update functions
    func redrawLayers() {
        thumbLayer.setNeedsDisplay()
        trackLayer.setNeedsDisplay()
    }
    
    func updateLayersPosition() {
        let thumbCenterX = positionForValue(value)
        thumbLayer.position = CGPoint(x: thumbCenterX, y: bounds.size.height / 2)
    }
   
    func updateLayersValue() {
        thumbLayer.string = "\(Int(value))"
    }
    
    func positionForValue(value: Float) -> CGFloat {
        return usableTrackingLength * CGFloat((value - minimumValue) / (maximumValue - minimumValue)) + thumbWidth / 2
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
        
        var tempValue = value + valueDelta
        if (tempValue > maximumValue) {
            tempValue = maximumValue
        } else if (tempValue < minimumValue) {
            tempValue = minimumValue
        }
        
        if (tempValue == value) {
            // Do nothing and return
            return true
        }
        value = tempValue
        print("Value: \(value)")
        previousTouchPoint = touchPoint
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayersPosition()
        updateLayersValue()
        CATransaction.commit()
        
        sendActionsForControlEvents(.ValueChanged)
        
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        print("End")
    }
    
    // MARK: - Helper functions
    func trackRectForBound(bound: CGRect) -> CGRect {
        return CGRectMake(trackInset, (bound.size.height - trackHeight) / 2, bound.size.width - 2 * trackInset, trackHeight)
    }
}
