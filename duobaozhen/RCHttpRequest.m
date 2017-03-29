//
//  RCHttpRequest.m
//  rsscoffee
//
//  Created by xuzepei on 09-9-8.
//  Copyright 2009 Rumtel Co.,Ltd. All rights reserved.
//

//下载父类，用做继承

#import "RCHttpRequest.h"
#import <UIKit/UIKit.h>

#define CT_UNKNOWN 0
#define TIME_OUT 20
#define CT_XML 1
#define CT_JSON 2

@implementation RCHttpRequest

+ (RCHttpRequest*)sharedInstance
{
    static RCHttpRequest* sharedInstance = nil;
    if(nil == sharedInstance)
    {
        @synchronized([RCHttpRequest class])
        {
            if (nil == sharedInstance)
            {
                sharedInstance = [[RCHttpRequest alloc] init];
            }
        }
    }
    
    return sharedInstance;
}

- (id)init
{
	if(self = [super init])
	{
		_receivedData = [[NSMutableData alloc] init];
		_isConnecting = NO;
		_contentType = CT_UNKNOWN;
		_requestType = 0;
		_expectedContentLength = 0;
		_currentLength = 0;
	}
	
	return self;
}

- (void)dealloc
{
    if (_timeOutTimer) {
        [_timeOutTimer invalidate];
        _timeOutTimer = nil;
    }
    
	self.isConnecting = NO;
    self.receivedData = nil;
    self.requestingURL = nil;
    self.token = nil;
	self.urlConnection = nil;
	
}

- (void)cancel
{
    if (_timeOutTimer) {
        [_timeOutTimer invalidate];
        _timeOutTimer = nil;
    }
    
    if(_urlConnection)
    {
        [_urlConnection cancel];
        [self connection:_urlConnection didFailWithError:nil];
    }
    
    _isConnecting = NO;
    self.receivedData = nil;
	self.urlConnection = nil;
}

- (BOOL)request:(NSString*)urlString delegate:(id)delegate resultSelector:(SEL)resultSelector token:(id)token
{
    if(0 == [urlString length] || _isConnecting)
        return NO;
    
    self.resultSelector = resultSelector;
	self.delegate = delegate;
	self.token = token;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	self.requestingURL = urlString;
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	[request setURL:[NSURL URLWithString: urlString]];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval: TIME_OUT];
	[request setHTTPShouldHandleCookies:FALSE];
	[request setHTTPMethod:@"GET"];
    
    NSLog(@"request:%@",_requestingURL);
	
    BOOL isSuccess = YES;
    
    NSURLConnection * urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
	if (urlConnection)
	{
        self.urlConnection = urlConnection;
        
		_isConnecting = YES;
		[_receivedData setLength: 0];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
        //		if([_delegate respondsToSelector: @selector(willStartHttpRequest:)])
        //			[_delegate willStartHttpRequest:nil];
	}
    else
    {
        isSuccess = NO;
    }
    
    return isSuccess;
}


- (BOOL)post:(NSString*)urlString delegate:(id)delegate resultSelector:(SEL)resultSelector token:(id)token
{
    if(0 == [urlString length] || _isConnecting)
        return NO;
    
    self.resultSelector = resultSelector;
	self.delegate = delegate;
	self.token = token;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	self.requestingURL = urlString;
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	[request setURL:[NSURL URLWithString: urlString]];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval: TIME_OUT];
	[request setHTTPShouldHandleCookies:FALSE];
	[request setHTTPMethod:@"POST"];
    
    NSString* body = (NSString*)_token;
    NSLog(@"%@",body);
    if([body length])
    {
        [request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSLog(@"post:%@",_requestingURL);
	
    BOOL isSuccess = YES;
    
    NSURLConnection * urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
	if (urlConnection)
	{
        self.urlConnection = urlConnection;
        
		_isConnecting = YES;
		[_receivedData setLength: 0];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
        //		if([_delegate respondsToSelector: @selector(willStartHttpRequest:)])
        //			[_delegate willStartHttpRequest:nil];
	}
    else
    {
        isSuccess = NO;
    }
    
    return isSuccess;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.statusCode = [(NSHTTPURLResponse*)response statusCode];
	NSDictionary* header = [(NSHTTPURLResponse*)response allHeaderFields];
	NSString *content_type = [header valueForKey:@"Content-Type"];
	_contentType = CT_UNKNOWN;
	if (content_type)
	{
		if ([content_type rangeOfString:@"xml"].location != NSNotFound)
			_contentType = CT_XML;
		else if ([content_type rangeOfString:@"json"].location != NSNotFound)
			_contentType = CT_JSON;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_receivedData == nil) {
        _receivedData = [[NSMutableData alloc] initWithCapacity:0];
    }
    [_receivedData appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"connectionDidFinishLoading:%d",_statusCode);
    
	if(200 == _statusCode)
	{
        NSString* jsonString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
        
		_isConnecting = NO;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[_receivedData setLength:0];
        
        if(_resultSelector && [_delegate respondsToSelector:_resultSelector])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_delegate performSelector:_resultSelector withObject:jsonString];
#pragma clang diagnostic pop
        }
        
        
	}
	else
	{
		_isConnecting = NO;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[_receivedData setLength:0];
		
        if(_resultSelector && [_delegate respondsToSelector:_resultSelector])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_delegate performSelector:_resultSelector withObject:nil];
#pragma clang diagnostic pop
        }
	}
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError:%d",_statusCode);
    
	_isConnecting = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[_receivedData setLength: 0];
    
    if(_resultSelector && [_delegate respondsToSelector:_resultSelector])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_delegate performSelector:_resultSelector withObject:nil];
#pragma clang diagnostic pop
    }
}


@end
