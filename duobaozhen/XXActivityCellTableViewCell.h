//
//  XXActivityCellTableViewCell.h
//  duobaozhen
//
//  Created by 肖旋 on 16/6/15.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXActivityCellTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *backView;
@property (nonatomic, strong) IBOutlet UIImageView *backImageView;

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *describeLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;



- (void)uploadViewWithDic:(NSDictionary *)dic;

@property (nonatomic, strong) NSDictionary *dic;

@end
