//
//  UIViewController+Appeare.h
//  AppearBtn
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 liuwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppearBtn.h"



@interface UIViewController (Appeare) <UIScrollViewDelegate>

-(void)addAppearBtnWithBlock:(AppearBtnDidClick)clickCallback;

@end
