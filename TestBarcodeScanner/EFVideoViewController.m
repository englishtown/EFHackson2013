//
//  EFVideoViewController.m
//  EFHack2013
//
//  Created by zhangkai on 4/18/13.
//  Copyright (c) 2013 zhangkai. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "EFVideoViewController.h"

@interface EFVideoViewController ()
{
    MPMoviePlayerController *moviePlayerController;
}
@end

@implementation EFVideoViewController
@synthesize mediaName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor yellowColor];
        
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *mediapath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,mediaName];
    
    NSURL *fileURL = [NSURL fileURLWithPath:mediapath];
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [moviePlayerController.view setFrame:CGRectMake(0, 0, 320, 564-20)];
    [self.view addSubview:moviePlayerController.view];
    moviePlayerController.fullscreen = YES;
    [moviePlayerController play];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 10, 60, 30);
    backButton.backgroundColor = [UIColor grayColor];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
-(void)goBack
{
    [moviePlayerController pause];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        [moviePlayerController.view setFrame:CGRectMake(0, 0, 564, 300)];
    }else{
        
        [moviePlayerController.view setFrame:CGRectMake(0, 0, 320, 564-20)];
    }
}
//-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        
//        [moviePlayerController.view setFrame:CGRectMake(0, 0, 320, 460)];
//    }else{
//        
//        [moviePlayerController.view setFrame:CGRectMake(0, 0, 460, 320)];
//    }
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
