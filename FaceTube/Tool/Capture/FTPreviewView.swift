//
//  FTPreviewView.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/17.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import GLKit

class FTPreviewView: GLKView, FTImageTarget {

    public var filter: CIFilter?
    public var coreImageContext: CIContext?
    fileprivate var drawableBounds: CGRect!
    
    //MARK: ************************  life cycle  ************************
    
    override init(frame: CGRect, context: EAGLContext) {
        super .init(frame: frame, context: context)
        
        self.enableSetNeedsDisplay = false
        self.backgroundColor = UIColor.black
        self.isOpaque = true
        
        // because the native video image from the back camera is in
        // UIDeviceOrientationLandscapeLeft (i.e. the home button is on the right),
        // we need to apply a clockwise 90 degree transform so that we can draw
        // the video preview as if we were in a landscape-oriented view;
        // if you're using the front camera and you want to have a mirrored
        // preview (so that the user is seeing themselves in the mirror), you
        // need to apply an additional horizontal flip (by concatenating
        // CGAffineTransformMakeScale(-1.0, 1.0) to the rotation transform)
        self.transform = CGAffineTransform.init(rotationAngle: .pi/2.0)
        self.frame = frame
        
        self.bindDrawable()
        
        self.drawableBounds = self.bounds
        self.drawableBounds.size.width = CGFloat(self.drawableWidth)
        self.drawableBounds.size.height = CGFloat(self.drawableHeight)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filterChanged(notification:)), name: NSNotification.Name.FTFilterSelectionChangedNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ************************  response methods  ***************
    
    func filterChanged(notification: Notification){
        self.filter = notification.object as? CIFilter
    }
    
    
}

extension FTPreviewView{
    
    func setImage(image: CIImage) {
        self.bindDrawable()
        
        self.filter?.setValue(image, forKey: kCIInputImageKey)
        let filteredImage = self.filter?.outputImage;
        
        if filteredImage != nil {
            let cropRect = FTCenterCropImageRect(sourceRect: image.extent, previewRect: self.drawableBounds)
            self.coreImageContext?.draw(filteredImage!, in: self.drawableBounds, from: cropRect)
        }
        self.display()
        self.filter?.setValue(nil, forKey: kCIInputImageKey)
    }
    
}
