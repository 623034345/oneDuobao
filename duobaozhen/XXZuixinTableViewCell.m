//
//  XXZuixinTableViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/1.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXZuixinTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MZTimerLabel.h"

@interface XXZuixinTableViewCell ()<MZTimerLabelDelegate>{
    
      MZTimerLabel *timerExample7;
}
@property (nonatomic ,strong)MZTimerLabel *timerExample8;

@end

@implementation XXZuixinTableViewCell

- (void)setObject:(XXZuixinObject *)object {
     NSString *str  = [object.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    self.titleLabel.text = str;
 
    self.moneyLabel.text = [NSString stringWithFormat:@"价值:￥%@",object.money];
//    self.userLabel.text = [NSString stringWithFormat:@"中奖者:%@",object.q_user];
//    self.renciLabel.text = [NSString stringWithFormat:@"本期夺宝:%@人次",object.gonumber] ;
    [self.jiangpinImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,object.thumb]] placeholderImage:[UIImage imageNamed:@"222.png"]];


  
    if ([object.djs isEqualToString:@"0"]) {
        [self refresh:object];
        
    }else {
        self.jiexiaoLabel.hidden = NO;
        self.userImage.hidden = YES;
        self.renciLabel.hidden = YES;
        self.userLabel.hidden = YES;
        self.timeLabel.hidden = YES;
        self.djsLabel.hidden = NO;
        
       // self.djsLabel.text = object.djs;

 
        NSLog(@"123:%f", [object.djs doubleValue]/1000);
        [timerExample7 reset];
        [timerExample7 setCountDownTime:[object.djs doubleValue]/1000];
            
     
       // timerExample7.resetTimerAfterFinish = NO;
        timerExample7.timeFormat = @"mm:ss:SS";
        

        


        
        if(![timerExample7 counting]){
            [timerExample7 startWithEndingBlock:^(NSTimeInterval countTime) {
                
                [self refresh:object];
            }];
        }
        
    }
    
    
}


- (void)refresh:(XXZuixinObject *)object {
    NSString *str = [NSString stringWithFormat:@"%@",object.q_end_time];
    self.timeLabel.text = [NSString stringWithFormat:@"揭晓时间:%@",[str substringFromIndex:10]];
    if (object.q_user == nil) {
        object.q_user = @"";
    }
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"中奖者: %@",object.q_user]];
    NSRange range1=[[hintString string]rangeOfString:object.q_user];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:150/255.0 blue:255/255.0 alpha:1] range:range1];
    self.userLabel.attributedText = hintString;
    
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"本期夺宝:%@人次",object.gonumber]];
    NSRange range2 = [[hintString1 string]rangeOfString:object.gonumber];
    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    self.renciLabel.attributedText = hintString1;
    
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",object.userphoto]] placeholderImage:[UIImage imageNamed:@"222"]];
    _djsLabel.hidden = YES;
    self.userImage.hidden = NO;
    self.renciLabel.hidden = NO;
    self.userLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    self.jiexiaoLabel.hidden = YES;
    
}

- (void)dealloc {

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
    timerExample7 = [[MZTimerLabel alloc] initWithLabel:_djsLabel andTimerType:MZTimerLabelTypeTimer];
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width /2;
    self.userImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
