//
//  TXHttpManager.h
//  ____
//
//  Created by Thinkey on 10/4/12.
//  Copyright (c) 2012 Thinkey. All rights reserved.
//

#import "Reachability.h"
#import "TXHttpRequest.h"
#define TXHTTP ((TXHttpManager *)[TXHttpManager sharedInstance])

#define NULL_GATEWAY @""
#define TIMEOUT 15.0
#define OK_STATUS_CODE 200

@interface TXHttpManager : NSObject

@property (nonatomic, strong) Reachability* _internetReach;
@property (nonatomic, assign) BOOL _hasInternet;
@property (nonatomic, strong) NSString *_gateway;
@property (nonatomic, assign) NSTimeInterval _timeout;
@property (nonatomic, assign) NSInteger _okStatusCode;

- (void)parseDataOfRequest:(TXHttpRequest *)request;
+ (id)sharedInstance;
+ (id)existentInstance;
@end
