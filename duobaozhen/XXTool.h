//
//  XXTool.h
//  tongtongche
//
//  Created by 肖旋 on 16/4/20.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XXTool : NSObject

+ (void)getDataWithParameters:(NSDictionary *)parameters url:(NSString *)url blockSuccess:(void(^)(NSURLSessionDataTask * task, id  responseObject))blockSuccess blockFailure:(void(^)(NSURLSessionDataTask * task, NSError * error))blockFailure;

+(NSString *) md5: (NSString *) inPutText;

+ (void)setUILabel:(UILabel *)label Data:(NSString *)string SetData:(NSString *)setstring Color:(UIColor *)color Font:(CGFloat)font Underline:(BOOL)isbool;

+(void)setFoursides:(UIView *)view Direction:(NSString *)dirction sizeW:(CGFloat)sizew;

+ (NSString*)dictionaryToJson:(id)dic;
+ (NSDictionary*)parseToDictionary:(NSString*)jsonString;

+ (void)displayAlert:(NSString*)aTitle message:(NSString*)message;

+ (void)setNickname:(NSString*)nickname;
+ (NSString*)getNickname;

+ (void)setCityID:(NSString*)CityID;
+ (NSString*)getCityID;

+ (void)setUserName:(NSString*)userName;
+ (NSString*)getUserName;

+ (void)setUserID:(NSString*)userID;
+ (NSString*)getUserID;

+ (void)setLongitude:(NSString*)longitude;
+ (NSString*)getLongitude;

+ (void)setLatitude:(NSString*)latitude;
+ (NSString*)getLatitude;

+ (void)setTimes:(NSInteger)times;
+ (NSInteger)getTimes;
@end
