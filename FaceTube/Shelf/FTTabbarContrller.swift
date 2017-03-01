//
//  FTTabbarContrller.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/1.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

class FTTabbarContrller: UITabBarController {

    //MARK:lift cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addChildViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    //MARK:private methods
    
    fileprivate func addChildViewControllers(){
        
        let homeViewController = HomeViewController()
        homeViewController.view.backgroundColor = UIColor.red
        homeViewController.tabBarItem.title = "首页"
        
        let secViewController = HomeViewController()
        secViewController.view.backgroundColor = UIColor.yellow
        secViewController.tabBarItem.title = "sec"
        
        let controllers = NSArray.init(array:[homeViewController,secViewController])
        
        self.viewControllers = controllers as? [UIViewController]
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
