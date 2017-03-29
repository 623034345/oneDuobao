//
//  CardModel.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/10.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject
@property (nonatomic, copy) NSString *threshold_price;
@property (nonatomic, copy) NSString *ccst;
@property (nonatomic, copy) NSString *ccet;
@property (nonatomic, copy) NSString *ccid;
@property (nonatomic, copy) NSString *reduction_price;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
