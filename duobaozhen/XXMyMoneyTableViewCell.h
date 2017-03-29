//
//  XXMyMoneyTableViewCell.h
//  duobaozhen
//
//  Created by 肖旋 on 16/7/8.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXMyMoneyTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *monetyLabel;

- (void)uploadViewWithDic:(NSDictionary *)dic;

@end
