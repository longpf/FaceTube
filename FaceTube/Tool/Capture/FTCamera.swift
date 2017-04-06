//
//  FTCamera.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/5.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

class FTCamera: NSObject {

    public private(set) var captureSession: AVCaptureSession!
    public private(set) var cameraQueue: DispatchQueue!
    
    fileprivate override init() {
        
        cameraQueue = DispatchQueue.init(label: "com.facetube.camera")
        
    }
    
    //MARK:session
    
    public func setupSession(_ error: NSErrorPointer){
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = sessionPreset() as String!
        
    }
    
    public func sessionPreset() -> NSString {
        return AVCaptureSessionPresetHigh as NSString
    }
    
    public func setupSessinInputs(_ error: NSErrorPointer) -> Bool{
        
        let videoDevice: AVCaptureDevice = getVideoDevice(position: .front)!
        let audioDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        var videoDeviceInput: AVCaptureDeviceInput?
        var audioDeviceInput: AVCaptureDeviceInput?
        do{
            videoDeviceInput = try AVCaptureDeviceInput.init(device: videoDevice)
            audioDeviceInput = try AVCaptureDeviceInput.init(device: audioDevice)
        }catch let aError as NSError {
            error?.pointee = aError
        }
        
        if captureSession.canAddInput(videoDeviceInput){
            captureSession.addInput(videoDeviceInput)
        }
        if captureSession.canAddInput(audioDeviceInput){
            captureSession.addInput(audioDeviceInput)
        }

        return true
    }
    
    //MAKR:device
    
    fileprivate func getVideoDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        
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
