//
//  AppDelegate.h
//  TestBarcodeScanner
//
//  Created by Shi Lin on 4/18/13.
//  Copyright (c) 2013 Shi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScanBarcodeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) ScanBarcodeViewController *viewController;

@end
