//
//  FTImageTarget.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/12.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import Foundation

@objc protocol FTImageTarget: NSObjectProtocol {
    
    @objc optional func setImage(image: CIImage)
    
}

