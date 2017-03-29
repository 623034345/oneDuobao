//
//  RCHttpRequest.h
//  rsscoffee
//
//  Created by xuzepei on 09-9-8.
//  Copyright 2009 Rumtel Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCHttpRequestDelegate <NSObject>
@optional
- (void) willStartHttpRequest: (id)token;
- (void) didFinishHttpRequest: (id)result token: (id)token;
- (void) didFailHttpRequest: (id)token;
- (void) updatePercentage: (float)percentage token: (id)token;
@end


@interface RCHttpRequest : NSObject {

}

@property (nonatomic, strong)NSMutableData* receivedData;
@property (assign)BOOL isConnecting;
@property (nonatomic, weak)id delegate;
@property (assign)int statusCode;
@property (assign)int contentType;
@property (assign)int requestType;
@property (nonatomic, strong)NSString* requestingURL;
@property (nonatomic, strong)id token;
@property (assign)long long expectedContentLength;
@property (assign)long long currentLength;
@property (nonatomic, strong)NSURLConnection* urlConnection;
@property(assign)SEL resultSelector;
@property (nonatomic, strong)NSTimer* timeOutTimer;

+ (RCHttpRequest*)sharedInstance;
- (BOOL)request:(NSString*)urlString
	   delegate:(id)delegate
 resultSelector:(SEL)resultSelector //结果返回方法,仅限一个参数
		  token:(id)token;
- (BOOL)post:(NSString*)urlString delegate:(id)delegate resultSelector:(SEL)resultSelector token:(id)token;
- (void)cancel;


@end
