//
//  DataController.h
//  ZhaoChanGuan
//
//  Created by zhang kai on 1/23/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject

+(id)sharedDataController;
-(void)fetachRestrant:(float)lat longitude:(float)lon;
@end
