//
//  UIResponder+CustomResponderEvent.m
//  HandBuyCar
//
//  Created by 张建 on 15/4/23.
//  Copyright (c) 2015年 张建. All rights reserved.
//

#import "UIResponder+CustomResponderEvent.h"

static __weak id currentFirstResponder;

@implementation UIResponder (CustomResponderEvent)

-(void) routerEventWithName:(NSString *)eventName dataInfo:(NSDictionary *)dataInfo{
    [[self nextResponder] routerEventWithName:eventName dataInfo:dataInfo];
}

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}
@end
