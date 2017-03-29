//
//  TitleLebal.m
//  TopSliderBar
//
//  Created by Xiaoyue on 16/3/1.
//  Copyright © 2016年 李运洋. All rights reserved.
//

#import "TitleLebal.h"

@implementation TitleLebal


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        
    }
    
    return self;
}



-(void)setScale:(CGFloat)scale
{
    self.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1];
    
    CGFloat transformScale = 1+scale*0.2;
    
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
