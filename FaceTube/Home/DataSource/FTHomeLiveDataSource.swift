//
//  FTHomeLiveDataSource.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/9.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//`


import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper


class FTHomeLiveDataSource: FTDataSource {
    
    override func fetchNewestData() {
        fetchHomeLiveData()
    }
    
    override func fetchMoreData() {
        
        print("暂时不支持加载更多")
    }
    
    fileprivate func fetchHomeLiveData(){
        
        if !(self.dataArray != nil) {
            self.dataArray = NSMutableArray()
        }
        
        let path = "http://116.211.167.106/api/live/aggregation"
        let params: [String : String] = [
                                         "uid":"21868005",
                                         "interest":"1"
                                        ]
        
        weak var wSelf: FTHomeLiveDataSource! = self;
        
        FTHTTPClient.getRequest(urlString: path, params: params, success: { (response) in
            
            let models = Mapper<FTHomeLiveModelResponse>().map(JSONObject: response)?.lives
            if (wSelf != nil){
                wSelf.dataArray?.addObjects(from: models!)
                if (wSelf.fetchDataCompleted != nil){
                    wSelf.fetchDataCompleted!(wSelf)
                }
                if (wSelf.delegate != nil){
                    wSelf.delegate?.fetchDataCompleted(dataSource: wSelf)
                }
            }
            
        }) { (error: NSError?) in
            
            if (wSelf != nil){
                if(wSelf.fetchDataFail != nil){
                    wSelf.fetchDataFail!(wSelf,error!)
                }
            }
            if (wSelf.delegate != nil){
                wSelf.delegate?.fetchDataFail(dataSource: wSelf, error: error!)
            }
        }
        
    }
    
    
    
    
}
