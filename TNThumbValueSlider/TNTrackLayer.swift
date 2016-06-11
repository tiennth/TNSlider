//
//  TNTrackLayer.swift
//  TNThumbValueSlider
//
//  Created by Tien on 6/9/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class TNTrackLayer: CALayer {
    
    var trackMinColor: UIColor?
    var trackMaxColor: UIColor?
    
    var value: Float = 0
    var range: Float = 1
    
    override func drawInContext(ctx: CGContext) {
        let cornerRadius = bounds.height * 1/2
        
        let trackMinRect = CGRect(x: 0, y: 0, width: bounds.size.width * CGFloat(value / range), height: bounds.size.height)
        let trackMinPath = UIBezierPath(roundedRect: trackMinRect, cornerRadius: cornerRadius)
        CGContextSetFillColorWithColor(ctx, trackMinColor?.CGColor)
        CGContextAddPath(ctx, trackMinPath.CGPath)
        CGContextFillPath(ctx)
        
        let trackMaxRect = CGRect(x: bounds.size.width * CGFloat(value / range), y: 0, width: bounds.size.width * CGFloat(1 - value / range), height: bounds.size.height)
        let trackMaxPath = UIBezierPath(roundedRect: trackMaxRect, cornerRadius: cornerRadius)
        CGContextSetFillColorWithColor(ctx, trackMaxColor?.CGColor)
        CGContextAddPath(ctx, trackMaxPath.CGPath)
        CGContextFillPath(ctx)
//        CGContextClip(ctx)
        
        
    }
}
