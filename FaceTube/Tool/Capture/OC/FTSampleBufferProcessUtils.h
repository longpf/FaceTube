//
//  FTSampleBufferProcessUtils.h
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/6/10.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMSampleBuffer.h>
#import <CoreImage/CIImage.h>

@interface FTSampleBufferProcessUtils : NSObject

+ (CVImageBufferRef)processSampleBuffer:(CMSampleBufferRef)sampleBuffer;
+ (CIImage *)processSampleBuffer2CIImage:(CMSampleBufferRef)sampleBuffer;

@end
