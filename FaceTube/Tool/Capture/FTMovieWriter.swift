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

    public var delegate: FTMovieWriterDelegate?
    public private(set) var isWriting: Bool!
    
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
    fileprivate var firstSample: Bool!
    
    init(videoSettings: [AnyHashable : Any], audioSettings: [AnyHashable : Any], dispatchQueue: DispatchQueue){
        
        self.videoSettings = videoSettings
        self.audioSettings = audioSettings
        self.dispatchQueue = dispatchQueue
        
        self.isWriting = false
        
        self.ciContext = FTContextManager.shared.ciContext
        self.colorSpace = CGColorSpaceCreateDeviceRGB()
        
        self.activeFilter = FTPhotoFilters.defaultFilter()
        self.onceToken_lifeCycle = true
        self.firstSample = true
        
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
            self.assetWriterVideoInput?.transform = transformForDeviceOrientation(orientation: UIDevice.current.orientation)
            
            let attributes: [String : Any] = [
                                                kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA,
                                                kCVPixelBufferWidthKey as String : self.videoSettings[AVVideoWidthKey]!,
                                                kCVPixelBufferHeightKey as String : self.videoSettings[AVVideoHeightKey]!,
                                                kCVPixelFormatOpenGLESCompatibility as String : kCFBooleanTrue
                                             ]
            
            self.assetWriterInputPixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor.init(assetWriterInput: self.assetWriterVideoInput!, sourcePixelBufferAttributes: attributes)
            
            
            if (self.assetWriter?.canAdd(self.assetWriterVideoInput!))!{
                self.assetWriter?.add(self.assetWriterVideoInput!)
            }else{
                print("unable to add video input.")
                return
            }
            
            self.assetWriterAudioInput = AVAssetWriterInput.init(mediaType: AVMediaTypeAudio, outputSettings: self.audioSettings as? [String : Any])
            self.assetWriterAudioInput?.expectsMediaDataInRealTime = true
            
            if (self.assetWriter?.canAdd(self.assetWriterAudioInput!))!{
                self.assetWriter?.add(self.assetWriterAudioInput!)
            }else{
                print("unable to add audio input")
            }
            
            self.isWriting = true
            self.firstSample = true
            
        }
        
    }
    
    public func processSampleBuffer(sampleBuffer: CMSampleBuffer){
    
        if !self.isWriting{
            return
        }
        
        let formatDesc = CMSampleBufferGetFormatDescription(sampleBuffer)
        let mediaType = CMFormatDescriptionGetMediaType(formatDesc!)
        
        if mediaType == kCMMediaType_Video {
            
            //获取最近一次的 timestamp
            let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            
            if self.firstSample{
                
                if (self.assetWriter?.startWriting())!{
                    self.assetWriter?.startSession(atSourceTime: timestamp)
                }else{
                    print("failed to start writing.")
                }
                self.firstSample = false
            }
            
            var outputRenderBuffer: CVPixelBuffer? = nil
            //buffer重用池
            let pixelBufferPool: CVPixelBufferPool? = self.assetWriterInputPixelBufferAdaptor?.pixelBufferPool
            
            let err: OSStatus = CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool!, &outputRenderBuffer)
            
            if err != 0 {
                print("unable to obtain a pixel buffer from the pool")
                return
            }
            
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            
            let sourceImage = CIImage.init(cvPixelBuffer: imageBuffer!)
            
            self.activeFilter?.setValue(sourceImage, forKey: kCIInputImageKey)
            
            var filteredImage = self.activeFilter?.outputImage
            
            if filteredImage != nil {
                filteredImage = sourceImage;
            }
            
            self.ciContext.render(filteredImage!, to: outputRenderBuffer!, bounds: (filteredImage?.extent)!, colorSpace: self.colorSpace)
            
            if (self.assetWriterVideoInput?.isReadyForMoreMediaData)!{
                if !(self.assetWriterInputPixelBufferAdaptor?.append(outputRenderBuffer!, withPresentationTime: timestamp))!{
                    print("error appending pixel buffer.")
                }
            }
            
            //swift core foundation 自动管理内存
            //CVPixelBufferRelease(outputRenderBuffer)
        }
        else if (!self.firstSample && mediaType == kCMMediaType_Audio){
            
            if (self.assetWriterAudioInput?.isReadyForMoreMediaData)! {
                if !(self.assetWriterAudioInput?.append(sampleBuffer))! {
                    print("error appending audio sample buffer")
                }
            }
            
        }
    }
    
    public func stopWriting() {
        
        self.isWriting = false
        
        self.dispatchQueue.async {
            
            self.assetWriter?.finishWriting {
                
                if self.assetWriter?.status == AVAssetWriterStatus.completed{
                    
                    DispatchQueue.main.async {
                        let fileURL = self.assetWriter?.outputURL
                        if self.delegate != nil {
                            self.delegate?.didWriteMovieAtURL(outputURL: fileURL! as NSURL)
                        }
                    }
                }
                else{
                    print("fail to write movie"+(self.assetWriter?.error.debugDescription)!)
                    
                }
            }
            
            
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
