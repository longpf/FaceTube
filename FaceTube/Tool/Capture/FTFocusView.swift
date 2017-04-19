//
//  FTFocusView.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/24.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit


/// 聚焦的view
class FTFocusView: FTView {
    
    fileprivate var focusImageView: UIImageView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initialize();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize();
    }
    
    fileprivate func initialize(){
        
        backgroundColor = UIColor.clear
        contentMode = .scaleAspectFill
        focusImageView = UIImageView.init(image: UIImage.init(named: "ft_captureFocus"))
        addSubview(focusImageView)
        frame = focusImageView.frame
        
    }
    
    deinit {
        layer.removeAllAnimations()
    }
    
    
    //MARK:开始动画
    open func startAnimation() {
        
        layer.removeAllAnimations()
        
        transform =  CGAffineTransform.init(scaleX: 1.4, y: 1.4)
        alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: { 
            
            self.transform = CGAffineTransform.identity
            self.alpha = 1
            
        }) { (finish: Bool) in
            
            let options: UIViewAnimationOptions = [UIViewAnimationOptions.curveLinear,UIViewAnimationOptions.autoreverse,UIViewAnimationOptions.repeat]
            
            UIView.animate(withDuration: 0.4, delay: 0, options: options, animations: {
                self.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
                self.alpha = 1;
            }, completion: nil)
        }
    }
    
    //MARK:结束动画
    open func stopAnimation() {
        
        self.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseOut, animations: { 
            self.alpha = 0
        }) { (finish: Bool) in
            self.removeFromSuperview()
        }
        
        
    }
    

}
