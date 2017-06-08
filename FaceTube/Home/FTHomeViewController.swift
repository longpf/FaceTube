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
import AMScrollingNavbar
import MJRefresh

class FTHomeViewController: FTViewController, ScrollingNavigationControllerDelegate {
    
    var tableView: FTTableView!
    var dataSource: FTHomeLiveDataSource!
    var palyUrl = ""
    var player: IJKFFMoviePlayerController! = nil;
    var toolbar: UIToolbar!
    var selectedCell: FTHomeLiveTableViewCell?
    
    //MARK:lift cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "FaceTube"
        view.backgroundColor = UIColor.backgroundColor()
        
        //dataSource
        self.dataSource = FTHomeLiveDataSource()
        self.dataSource.fetchDataCompleted = { (dataSource: FTDataSource) in
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }

        //tableView
        self.tableView = FTTableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height-40), style: .plain)
        self.tableView.register(FTHomeLiveTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.backgroundColor()
        self.view.addSubview(self.tableView)
        
        //refresh
        let header: MJRefreshNormalHeader = MJRefreshNormalHeader()
        header.setRefreshingTarget(self.dataSource, refreshingAction: #selector(FTDataSource.fetchNewestData))
        self.tableView.mj_header = header
        
        //获取数据
        self.tableView.mj_header.beginRefreshing()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (navigationController?.delegate == nil){
            navigationController?.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.navigationBarColor()
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 0.0)
            navigationController.scrollingNavbarDelegate = self
        }
        self.tableView.mj_header.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.mj_header.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //MARK: 转场动画
    override func captureView() -> UIView {
        return (selectedCell?.thumbImageView)!
    }
    
    override func needBlur() -> Bool {
        return true
    }
    
    override func needHiddenTabBar() -> Bool {
        return true
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
        return SCREEN_SIZE.width+50
    }

}

extension FTHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = tableView.cellForRow(at: indexPath) as! FTHomeLiveTableViewCell?
        let model: FTHomeLiveModel = dataSource.dataArray[indexPath.row] as! FTHomeLiveModel
        let detailCon: FTLiveDetailViewController = FTLiveDetailViewController()
        detailCon.homeLiveModel = model
        detailCon.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCon, animated: true)
    }
}

extension FTHomeViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.push {
            return FTMagicMoveTransion()
        } else {
            return nil
        }
    }
    
}



