//
//  HttpCenter.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/22.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "HttpCenter.h"

@implementation HttpCenter

static HttpCenter *instance = nil;

//单例
+ (HttpCenter *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      instance = [[self alloc] init];
                  });
    return instance;
}
//初始化
- (id)init
{
    if (self = [super init])
    {

//        //响应格式
//        [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/javascript", @"text/html", nil];//
        
        manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //超时时间
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        //        manager.requestSerializer.timeoutInterval = 10;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager setAccessibilityLanguage:@"zh-Hans"];
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

//Json get请求
- (void)get:(NSString *)urlStr
 parameters:(NSDictionary *)parDic
    success:(successResult)successBlock
    failure:(failureResult)failureBlock
{
    [manager GET:urlStr parameters:parDic success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(responseObject);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code == -1001 || error.code == -1003 ||error.code == 3840)
        {
            NSLog(@"%ld",(long)error.code);
            
            failureBlock(@"网络连接异常！");
        }
        else
        {
            failureBlock([error localizedDescription]);
        }

    }];
//    [manager GET:urlStr
//      parameters:parDic
//         success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         //        NSDictionary *dicJson=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//         
//         successBlock(responseObject);
//     }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         //        NSLog(@"Error: %@", error);
//         NSLog ( @"operation: %@" , operation. responseString );
//         if (error.code == -1001 || error.code == -1003 ||error.code == 3840)
//         {
//             NSLog(@"%ld",(long)error.code);
//             
//             failureBlock(@"网络连接异常！");
//         }
//         else
//         {
//             failureBlock([error localizedDescription]);
//         }
//     }];
}

//Json post请求
- (void)post:(NSString *)urlStr
  parameters:(id)parDic
     success:(successResult)successBlock
     failure:(failureResult)failureBlock
{
    [manager POST:urlStr parameters:parDic success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(responseObject);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code == -1001 || error.code == -1003 ||error.code == 3840)
        {
            failureBlock(@"网络连接异常！");
        }
        else
        {
            
            failureBlock([error localizedDescription]);
        }
    }];
//    [manager POST:urlStr
//       parameters:parDic
//          success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         //        NSDictionary *dicJson=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//         successBlock(responseObject);
//     }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         if (error.code == -1001 || error.code == -1003 ||error.code == 3840)
//         {
//             failureBlock(@"网络连接异常！");
//         }
//         else
//         {
//             
//             failureBlock([error localizedDescription]);
//         }
//     }];
}
- (BOOL)isNullStr:(NSString *)str
{
    if ([@"" isEqualToString:str] || NULL == str || nil == str || [@"(null)" isEqualToString:str] || [@"<null>" isEqualToString:str] || [[NSNull null] isEqual:str] || [@"NULL" isEqualToString:str] || [@"nil" isEqualToString:str] || [@"null" isEqualToString:str])
    {
        return YES;
    }
    return NO;
}

@end
