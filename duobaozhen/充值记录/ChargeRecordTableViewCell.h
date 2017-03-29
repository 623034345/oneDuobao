//
//  ChargeRecordTableViewCell.h
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeRecordObject.h"
@interface ChargeRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weakLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic ,strong)ChargeRecordObject *chargeObject;

@end
