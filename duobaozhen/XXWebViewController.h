//
//  XXWebViewController.h
//  tongtongche
//
//  Created by 肖旋 on 16/4/19.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXWebViewController : UIViewController

typedef NS_ENUM(NSInteger, XXWebViewType) {
    XXWebViewTypeDefault = 0,
    XXWebViewTypeShoppingCart,
    XXWebViewTypeAllGoods,
};

typedef NS_ENUM(NSInteger, XXWeViewTitleType) {
    XXWebViewTitleTypeWeb = 0,
    XXWebViewTitleTypeNative,
};

@property (nonatomic, strong) NSString *url;

@property (nonatomic) NSInteger homeNum;

@property (nonatomic) NSInteger type;

@property (nonatomic, assign) XXWebViewType webViewType;
@property (nonatomic, assign) XXWeViewTitleType webViewTitleType;

@property (nonatomic) NSInteger tongtongType;

@property (nonatomic, copy) NSString *title1;

- (id)initForWishList;

@end
