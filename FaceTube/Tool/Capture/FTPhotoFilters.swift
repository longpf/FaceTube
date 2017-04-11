//
//  FTPhotoFilters.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/10.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import UIKit

class FTPhotoFilters: NSObject {

    public class func filterNames() -> [String] {
        
        return [
                "CIPhotoEffectChrome",
                "CIPhotoEffectFade",
                "CIPhotoEffectInstant",
                "CIPhotoEffectMono",
                "CIPhotoEffectNoir",
                "CIPhotoEffectProcess",
                "CIPhotoEffectTonal",
                "CIPhotoEffectTransfer"
                ]
    }
    
    
    
    public class func filterDisplayNames() -> [String] {
        
        var array: [String] = []
        
        for filterName in  FTPhotoFilters.filterNames(){
            array.append(filterName.stringByMatchingRegex(regex: "CIPhotoEffect(.*)", capture: 1)!)
        }
        
        return array
    }
    
    public class func defaultFilter() -> CIFilter{
        
        let filterName: String = filterNames().first!
        return CIFilter.init(name: filterName)!
        
    }

    public class func filterForDisplayName(displayName: String) -> CIFilter?{
        
        for name in FTPhotoFilters.filterNames() {
            if name.contains(displayName){
                return CIFilter.init(name: name)
            }
        }
        return nil
    }
    
    
}
