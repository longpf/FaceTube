//
//  FTLiveLabel.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/15.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import ObjectMapper

class FTLiveLabel: FTModel {
    
    var tab_name: String?
    var tab_key: String?
    var cl: [NSInteger]?
    
    
    override func mapping(map: Map) {
        
        tab_name <- map["tab_name"]
        tab_key <- map["tab_key"]
        cl <- map["cl"]
        
    }
    
    
    
}
