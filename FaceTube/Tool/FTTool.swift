//
//  FTTool.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/9.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit


public let SCREEN_SIZE: CGSize = UIScreen.main.bounds.size


class FTTool: NSObject {

    ///时间戳10位 秒级
    public class func timestamp() -> String{
        return String((NSInteger)(NSDate().timeIntervalSince1970))
    }
    
    ///数字转字符串(单位 万/千万)
    public class func number2String(num: NSInteger) -> String{
        var result = ""
        if num < 10000{
            result = String(num)
        }else if num < 100000000{
            result = String(format: "%.1f万", CGFloat(num) / 10000.0)
        }else{
            result = String(format: "%.1f亿", CGFloat(num) / 100000000.0)
        }
        return result
    }
    
    //截屏
    public class func screenSnapshot() -> UIImage? {
        
        guard let window = UIApplication.shared.keyWindow else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
