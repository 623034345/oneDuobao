//
//  PartRecordObject.h
//  duobaozhen
//
//  Created by administrator on 16/9/14.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartRecordObject : NSObject

@property (nonatomic ,strong)NSString *gonumber;
@property (nonatomic ,strong)NSString *uphoto;
@property (nonatomic ,strong)NSString *time;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *mobile;
@property (nonatomic ,strong)NSString *username;
@property (nonatomic ,strong)NSString *zcip;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
