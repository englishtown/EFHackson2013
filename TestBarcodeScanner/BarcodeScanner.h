//
//  BarcodeScanner.h
//  TestBarcodeScanner
//
//  Created by Shi Lin on 4/19/13.
//  Copyright (c) 2013 Shi Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXingObjC.h"

@interface BarcodeScanner : NSObject

+(id)sharedInstance;
-(ZXCapture*)sharedCapture;

@end
