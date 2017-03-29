//
//  UIViewController+Base.m
//  ForNowIosSupper
//
//  Created by fornowIOS on 15/8/6.
//  Copyright (c) 2015年 fornowIOS. All rights reserved.
//

#import "UIViewController+Base.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HUDKEY = &HUDKEY;
static const void *INDICATORKEY = &INDICATORKEY;
static const void *ALERTKEY = &ALERTKEY;
static const void *BGVIEWKEY = &BGVIEWKEY;
static const void *WIFIVIEW = &WIFIVIEW;

@implementation UIViewController (Base)

//圆形菊花
- (MBProgressHUD *)hud
{
    return objc_getAssociatedObject(self, HUDKEY);
}

- (void)setHud:(MBProgressHUD *)hud
{
    objc_setAssociatedObject(self, HUDKEY, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}







//遮罩层
- (UIView *)bgView
{
    return objc_getAssociatedObject(self, BGVIEWKEY);
}

- (void)setBgView:(UIView *)bgView
{
    objc_setAssociatedObject(self, BGVIEWKEY, bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//无网络
- (UIView *)wifiView
{
    return objc_getAssociatedObject(self, WIFIVIEW);
}

-(void)setbtn:(UIView *)view
{
    objc_setAssociatedObject(self, WIFIVIEW, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//去除NaviagtionBar下的黑线
- (void)hideNavigationBarLine
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setTitleTextAttributes:
         
         
         @{NSFontAttributeName:[UIFont systemFontOfSize:19],
           
           
           NSForegroundColorAttributeName:UIWHITE}];
        [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
            {
                UIView *view = (UIView *)obj;
                view.backgroundColor = UICOLOR_HEX(0xda202e);//0xa71520
;
                view.hidden = YES;
            }
            if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")])
            {
                UIView *view = (UIView *)obj;
                view.hidden = YES;
                view.backgroundColor = UICLEAR;
            }
            if ([obj isKindOfClass:NSClassFromString(@"UIImageView")])
            {
                [[(UIImageView *)obj subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                {
                    if ([obj isKindOfClass:[UIImageView class]])
                    {
                        UIImageView *imageView = (UIImageView *)obj;
                        imageView.hidden = YES;
                    }
                    if ([obj isKindOfClass:NSClassFromString(@"_UIBackdropView")])
                    {
                        UIView *view = (UIView *)obj;
                        view.hidden = YES;
                    }
                }];
            }
        }];
    }
  
}

//调整ScrollView位置
- (void)adjustsScrollViewInsets
{
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

//带图片的返回按钮
- (void)addBackBtnWithImageNormal:(NSString *)normalStr
                          fuction:(SEL)function;
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 25, 25);
    [backBtn setImage:[UIImage imageNamed:normalStr]
                       forState:UIControlStateNormal];

    [backBtn addTarget:self
                action:function
      forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}

//带图片的下一步按钮
- (void)addNextBtnWithImageNormal:(NSString *)normalStr
                          fuction:(SEL)function
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.bounds = CGRectMake(0, 0, 20, 20);
    [saveBtn setBackgroundImage:[UIImage imageNamed:normalStr]
                       forState:UIControlStateNormal];
    [saveBtn addTarget:self
                action:function
      forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBtnItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveBtnItem;
}

//带文字的下一步按钮
- (void)addNextBtnWithTitle:(NSString *)titleStr
                    fuction:(SEL)function
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.backgroundColor = UICLEAR;
    saveBtn.bounds = CGRectMake(0, 0, 49, 44);
    [saveBtn.titleLabel setFont:UIFONT(16)];
    [saveBtn setTitle:titleStr
             forState:UIControlStateNormal];
    [saveBtn setTitle:titleStr
             forState:UIControlStateHighlighted];
    [saveBtn setTitleColor:UIWHITE
                  forState:UIControlStateNormal];
    [saveBtn setTitleColor:UIColorWithRGB(239, 239, 239)
                  forState:UIControlStateHighlighted];
    [saveBtn addTarget:self
                action:function
      forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBtnItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveBtnItem;
}

//添加轻按手势
- (void)addTapRecognizer:(SEL)fuction
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:fuction];
    [self.view addGestureRecognizer:tap];
}







//表格中使用
- (void)showIndicatorViewWithViewHeight:(CGFloat)height
{

}


//显示带提示弹窗的对话框
- (void)showAlertWithPoint:(int)flag
                      text:(NSString *)textStr
                     color:(UIColor *)color
{
    
//    if (![[self alert] window])
//    {
//        InfoAlert *infoAlert = [[InfoAlert alloc] initInfoAlertWithPoint:flag
//                                                                    text:textStr
//                                                                   color:color];
//        [KEYWINDOW_VIEW addSubview:infoAlert];
//        [self setAlert:infoAlert];
//        [infoAlert showView];
//    }
    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = textStr;
    
    if (flag == 1)
    {
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    }
    if (flag == 0)
    {
        HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    }
    
    [HUD showInView:self.view];
    [HUD dismissAfterDelay:1.0];
    
    
}












#pragma mark - 时间处理
//时间间隔
- (NSString *)dayHourMinuteWith:(NSString *)gmtTime
{
    if (gmtTime.length > 10) {
        gmtTime = [gmtTime substringToIndex:10];
    }
    NSDate *appointmentTime = [NSDate dateWithTimeIntervalSince1970:[gmtTime intValue]];
    NSTimeInterval date = [appointmentTime timeIntervalSince1970]*1;
    NSDate *nowDate = [NSDate date];
    NSTimeInterval now = [nowDate timeIntervalSince1970]*1;
    NSTimeInterval cha = date - now;//时间差，秒数
    int days = (int)cha/(3600*24);
    int hours = (int)cha%(3600*24)/3600;
    int minute = (int)cha%3600/60;
    int second = (int)cha%60;
    NSString *dateContent;
    if (days <= 0 && hours <= 0 && minute <= 0 && second <= 0)
    {
        dateContent = @"000";
    }
    else
    {
        dateContent = [[NSString alloc] initWithFormat:@"%i 天 %i小时 %i分钟", days, hours, minute + 1];
    }
    return dateContent;
}

//距离预约时间分钟
- (int)minuteWith:(NSString *)gmtTime
{
    if (gmtTime.length > 10)
    {
        gmtTime = [gmtTime substringToIndex:10];
    }
    NSDate *appointmentTime = [NSDate dateWithTimeIntervalSince1970:[gmtTime intValue]];
    NSTimeInterval date = [appointmentTime timeIntervalSince1970]*1;
    NSDate *nowDate = [NSDate date];
    NSTimeInterval now = [nowDate timeIntervalSince1970]*1;
    NSTimeInterval cha = date - now;//时间差，秒数
    int minute = (int)cha/60;
    return minute;
}
//带提示框的弹窗
-(void)alertControllerQue:(UIAlertAction*)seleced prompt:(NSString *)prompt msg:(NSString *)msgStr
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:msgStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action)
    {
        
    }];
    
//    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
////        [alert addTapRecognizer:seleced];
//        [alert addAction:seleced];
//
//        
//    }];
    [alert addAction:cancle];
    [alert addAction:seleced];
    [self presentViewController:alert animated:YES completion:nil];
}


//触摸表
-(void)touchTable:(UITableView *)table
commentTableViewTouchInSide:(SEL)commentTableViewTouchInSide
{
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:commentTableViewTouchInSide];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [table addGestureRecognizer:tableViewGesture];
}
-(void)sharedWithcontArr:(NSArray *)contArr
{
   

}
-(void)ShowJGHUD
{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Loading";
    [HUD showInView:self.view];
    [HUD dismissAfterDelay:3.0];
}
-(void)ShowJGHUDError
{
   
}
@end
