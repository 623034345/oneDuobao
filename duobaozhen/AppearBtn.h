//
//  AppearBtn.h
//  AppearBtn
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 liuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AppearBtnDidClick)();

@interface AppearBtn : UIButton
@property (nonatomic , assign)CGPoint originOffset;
@property (nonatomic, copy) AppearBtnDidClick clickCallback;

@end
