//
//  Parse.h
//  ZhaoChanGuan
//
//  Created by zhang kai on 1/26/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restrants.h"
#import "Restrant.h"

@interface Parse : NSObject

+(id)sharedParse;
-(Restrants *)parseRestrants:(NSData *)data;
-(Restrant *)parseRestrant:(NSDictionary *)dictionary;
@end
