//
//  FTCaptureButton.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/19.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

public let FTCAPTUE_BUTTON_FRAME = CGRect.init(x: 0, y: 0, width: 68, height: 68)
public let FTCAPTUE_LINE_WIDTH = CGFloat.init(6.0)

public enum FTCaptureButtonMode: Int{
    case FTCaptureButtonModePhoto = 0,
         FTCaptureButtonModeVideo
}

class FTCaptureButton: UIButton {

    fileprivate var model: FTCaptureButtonMode!
    private var circleLayer: CALayer!
    
    init(model: FTCaptureButtonMode!){
        super.init(frame: FTCAPTUE_BUTTON_FRAME)
        self.model = model
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func initialize(){
    
        self.backgroundColor = UIColor.green
        self.tintColor = UIColor.clear
        
        let circleColor = self.model == FTCaptureButtonMode.FTCaptureButtonModeVideo ? UIColor.red : UIColor.white
        self.circleLayer = CALayer()
        self.circleLayer.backgroundColor = circleColor.cgColor
        self.circleLayer.bounds = self.bounds.insetBy(dx: 8, dy: 8)
        self.circleLayer.position = CGPoint.init(x: self.bounds.minX, y: self.bounds.minY)
        self.circleLayer.cornerRadius = self.bounds.width / 2.0
        self.layer.addSublayer(self.circleLayer)
        
    }
    
    override var isHighlighted: Bool{
        
        willSet {
            let fadeAnimation = CABasicAnimation.init(keyPath: "opacity")
            fadeAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
            fadeAnimation.duration = 0.2
            if newValue{
                fadeAnimation.toValue = NSNumber.init(value: 0)
            }else{
                fadeAnimation.toValue = NSNumber.init(value: 1)
            }
            print(fadeAnimation.toValue.debugDescription)
            self.circleLayer.opacity = (fadeAnimation.toValue as! NSNumber).floatValue
            self.circleLayer.add(fadeAnimation, forKey: "fadeAnimation")
        }
        
    }
    
    
    override var isSelected: Bool{
        
        willSet {
            
            if self.model == FTCaptureButtonMode.FTCaptureButtonModeVideo {
                
                CATransaction.disableActions()
                let scaleAnimation = CABasicAnimation.init(keyPath: "transform.scale")
                let radiusAnimation = CABasicAnimation.init(keyPath: "cornerRadius")
                
                if newValue {
                    scaleAnimation.toValue = NSNumber.init(value: 0.6)
                    radiusAnimation.toValue = NSNumber.init(value: Float(self.circleLayer.bounds.width / 4.0))
                }else{
                    scaleAnimation.toValue = NSNumber.init(value: 1)
                    radiusAnimation.toValue = NSNumber.init(value: Float(self.circleLayer.bounds.width / 2.0))
                }
                
                let group = CAAnimationGroup.init()
                group.animations = [scaleAnimation,radiusAnimation]
                group.beginTime = CACurrentMediaTime() + 0.2
                group.duration = 0.35
                
                self.circleLayer.setValue(radiusAnimation, forKey: "radiusAnimation")
                self.circleLayer.setValue(scaleAnimation, forKey: "scaleAnimation")
                
                self.circleLayer.add(group, forKey: "group")
                
            }
            
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let context: CGContext! = UIGraphicsGetCurrentContext()
        context.setStrokeColor(UIColor.white.cgColor)
        context.setFillColor(UIColor.white.cgColor)
        context.setLineWidth(FTCAPTUE_LINE_WIDTH)
        let insetRect = rect.insetBy(dx: FTCAPTUE_LINE_WIDTH/2.0, dy: FTCAPTUE_LINE_WIDTH/2.0)
        context.strokeEllipse(in: insetRect)
        
    }
    
    
}


















