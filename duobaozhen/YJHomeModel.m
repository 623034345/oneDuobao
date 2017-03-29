//
//  YJHomeModel.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/22.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJHomeModel.h"

@implementation YJHomeModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.tId = value;
    }
}
@end
