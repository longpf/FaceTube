//
//  FTViewController.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/9.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import AMScrollingNavbar


class FTViewController: ScrollingNavigationViewController,FTMagicMoveTransionFromProtocol,FTMagicMoveTransionToProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //转场动画
    func captureView() -> UIView? {
        return nil
    }
    
    func captureViewAnimationFrame() -> CGRect {
        return CGRect.init()
    }
    
    func magicMoveTransionComplete() {
        
    }
    
    func needBlur() -> Bool {
        return false
    }
    
    func needHiddenTabBar() -> Bool{
        return false
    }


}
