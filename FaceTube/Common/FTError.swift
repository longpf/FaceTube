//
//  FTError.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/6.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import Foundation


public let FTCameraErrorDomain: String = "com.longpf.FTCameraErrorDomain"


enum FTCameraErrorCode: Int{
    
    case FTCameraErrorFailedToAddInput = 1000,
         FTCameraErrorFailedToAddOutput,
         FTCameraErrorHighFrameRateCaptureNotSupported
    
}





