//
//  BarcodeScanner.m
//  TestBarcodeScanner
//
//  Created by Shi Lin on 4/19/13.
//  Copyright (c) 2013 Shi Lin. All rights reserved.
//

#import "BarcodeScanner.h"

static BarcodeScanner* instance;

@interface BarcodeScanner (){
    ZXCapture* capture;


}

@end
@implementation BarcodeScanner

+(id)sharedInstance{

    if (!instance) {
        instance = [[BarcodeScanner alloc] init];
        
    }
    return instance;
    
}

-(ZXCapture*)sharedCapture{

}

@end
