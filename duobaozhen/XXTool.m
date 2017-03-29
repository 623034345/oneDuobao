//
//  XXTool.m
//  tongtongche
//
//  Created by 肖旋 on 16/4/20.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXTool.h"
#import "SBJSON.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@implementation XXTool

+ (void)getDataWithParameters:(NSDictionary *)parameters url:(NSString *)url blockSuccess:(void(^)(NSURLSessionDataTask * task, id  responseObject))blockSuccess blockFailure:(void(^)(NSURLSessionDataTask * task, NSError * error))blockFailure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:url parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        blockSuccess(task, responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [XXTool displayAlert:@"提示" message:error.localizedDescription];
        blockFailure(task, error);
    }];
}

+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString*)dictionaryToJson:(id)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary*)parseToDictionary:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return nil;
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"    " withString:@""];
//    SBJSON* sbjson = [[SBJSON alloc] init];
    NSError* error = nil;
//    NSDictionary* dict = [sbjson objectWithString:jsonString error:&error];
    NSDictionary *dictt = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    if(error)
        NSLog(@"error:%@",[error description]);
    if(dictt && [dictt isKindOfClass:[NSDictionary class]])
    {
        return dictt;
    }
    
    
    return nil;
}

+ (void)displayAlert:(NSString*)aTitle message:(NSString*)message
{
    if(0 == [aTitle length] || 0 == [message length])
        return;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: aTitle
                                                    message: message
                                                   delegate: self
                                          cancelButtonTitle: @"确定"
                                          otherButtonTitles: nil];
    [alert show];
}

+ (void)setUILabel:(UILabel *)label Data:(NSString *)string SetData:(NSString *)setstring Color:(UIColor *)color Font:(CGFloat)font Underline:(BOOL)isbool{
    
    
    NSRange str = [label.text rangeOfString:setstring];
    if (str.location != NSNotFound) {
        
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:label.text];
        [str1 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(label.text.length - string.length,setstring.length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(label.text.length - string.length,setstring.length)];
        if (isbool) {
            
            [str1 addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(label.text.length - string.length,setstring.length)];
        }
        
        label.attributedText = str1;
        
    }
}

+(void)setFoursides:(UIView *)view Direction:(NSString *)dirction sizeW:(CGFloat)sizew{
    
    if ([dirction  isEqual: @"left"]) {
        
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, sizew)];
        bottomview.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        [view addSubview:bottomview];
        
    }else if([dirction  isEqual: @"right"]){
        
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width - 1, 0, 1, sizew)];
        bottomview.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        [view addSubview:bottomview];
        
    }else if([dirction  isEqual: @"top"]){
        
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizew, 1)];
        bottomview.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        [view addSubview:bottomview];
        
    }else if([dirction  isEqual: @"bottom"]){
        
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, sizew, 1)];
        bottomview.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        [view addSubview:bottomview];
    }
}

+ (void)setNickname:(NSString*)nickname
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:nickname forKey:@"nickname"];
    [temp synchronize];
}

+ (NSString*)getNickname
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    NSString* nickname = [temp objectForKey:@"nickname"];
    if([nickname length])
        return nickname;
    
    return @"兰州";
}

+ (void)setCityID:(NSString*)CityID
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:CityID forKey:@"cityid"];
    [temp synchronize];
}

+ (NSString*)getCityID
{
    NSUserDefaults * temp = [NSUserDefaults standardUserDefaults];
    NSString * cityID = [temp objectForKey:@"cityid"];
    if ([cityID length]) {
        return cityID;
    }
    return @"246";
}

+ (void)setUserName:(NSString*)userName
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:userName forKey:@"userName"];
    [temp synchronize];
}

+ (NSString*)getUserName
{
    NSUserDefaults * temp = [NSUserDefaults standardUserDefaults];
    NSString * userName = [temp objectForKey:@"userName"];
    if ([userName length]) {
        return userName;
    }
    return nil;
}

+ (void)setUserID:(NSString*)userID
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:userID forKey:@"userID"];
    [temp synchronize];
}

+ (NSString*)getUserID
{
    NSUserDefaults * temp = [NSUserDefaults standardUserDefaults];
    NSString * userID = [temp objectForKey:@"userID"];
    if ([userID length]) {
        return userID;
    }
    return @"0";
}

+ (void)setLongitude:(NSString*)longitude
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:longitude forKey:@"longitude"];
    [temp synchronize];
}

+ (NSString*)getLongitude
{
    NSUserDefaults * temp = [NSUserDefaults standardUserDefaults];
    NSString * longitude = [temp objectForKey:@"longitude"];
    if ([longitude length]) {
        return longitude;
    }
    return nil;
}

+ (void)setLatitude:(NSString*)latitude
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:latitude forKey:@"latitude"];
    [temp synchronize];
}

+ (NSString*)getLatitude
{
    NSUserDefaults * temp = [NSUserDefaults standardUserDefaults];
    NSString * latitude = [temp objectForKey:@"latitude"];
    if ([latitude length]) {
        return latitude;
    }
    return nil;
}

+ (void)setTimes:(NSInteger)times
{
    NSUserDefaults * temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:[NSNumber numberWithInteger:times] forKey:@"times"];
    [temp synchronize];
}

+ (NSInteger)getTimes
{
    NSUserDefaults * temp = [NSUserDefaults standardUserDefaults];
    NSInteger times = [[temp objectForKey:@"times"] integerValue];
    return times;
}

@end
