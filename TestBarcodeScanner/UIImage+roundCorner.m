//
//  UIImage+roundCorner.m
//  MuyingYongpin
//
//  Created by zhang kai on 11/2/12.
//
//

#import "UIImage+roundCorner.h"

@implementation UIImage (RoundedCorners)

/**
 *	Takes a image, gives it rounded corners and returns it
 *	@param	radius The size of the corners
 *	@param	aColor The color of the area outside the masked area, pass nil or clearColor
 *	@return A newly masked image
 */
-(UIImage*) imageWithRoundedCorners:(CGFloat) radius alphaBackground:(UIColor*) aColor
{
    return [self imageWithSize:CGSizeMake(512, 512)//[self size]
						 block:^(CGContextRef context) {
                             
							 CGImageRef	mask,imageMask,maskedImage;
							 CGPathRef	path;
							 CGRect		rect	= CGRectZero;
                             
                             //							 rect.size = [self size];
                             rect.size = CGSizeMake(512, 512);
                             
							 //Create a path
							 path = [self newPathForRoundedRect:rect
														 radius:radius];
                             
							 //Fill the rect with a backing color
							 CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
							 CGContextFillRect(context, rect);
                             
							 // Add the path
							 CGContextAddPath(context, path);
                             
							 // Fill the path
							 CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
							 CGContextFillPath(context);
                             
							 imageMask = CGBitmapContextCreateImage(context);
                             
							 //Reset the context
							 CGContextClearRect(context,rect);
                             
							 mask = CGImageMaskCreate(
                                                      CGImageGetWidth(imageMask),
                                                      CGImageGetHeight(imageMask),
                                                      CGImageGetBitsPerComponent(imageMask),
                                                      CGImageGetBitsPerPixel(imageMask),
                                                      CGImageGetBytesPerRow(imageMask),
                                                      CGImageGetDataProvider(imageMask),
                                                      NULL,
                                                      false
                                                      );
                             
                             
							 if( !mask ){
                                 //Log failure
                                 //                                 DDLogWarn(@"Mask failed");
                             }
                             
							 //Mask the image
							 maskedImage = CGImageCreateWithMask([self CGImage], mask);
                             
							 //Set a possible background fill color
							 if( aColor ){
								 //Fill the rect with the background color
								 CGContextSetFillColorWithColor(context, [aColor CGColor]);
                                 
								 CGContextFillRect(context, rect);
							 }
                             
							 //Then draw the masked image
							 CGContextDrawImage(context, rect, maskedImage);
                             
							 //Clean up
							 CGImageRelease(maskedImage);
                             CGImageRelease(mask);
                             CGImageRelease(imageMask);
							 CGPathRelease(path);
                             
						 }];
    
}
//Create a pill with the given rect
- (CGPathRef) newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
        
    CGPathMoveToPoint(retPath, NULL, outside_left, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, outside_right, outside_top);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, outside_top);
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
}
-(UIImage*) imageWithSize:(CGSize) aSize block:(void(^)(CGContextRef ctx)) aBlock{
    
	CGContextRef		context;
	void				*bitmapData;
	CGColorSpaceRef		colorSpace;
	int					bitmapByteCount;
	int					bitmapBytesPerRow;
	CGImageRef			image;
	UIImage				*finalImage;
    
	//mask the image with the path
	bitmapBytesPerRow	= (aSize.width * 4);
	bitmapByteCount		= (bitmapBytesPerRow * aSize.height);
    
	//Create the color space
	colorSpace = CGColorSpaceCreateDeviceRGB();
    //    colorSpace = CGColorSpaceCreateDeviceGray();
    
	bitmapData = malloc( bitmapByteCount );
    
	//Check the the buffer is alloc'd
	if( bitmapData == NULL ){
        //		DebugLog(@"Buffer could not be alloc'd");
	}
    
	//Create the context
	context = CGBitmapContextCreate(bitmapData, aSize.width, aSize.height, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
	if( context == NULL ){
        //		DebugLog(@"Context could not be created");
	}
    
	//Run the block
	aBlock( context );
    
	//transer the data into an UIImage so we can cleanup
	image = CGBitmapContextCreateImage(context);
    
	finalImage = [UIImage imageWithCGImage:image];
    
	CGImageRelease(image);
    
	//Clean up
	free(bitmapData);
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
    
	return finalImage;
}
@end
