//
//  LuckyRecordTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuckyRecordObject.h"

@interface LuckyRecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qishuLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic ,strong)LuckyRecordObject *luckyObject;

@property (nonatomic ,assign)CGFloat cellHeight;
@end
