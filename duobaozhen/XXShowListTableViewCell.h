//
//  XXShowListTableViewCell.h
//  duobaozhen
//
//  Created by 肖旋 on 16/6/16.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowListObject.h"
@protocol shouqiDelegate <NSObject>

- (void)shouqiClick:(UIButton *)button;

@end

@interface XXShowListTableViewCell : UITableViewCell

@property (nonatomic ,strong)ShowListObject *object;

- (void)uploadViewWithDic:(NSDictionary *)dic;

@property (nonatomic, strong) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;

@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;
@property (nonatomic, strong) IBOutlet UILabel *dateLable;
@property (nonatomic, strong) IBOutlet UILabel *nickLable;
@property (nonatomic, strong) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet UILabel *renshuLabel;

@property (nonatomic, strong) IBOutlet UIButton *likeButton1;
@property (nonatomic, strong) IBOutlet UIButton *likeButton2;
@property (weak, nonatomic) IBOutlet UIButton *shouqiButton;
@property (weak, nonatomic) IBOutlet UILabel *IPLabel;

@property (weak, nonatomic) IBOutlet UILabel *themLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;

@property (weak, nonatomic) IBOutlet UILabel *qihaoLabel;

@property (nonatomic ,assign)id<shouqiDelegate>delegate;

@property (nonatomic ,strong) UIView *imagesView;
@property (nonatomic ,strong) NSMutableArray *imageUrls;
@property (nonatomic ,strong)NSString *userStr;
@end
