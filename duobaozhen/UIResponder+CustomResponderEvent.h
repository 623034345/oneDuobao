//
//  UIResponder+CustomResponderEvent.h
//  HandBuyCar
//
//  Created by  on 16/4/23.
//  Copyright (c) 2016年  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (CustomResponderEvent)


- (void)routerEventWithName:(NSString *)eventName dataInfo:(NSDictionary *)dataInfo;

+(id) currentFirstResponder;

-(void) findFirstResponder:(id) sender;

@end
