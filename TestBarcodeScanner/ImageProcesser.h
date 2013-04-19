//
//  ImageProcesser.h
//  MuyingYongpin
//
//  Created by zhang kai on 10/30/12.
//
//

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"

@protocol ImageProcesserDelegate;

@interface ImageProcesser : NSObject
{
    NSOperationQueue *imageProcessQueue;
}

+(ImageProcesser *)sharedImageProcesser;


-(void)processImage:(UIImage *)image withDelegate:(id<ImageProcesserDelegate>)delegate;
@end

@protocol ImageProcesserDelegate<NSObject>

-(void)imageProcess:(ImageProcesser *)processer didFinishProcessImage:(UIImage *)image;

@end
