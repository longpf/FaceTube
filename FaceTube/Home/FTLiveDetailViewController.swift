//
//  FTLiveDetailViewController.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/15.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import SnapKit

class FTLiveDetailViewController: FTViewController {
    
    var player: IJKFFMoviePlayerController!
    var homeLiveModel: FTHomeLiveModel?
    fileprivate var backgroundImageView: UIImageView?
    fileprivate var visualEffectView: UIVisualEffectView?
    
    //MARK: lift cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor()
        
        backgroundImageView = UIImageView()
        backgroundImageView?.backgroundColor = UIColor.clear
        view.addSubview(backgroundImageView!)
        backgroundImageView?.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        let blurEffect: UIBlurEffect = UIBlurEffect.init(style: .light)
        visualEffectView = UIVisualEffectView.init(effect: blurEffect)
        backgroundImageView?.addSubview(visualEffectView!)
        visualEffectView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(backgroundImageView!)
        })
        
        let backButton = UIButton.init(frame: CGRect.init(x: 15, y: 20, width: 44, height: 44))
        backButton.setImage(UIImage.init(named: "ft_round_btn_back_n"), for: .normal)
        backButton.addTarget(self, action: #selector(FTLiveDetailViewController.gotoBack(button:)), for: .touchUpInside)
        view.addSubview(backButton)
        
        initPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if player != nil{
            player.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    deinit
    {
        if player != nil {
            player.stop()
            player = nil
        }
    }
    
    //MAKR:private methods
    
    func initPlayer() {
        
        if homeLiveModel != nil {
            let url = NSURL.init(string: (homeLiveModel?.stream_addr)!)
            
            let player = IJKFFMoviePlayerController.init(contentURL: url as URL!, with: nil)
            self.player = player;
            self.player.prepareToPlay()
            self.player.view.frame = UIScreen.main.bounds
            
            self.view.insertSubview(self.player.view, at: 1)
            
        }
    }
    
    //MARK: response methods
    
    func gotoBack(button: UIButton){
        _ = navigationController?.popViewController(animated: true)
    }

    //MARK:转场动画
    override func captureViewAnimationFrame() -> CGRect {
        return UIScreen.main.bounds
    }
    
    override func magicMoveTransionComplete() {

        let url = URL(string: (homeLiveModel?.creator?.portrait)!)
        backgroundImageView?.kf.setImage(with: url);

    }
    
}
