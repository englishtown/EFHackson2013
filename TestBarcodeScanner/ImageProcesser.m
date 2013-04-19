//
//  ImageProcesser.m
//  MuyingYongpin
//
//  Created by zhang kai on 10/30/12.
//
//

#import "ImageProcesser.h"
#import "UIImage+roundCorner.h"

#define PROCESSED_IMAGE_KEY @"processedImage"
#define PROCESS_INFO_KEY @"processInfo"

#define IMAGE_KEY @"image"
#define DELEGATE_KEY @"delegate"

@implementation ImageProcesser
static ImageProcesser *sharedInstance;

- (void)dealloc
{
    SDWISafeRelease(imageProcessQueue);
    SDWISuperDealoc;
}

+(ImageProcesser *)sharedImageProcesser
{
    if (!sharedInstance)
    {
        sharedInstance = [[ImageProcesser alloc] init];
    }
    return sharedInstance;
}
- (id)init
{
    if ((self = [super init]))
    {
        // Initialization code here.
        imageProcessQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

-(void)processImage:(UIImage *)image withDelegate:(id<ImageProcesserDelegate>)delegate 
{
    NSDictionary *processInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                image, IMAGE_KEY,
                                delegate, DELEGATE_KEY,nil];
    
    NSOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(processImageWithInfo:) object:processInfo];
    [imageProcessQueue addOperation:operation];
    SDWIRelease(operation);
}
-(void)processImageWithInfo:(NSDictionary *)processInfo
{
    UIImage *image = [processInfo objectForKey:IMAGE_KEY];
    
    UIImage *processedImage = [image imageWithRoundedCorners:8 alphaBackground:[UIColor clearColor]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          processedImage, PROCESSED_IMAGE_KEY,
                          processInfo,PROCESS_INFO_KEY,nil];
    
    [self performSelectorOnMainThread:@selector(notifyDelegateOnMainThreadWithInfo:) withObject:dict waitUntilDone:NO];
}
- (void)notifyDelegateOnMainThreadWithInfo:(NSDictionary *)dict
{
    SDWIRetain(dict);
    NSDictionary *processInfo = [dict objectForKey:PROCESS_INFO_KEY];
    UIImage *processedImage = [dict objectForKey:PROCESSED_IMAGE_KEY];
    
    id <ImageProcesserDelegate> delegate = [processInfo objectForKey:DELEGATE_KEY];
    
    [delegate imageProcess:self didFinishProcessImage:processedImage];
    SDWIRelease(dict);
}

@end


