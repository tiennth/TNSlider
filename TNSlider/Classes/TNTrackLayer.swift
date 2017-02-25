//
//  TNTrackLayer.swift
//  TNThumbValueSlider
//
//  Created by Tien on 6/9/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class TNTrackLayer: CALayer {
    
    var trackMinColor: UIColor = TNConstants.trackMinColor
    var trackMaxColor: UIColor = TNConstants.trackMaxColor
    
    var value: Float = 0
    var minimumValue: Float = 0
    var maximumValue: Float = 1
    
    override func draw(in ctx: CGContext) {
        let cornerRadius = bounds.height * 1/2
        
        let range = maximumValue - minimumValue
        let thresholdX = bounds.size.width * CGFloat((value - minimumValue) / range)
        let trackMinRect = CGRect(x: 0, y: 0, width: thresholdX, height: bounds.size.height)
        let trackMinPath = UIBezierPath(roundedRect: trackMinRect, cornerRadius: cornerRadius)
        ctx.setFillColor(trackMinColor.cgColor)
        ctx.addPath(trackMinPath.cgPath)
        ctx.fillPath()
        
        let trackMaxRect = CGRect(x: thresholdX, y: 0, width: bounds.size.width - thresholdX, height: bounds.size.height)
        let trackMaxPath = UIBezierPath(roundedRect: trackMaxRect, cornerRadius: cornerRadius)
        ctx.setFillColor(trackMaxColor.cgColor)
        ctx.addPath(trackMaxPath.cgPath)
        ctx.fillPath()
    }
}
