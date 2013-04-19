//
//  TXHttpManager.m
//  ____
//
//  Created by Thinkey on 10/4/12.
//  Copyright (c) 2012 Thinkey. All rights reserved.
//

#import "TXHttpManager.h"

static TXHttpManager *managerInstance = nil;
@implementation TXHttpManager
@synthesize _hasInternet, _gateway, _timeout, _okStatusCode, _internetReach;

- (void)updateInternetStatusWithReachability:(Reachability *)curReach
{
    if(curReach == _internetReach)
	{	
		NetworkStatus netStatus = [curReach currentReachabilityStatus];
		switch (netStatus)
		{
			case NotReachable:
			{
				self._hasInternet = NO;  
				break;
			}
				
			case ReachableViaWWAN:
			{
				self._hasInternet = YES;
				break;
			}
			case ReachableViaWiFi:
			{
				self._hasInternet = YES;
				break;
			}
		}
        if ([curReach connectionRequired] == YES) {
            self._hasInternet = NO;
        }
	}
}

- (void) reachabilityChanged: (NSNotification *)note
{
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInternetStatusWithReachability:curReach];
}

- (id)init
{
	self=[super init];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        self._internetReach = [Reachability reachabilityForInternetConnection];
        [_internetReach startNotifier];
        [self updateInternetStatusWithReachability:_internetReach];
        self._gateway = NULL_GATEWAY;
        self._timeout = TIMEOUT;
        self._okStatusCode = OK_STATUS_CODE;
	}
	return self;
}

- (void)parseDataOfRequest:(TXHttpRequest *)request
{
    if (request._parserMode == TXRequestParserNone) {
        return;
    } else if (request._parserMode == TXRequestParserJson) {
//        NSString *jsonString = [[NSString alloc] initWithData:request._rawData encoding:NSUTF8StringEncoding];
//        NSDictionary *jsonDic = [jsonString JSONValue];
//        request._parsedData = jsonDic;
//        NSLog(@"[TXHttpManager] jsonString: %@",jsonString);
    } else if (request._parserMode == TXRequestParserXml) {
        
    }
}

+ (id)existentInstance
{
    return managerInstance;
}

#pragma mark -
#pragma mark Singleton instance methods

+ (id)sharedInstance
{
    if (managerInstance == nil) {
        managerInstance = [[super allocWithZone:NULL] init];
    }
    return managerInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
