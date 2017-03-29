//
//  HttpCenter.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/22.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"

typedef void (^successResult)(id successObj);
typedef void (^failureResult)(NSString *failureStr);

@interface HttpCenter : NSObject<NSURLSessionDataDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    AFHTTPSessionManager *manager;

}
@property (nonatomic, retain) NSOperationQueue *queue; // 队列
@property (nonatomic, retain) NSMutableDictionary *imageDicWithDownload; // 保存上传成功后返回的的图片路径 key(图片名) ->
@property (strong, nonatomic)NSURLSession * session;
@property (strong, nonatomic)NSURLSessionUploadTask *dataTask;
+ (HttpCenter *)sharedInstance;
- (void)get:(NSString *)urlStr
 parameters:(NSDictionary *)parDic
    success:(successResult)successBlock
    failure:(failureResult)failureBlock;
- (void)post:(NSString *)urlStr
  parameters:(id)parDic
     success:(successResult)successBlock
     failure:(failureResult)failureBlock;
- (BOOL)isNullStr:(NSString *)str;
@end
