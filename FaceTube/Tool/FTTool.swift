//
//  FTTool.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/9.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

class FTTool: NSObject {

    ///时间戳10位 秒级
    public class func timestamp() -> String{
        return String((NSInteger)(NSDate().timeIntervalSince1970))
    }
    
}
