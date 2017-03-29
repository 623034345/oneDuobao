//
//  UIViewController+Base.h
//  ForNowIosSupper
//
//  Created by fornowIOS on 15/8/6.
//  Copyright (c) 2015年 fornowIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGProgressHUD.h"
@interface UIViewController (Base) <UIGestureRecognizerDelegate>

- (void)hideNavigationBarLine;
- (void)adjustsScrollViewInsets;
- (void)addBackBtnWithImageNormal:(NSString *)normalStr
                          fuction:(SEL)function;
- (void)addNextBtnWithImageNormal:(NSString *)normalStr
                          fuction:(SEL)function;
- (void)addNextBtnWithTitle:(NSString *)titleStr
                    fuction:(SEL)function;
- (void)addTapRecognizer:(SEL)fuction;
- (void)showHudView;
- (void)dismissHudView;
- (void)showIndicatorView;
- (void)showIndicatorViewWithViewHeight:(CGFloat )hight;
- (void)dismissIndicatorView;
- (void)showAlertWithPoint:(int)flag
                      text:(NSString *)textStr
                     color:(UIColor *)color;
- (void)dismissView;
- (void)addWifiBtnWithfuction:(SEL)function;
- (void)removeWifiBtn;
- (BOOL)isReachable;
- (void)addObserver:(id)obj
           function:(SEL)fuction;
- (void)removeObserver:(id)obj;
-(void)alertControllerQue:(UIAlertAction *)seleced prompt:(NSString *)prompt msg:(NSString *)msgStr;
- (NSString *)dayHourMinuteWith:(NSString *)gmtTime;
- (int)minuteWith:(NSString *)gmtTime;
- (UIImage *)QRcodeWithText:(NSString *)textStr size:(NSInteger )size;
-(void)touchTable:(UITableView *)table
commentTableViewTouchInSide:(SEL)commentTableViewTouchInSide;
-(void)sharedWithcontArr:(NSArray *)contArr;
-(void)ShowJGHUD;
-(void)ShowJGHUDError;
@end
