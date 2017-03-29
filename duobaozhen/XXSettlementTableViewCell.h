//
//  XXSettlementTableViewCell.h
//  duobaozhen
//
//  Created by 肖旋 on 16/7/1.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXSettlementTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *countString;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;

- (void)updateView;

@end
