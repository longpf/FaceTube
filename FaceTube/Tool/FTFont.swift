//
//  FTFont.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/14.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import Foundation

extension UIFont {
    
    open class func ft_light(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "Heiti SC", size: size)!
    }
    
    open class func ft_regular(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "Geeza Pro", size: size)!
    }
    
    open class func ft_medium(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "Helvetica-Bold", size: size)!
    }
    
}

