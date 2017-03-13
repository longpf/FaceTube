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


class HomeViewController: FTViewController {

    var SCREEN_SIZE: CGSize! = UIScreen.main.bounds.size
    
    var tableView: FTTableView!
    var dataSource: FTHomeLiveDataSource!
    var palyUrl = ""
    var player: IJKFFMoviePlayerController! = nil;
    
    
    
    //MARK:lift cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.tableView = FTTableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height-40), style: .plain)
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.lightGray
        
        
        self.dataSource = FTHomeLiveDataSource()
        self.dataSource.fetchNewestData()
        self.dataSource.fetchDataCompleted = { (dataSource: FTDataSource) in
            
            for info in dataSource.dataArray! {
                let model = info as? FTHomeLiveModel
                print(model ?? "nil")
            }
            
        }
        
        
        // Do any additional setup after loading the view.

        
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
    


}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        return cell
    
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    
}
