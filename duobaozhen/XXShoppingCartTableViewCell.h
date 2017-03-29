//
//  XXShoppingCartTableViewCell.h
//  duobaozhen
//
//  Created by 肖旋 on 16/6/29.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXShoppingCartTableViewCell : UITableViewCell

@property(nonatomic,copy) void(^addBlock)(NSString *);
@property(nonatomic,copy) void(^minusBlock)(NSString *);
@property(nonatomic,copy) void(^allBlock)(NSString *);
@property(nonatomic,copy) void(^allBlock1)(NSString *);
@property(nonatomic,copy) void(^deleteBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *baoweiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shiyuanImage;

@property (weak, nonatomic) IBOutlet UIButton *imgBtn;

@property (nonatomic, weak) IBOutlet UITextField *countField;

@property (nonatomic, weak) IBOutlet UIView *countView;

@property (nonatomic, weak) IBOutlet UIImageView *goodsImageView;

@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UIButton *minusButton;

@property (nonatomic, weak) IBOutlet UIButton *allButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *remainderLabel;
@property (nonatomic, weak) IBOutlet UILabel *qishuLabel;

@property (nonatomic, copy) NSString *countStr;

- (void)uploadViewWithDic:(NSDictionary *)dic;

@end
