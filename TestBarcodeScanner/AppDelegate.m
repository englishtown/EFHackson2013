//
//  AppDelegate.m
//  TestBarcodeScanner
//
//  Created by Shi Lin on 4/18/13.
//  Copyright (c) 2013 Shi Lin. All rights reserved.
//

#import "AppDelegate.h"

#import "ScanBarcodeViewController.h"
#import "StudyFlashcardsViewController.h"
#import "StudyVideoViewController.h"
#import "ActionsViewController.h"
#import "ViewController.h"
#import "FlashCardRootViewController.h"
#import "ScanBarcodeViewController.h"
#import "ViewController.h"

@implementation AppDelegate
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    ScanBarcodeViewController *sbVC = [[ScanBarcodeViewController alloc] initWithNibName:@"ScanBarcodeViewController" bundle:nil];
    ActionsViewController *aaVC = [[ActionsViewController alloc] initWithNibName:@"ActionsViewController" bundle:nil];
    UINavigationController *aVC = [[UINavigationController alloc] initWithRootViewController:aaVC];
    [aVC.navigationBar setTintColor:[UIColor colorWithRed:6/255.0 green:64/255.0 blue:94/255.0 alpha:1.0]];
    ViewController *svVC = [[ViewController alloc] init];
    FlashCardRootViewController *sfVC = [[FlashCardRootViewController alloc] init];

    sbVC.title = @"Scan";
    sfVC.title = @"Flashcards";
    svVC.title = @"Video";
    aVC.title = @"Facetime";
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:6/255.0 green:64/255.0 blue:94/255.0 alpha:1.0]];
    self.tabBarController.viewControllers = @[sbVC,svVC, sfVC,aVC];
    
    UITabBarItem *scanItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:0];
    scanItem.image = [UIImage imageNamed:@"Audit.png"];
    
    UITabBarItem *videoItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
    videoItem.image = [UIImage imageNamed:@"Cinema.png"];
    
    UITabBarItem *flashcardItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:2];
    flashcardItem.image = [UIImage imageNamed:@"Notepad.png"];
    
    UITabBarItem *facetimeItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:3];
    facetimeItem.image = [UIImage imageNamed:@"Balloon.png"];
    
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
