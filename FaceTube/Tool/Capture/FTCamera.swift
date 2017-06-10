//
//  FTCamera.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/5.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

class FTCamera: NSObject,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate {

    //捕获会话
    public private(set) var captureSession: AVCaptureSession!
    public private(set) var cameraQueue: DispatchQueue!
    public private(set) var recording: Bool!
    public var imageTarget: FTImageTarget?
    
    
    //视频数据输出设备
    fileprivate var videoDataOutput: AVCaptureVideoDataOutput?
    //音频数据输出设备
    fileprivate var audioDataOutput: AVCaptureAudioDataOutput?
    fileprivate var activeVideoInput: AVCaptureDeviceInput?
    
    fileprivate var movieWriter: FTMovieWriter?
    
    override init() {
        
        cameraQueue = DispatchQueue.init(label: "com.facetube.camera")
        recording = false
        
    }
    
    //MARK:session
    
    public func setupSession(_ error: NSErrorPointer) -> Bool{
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = sessionPreset() as String!
        
        if !setupSessinInputs(error) {
            return false
        }
        
        if !setupSessionOutputs(error){
            return false
        }
        
        return true
    }
    
    public func sessionPreset() -> NSString {
        return AVCaptureSessionPreset1280x720 as NSString
    }
    
    public func setupSessinInputs(_ error: NSErrorPointer) -> Bool{
        
        let videoDevice: AVCaptureDevice = cameraWithPosition(position: .front)!
        let audioDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        var videoDeviceInput: AVCaptureDeviceInput?
        var audioDeviceInput: AVCaptureDeviceInput?
        do{
            videoDeviceInput = try AVCaptureDeviceInput.init(device: videoDevice)
            audioDeviceInput = try AVCaptureDeviceInput.init(device: audioDevice)
            activeVideoInput = videoDeviceInput
        }catch let aError as NSError {
            error?.pointee = aError
            return false
        }
        
        if captureSession.canAddInput(videoDeviceInput){
            captureSession.addInput(videoDeviceInput)
        }else{
            error?.pointee = NSError.init(domain: FTCameraErrorDomain, code: FTCameraErrorCode.FTCameraErrorFailedToAddInput.rawValue, userInfo: [NSLocalizedDescriptionKey:"Failed to add video input."])
            return false
        }
        if captureSession.canAddInput(audioDeviceInput){
            captureSession.addInput(audioDeviceInput)
        }else{
            error?.pointee = NSError.init(domain: FTCameraErrorDomain, code: FTCameraErrorCode.FTCameraErrorFailedToAddInput.rawValue, userInfo: [NSLocalizedDescriptionKey:"Failed to add video input."])
            return false
        }

        return true
    }
    
    public func  setupSessionOutputs(_ error: NSErrorPointer) -> Bool{
        
        videoDataOutput = AVCaptureVideoDataOutput()
        //kCVPixelBufferPixelFormatTypeKey用来指定像素的输出格式
        videoDataOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable:NSNumber.init(value: kCVPixelFormatType_32BGRA)]
        videoDataOutput?.alwaysDiscardsLateVideoFrames = false
        videoDataOutput?.setSampleBufferDelegate(self, queue: cameraQueue)
        
        if self.captureSession.canAddOutput(self.videoDataOutput) {
            self.captureSession.addOutput(self.videoDataOutput)
        }else{
            return false
        }
        
        audioDataOutput = AVCaptureAudioDataOutput()
        audioDataOutput?.setSampleBufferDelegate(self, queue: cameraQueue)
        
        if self.captureSession.canAddOutput(self.audioDataOutput){
            self.captureSession.addOutput(self.audioDataOutput)
        }else{
            return false
        }
        
        let videoSettings = videoDataOutput?.recommendedVideoSettingsForAssetWriter(withOutputFileType: AVFileTypeQuickTimeMovie)
        let audioSettings = audioDataOutput?.recommendedAudioSettingsForAssetWriter(withOutputFileType: AVFileTypeQuickTimeMovie)
        
        movieWriter = FTMovieWriter.init(videoSettings: videoSettings!, audioSettings: audioSettings!, dispatchQueue: cameraQueue)
        movieWriter?.delegate = self
        
        return true
    }
    
    /// 开启会话
    public func startSession(){
        
        cameraQueue.async {
            if !self.captureSession.isRunning{
                self.captureSession.startRunning()
            }
        }
    }
    
    /// 停止会话
    public func stopSession() {
        
        if self.captureSession.isRunning {
            self.captureSession.stopRunning()
        }
        
    }
    
    /// 开始录制
    public func startRecording(){
        movieWriter?.startWriting()
        recording = true
    }
    
    /// 停止录制
    public func stopRecording() {
        movieWriter?.stopWriting()
        recording = false
    }
    
    
    //MARK:device
    
    
    ///根据摄像头前后位置获取捕获设备
    fileprivate func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        
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
    
    ///获取正在摄像头
    func activeCamera() -> AVCaptureDevice? {
        return activeVideoInput?.device
    }
    
    ///没在使用的摄像头
    func inactiveCamera() -> AVCaptureDevice? {
        var device: AVCaptureDevice? = nil;
        
        if cameraCount() > 1 {
            if activeCamera()?.position == .back {
                device = cameraWithPosition(position: .front)
            }else{
                device = cameraWithPosition(position: .back)
            }
        }
        
        return device;
    }
    
    ///摄像头数量
    func cameraCount() -> NSInteger {
        return AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count
    }
    
    ///是否可以切换摄像头
    func canSwitchCameras() -> Bool {
        return cameraCount() > 1
    }
    
    ///切换摄像头
    func switchCamers() -> Bool {
        
        if !canSwitchCameras(){
            return false
        }
        
        //获取改变的摄像头设备
        let toggleDevice: AVCaptureDevice? = inactiveCamera()
        
        //获取改变的摄像头输入设备
        var toggleDeviceInput: AVCaptureDeviceInput?
        do{
            try toggleDeviceInput = AVCaptureDeviceInput.init(device: toggleDevice)
        }catch{
            return false
        }
        
        //        if (toggleDeviceInput != nil && captureSession.canAddInput(toggleDeviceInput)) {
        //        }
        captureSession.removeInput(activeVideoInput)
        captureSession.addInput(toggleDeviceInput)
        
        activeVideoInput = toggleDeviceInput;
        
        return true
    }
    
    ///正在使用的摄像头是否支持闪光灯
    func activeCameraHasFlash() -> Bool {
        let currentDevice = activeCamera()
        return (currentDevice?.hasFlash)!
    }
    
    ///正在使用的摄像头的打开或是关闭
    func activeCameraSwitchFlash(on: Bool) -> Bool {
        
        if activeCameraHasFlash() {
            
            let currentDevice: AVCaptureDevice! = activeCamera()
            
            do {
                
                try currentDevice.lockForConfiguration()
                
                if on{
                    
                    if currentDevice.isTorchModeSupported(.on) {
                        currentDevice.torchMode = .on
                    }else{
                        return false
                    }
                    if currentDevice.isFlashModeSupported(.on){
                        currentDevice.flashMode = .on
                    }
                    
                }else{
                    
                    if currentDevice.isTorchModeSupported(.off){
                        currentDevice.torchMode = .off
                    }else{
                        return false
                    }
                    if currentDevice.isFlashModeSupported(.off){
                        currentDevice.flashMode = .off
                    }
                }
                currentDevice.unlockForConfiguration()
                
            }catch{
                return false
            }
            
            return true
        }
        
        return false
    }
    
    //MARK:AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        movieWriter?.processSampleBuffer(sampleBuffer: sampleBuffer)
        
        if captureOutput == videoDataOutput{
            let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            let sourceImage = CIImage.init(cvPixelBuffer: imageBuffer)
            self.imageTarget?.setImage!(image: sourceImage)
        }
        
    }
    
}

extension FTCamera: FTMovieWriterDelegate {
    func didWriteMovieAtURL(outputURL: NSURL) {
        UISaveVideoAtPathToSavedPhotosAlbum(outputURL.path!, self, #selector(video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func video(videoPath: String, didFinishSavingWithError error: NSError, contextInfo info: UnsafeMutableRawPointer) {
    }
}
