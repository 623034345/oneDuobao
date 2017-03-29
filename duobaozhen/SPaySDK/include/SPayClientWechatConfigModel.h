//
//  SPayClientWechatConfigModel.h
//  SPaySDK
//
//  Created by wongfish on 15/8/3.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPayClientWechatConfigModel : NSObject



/**
 *  app Scheme(微信支付SDK中配置的对应app Scheme)
 */
@property (nonatomic,copy) NSString *appScheme;

/**
 *  微信 Appid
 */
@property (nonatomic,copy) NSString *wechatAppid;

@end
