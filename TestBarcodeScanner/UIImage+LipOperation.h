//
//  UIImage+LipOperation.h
//  LANCOME
//
//  Created by Xin Thinkey on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (LipOperation)
- (UIImage *)imageByMergingImage:(UIImage *)overlay;
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
+ (UIImage *) imageWithView:(UIView *)view;
- (UIImage *)croppedImage:(CGRect)bounds;
@end

