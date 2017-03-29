//
//  PYPhotosView.h
//  新浪微博
//
//  Created by 谢培艺 on 15/12/16.
//  Copyright © 2015年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYConst.h"
@class PYPhotoView,PYPhotosView;

typedef NS_ENUM(NSInteger, PYPhotosViewLayoutType) { // 布局类型
    PYPhotosViewLayoutTypeFlow = 0, // 流水布局
    PYPhotosViewLayoutTypeLine = 1  // 线性布局
};

typedef NS_ENUM(NSInteger, PYPhotosViewState) { // 图片状态
    PYPhotosViewStateWillCompose = 0,   // 未发布
    PYPhotosViewStateDidCompose = 1     // 已发布
};

@interface PYPhotosView : UIScrollView

/** 网络图片相册 */
@property (nonatomic, strong) NSArray *photos;
/** 本地相册图片数组 */
@property (nonatomic, strong) NSMutableArray *images;
/** 所有图片的状态（默认为已发布状态） */
@property (nonatomic, assign) PYPhotosViewState photosState;
/** 图片布局（默认为流水布局） */
@property (nonatomic, assign) PYPhotosViewLayoutType layoutType;

/** 图片间距（默认为5） */
@property (nonatomic, assign) CGFloat photoMargin;
/** 图片的宽 (默认为70) */
@property (nonatomic, assign) CGFloat photoWidth;
/** 图片的高 (默认为70) */
@property (nonatomic, assign) CGFloat photoHeight;

/** 每行最多个数（默认为3）, 当图片布局为流水布局时，此设置失效 */
@property (nonatomic, assign) NSInteger photosMaxCol;

/** 快速创建photosView对象 */
+ (instancetype)photosView;
/** photos: 保存图片链接的数组 */
+ (instancetype)photosView:(NSArray *)photos;
/**
 * photos: 保存图片链接的数组
 * type : 布局类型（默认为流水布局）
 */
+ (instancetype)photosView:(NSArray *)photos layoutType:(PYPhotosViewLayoutType)type;

/** 
 * photos: 保存图片链接的数组
 * maxCol : 每行最多显示图片的个数
 */
+ (instancetype)photosView:(NSArray *)photos photosMaxCol:(NSInteger)maxCol;

/**  */

/** 根据图片个数和图片状态自动计算出PYPhontosView的size */
- (CGSize)sizeWithPhotoCount:(NSInteger)count photosState:(NSInteger)state;

@end
