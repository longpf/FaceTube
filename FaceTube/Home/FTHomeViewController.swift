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


class FTHomeViewController: FTViewController {
    
    var SCREEN_SIZE: CGSize! = UIScreen.main.bounds.size
    
    var tableView: FTTableView!
    var dataSource: FTHomeLiveDataSource!
    var palyUrl = ""
    var player: IJKFFMoviePlayerController! = nil;
    
    
    
    //MARK:lift cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView = FTTableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height-40), style: .plain)
        self.tableView.register(FTHomeLiveTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.view.addSubview(self.tableView)
        
        
        self.dataSource = FTHomeLiveDataSource()
        self.dataSource.fetchNewestData()
        self.dataSource.fetchDataCompleted = { (dataSource: FTDataSource) in
            self.tableView.reloadData()
        }
        
        
        
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    
    
    
}

extension FTHomeViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: NSInteger! = (self.dataSource.dataArray?.count)!
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FTHomeLiveTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FTHomeLiveTableViewCell
        let model: FTHomeLiveModel = self.dataSource.dataArray?.object(at: indexPath.row) as! FTHomeLiveModel
        cell.updateHomeLiveCell(model: model)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

}

extension FTHomeViewController: UITableViewDelegate {
    
    
}
