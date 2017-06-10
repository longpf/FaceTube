//
//  FTCaptureViewController.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/18.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

class FTCaptureViewController: FTViewController {
    
    /// 预览view
    var previewView: FTPreviewView!
    /// camer
    var camera: FTCamera!
    /// overlayView上面放着事件按钮
    var overlayView: FTCameraOverlayView!
    
    
    //MARK: ************************  life cycle  ************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let eaglContext = FTContextManager.shared.eaglContext
        self.previewView = FTPreviewView.init(frame: self.view.bounds, context: eaglContext!)
        self.previewView.coreImageContext = FTContextManager.shared.ciContext
        self.view.addSubview(self.previewView)
        
        self.camera = FTCamera()
        self.camera.imageTarget = self.previewView
        
        self.overlayView = FTCameraOverlayView.init(camera: self.camera)
        self.overlayView.frame = self.view.bounds
        self.view.addSubview(self.overlayView)
        
        var error: NSError? = nil
        if self.camera.setupSession(&error){
            self.camera.startSession()
        }else{
            print(error?.localizedDescription ?? "setupSession error")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarHidden(true, with: .none)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let tabbarController = tabBarController as? FTTabbarContrller{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                tabbarController.showTabBar(show: false, aniamtie: true)
            })
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
}
