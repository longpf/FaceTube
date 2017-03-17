//
//  FTMagicMoveTransion.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/15.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import Foundation


@objc protocol FTMagicMoveTransionFromProtocol {
    //转场开始,从前一个视图捕获一个view将被截图用作转场动画
    @objc optional func captureView() -> UIView?
    //是否需要模糊
    @objc optional func needBlur() -> Bool
    //是否需要隐藏tabbar
    @objc optional func needHiddenTabBar() -> Bool
}


@objc protocol FTMagicMoveTransionToProtocol {
    
    //执行转场动画时,被捕获的view将被设置的frame
    @objc optional func captureViewAnimationFrame() -> CGRect
    
    //转场动画执行结束的操作
    @objc optional func magicMoveTransionComplete()
    
}


class FTMagicMoveTransion: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC: FTViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! FTViewController
        let toVC: FTViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! FTViewController
        let container = transitionContext.containerView
        
        //截屏  因为tabbar push 的时候可能会消失 影响动画效果 所有需要截屏
        var screenShotView: UIImageView? = nil;
        
        //是否需要隐藏tabbar
        let needHiddenTabBar: Bool = fromVC.needHiddenTabBar()
        
        if (needHiddenTabBar){
            fromVC.tabBarController?.tabBar.isHidden = true
            
            //截屏
            let screenShot: UIImage = FTTool.screenSnapshot()!
            screenShotView = UIImageView.init(image: screenShot)
            screenShotView?.frame = UIScreen.main.bounds
        }
        
        
        //从源控制器获得一个view的截图用来执行动画用
        assert( fromVC.captureView() != nil, "captureView() error")
        if fromVC.captureView() == nil{
            return
        }
        let captureView: UIView = fromVC.captureView()!
        let snapshotView: UIView = captureView.snapshotView(afterScreenUpdates: false)!
        snapshotView.frame = container.convert(captureView.frame, from: captureView.superview)
        captureView.isHidden = true
        if fromVC.needBlur(){
            //处理模糊
            let blurEffect: UIBlurEffect = UIBlurEffect.init(style: .light)
            let visualEffectView: UIVisualEffectView = UIVisualEffectView.init(effect: blurEffect)
            visualEffectView.frame = toVC.captureViewAnimationFrame()
            snapshotView.addSubview(visualEffectView)
        }
        
        //设置目标控制器的位置,并把透明度设为0, 在后面的动画中慢慢显示出来变为1
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        
        //都添加到container中, 顺序不能错了
        if needHiddenTabBar{
            container.addSubview(screenShotView!)
        }
        container.addSubview(toVC.view)
        container.addSubview(snapshotView)
        
        
        //执行动画
        toVC.view.layoutIfNeeded()
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations: { 
            
            let rect: CGRect = toVC.captureViewAnimationFrame()
            snapshotView.frame = rect
            toVC.view.alpha = 1
            
        }) { (finish: Bool) in
            
            captureView.isHidden = false
            snapshotView.removeFromSuperview()
            if needHiddenTabBar{
                screenShotView?.removeFromSuperview()
            }
            let completeSel: Selector = #selector(FTMagicMoveTransionToProtocol.magicMoveTransionComplete)
            if toVC.responds(to: completeSel){
                toVC.magicMoveTransionComplete()
            }
            //动画执行完后,让系统管理navigation
            transitionContext.completeTransition(true)
        }
        
    }
    
}



