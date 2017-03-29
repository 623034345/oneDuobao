//
//  FYJScrollView.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/17.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "FYJScrollView.h"

@implementation FYJScrollView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //    [[self nextResponder] touchesBegan:touches withEvent:event];
    const char * name = class_getName(self.class);
    NSString *className = [NSString stringWithUTF8String:name];//[self.class isSubclassOfClass:[UITableView class]]
    if ([className isEqualToString:@"UITableView"])
    {
        //        NSLog(@"点击的啥%@",className);
    }
    else
    {
        [self routerEventWithName:className dataInfo:nil];
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
