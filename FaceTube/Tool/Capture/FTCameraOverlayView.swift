//
//  FTCameraOverlayView.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/19.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import SnapKit

class FTCameraOverlayView: FTView {

    var toolbar: FTVideoCaptureToolBar!
    
    
    //MARK: ************************  life cycle  ************************
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initialize();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize();
    }
    
    fileprivate func initialize(){
        
        self.toolbar = FTVideoCaptureToolBar()
        self.addSubview(self.toolbar)
        
        
        
    }


}
