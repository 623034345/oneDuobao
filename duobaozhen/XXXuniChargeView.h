//
//  XXXuniChargeView.h
//  duobaozhen
//
//  Created by administrator on 17/1/4.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXXuniChargeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
+(instancetype)flagView;
@end
