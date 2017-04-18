//
//  FTContextManager.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/5.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

final class FTContextManager: NSObject {

    
    public private(set) var eaglContext: EAGLContext!
    public private(set) var ciContext: CIContext!
    
    
    static let shared = FTContextManager();
    private override init() {
        
        eaglContext = EAGLContext.init(api: .openGLES2)
        ciContext = CIContext.init(eaglContext: eaglContext, options: [kCIContextWorkingColorSpace:NSNull.init()])
        
    }

    
    
}
