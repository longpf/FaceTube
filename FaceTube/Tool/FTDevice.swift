
//
//  FTDevice.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/11.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import Foundation

public func transformForDeviceOrientation(orientation: UIDeviceOrientation) -> CGAffineTransform {
    
    var result: CGAffineTransform = CGAffineTransform.identity
    
    switch orientation {
    case .landscapeRight:
        result = CGAffineTransform.init(rotationAngle: .pi)
        break
    case .portraitUpsideDown:
        result = CGAffineTransform.init(rotationAngle: .pi * 1.5)
        break

    case .faceDown,.faceUp,.portrait:
        result = CGAffineTransform.init(rotationAngle: .pi * 0.5)
        break
    default:
        break
    
    }
    
    return result
    
}

/// 根据前后摄像头返回transform
public func transformWithDevice(devicePosition: AVCaptureDevicePosition) -> CGAffineTransform {
    
    var transform = CGAffineTransform.identity
    
    switch devicePosition {
    case .back:
        transform = CGAffineTransform.init(rotationAngle: .pi/2.0)
        break
    case .front:
        transform = CGAffineTransform.init(rotationAngle: .pi*1.5).scaledBy(x: -1.0, y: 1.0)
        break
    default:
        break
    }
    return transform
}


