//
//  TXHttpRequest.m
//  ____
//
//  Created by Thinkey on 10/4/12.
//  Copyright (c) 2012 Thinkey. All rights reserved.
//

#import "TXHttpRequest.h"
#import "TXHttpManager.h"


@implementation TXHttpRequest
@synthesize _gateway, _endPoint, _parameters, _httpMethod, _timeout, _rawData, _parsedData, _result, _parserMode, _doneBlock, _retry, _postData;
- (void)dealloc
{
    NSLog(@"request clean");
}

- (id)initWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)parameters doneBlock:(TXRequestDoneBlock)doneBlock;
{
    self=[super init];
    if (self) {
        NSLog(@"request init");
		self._gateway = TXHTTP._gateway;
        self._httpMethod = @"GET";
        self._timeout = TXHTTP._timeout;
        _result = TXRequestResultNa;
        self._parserMode = TXRequestParserJson;
        self._retry = 0;
        self._rawData = [NSMutableData data];
        self._endPoint = endPoint;
        self._parameters = parameters;
        self._doneBlock = doneBlock;
	}
	return self;
}

- (id)init
{
    return [self initWithEndPoint:nil parameters:nil doneBlock:nil];
}

+ (id)requestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)parameters doneBlock:(TXRequestDoneBlock)doneBlock
{
    return [[self alloc] initWithEndPoint:endPoint parameters:parameters doneBlock:doneBlock];
}

+ (id)sendRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)parameters doneBlock:(TXRequestDoneBlock)doneBlock
{
    TXHttpRequest *request = [[self alloc] initWithEndPoint:endPoint parameters:parameters doneBlock:doneBlock];
    [request sendRequest];
    return request;
}


+ (NSString *)urlEncodedString:(NSString *)str
{
	//(CFStringRef)@"$&+,/:;=?@"
	NSString *result = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (CFStringRef)@"!*'();:@&=+$,/?#[]", kCFStringEncodingUTF8);
	return result;
}

- (NSString *)parametersString
{	
	NSString *str = @"";
	if (self._parameters == nil) {
        return str;
    }
	for(NSString *key in [self._parameters allKeys])
	{
		NSString *value = [self._parameters objectForKey:key];
		value = [TXHttpRequest urlEncodedString:value];
		str = [str stringByAppendingFormat:@"%@=%@&", key, value];
	}
	return [str substringToIndex:[str length]-1];
}

- (NSString *)urlString
{
	NSString *str = [NSString stringWithFormat:@"%@%@", self._gateway, self._endPoint];
	if ([[self._parameters allKeys] count]) {
		str = [str stringByAppendingString:@"?"];
        str = [str stringByAppendingString:[self parametersString]];
	}
	return str;
}

- (void)_sendRequest
{
    NSURL *url;
    NSMutableURLRequest *httpRequest;
    if([self._httpMethod isEqualToString:@"GET"])
    {
        url = [NSURL URLWithString:[self urlString]];
        httpRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self._timeout];
    } else if ([self._httpMethod isEqualToString:@"POSTIMAGE"]) {
        url = [NSURL URLWithString:[self urlString]];
        httpRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self._timeout];
        [httpRequest setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [httpRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: attachment; name=\"photo[image]\"; filename=\"x.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:(NSData *)_postData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //    // text parameter
        //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"parameter1\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[parameterValue1 dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpRequest setHTTPBody:body];
    } else {    //post
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self._gateway, self._endPoint]];
        httpRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self._timeout];
        [httpRequest setHTTPMethod:@"POST"];
        NSString *postString = [self parametersString];
        NSLog(@"[TXHttpRequest] post data: %@", postString);
        NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        [httpRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [httpRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [httpRequest setHTTPBody:postData];
    }
    NSLog(@"[TXHttpRequest] req url: %@", [url description]);
    [NSURLConnection connectionWithRequest:httpRequest delegate:self];
}

- (void)sendRequest
{
	if(TXHTTP._hasInternet)
	{
		[self _sendRequest];
		return;
	}
    _result = TXRequestConnectionError;
    if (_doneBlock) {
        self._doneBlock(self);
    }   
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self._rawData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{	
    if ([(NSHTTPURLResponse*)response statusCode] != TXHTTP._okStatusCode) {
        _result = TXRequestResponseError;
        NSLog(@"HTTP statusCode error, %d", [(NSHTTPURLResponse*)response statusCode]);
    }
	[self._rawData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_result != TXRequestResponseError) {
        [TXHTTP parseDataOfRequest:self];
        _result = TXRequestSuccess;
    }
    if (_doneBlock) {
        self._doneBlock(self);
    }
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (self._retry) {
        self._retry --;
        [self sendRequest];
    } else {
        _result = TXRequestConnectionError;
        if (_doneBlock) {
            self._doneBlock(self);
        }
    }
}

@end
