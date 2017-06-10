//
//  FTSampleBufferProcessUtils.m
//  FaceTube
//
//  Created by 龙鹏飞 on 2017/6/10.
//  Copyright © 2017年 https://github.com/LongPF/FaceTube. All rights reserved.
//

#import <opencv2/opencv.hpp>
//导入支持iOS 10平台
#import <opencv2/imgcodecs/ios.h>
#include"opencv2/imgproc/imgproc.hpp"
#include "opencv2/core/core.hpp"
#include"opencv2/highgui/highgui.hpp"
#import "FTSampleBufferProcessUtils.h"


@implementation FTSampleBufferProcessUtils


//处理成CVImageBufferRef   mat_dst没释放
+ (CVImageBufferRef)processSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    
    cv::Mat mat_src = [self matFromImageBuffer:imageBuffer];
    cv::Mat mat_dst;
    cv::cvtColor (mat_src, mat_dst, cv::COLOR_BGRA2BGR);
    
    /*
     第一个参数，InputArray类型的src，输入图像，即源图像，需要为8位或者浮点型单通道、三通道的图像。
     第二个参数，OutputArray类型的dst，即目标图像，需要和源图片有一样的尺寸和类型。
     第三个参数，int类型的d，表示在过滤过程中每个像素邻域的直径。如果这个值我们设其为非正数，那么OpenCV会从第五个参数sigmaSpace来计算出它来。
     第四个参数，double类型的sigmaColor，颜色空间滤波器的sigma值。这个参数的值越大，就表明该像素邻域内有更宽广的颜色会被混合到一起，产生较大的半相等颜色区域。
     第五个参数，double类型的sigmaSpace坐标空间中滤波器的sigma值，坐标空间的标注方差。他的数值越大，意味着越远的像素会相互影响，从而使更大的区域足够相似的颜色获取相同的颜色。当d>0，d指定了邻域大小且与sigmaSpace无关。否则，d正比于sigmaSpace。
     第六个参数，int类型的borderType，用于推断图像外部像素的某种边界模式。注意它有默认值BORDER_DEFAULT。
     */
    
    bilateralFilter(mat_src, mat_dst, 2, 2, 2);
    
    //释放
    mat_src.release();
    
    return [self getImageBufferFromMat:mat_dst];
}

//处理成CIImage
+ (CIImage *)processSampleBuffer2CIImage:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    
    cv::Mat mat_src = [self matFromImageBuffer:imageBuffer];
    cv::Mat mat_dst;
    cv::cvtColor (mat_src, mat_dst, 1);
    
    /*
     第一个参数，InputArray类型的src，输入图像，即源图像，需要为8位或者浮点型单通道、三通道的图像。
     第二个参数，OutputArray类型的dst，即目标图像，需要和源图片有一样的尺寸和类型。
     第三个参数，int类型的d，表示在过滤过程中每个像素邻域的直径。如果这个值我们设其为非正数，那么OpenCV会从第五个参数sigmaSpace来计算出它来。
     第四个参数，double类型的sigmaColor，颜色空间滤波器的sigma值。这个参数的值越大，就表明该像素邻域内有更宽广的颜色会被混合到一起，产生较大的半相等颜色区域。
     第五个参数，double类型的sigmaSpace坐标空间中滤波器的sigma值，坐标空间的标注方差。他的数值越大，意味着越远的像素会相互影响，从而使更大的区域足够相似的颜色获取相同的颜色。当d>0，d指定了邻域大小且与sigmaSpace无关。否则，d正比于sigmaSpace。
     第六个参数，int类型的borderType，用于推断图像外部像素的某种边界模式。注意它有默认值BORDER_DEFAULT。
     */
    
    int value = 2;
    
    bilateralFilter(mat_src, mat_dst, value, value*2, value/2);
    
    
    CVImageBufferRef resultBuffer = [self getImageBufferFromMat:mat_dst];
    
    //释放
    mat_src.release();
    mat_dst.release();
    
    CIImage *resultImage = [CIImage imageWithCVImageBuffer:resultBuffer];
    
    CVPixelBufferRelease(resultBuffer);
    
    return resultImage;
}


+ (cv::Mat) matFromImageBuffer: (CVImageBufferRef) buffer {
    
    cv::Mat mat ;
    
    CVPixelBufferLockBaseAddress(buffer, 0);
    
    void *address = CVPixelBufferGetBaseAddress(buffer);
    int width = (int) CVPixelBufferGetWidth(buffer);
    int height = (int) CVPixelBufferGetHeight(buffer);
    
    mat   = cv::Mat(height, width, CV_8UC3, address, 0);
    //cv::cvtColor(mat, _mat, CV_BGRA2BGR);
    
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    
    return mat;
}

+ (CVImageBufferRef) getImageBufferFromMat: (cv::Mat) mat {
    
    cv::cvtColor(mat, mat, CV_BGR2BGRA);
    
    int width = mat.cols;
    int height = mat.rows;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             // [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             // [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             [NSNumber numberWithInt:width], kCVPixelBufferWidthKey,
                             [NSNumber numberWithInt:height], kCVPixelBufferHeightKey,
                             nil];
    
    CVPixelBufferRef imageBuffer;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorMalloc, width, height, kCVPixelFormatType_32BGRA, (CFDictionaryRef) CFBridgingRetain(options), &imageBuffer) ;
    
    
    NSParameterAssert(status == kCVReturnSuccess && imageBuffer != NULL);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *base = CVPixelBufferGetBaseAddress(imageBuffer) ;
    memcpy(base, mat.data, mat.total()*4);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return imageBuffer;
}


@end
