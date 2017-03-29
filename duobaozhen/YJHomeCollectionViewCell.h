//
//  YJHomeCollectionViewCell.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/2/22.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJHomeModel.h"
@interface YJHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) void(^buttonIdex)(NSInteger index);
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *tenImage;

@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIProgressView *pro;

@property (nonatomic, strong) UILabel *proLabel;
@property (nonatomic, strong) UIButton *bt;
@property (nonatomic, strong) YJHomeModel *mod;

-(void)setAdic:(NSDictionary *)aDic;

@end
