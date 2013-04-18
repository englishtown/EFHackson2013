//
//  ViewController.m
//  TestBarcodeScanner
//
//  Created by Shi Lin on 4/18/13.
//  Copyright (c) 2013 Shi Lin. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "ScanBarcodeViewController.h"
#import "ZXingObjC.h"

@interface ScanBarcodeViewController ()<ZXCaptureDelegate>
@property (nonatomic, retain) ZXCapture* capture;
@property (nonatomic, assign) IBOutlet UILabel* decodedLabel;

- (NSString*)displayForResult:(ZXResult*)result;

@end

@implementation ScanBarcodeViewController
@synthesize capture,decodedLabel;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s",__PRETTY_FUNCTION__);

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.delegate = self;
    self.capture.rotation = 90.0f;
    
    // Use the back camera
    self.capture.camera = self.capture.back;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    [self.view bringSubviewToFront:self.decodedLabel];
    self.decodedLabel.numberOfLines = 0;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture*)capture result:(ZXResult*)result {
    if (result) {
        // We got a result. Display information about the result onscreen.
        [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:[self displayForResult:result] waitUntilDone:YES];
        
        NSLog(@"result %@", result);
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ACTIVITY_ID_Ready" object:[NSString stringWithFormat:@"%@",@"89774"]];
    }
}

- (void)captureSize:(ZXCapture*)capture width:(NSNumber*)width height:(NSNumber*)height {
}

#pragma mark - Private Methods

- (NSString*)displayForResult:(ZXResult*)result {
    return [NSString stringWithFormat:@"%@", result.text];
}


@end
