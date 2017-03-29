//
//  ChargeRecordTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ChargeRecordTableViewCell.h"

@implementation ChargeRecordTableViewCell

-(void)setChargeObject:(ChargeRecordObject *)chargeObject {
    
    
    self.weakLabel.text = chargeObject.week;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"+￥%@.00",chargeObject.money];
    
    self.timeLabel.text = chargeObject.time;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
