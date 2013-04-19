//
//  StartActionViewController.m
//  TestBarcodeScanner
//
//  Created by Thinkey on 4/18/13.
//  Copyright (c) 2013 Shi Lin. All rights reserved.
//

#import "StartActionViewController.h"
#define min(x,y) ({ (x) < (y) ? (x) : (y); })
#import "UIImage+LipOperation.h"
#import "TXHttpManager.h"
#import "TXFloatView.h"
#import "HomeViewController.h"

@interface StartActionViewController ()
@property (nonatomic, strong) TXFloatView *loading;
@end

@implementation StartActionViewController

- (CGSize)forcefitSize:(CGSize)thisSize inSize:(CGSize) aSize
{
	CGFloat scale1;
	CGFloat scale2;
	CGSize newsize = thisSize;
	
	if (newsize.height && newsize.width) {
		scale1 = aSize.height / newsize.height;
		scale2 = aSize.width / newsize.width;
		scale1 = min(scale1,scale2);
		newsize.width *= scale1;
		newsize.height *= scale1;
	}
	return newsize;
}

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
    self.scrollView.contentSize = CGSizeMake(320, 630);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)search:(id)sender
{
    [self.navigationController pushViewController:[[HomeViewController alloc] init] animated:YES];
}
- (IBAction)call:(id)sender
{
    NSString *str = [@"tel://" stringByAppendingString:@"18621638686"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)upload:(id)sender
{
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.sourceType = type;
        self.imagePickerController.allowsEditing = YES;
        self.imagePickerController.delegate = self;
        [self presentModalViewController:self.imagePickerController animated:NO];
    }

}

- (void)submitUserImage:(UIImage *)image doneBlock:(TXRequestDoneBlock)doneBlock
{
    NSString *strUrlPath = @"http://schooldragonuat.englishtown.com/hackthon/uploadimagehandler.ashx";
	TXHttpRequest *req = [TXHttpRequest requestWithEndPoint:strUrlPath
                                                 parameters:nil
                                                  doneBlock:^(TXHttpRequest *request){
                                                      doneBlock(request);
                                                  }];
    req._httpMethod = @"POSTIMAGE";
    req._parserMode = TXRequestParserNone;
    req._postData = UIImageJPEGRepresentation (image, 0.6);
    [req sendRequest];
}

- (void)doUpload
{
    self.loading = [TXFloatView viewInSuperview:self.view];
    [self.loading showAnimated:YES withString:nil];
    [self submitUserImage:self.uploadImage doneBlock:^(TXHttpRequest *req){
        [self.loading hideAnimated:YES thenCleanup:YES];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    CGSize targetSize = CGSizeMake(280*2, 280*2);
    CGSize realSize = [self forcefitSize:image.size inSize:targetSize];
	self.uploadImage = [image resizedImage:realSize interpolationQuality:kCGInterpolationDefault];
    [self.upload setImage:self.uploadImage forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(doUpload) withObject:nil afterDelay:0.3];
}

@end
