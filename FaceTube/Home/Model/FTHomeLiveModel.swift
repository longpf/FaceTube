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
    
    var creator: FTLiveUser?
    var id: String?
    var name: String!
    var city: String!
    var share_addr: String?
    var stream_addr: String?
    var version: NSInteger?
    var slot:NSInteger?
    var live_type: String?
    var landscape: NSInteger?
    var like: [Any]?
    var optimal: NSInteger?
    var online_users: NSInteger!
    var group: NSInteger?
    var link: NSInteger?
    var multi: NSInteger?
    var rotate: NSInteger?
    var extra: FTHomeLiveExtraModel?

    override func mapping(map: Map) {
        
        creator <- map["creator"]
        id <- map["id"]
        name <- map["name"]
        city <- map["city"]
        share_addr <- map["share_addr"]
        stream_addr <- map["stream_addr"]
        version <- map ["version"]
        slot <- map["slot"]
        live_type <- map["live_type"]
        landscape <- map["landscape"]
        like <- map["like"]
        optimal <- map["optimal"]
        online_users <- map["online_users"]
        group <- map["group"]
        link <- map["link"]
        multi <- map["multi"]
        rotate <- map["rotate"]
        extra <- map["extra"]
        
    }
}

class FTHomeLiveExtraModel: FTModel {
    
    var cover: Any?
    var label: [FTLiveLabel]?
    
    override func mapping(map: Map) {
        
        cover <- map["cover"]
        label <- map["label"]
        
    }
}


class FTHomeLiveModelResponse: FTModel {
    
    var dm_error: NSInteger?
    var error_msg: String!
    var lives: [FTHomeLiveModel]?
    var expire_time: NSInteger?
    
    override func mapping(map: Map) {
        dm_error <- map["dm_error"]
        error_msg <- map["error_msg"]
        lives <- map["lives"]
        expire_time <- map["expire_time"]
    }
}
