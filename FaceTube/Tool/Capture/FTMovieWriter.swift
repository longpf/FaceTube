//
//  FTMovieWriter.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/10.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

protocol FTMovieWriterDelegate {
    
    func didWriteMovieAtURL(outputURL: NSURL);
    
}

fileprivate let FTVideoFileName: String = "movie.mov"

class FTMovieWriter: NSObject {

    fileprivate var assetWriter: AVAssetWriter?
    fileprivate var assetWriterVideoInput: AVAssetWriterInput?
    fileprivate var assetWriterAudioInput: AVAssetWriterInput?
    fileprivate var assetWriterInputPixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    fileprivate var colorSpace: CGColorSpace!
    
    fileprivate var videoSettings: [AnyHashable : Any]
    fileprivate var audioSettings: [AnyHashable : Any]
    
    fileprivate var dispatchQueue: DispatchQueue
    
    fileprivate weak var ciContext: CIContext!
    fileprivate var activeFilter: CIFilter?
    
    /// 生命周期内执行一次的标记
    fileprivate var onceToken_lifeCycle: Bool!
    
    init(videoSettings: [AnyHashable : Any], audioSettings: [AnyHashable : Any], dispatchQueue: DispatchQueue){
        
        self.videoSettings = videoSettings
        self.audioSettings = audioSettings
        self.dispatchQueue = dispatchQueue
        
        self.ciContext = FTContextManager.shared.ciContext
        self.colorSpace = CGColorSpaceCreateDeviceRGB()
        
        self.activeFilter = FTPhotoFilters.defaultFilter()
        self.onceToken_lifeCycle = true
        
    }
    
    deinit {
        if !onceToken_lifeCycle{
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    //MARK: ************************  interface methods  ***************
    
    public func startWriting() {
        
        if self.onceToken_lifeCycle{
            //注册监听
            registeredObservers()
            self.onceToken_lifeCycle = false
        }
        
        self.dispatchQueue.async {
            
            do {
                let fileType = AVFileTypeQuickTimeMovie
                try self.assetWriter = AVAssetWriter.init(outputURL: self.outputURL() as URL, fileType: fileType)
            }catch let error{
                print(error)
                return
            }
            
            self.assetWriterVideoInput = AVAssetWriterInput.init(mediaType: AVMediaTypeVideo, outputSettings: self.videoSettings as? [String : Any])
            self.assetWriterVideoInput?.expectsMediaDataInRealTime = true //是否将输入处理成RealTime
            
            
        }
        
        
    }
    
    //MARK: ************************  private methods  *****************
    
    private func registeredObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(filterChanged(notification:)), name: Notification.Name.FTFilterSelectionChangedNotification, object: nil)
    }
    
    private func outputURL() -> NSURL{
        
        let filePath = NSTemporaryDirectory().appendingFormat("/%@", FTVideoFileName)
        let url = NSURL.fileURL(withPath: filePath)
        if FileManager.default.fileExists(atPath: filePath) {
            do{
                try FileManager.default.removeItem(at: url)
            }catch{}
        }
        
        return url as NSURL
    }
    
    //MARK: ************************  response methods  ***************
    @objc private func filterChanged(notification: Notification){
        self.activeFilter = notification.object as? CIFilter;
    }
    


    
}
