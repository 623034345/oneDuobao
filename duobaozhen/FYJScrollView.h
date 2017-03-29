//
//  FYJScrollView.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/17.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+CustomResponderEvent.h"

@interface FYJScrollView : UIScrollView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
@end
