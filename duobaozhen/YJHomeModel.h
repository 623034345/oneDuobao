//
//  YJHomeModel.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/22.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJHomeModel : NSObject
@property (nonatomic ,strong)NSString *shenyurenshu;
@property (nonatomic ,strong)NSString *yunjiage;
@property (nonatomic ,strong)NSString *tId;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSString *zongrenshu;
@property (nonatomic ,strong)NSString *thumb;
@property (nonatomic ,strong)NSString *sid;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
