//
//  TreasureDetailHeader.h
//  WinTreasure
//
//  Created by Apple on 16/6/8.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreaureHeaderMenu.h"
#import <YYKit/YYKit.h>
#import "WYScrollView.h"


@class TreasureDetailModel;
@class TSProgressView;
@class TSCountLabel;

typedef NS_ENUM(NSUInteger, TreasureDetailHeaderType) {
    TreasureDetailHeaderTypeNotParticipate = 0, //未参加
    TreasureDetailHeaderTypeCountdown, //倒计时
    TreasureDetailHeaderTypeWon, //已获奖
    TreasureDetailHeaderTypeParticipated //参加
};

typedef void(^TreasureDetailHeaderClickImageBlock)(id object);
typedef void(^TreasureDetailHeaderClickMenuButtonBlock)(id object);
typedef void(^TreasureDetailHeaderCountDetailButtonBlock)(void);

typedef void(^TreasureCountDetailButtonBlock)(void);

@interface TreasureProgressView : UIView

@property (nonatomic, assign) NSInteger countTime;

@property (nonatomic, assign) TreasureDetailHeaderType type;
/**期号
 */
@property (nonatomic, strong) YYLabel *periodNumberLabel;

/**倒计时label
 */
@property (nonatomic, strong) YYLabel *countLabel;

/**时间
 */
@property (nonatomic, strong) TSCountLabel *countDownLabel;

/**计算详情
 */
@property (nonatomic, strong) UIButton *countDetailButton;

/**进度
 */
@property (nonatomic, strong)  TSProgressView *progressView;

/**参与人次
 */
@property (nonatomic, strong) YYLabel *totalLabel;

/**剩余
 */
@property (nonatomic, strong) YYLabel *leftLabel;

/**揭晓时间
 */
@property (nonatomic, strong) YYLabel *publishTimeLabel;

/**用户ID
 */
@property (nonatomic, strong) YYLabel *IDLabel;

/**获奖者
 */
@property (nonatomic, strong) YYLabel *winnerLabel;

/** 幸运号码:电话号码处理 */
@property (nonatomic ,strong)NSString *userStr;

/**幸运号码
 */
@property (nonatomic, strong) YYLabel *luckyNumberLabel;


@property (nonatomic, strong) YYLabel *tokenID;

/**获奖者头像
 */
@property (nonatomic, strong) UIImageView *winnerImgView;

/**获奖者标记
 */
@property (nonatomic, strong) UIImageView *winnerImageView;

/**获奖者标志图片
 */
@property (nonatomic, strong) UIImageView *markImgView;

/**背景图片
 */
@property (nonatomic, strong) UIView *backImgView;


// 用于接受数据
@property (nonatomic, strong) NSDictionary *dicts;

@property (nonatomic, strong) TreasureCountDetailButtonBlock block;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime addData:(NSDictionary *)dataDict;
- (void)start;

@end

/**是否已参与
 */
@interface ParticipateView : UIView

@property (nonatomic, strong) YYLabel *participateLabel;

@property (nonatomic, strong) YYLabel *numberLabel;

@property (nonatomic, assign) BOOL isParticipated;

@property (nonatomic, strong) NSDictionary *dict;

- (instancetype)initWithFrame:(CGRect)frame
               isParticipated:(BOOL)isParticipated;

@end

@interface TreasureDetailHeader : UIView

/**是否参与视图
 */
@property (nonatomic, strong) ParticipateView *participateView;

@property (nonatomic, assign) TreasureDetailHeaderType type;

@property (nonatomic, copy) TreasureDetailHeaderClickImageBlock imageBlock;

@property (nonatomic, copy) TreasureDetailHeaderClickMenuButtonBlock clickMenuBlock;

/**计算详情
 */
@property (nonatomic, copy) TreasureDetailHeaderCountDetailButtonBlock countDetailBlock;

@property (nonatomic, strong) TreasureProgressView *treasureProgressView;

@property (nonatomic, strong) TreaureHeaderMenu *headerMenu;

@property (nonatomic, strong) WYScrollView *bannerView;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) NSArray *images;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(TreasureDetailHeaderType)type
                    countTime:(NSInteger)countTime
                      addData:(NSDictionary *)dict addBannerImages:(NSArray *)images;
+ (CGFloat)getHeight;

@end
