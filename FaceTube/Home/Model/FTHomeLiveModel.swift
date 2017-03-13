//
//  FTHomeLiveModel.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/9.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import ObjectMapper

class FTHomeLiveModel: FTModel {
    
    var id: String?
    var nick: String?
    var gender: NSInteger!
    var radio_fan_number: NSInteger!
    var level: NSInteger!
    var online_users: NSInteger!
    var name: String!
    var city: String!
    var origin: String?
    var portrait: String?
    var live_id: String?
    var live_url: String?
    var status: NSInteger!
    


    override func mapping(map: Map) {
        
        id <- map["id"]
        nick <- map["nick"]
        gender <- map["gender"]
        radio_fan_number <- map["radio_fan_number"]
        level <- map["level"]
        online_users <- map["online_users"]
        name <- map["name"]
        city <- map["city"]
        origin <- map["origin"]
        portrait <- map["portrait"]
        live_id <- map["live_id"]
        live_url <- map["live_url"]
        status <- map["status"]
        
    }
}

class FTHomeLiveModelResponse: FTModel {
    
    var ret: NSInteger?
    var msg: String!
    var radio_list: [FTHomeLiveModel]?
    
    override func mapping(map: Map) {
        ret <- map["ret"]
        msg <- map["msg"]
        radio_list <- map["radio_list"]
    }
}
