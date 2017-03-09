//
//  FTDataSource.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/9.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

protocol FTDataSourceDelegate {
    
    func fetchDataCompleted(dataSource: FTDataSource)
    func fetchDataFail(dataSource: FTDataSource, error: NSError)
}

class FTDataSource: NSObject {
    
    var isLoading: Bool!
    var page: NSInteger!
    var hasMoreData: Bool!
    var delegate: FTDataSourceDelegate?
    
    public func fetchNewestData(){
        
    }
    
    public func fetchMoreData(){
        
    }
    
}
