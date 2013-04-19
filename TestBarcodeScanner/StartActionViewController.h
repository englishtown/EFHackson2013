//
//  StartActionViewController.h
//  TestBarcodeScanner
//
//  Created by Thinkey on 4/18/13.
//  Copyright (c) 2013 Shi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartActionViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIButton *upload;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

- (IBAction)search:(id)sender;
- (IBAction)call:(id)sender;
- (IBAction)upload:(id)sender;

@end
