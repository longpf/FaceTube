//
//  HomeViewController.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/1.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class FTHomeViewController: FTViewController,UITableViewDataSource {
    
    var SCREEN_SIZE: CGSize! = UIScreen.main.bounds.size
    
    var tableView: FTTableView!
    var dataSource: FTHomeLiveDataSource!
    var palyUrl = ""
    var player: IJKFFMoviePlayerController! = nil;
    
    
    
    //MARK:lift cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView = FTTableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height-40), style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        
        
        self.dataSource = FTHomeLiveDataSource()
        self.dataSource.fetchNewestData()
        self.dataSource.fetchDataCompleted = { (dataSource: FTDataSource) in
            self.tableView.reloadData()
        }
        
        
        
        
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
        
        
        
        
        
        
        
    }
    
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: NSInteger! = (self.dataSource.dataArray?.count)!
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model: FTHomeLiveModel = self.dataSource.dataArray?.object(at: indexPath.row) as! FTHomeLiveModel
        cell.textLabel?.text = model.nick
        return cell
        
    }
    
    
    
    
}

//extension HomeViewController: UITableViewDataSource {
//
//
//}

extension FTHomeViewController: UITableViewDelegate {
    
    
}
