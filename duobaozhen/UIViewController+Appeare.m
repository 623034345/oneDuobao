//
//  UIViewController+Appeare.m
//  AppearBtn
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 liuwen. All rights reserved.
//

#import "UIViewController+Appeare.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property(nonatomic , strong)AppearBtn *appearBtn;

@end


@implementation UIViewController (Appeare)

static char apButton;

-(void)setAppearBtn:(UIButton *)appearBtn {
    objc_setAssociatedObject(self, &apButton, appearBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)appearBtn {
  return objc_getAssociatedObject(self, &apButton);
}

-(void)addAppearBtnWithBlock:(AppearBtnDidClick)clickCallback{
    if (!self.appearBtn) {
        // 添加浮按钮
        AppearBtn *btn = [[AppearBtn alloc] initWithFrame:CGRectMake(WIDTH - 100, HEIGHT - 100, 50, 50)];
        [btn setTitle:@"顶部" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor grayColor]];
        btn.hidden = YES;
        btn.clickCallback = clickCallback;
        [btn addTarget:self action:@selector(appearBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        [self.view bringSubviewToFront:btn];
        self.appearBtn = btn;
    }
}

- (void)appearBtnDidClick:(AppearBtn *)btn {
    btn.clickCallback();
}

#pragma mark - scrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.appearBtn.originOffset = scrollView.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    self.appearBtn.hidden = self.appearBtn.originOffset.y < offset.y;
    
    self.appearBtn.originOffset = offset;
}

@end
