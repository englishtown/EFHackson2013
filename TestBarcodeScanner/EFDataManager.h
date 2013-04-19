//
//  EFDataManager.h
//  EFHack2013
//
//  Created by zhangkai on 4/18/13.
//  Copyright (c) 2013 zhangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFDataManager : NSObject

+(id)sharedDataManager;
-(void)parseUrlResource:(NSString *)urlStr;
@end
