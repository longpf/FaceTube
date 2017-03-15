//
//  File.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/14.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import Foundation



/*
 FTHTTPClient
 .getRequest(urlString: "http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1", params: nil, success: {
 (responsObjc) -> Void in
 
 let json = JSON(responsObjc)
 let datas = json["lives"].array
 
 for index in 0...3
 {
 if index == 1
 {
 let dic = datas?[1]
 let url = dic?["stream_addr"]
 
 self.palyUrl = (url?.string)!
 
 print(url)
 
 self.initPlayer()
 
 break
 }
 }
 
 }, fail: { (error) -> Void in
 
 print(error)
 
 
 })
 
 
 */


/*

func initPlayer() {
    
    if !self.palyUrl.isEmpty
    {
        let url = NSURL.init(string: self.palyUrl)
        let player = IJKFFMoviePlayerController.init(contentURL: url as URL!, with: nil)
        self.player = player;
        self.player.prepareToPlay()
        self.player.view.frame = UIScreen.main.bounds
        
        self.view.insertSubview(self.player.view, at: 1)
    }
    
    
}

*/




