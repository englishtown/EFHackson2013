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
#import "AppDelegate.h"

@interface ScanBarcodeViewController ()<ZXCaptureDelegate,UIActionSheetDelegate>
@property (nonatomic, retain) ZXCapture* capture;
@property (nonatomic, assign) IBOutlet UILabel* decodedLabel;
@property (nonatomic, retain) NSString *unitId;
@property (nonatomic, retain) NSString *activityId;

- (NSString*)displayForResult:(ZXResult*)result;

@end

@implementation ScanBarcodeViewController
@synthesize capture,decodedLabel,unitId,activityId;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    if (self.capture == nil) {
        self.capture = [[ZXCapture alloc] init];
        self.capture.delegate = self;
        self.capture.rotation = 90.0f;
        
        // Use the back camera
        self.capture.camera = self.capture.back;
        
        self.capture.layer.frame = self.view.bounds;
        [self.view.layer addSublayer:self.capture.layer];
        [self.view bringSubviewToFront:self.decodedLabel];
        self.decodedLabel.numberOfLines = 0;
    }else{
        [self.capture start];
        [self.view.layer addSublayer:self.capture.layer];
    }

    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    [self.capture.layer removeFromSuperlayer];
    [self.capture stop];
    //self.capture = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
  
    

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
        
        if (result.text == nil || [result.text isEqualToString:@""]) {
            return;
        }
        
        NSArray *a = [result.text componentsSeparatedByString:@","];
        NSString *unit_idStr = [[a objectAtIndex:0] stringByReplacingOccurrencesOfString:@"unit!" withString:@""];
        if ([result.text hasPrefix:@"party!"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PARTY" object:@"8888"];
            return;
        }
        if (![result.text hasPrefix:@"unit!"] && ![result.text hasPrefix:@"activity!"]) {
            return;
        }
        if (([a count] == 1) || (([a count] == 2) && ([[NSString stringWithFormat:@"%@", [a objectAtIndex:1]] length]  == 0))) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashCardView" object:[NSString stringWithFormat:@"%@",unit_idStr]];
            return;
        }else if([a count] == 2 ){
            NSString *activity_idStr = [[a objectAtIndex:1] stringByReplacingOccurrencesOfString:@"activity!" withString:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ACTIVITY_ID_Ready" object:[NSString stringWithFormat:@"%@",activity_idStr]];
            
            NSArray *a = [result.text componentsSeparatedByString:@","];
            NSString *unit_idStr = [[a objectAtIndex:0] stringByReplacingOccurrencesOfString:@"unit!" withString:@""];
            
            if (([a count] == 1) || (([a count] == 2) && ([[NSString stringWithFormat:@"%@", [a objectAtIndex:1]] length]  == 0))) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashCardView" object:[NSString stringWithFormat:@"%@",unit_idStr]];
                return;
            }else if([a count] == 2 ){
                NSString *activity_idStr = [[a objectAtIndex:1] stringByReplacingOccurrencesOfString:@"activity!" withString:@""];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ACTIVITY_ID_Ready" object:[NSString stringWithFormat:@"%@",activity_idStr]];
                
                //            UIActionSheet *actionView = [[UIActionSheet alloc] initWithTitle:@"Title" delegate:self cancelButtonTitle:@"Redo" destructiveButtonTitle:@"Video" otherButtonTitles:@"Words", nil];
                //            [actionView showFromTabBar:((AppDelegate*)[UIApplication sharedApplication].delegate).tabBarController.tabBar];
                
                [self.capture stop];
                return;
            }
        }

    }
}


// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ACTIVITY_ID_Ready" object:[NSString stringWithFormat:@"%@",activityId]];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ACTIVITY_ID_Ready" object:[NSString stringWithFormat:@"%@",unitId]];
            break;
        default:
            [self.capture start];
            break;
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
    [self.capture start];
}

- (void)captureSize:(ZXCapture*)capture width:(NSNumber*)width height:(NSNumber*)height {
}

#pragma mark - Private Methods

- (NSString*)displayForResult:(ZXResult*)result {
    return [NSString stringWithFormat:@"%@", result.text];
}


@end
