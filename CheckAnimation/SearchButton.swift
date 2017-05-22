//
//  SearchButton.swift
//  CheckAnimation
//
//  Created by Trevis Thomas on 5/21/17.
//  Copyright © 2017 Trevis Thomas. All rights reserved.
//

import UIKit

@IBDesignable
class SearchButton: UIView {
    
    
    @IBInspectable var color: UIColor = UIColor.green
    @IBInspectable var thickness: CGFloat = 2.0
    
    @IBInspectable var isSearchMode : Bool? = true
    
    let magnifierHeadLayer : CAShapeLayer = CAShapeLayer()
    let handleLayer: CAShapeLayer = CAShapeLayer()
    
    
    enum state {
        case uninitilized
        case search
        case close
    }
    
    override func draw(_ rect: CGRect) {
//        let path = UIBezierPath(ovalIn: rect.insetBy(dx: 5, dy: 5))
//        
//        path.lineWidth = thickness
        color.setStroke()
//
//        path.stroke()
        
        guard let isSearchMode = isSearchMode else {
        
            return
        }
        
        if (isSearchMode) {
            let magifier = magnificationCirclePath(rect)
            magifier.lineWidth = thickness
            magifier.stroke()
        } else {
            let slashOne = handlePath(rect)
            slashOne.lineWidth = thickness
            slashOne.stroke()
            
            let slashTwo = handlePathAlt(rect)
            slashTwo.lineWidth = thickness
            slashTwo.stroke()
        }
    }
    
    public func toggle() {
        
        if(isSearchMode == true) {
            animateFromMagnifierToClose()
        }
        
//        isSearchMode = !isSearchMode
        
    }
    
    private func animateFromMagnifierToClose() {
        //For the animation i use two paths for the magnifyer.  One for the circle, another for the handle
        
        isSearchMode = nil //The idea is that during animation this is nil.
        layer.setNeedsDisplay() //Gives draw the opertunity to be cleared.
        
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.magnifierHeadLayer.removeFromSuperlayer()
//            self.handleLayer.removeFromSuperlayer()
        })
        
        magnifierHeadLayer.removeFromSuperlayer() //Ok this is weird.
        
        
        magnifierHeadLayer.fillColor = UIColor.clear.cgColor
        magnifierHeadLayer.backgroundColor = UIColor.white.cgColor
        magnifierHeadLayer.strokeColor = color.cgColor
        magnifierHeadLayer.lineWidth = thickness
        magnifierHeadLayer.path = magnifyCirclePath(bounds).cgPath
        
        
        
        let magnifierStrokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        magnifierStrokeAnimation.fromValue = 1.0
        magnifierStrokeAnimation.toValue = 0.0
        
        magnifierStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        //These dont seem to work with path
        magnifierStrokeAnimation.fillMode = kCAFillModeForwards
        magnifierStrokeAnimation.isRemovedOnCompletion = true
        magnifierStrokeAnimation.duration =  0.50
        
        
        magnifierHeadLayer.add(magnifierStrokeAnimation, forKey: nil)
        
        layer.addSublayer(magnifierHeadLayer)
        
        CATransaction.commit()
        //Handle
        
        animateTheHandle()
        animateTheOtherSlash()
        
    }
    
    private func animateTheHandle(){
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
//            handleLayer.removeFromSuperlayer()
        })
        handleLayer.removeFromSuperlayer() //Maybe not needed
        handleLayer.fillColor = UIColor.clear.cgColor
        handleLayer.backgroundColor = UIColor.white.cgColor
        handleLayer.strokeColor = color.cgColor
        handleLayer.lineWidth = thickness
        handleLayer.path = handlePath(bounds).cgPath
        
        let handleStrokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        handleStrokeAnimation.fromValue = 0.33
        handleStrokeAnimation.toValue = 1.0
        
        handleStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        handleStrokeAnimation.fillMode = kCAFillModeBackwards
        handleStrokeAnimation.isRemovedOnCompletion = true
        handleStrokeAnimation.duration =  0.30
        handleStrokeAnimation.beginTime = CACurrentMediaTime() + 0.50
        
        
        handleLayer.add(handleStrokeAnimation, forKey: nil)
        
        layer.addSublayer(handleLayer)
        CATransaction.commit()
    }
    
    private func animateTheOtherSlash(){
        let slashLayer: CAShapeLayer = CAShapeLayer()
        
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            slashLayer.removeFromSuperlayer()
            self.handleLayer.removeFromSuperlayer()
            
            self.isSearchMode = false
            self.setNeedsDisplay() //Gives draw the opertunity to be cleared.
            
        })
//        slashLayer.removeFromSuperlayer() //Maybe not needed
        slashLayer.fillColor = UIColor.clear.cgColor
        slashLayer.backgroundColor = UIColor.white.cgColor
        slashLayer.strokeColor = color.cgColor
        slashLayer.lineWidth = thickness
        
        //
        
        let rotationPoint = CGPoint(x: layer.frame.width / 2.0, y: layer.frame.height / 2.0) // The point we are rotating around
        
        print(rotationPoint.debugDescription)
        let width = layer.frame.width
        let height = layer.frame.height
        let minX = layer.frame.minX
        let minY = layer.frame.minY
        
        let anchorPoint = CGPoint(x: (rotationPoint.x-minX)/width,
                                  y: (rotationPoint.y-minY)/height)
        
        slashLayer.anchorPoint = anchorPoint;
        slashLayer.position = rotationPoint;
        //

        
        let weirdo = CGRect(origin: rotationPoint, size: layer.frame.size)
        
//        slashLayer.path = handlePath(bounds).cgPath
        slashLayer.path = handlePath(weirdo).cgPath
        
        let slashStrokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        slashStrokeAnimation.fromValue = 0.33
        slashStrokeAnimation.toValue = 1.0
        
        slashStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        slashStrokeAnimation.fillMode = kCAFillModeBackwards
        slashStrokeAnimation.isRemovedOnCompletion = true
        slashStrokeAnimation.duration =  0.30
        slashStrokeAnimation.beginTime = CACurrentMediaTime() + 0.50
        
        slashLayer.add(slashStrokeAnimation, forKey: nil)
        
        
        
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = .pi / 2.0
        
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        rotateAnimation.fillMode = kCAFillModeBackwards
        rotateAnimation.isRemovedOnCompletion = true
        rotateAnimation.duration =  0.60
        rotateAnimation.beginTime = CACurrentMediaTime() + 0.50
        
        slashLayer.add(rotateAnimation, forKey: nil)
        
        layer.addSublayer(slashLayer)
        CATransaction.commit()
    }
    
    
    
    private func magnifyCirclePath(_ rect: CGRect) -> UIBezierPath {
        let radius = rect.height * 0.15
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -(7 * .pi)/4, endAngle: .pi / 4, clockwise: true)
        
        return path
    }
    
    private func handlePath(_ rect: CGRect) -> UIBezierPath {
        let handleRadius = rect.height * 0.33
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        let bottomPoint = pointOnCircle(origin: center, radius: handleRadius, angle:.pi / 4 )
        let topPoint = pointOnCircle(origin: center, radius: handleRadius, angle: 5 * .pi / 4 )
        
        let path = UIBezierPath()
        
//        path.move(to: bottomPoint)
//        path.addLine(to: topPoint)
        
        //This transform business is for the animation for the x-slash beause i'm rotating it and animating the path
        let transform = CGAffineTransform(translationX: -rect.origin.x, y: -rect.origin.y)
        
        
        path.move(to: bottomPoint.applying(transform))
        path.addLine(to: topPoint.applying(transform))
        
        return path
        
    }
    
    private func handlePathAlt(_ rect: CGRect) -> UIBezierPath {
        let handleRadius = rect.height * 0.33
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        let bottomPoint = pointOnCircle(origin: center, radius: handleRadius, angle: 7 * .pi / 4 )
        let topPoint = pointOnCircle(origin: center, radius: handleRadius, angle: 3 * .pi / 4 )
        
        let path = UIBezierPath()
        
                path.move(to: bottomPoint)
                path.addLine(to: topPoint)
        
        //This transform business is for the animation for the x-slash beause i'm rotating it and animating the path
//        let transform = CGAffineTransform(translationX: -rect.origin.x, y: -rect.origin.y)
//        
//        
//        path.move(to: bottomPoint.applying(transform))
//        path.addLine(to: topPoint.applying(transform))
        
        return path
        
    }
    
    private func magnificationCirclePath (_ rect: CGRect) -> UIBezierPath{
        
        let radius = rect.height * 0.15
        let handleRadius = rect.height * 0.33
        
        let connectionAngle : CGFloat =  .pi / 4
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        let handleTip = pointOnCircle(origin: center, radius: handleRadius, angle:connectionAngle )
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -(7 * .pi)/4, endAngle: connectionAngle, clockwise: true)
        
        path.addLine(to: handleTip)
        
        return path
       
    }
    
    func pointOnCircle(origin: CGPoint, radius: CGFloat, angle : CGFloat) -> CGPoint {
        let x = origin.x + radius * cos(angle)
        let y = origin.y + radius * sin(angle)
        
        return CGPoint(x: x, y: y)
    }

}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
