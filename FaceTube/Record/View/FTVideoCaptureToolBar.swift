//
//  FTVideoCaptureToolBar.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/23.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol FTVideoCaptureToolBarDelegate: NSObjectProtocol {
    
    func videoCaptureToolBarClose()
    func videoCaptureToolBarBeauty()
    func videoCaptureToolBarFlash(on: Bool) -> Bool
    func videoCaptureToolBarSwitch()
    
}

class FTVideoCaptureToolBar: FTView {

    var closeButton: UIButton!
    var beautyButton: UIButton!
    var flashButton: UIButton!
    var cameraSwitchButton: UIButton!
    var delegate: FTVideoCaptureToolBarDelegate?;
    var flash_on = false
    
    //MAKR : life cycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initialize();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize();
    }
    
    func initialize(){
        
        self.backgroundColor = UIColor.clear
        
        closeButton = UIButton()
        closeButton.setImage(UIImage.init(named: "ft_record_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction(button:)), for: .touchUpInside)
        self.addSubview(closeButton)
        
        beautyButton = UIButton()
        beautyButton.setImage(UIImage.init(named: "ft_record_beauty_on"), for: .normal)
        beautyButton.addTarget(self, action: #selector(beautyAction(button:)), for: .touchUpInside)
        self.addSubview(beautyButton)
        
        flashButton = UIButton()
        flashButton.setImage(UIImage.init(named: "ft_record_flash_off"), for: .normal)
        flashButton.setImage(UIImage.init(named: "ft_record_flash_disable"), for: .disabled)
        flashButton.addTarget(self, action: #selector(flashAction(button:)), for: .touchUpInside)
        self.addSubview(flashButton)
        
        cameraSwitchButton = UIButton()
        cameraSwitchButton.setImage(UIImage.init(named: "ft_record_switch_camera"), for: .normal)
        cameraSwitchButton.addTarget(self, action: #selector(camerSwitchButton(button:)), for: .touchUpInside)
        self.addSubview(cameraSwitchButton)
        
        closeButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(0)
            make.top.bottom.equalTo(self)
            make.width.equalTo(beautyButton.snp.width)
        }
        
        beautyButton.snp.makeConstraints { (make) in
            make.leading.equalTo(closeButton.snp.trailing)
            make.top.bottom.equalTo(self)
            make.width.equalTo(beautyButton.snp.width)
        }
        
        flashButton.snp.makeConstraints { (make) in
            make.leading.equalTo(beautyButton.snp.trailing)
            make.top.bottom.equalTo(self)
            make.width.equalTo(beautyButton.snp.width)
        }
        
        cameraSwitchButton.snp.makeConstraints { (make) in
            make.leading.equalTo(flashButton.snp.trailing)
            make.trailing.equalTo(self.snp.trailing)
            make.top.bottom.equalTo(self)
            make.width.equalTo(beautyButton.snp.width)
        }
        
    }
    
    //MARK: ************************  interface methods  ***************
    open func setFlash(on: Bool){
        
        if on {
            flashButton.setImage(UIImage.init(named: "ft_record_flash_on"), for: .normal)
        }else{
            flashButton.setImage(UIImage.init(named: "ft_record_flash_off"), for: .normal)
        }
        
    }
    
    
    //MARK: response mehtods
    
    func closeAction(button: UIButton){
        
        let sel: Selector! = NSSelectorFromString("videoCaptureToolBarClose")
        if (delegate != nil && (delegate?.responds(to: sel))!){
            delegate?.videoCaptureToolBarClose()
        }
        
    }
    
    func beautyAction(button: UIButton){
        
        let sel: Selector! = NSSelectorFromString("videoCaptureToolBarBeauty")
        if (delegate != nil && (delegate?.responds(to: sel))!){
            delegate?.videoCaptureToolBarBeauty()
        }
        
    }
    
    func flashAction(button: UIButton){
        
        let sel = #selector(FTVideoCaptureToolBarDelegate.videoCaptureToolBarFlash(on:))
        if (delegate != nil && (delegate?.responds(to: sel))!){
            let success = delegate?.videoCaptureToolBarFlash(on: flash_on)
            if success! {
                
                //开启/关闭闪光灯成功后改变按钮的image
                if flash_on {
                    flashButton.setImage(UIImage.init(named: "ft_record_flash_on"), for: .normal)
                }
                else{
                    flashButton.setImage(UIImage.init(named: "ft_record_flash_off"), for: .normal)
                }
                
                flash_on = !flash_on
                
            }
            
        }
        
    }
    
    
    func camerSwitchButton(button: UIButton){
        
        let sel: Selector! = NSSelectorFromString("videoCaptureToolBarSwitch")
        if (delegate != nil && (delegate?.responds(to: sel))!){
            delegate?.videoCaptureToolBarSwitch()
        }
        
    }
    
}
