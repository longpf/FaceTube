//
//  FTPreviewView.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/17.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import GLKit

/// 预览view
class FTPreviewView: GLKView, FTImageTarget {

    public var coreImageContext: CIContext?
    fileprivate var drawableBounds: CGRect!
    fileprivate var devicePosition: AVCaptureDevicePosition!
    
    //MARK: ************************  life cycle  ************************
    
    override init(frame: CGRect, context: EAGLContext) {
        super .init(frame: frame, context: context)
        
        self.enableSetNeedsDisplay = false
        self.backgroundColor = UIColor.black
        self.isOpaque = true
        
        self.transform = transformWithDevice(devicePosition: .front)
        self.frame = frame
        self.devicePosition = AVCaptureDevicePosition.front
        
        //view与opengles绑定
        self.bindDrawable()
        
        self.drawableBounds = self.bounds
        self.drawableBounds.size.width = CGFloat(self.drawableWidth)
        self.drawableBounds.size.height = CGFloat(self.drawableHeight)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(filterChanged(notification:)), name: NSNotification.Name.FTFilterSelectionChangedNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ************************  interface methods  ***************
    
    
    /// 根据前后摄像头设置transform
    public func setTransformWithDevice(devicePosition: AVCaptureDevicePosition){
        
        if (devicePosition.rawValue == self.devicePosition.rawValue){
            return
        }
        
        switch devicePosition {
        case .back:
            self.transform = CGAffineTransform.init(rotationAngle: .pi/2.0)
            self.devicePosition = AVCaptureDevicePosition.back
            break
        case .front:
            self.transform = CGAffineTransform.init(rotationAngle: .pi*1.5).scaledBy(x: -1.0, y: 1.0)
            self.devicePosition = AVCaptureDevicePosition.front
            break
        default:
            break
        }
        
    }
    
    
    //MARK: ************************  response methods  ***************
    
//    func filterChanged(notification: Notification){
//        self.filter = (notification.object as? CIFilter)?.copy() as? CIFilter
//    }
    
    
}

extension FTPreviewView{
    
    func setImage(image: CIImage) {
        self.bindDrawable()
        
        FTPhotoFilters.shared.selectedFilter.setValue(image, forKey: kCIInputImageKey)
        let filteredImage = FTPhotoFilters.shared.selectedFilter.outputImage;

        if filteredImage != nil {
            self.coreImageContext?.draw(filteredImage!, in: CGRect.init(x: 0, y: 0, width: self.drawableWidth, height: self.drawableHeight), from: image.extent)
        }else{
            self.coreImageContext?.draw(image, in: CGRect.init(x: 0, y: 0, width: self.drawableWidth, height: self.drawableHeight), from: image.extent)
        }
        self.display()
        FTPhotoFilters.shared.selectedFilter.setValue(nil, forKey: kCIInputImageKey)
    }
    
}
