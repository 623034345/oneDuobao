//
//  CustomTextField.m
//  duobaozhen
//
//  Created by administrator on 16/7/23.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
//    CGRect inset = CGRectMake(bounds.origin.x + 200, bounds.origin.y, bounds.size.width -10, bounds.size.height);
//    return inset;
    return CGRectInset(bounds, 40, 0);}

@end
