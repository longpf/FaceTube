//
//  FTCameraOverlayView.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/19.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import SnapKit

protocol FTCameraOverlayViewProtocol {
    
}

class FTCameraOverlayView: FTView {

    var toolbar: FTVideoCaptureToolBar!     //顶部的工具栏
    var captureButton: FTCaptureButton!     //拍摄按钮
    fileprivate weak var camera: FTCamera!  //弱引用一个camer来 方便 与 overlayview 的交互
    fileprivate var filterPickerView: FTFiltersPickerView!     //滤镜选择的pickerView
    fileprivate var bottomMaskView: UIView! //底部的黑色半透明遮罩
    
    //MARK: ************************  life cycle  ************************
    
    init(camera: FTCamera){
        super.init(frame: CGRect.init())
        self.camera = camera
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize();
    }
    
    fileprivate func initialize(){
        
        self.toolbar = FTVideoCaptureToolBar()
        self.addSubview(self.toolbar)
        
        self.captureButton = FTCaptureButton.init(model: FTCaptureButtonMode.FTCaptureButtonModeVideo)
        self.captureButton.addTarget(self, action: #selector(FTCameraOverlayView.captureButtonClicked(button:)), for: .touchUpInside)
        self.addSubview(self.captureButton)

        self.filterPickerView = FTFiltersPickerView()
        self.addSubview(self.filterPickerView)
        
        self.bottomMaskView = UIView()
        self.bottomMaskView.backgroundColor = UIColor.black
        self.bottomMaskView.alpha = 0.4
        self.insertSubview(self.bottomMaskView, belowSubview: self.captureButton)
        
        self.toolbar.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.height.equalTo(40)
        }
        
        self.captureButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-15)
            make.size.equalTo(CGSize.init(width: 68, height: 68))
        }
        
        self.filterPickerView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.captureButton.snp.top).offset(-5)
            make.height.equalTo(40)
        }
        
        self.bottomMaskView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
            make.top.equalTo(self.filterPickerView.snp.top).offset(-10)
        }
        
    }

    //MARK: ************************  response methods  ***************
    
    func captureButtonClicked(button: UIButton){
        
        if self.camera.recording {
            self.camera.stopRecording()
        }else{
            self.camera.startRecording()
        }
        
        button.isSelected = !button.isSelected
    }
    
}
