//
//  LuckyRecordTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "LuckyRecordTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation LuckyRecordTableViewCell


-(void)setLuckyObject:(LuckyRecordObject *)luckyObject {
    
    
    NSString *str = [luckyObject.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    self.titleLabel.text = str;
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,luckyObject.thumb]] placeholderImage:[UIImage imageNamed:@"222"]];

    self.timeLabel.text = [NSString stringWithFormat:@"中奖日期:%@",luckyObject.q_end_time];
 
    self.qishuLabel.text = [NSString stringWithFormat:@"期号:%@",luckyObject.qishu];
    
    if ([luckyObject.sdflag isEqualToString:@"1"]) {
        [self.button3 setTitle:@"已晒单" forState:UIControlStateNormal];
        self.button3.enabled = NO;
    }else {
            [self.button3 setTitle:@"晒单" forState:UIControlStateNormal];
           self.button3.enabled = YES;
        
    }
    
    if ([luckyObject.is_over isEqualToString:@"1"]) {
        [self.button2 setTitle:@"已确认收货" forState:UIControlStateNormal];
        self.button2.enabled = NO;
        
    }else {
        [self.button2 setTitle:@"确认收货" forState:UIControlStateNormal];
             self.button2.enabled = YES;
    }
    
    

    if ([luckyObject.orderstatus isEqualToString:@"1"] || [luckyObject.orderstatus isEqualToString:@"2"]) {
    
        self.rewardBtn.backgroundColor = [UIColor lightGrayColor];
        self.rewardBtn.enabled = NO;
        
//        if ([luckyObject.status integerValue] == 1) {
//            
//            
//            [self.btn3 setImage:[UIImage imageNamed:@"iconfont-zhengque"] forState:UIControlStateNormal];
//            self.addressBtn.enabled = NO;
//            [self.addressBtn setTitle:@"发货完成" forState:UIControlStateNormal];
//        }
        NSString *str1 = @"话";
        NSString *str = @"费";
        //在str1这个字符串中搜索\n，判断有没有
        if ([luckyObject.title rangeOfString:str].location != NSNotFound && [luckyObject.title rangeOfString:str1].location != NSNotFound) {
            NSLog(@"这个字符串中有a");
            self.button1.hidden = YES;
            self.button2.hidden = YES;
        }
        else
        {
            self.button1.hidden = NO;
            self.button2.hidden = NO;
        }
        
        self.button3.hidden = NO;
        self.cellHeight = 150;

//        if ([luckyObject.cateid isEqualToString:@"17"])
//        {
//            [self.button1 setTitle:@"查看卡密" forState:UIControlStateNormal];
//            self.button2.hidden = YES;
//            self.button3.hidden = YES;
//            
//        }
        
    }else {
        self.rewardBtn.backgroundColor = BASE_COLOR;
        self.rewardBtn.enabled = YES;
        self.cellHeight = 102;
        self.button1.hidden = YES;
        self.button2.hidden = YES;
        self.button3.hidden = YES;
        
    
//        [self.btn1 setImage:[UIImage imageNamed:@"iconfont-zhengque"] forState:UIControlStateNormal];
//        [self.btn2 setImage:[UIImage imageNamed:@"huiquan1"] forState:UIControlStateNormal];
//        [self.btn3 setImage:[UIImage imageNamed:@"huiquan1"] forState:UIControlStateNormal];
//        
//        [self.addressBtn setTitle:@"确认地址" forState:UIControlStateNormal];
//        self.addressBtn.enabled = YES;
     
    }
    
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.rewardBtn.layer.cornerRadius = 4;
    
    self.button1.layer.cornerRadius = 5;
    self.button1.layer.borderWidth = 1;
    self.button1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.button2.layer.borderWidth = 1;
    self.button2.layer.cornerRadius = 5;
    self.button2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.button3.layer.borderWidth = 1;
    self.button3.layer.cornerRadius = 5;
    self.button3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
