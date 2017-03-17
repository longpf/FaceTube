//
//  FTLiveUser.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/15.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import ObjectMapper

class FTLiveUser: FTModel {
    
    var id: String?
    var nick: String?
    var gender: NSInteger?
    var level: NSInteger?
    var portrait: String?
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        nick <- map["nick"]
        gender <- map["gender"]
        level <- map["level"]
        portrait <- map["portrait"]
        
    }

    
}
