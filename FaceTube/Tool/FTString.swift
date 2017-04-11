//
//  FTString.swift
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/4/10.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

import Foundation


extension String {
    
    func stringByMatchingRegex(regex: String,capture: NSInteger) -> String? {
        
        do {
            
            let expression = try NSRegularExpression.init(pattern: regex, options: .caseInsensitive)
            let result = expression.firstMatch(in: self, options: .reportProgress, range: NSRange.init(location: 0, length: self.characters.count))
            if (result?.numberOfRanges)! > capture {
                let nsrange = result?.rangeAt(capture)
                let rg = convertNSRange(from: nsrange!)
                return self.substring(with: rg!)
            }
        }catch{
            
        }
        
        return nil
    }

    
    //NSRange 转  range
    func convertNSRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from..<to
    }
    
}
