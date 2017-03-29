//
//  RecordTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/12/14.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *themLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qihaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (void)uploadViewWithDic:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;

@property (nonatomic, strong) NSDictionary *dic;
@end
