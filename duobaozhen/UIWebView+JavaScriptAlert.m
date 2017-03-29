//
//  UIWebView+JavaScriptAlert.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/24.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"

@implementation UIWebView (JavaScriptAlert)

static BOOL status = NO;
static BOOL isEnd = NO;

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    
    [customAlert show];
    
}

- (NSString *) webView:(UIWebView *)view runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)text initiatedByFrame:(id)frame {
    return @"";
}

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
    
    [confirmDiag show];
    
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.) {
        while (isEnd == NO) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
            
        }
    }else
    {
        while (isEnd == NO && confirmDiag.superview != nil) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
        }
    }
    isEnd = NO;
    return status;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    status = buttonIndex;
    isEnd = YES;
}

@end
