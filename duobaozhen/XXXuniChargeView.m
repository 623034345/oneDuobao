//
//  XXXuniChargeView.m
//  duobaozhen
//
//  Created by administrator on 17/1/4.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "XXXuniChargeView.h"

@implementation XXXuniChargeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)flagView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"XXXuniChargeView"
                                          owner:nil options:nil]lastObject];
}

@end
