
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

