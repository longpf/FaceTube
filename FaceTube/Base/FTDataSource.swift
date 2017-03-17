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


/// 处理实现请求,json转model
class FTDataSource: NSObject {
    
    /// 数据列表
    var dataArray: NSMutableArray!
    
    /// 是否正在加载
    var isLoading: Bool!
    
    /// 分页
    var page: NSInteger!
    
    /// 是否还有更多数据,需要根据不同情况重写
    var hasMoreData: Bool!
    
    /// 代理,根据协议方法回调请求结果
    var delegate: FTDataSourceDelegate?
    
    /// 请求成功的回调,与delegate实现一个即可
    var fetchDataCompleted: ((_ dataSource: FTDataSource) -> Void)?
    
    /// 请求失败的回调,与delegate实现一个即可
    var fetchDataFail: ((_ dataSource: FTDataSource, _ error: NSError) -> Void)?
    
    override init(){
        super.init()
        dataArray = NSMutableArray()
    }
    
    public func fetchNewestData(){
        
    }
    
    public func fetchMoreData(){
        
    }
    
}
