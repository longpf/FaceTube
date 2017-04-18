//
//  FTImage.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/17.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import Foundation

func FTCenterCropImageRect(sourceRect: CGRect,previewRect: CGRect) -> CGRect {
    
    let sourceAspectRatio = sourceRect.size.width / sourceRect.size.height
    let previewAspectRatio = previewRect.size.width  / previewRect.size.height
    var drawRect = sourceRect
    if sourceAspectRatio > previewAspectRatio {
        let scaledHeight = drawRect.size.height * previewAspectRatio
        drawRect.origin.x = drawRect.origin.x + (drawRect.size.width - scaledHeight) / 2.0
        drawRect.size.width = scaledHeight
    }else{
        drawRect.origin.y = drawRect.origin.y + (drawRect.size.height - drawRect.size.width / previewAspectRatio) / 2.0
        drawRect.size.height = drawRect.size.width / previewAspectRatio
    }
    return drawRect
    
}
