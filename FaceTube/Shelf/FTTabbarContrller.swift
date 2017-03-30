//
//  FTTabbarContrller.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/1.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class FTTabbarContrller: UITabBarController {

    //MARK: ************************  life cycle  ************************
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addChildViewControllers()
    }

    //MARK: ************************  interface methods  ***************
    
    open func showTabBar(show: Bool , aniamtie: Bool){
        
        if show {
            
            if aniamtie{
                UIView.transition(with: tabBar, duration: 0.3, options: .curveLinear, animations: {
                    self.tabBar.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
                }, completion: nil)
            }else{
                self.tabBar.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
            }
            
            
        }else{
            
            tabBar.layer.removeAllAnimations()
            
            if aniamtie{
                UIView.transition(with: tabBar, duration: 0.3, options: .curveLinear, animations: {
                    self.tabBar.layer.transform = CATransform3DMakeTranslation(0, 60, 0)
                }, completion: nil)
            }else{
                self.tabBar.layer.transform = CATransform3DMakeTranslation(0, 60, 0)
            }
        }
    }
    
    
    //MARK:private methods
    
    fileprivate func addChildViewControllers(){
        
        //home
        let homeViewController = FTHomeViewController()
        homeViewController.view.backgroundColor = UIColor.backgroundColor()
        let homeTabBarItem: UITabBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "ft_tabbar_live"), selectedImage: UIImage.init(named: "ft_tabbar_live_hl"))
        homeTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        homeViewController.tabBarItem = homeTabBarItem
        let homeNav: ScrollingNavigationController = ScrollingNavigationController.init(rootViewController: homeViewController)
        
        
        //record
        let recordViewController = FTVideoCaptureViewController()
        recordViewController.view.backgroundColor = UIColor.backgroundColor()
        let recordTabBarItem: UITabBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "ft_tabbar_record"), selectedImage: UIImage.init(named: "ft_tabbar_record_hl"))
        recordTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        recordViewController.tabBarItem = recordTabBarItem
        let recordNav: ScrollingNavigationController = ScrollingNavigationController.init(rootViewController: recordViewController)
        
        
        let controllers = NSArray.init(array:[homeNav,recordNav])
        
        
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
