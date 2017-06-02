//
//  DoodleTouchBezier.swift
//  Pods
//
//  Created by Kyle Zaragoza on 6/2/17.
//
//

import Foundation

internal struct DoodleTouchBezier {
    fileprivate static let drawStepsPerBezier = 300
    /**
     *  The start point of the cubic bezier path.
     */
    var startPoint: CGPoint
    
    /**
     *  The end point of the cubic bezier path.
     */
    var endPoint: CGPoint
    
    /**
     *  The first control point of the cubic bezier path.
     */
    var controlPoint1: CGPoint
    
    /**
     *  The second control point of the cubic bezier path.
     */
    var controlPoint2: CGPoint
    
    /**
     *  The starting width of the cubic bezier path.
     */
    var startWidth: CGFloat
    
    /**
     *  The ending width of the cubic bezier path.
     */
    var endWidth:  CGFloat
    
    /**
     *  The stroke color of the cubic bezier path.
     */
    var strokeColor: UIColor
    
    /**
     *  YES if the line is a constant width, NO if variable width.
     */
    var isConstantWidth: Bool
}

extension DoodleTouchBezier: DrawablePath {
    func draw(inContext context: CGContext) {
        if isConstantWidth {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: startPoint)
            bezierPath.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            bezierPath.lineWidth = startWidth
            bezierPath.lineCapStyle = .round
            strokeColor.setStroke()
            bezierPath.stroke(with: .normal, alpha: 1)
        } else {
            strokeColor.setFill()
            
            let widthDelta = endWidth - startWidth
            
            for i in 0..<DoodleTouchBezier.drawStepsPerBezier {
                let t = CGFloat(i) / CGFloat(DoodleTouchBezier.drawStepsPerBezier)
                let tt = t * t
                let ttt = tt * t
                let u = 1 - t
                let uu = u * u
                let uuu = uu * u
                
                var x = uuu * startPoint.x
                x += 3 * uu * t * controlPoint1.x
                x += 3 * u * tt * controlPoint2.x
                x += ttt * endPoint.x
                
                var y = uuu * startPoint.y
                y += 3 * uu * t * controlPoint1.y
                y += 3 * u * tt * controlPoint2.y
                y += ttt * endPoint.y
                
                let pointWidth = startWidth + (ttt * widthDelta)
                DoodleTouchBezier.drawPoint(CGPoint(x: x, y: y), withWidth: pointWidth, inContext: context)
            }
        }
    }
    
    static func drawPoint(_ point: CGPoint, withWidth width: CGFloat, inContext context: CGContext) {
        context.fillEllipse(in: CGRect(x: point.x, y: point.y, width: 0, height: 0).insetBy(dx: -width / 2, dy: -width / 2))
    }
}
