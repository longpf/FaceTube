//
//  FTVideoCaptureViewController.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/3/22.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit
import SnapKit

class FTVideoCaptureViewController: FTViewController,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate {

    var captureSession: AVCaptureSession!
    var videoConnection: AVCaptureConnection!
    var previedLayer: AVCaptureVideoPreviewLayer!
    var currentVideoDeviceInput: AVCaptureDeviceInput!
    var videoToolBar: FTVideoCaptureToolBar!
    
    //MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoToolBar = FTVideoCaptureToolBar()
        videoToolBar.delegate = self
        view.addSubview(videoToolBar)
        videoToolBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view)
            make.height.equalTo(40)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (captureSession == nil) {
            buildCaptureVideo()
        }
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: private methods
    
    /// 捕获音视频
    func buildCaptureVideo() {
        
        // 1. 创建捕获会话
        captureSession = AVCaptureSession()
        
        // 2. 获取摄像头设备,默认后置摄像头
        let videoDevice: AVCaptureDevice = getVideoDevice(position: .front)!
        
        // 3. 获取声音设备
        let audioDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        
        // 4. 创建对应视频设备输入对象
        var videoDeviceInput: AVCaptureDeviceInput?
        var audioDeviceInput: AVCaptureDeviceInput?
        // 5. 创建对应音频设备输入对象
        do{
            videoDeviceInput = try AVCaptureDeviceInput.init(device: videoDevice)
            audioDeviceInput = try AVCaptureDeviceInput.init(device: audioDevice)
            currentVideoDeviceInput = videoDeviceInput
        }catch{}
        
        // 6. 添加到会话
        if captureSession.canAddInput(videoDeviceInput){
            captureSession.addInput(videoDeviceInput)
        }
        if captureSession.canAddInput(audioDeviceInput){
            captureSession.addInput(audioDeviceInput)
        }
        
        // 7. 获取视频数据输出设备
        let videoOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
        // 7.1 设置代理, 捕获视频样品数据
        // 注意: 队列必须是串行队列,才能获取到数据,而且不能为空
        let videoQueue = DispatchQueue.init(label: "ft.videoCapture.queue")
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        // 8. 获取音频数据输出设备
        let audioOutput: AVCaptureAudioDataOutput = AVCaptureAudioDataOutput()
        // 8.1 设置代理,捕获音频样品数据
        // 注意: 队列必须是串行队列,才能获取到数据,而且不能为空
        let audioQueue = DispatchQueue.init(label: "ft.audioCapture.queue")
        audioOutput.setSampleBufferDelegate(self, queue: audioQueue)
        
        // 9. 获取视频输入与输出连接,用于分辨音视频数据
        videoConnection = videoOutput.connection(withMediaType: AVMediaTypeVideo)
        
        // 10. 添加视频预览图层
        previedLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        previedLayer.frame = UIScreen.main.bounds
        view.layer.insertSublayer(previedLayer, at: 0)
        
        // 11. 启动会话
        captureSession.startRunning()
        
        
    }

    //获取摄像头
    func getVideoDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        
        let devices: [Any]! = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for itm in devices {
            if let device = itm as? AVCaptureDevice
            {
                if device.position==position{
                    return device
                }
            }
        }
        return nil
    }
}


//MARK: FTVideoCaptureToolBarDelegate


extension FTVideoCaptureViewController: FTVideoCaptureToolBarDelegate{
    
    func videoCaptureToolBarClose(){
        
    }
    
    func videoCaptureToolBarBeauty(){
        
    }
    
    //闪光灯
    func videoCaptureToolBarFlash(on: Bool){
        
        let currentDevice: AVCaptureDevice = currentVideoDeviceInput.device
        
        if currentDevice.hasFlash {
            
            do {
                
                try currentDevice.lockForConfiguration()
                
                if on{
                    
                    if currentDevice.isTorchModeSupported(.on) {
                        currentDevice.torchMode = .on
                    }
                    if currentDevice.isFlashModeSupported(.on){
                        currentDevice.flashMode = .on
                    }
                    
                }else{
                    
                    if currentDevice.isTorchModeSupported(.off){
                        currentDevice.torchMode = .off
                    }
                    if currentDevice.isFlashModeSupported(.off){
                        currentDevice.flashMode = .off
                    }
                }
                
                
                currentDevice.unlockForConfiguration()
                
            }catch{}
            
        }
        
    }
    
    //切换摄像头
    func videoCaptureToolBarSwitch(){
        
        let curPosition: AVCaptureDevicePosition = currentVideoDeviceInput.device.position
        let togglePosition: AVCaptureDevicePosition = curPosition == .front ? .back : .front
        
        //获取改变的摄像头设备
        let toggleDevice: AVCaptureDevice = getVideoDevice(position: togglePosition)!
        
        //获取改变的摄像头输入设备
        var toggleDeviceInput: AVCaptureDeviceInput?
        do{
            try toggleDeviceInput = AVCaptureDeviceInput.init(device: toggleDevice)
        }catch{}
        
        //移除之前摄像头输入设备
        captureSession.removeInput(currentVideoDeviceInput)
        
        //添加新的摄像头输入设备
        captureSession.addInput(toggleDeviceInput)
        
        //记录当前摄像头输入设备
        currentVideoDeviceInput = toggleDeviceInput
    }
    
}
