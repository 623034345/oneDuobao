//
//  MustPay.h
//  MustPay
//
//  Created by 改革开放好 on 2016/11/8.
//  Copyright © 2016年 MustPay. All rights reserved.
//
typedef enum  {
    MustPayAlipay,//支付宝
    MustPayWeiXin,//微信支付
    MustPayYinLian,//银联
    MustPayBaiDu,//百度钱包
} MustPayType;
@protocol MustPayResultDelegate <NSObject>

-(void)mustPayResult:(NSString*)code;

@end

#import <Foundation/Foundation.h>
#import "MustPayHeader.h"
@interface MustPaySDK : NSObject<WXApiDelegate>
@property (nonatomic,assign)id<MustPayResultDelegate> delegate;
@property (nonatomic,retain)NSDictionary *dic;
@property (nonatomic,copy) NSString *appid;
@property (nonatomic,copy) NSString  *prepayid;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,copy) NSString *goodsPrice;
@property (nonatomic,copy) NSString *scheme;
@property (nonatomic,assign) BOOL clickType;//用于判断是否点击了MustPay里面的支付
+(instancetype)sharedSingleton;

/*验证订单状态*/
- (void)erifyOrderStatus;

/**
 @param appid       app在mustPay注册的appid 可以有服务端人员写个接口返回
 @param prepayid    订单的prepayid 用于验证订单
 @param goodsName   商品名字
 @param goodsPrice  商品价格
 @param scheme     支付宝 银联 要用到 银联支付宝要设置一样 可查看本应用info.plist URL Types里面的设置
 */
- (void)mustPayInitViewAppid:(NSString*)appid prepayid:(NSString*)prepayid goodsName:(NSString*)goodsName goodsPrice:(NSString*)goodsPrice scheme:(NSString*)scheme;

/**
 @param appid       app在mustPay注册的appid 可以有服务端人员写个接口返回
 @param prepayid    订单的prepayid 用于验证订单
 @param payType     支付方式
 @param schemes     支付宝用到 用于支付宝返回本应用
 */
-(void)mustPayAppid:(NSString*)appid prepayid:(NSString*)prepayid payType:(MustPayType)payType scheme:(NSString*)schemes;


/**
 @param appid       app在mustPay注册的appid 可以有服务端人员写个接口返回
 @param prepayid    订单的prepayid 用于验证订单
 */
- (void)inspectOrder:(NSString*)appid prepayId:(NSString*)prepayid;


/**
 *  回调结果接口(支付宝/微信/测试模式)
 *
 *  @param url              结果url
 *  @param completion  支付结果回调 Block，保证跳转支付过程中，当 app 被 kill 掉时，能通过这个接口得到支付结果
 *
 *  @return                 当无法处理 URL 或者 URL 格式不正确时，会返回 NO。
 */
- (BOOL)handleOpenURL:(NSURL *)url withCompletion:(NSString*)completion;

@end
