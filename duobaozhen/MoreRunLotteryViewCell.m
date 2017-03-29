//
//  MoreRunLotteryViewCell.m
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "MoreRunLotteryViewCell.h"
#import "MZTimerLabel.h"
#import "UIImageView+WebCache.h"
#import "TTCounterLabel.h"
@interface MoreRunLotteryViewCell()<TTCounterLabelDelegate>

@property (nonatomic ,strong)MZTimerLabel *timerLabel;

@property (weak, nonatomic) IBOutlet TTCounterLabel *counterLabel;
@property (nonatomic ,strong)NSString *userStr;
@property (nonatomic ,strong)NSString *gonumberStr;
@end

@implementation MoreRunLotteryViewCell

- (void)setObject:(MoreRunLotteryObject *)object {
    
    
  
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,object.thumb]] placeholderImage:[UIImage imageNamed:@"222.png"]];
    NSString *str  = [object.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    self.titleLabel.text = str;
    
    [self.timerLabel setCountDownTime:[object.djs integerValue]/1000];

    
       self.moneyLabel.text = [NSString stringWithFormat:@"期号:%@",object.qishu];
        self.userLabel.text = [NSString stringWithFormat:@"中奖者:%@",object.q_user];
        self.renciLabel.text = [NSString stringWithFormat:@"本期夺宝:%@人次",object.gonumber] ;
    
    self.luckyNumLabel.text = [NSString stringWithFormat:@"幸运号码:%@",object.q_user_code];
    
    if ([object.djs isEqualToString:@"0"]) {
        [self.counterLabel setHidden:YES];

        [self refresh:object];
        NSLog(@"---------------------%@----------------------------",object.djs);

        
    }else {
        NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^%@^^^^^^^^^^^^^^^^^^^^^^^^^",object.djs);

//        if (_counterLabel.isRunning == YES)
//        {
//            return;
//        }
        [self.counterLabel setHidden:NO];
        self.moneyLabel.hidden = NO;
        self.titleLabel.hidden = NO;
      //  self.jiexiaoLabel.hidden = NO;
//        self.userImage.hidden = YES;
        self.renciLabel.hidden = YES;
        self.userLabel.hidden = YES;
        self.timeLabel.hidden = YES;
        self.djsLabel.hidden = YES;
        self.luckyNumLabel.hidden = YES;
        //self.djsLabel.text = object.djs;
        // self.djsLabel.text = object.djs;
        
        
        NSLog(@"123:%f", [object.djs doubleValue]/1000);
        // NSDate *date = [NSDate date];
        // [timerExample7 pause];
        [self.timerLabel reset];
        
        //      [timerExample7 start];
        [self.timerLabel setCountDownTime:[object.djs doubleValue]/1000];
        
        
        //timerExample7.resetTimerAfterFinish = NO;
        self.timerLabel.timeFormat = @"mm:ss:SS";
        
        

        
//         The font property of the label is used as the font for H,M,S and MS
        [self.timerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        
        
        
        if(![self.timerLabel counting]){
            [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
                
                [self refresh:object];
            }];
        }
        
        //_counterLabel.backgroundColor = [UIColor colorWithRed:215/255.0 green:21/255.0 blue:66/255.0 alpha:1.0];
//        _counterLabel.countDirection = kCountDirectionDown;
//        
//        [_counterLabel setStartValue:[object.djs intValue]];
////        if ([object.djs doubleValue] == 0) {
////            _counterLabel.alpha = 0.0;
////            _counterLabel.hidden = YES;
////        }
//        _counterLabel.countdownDelegate = self;
//     //   _counterLabel.textColor = [UIColor whiteColor];
//        
//        [_counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
//        [_counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
//        
//        // The font property of the label is used as the font for H,M,S and MS
//        [_counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
//        
////        [_counterLabel updateApperance];
//        [_counterLabel start];
//        
//        _moreRun = object;
        
    }
    
}
- (void)countdownDidEndForSource:(TTCounterLabel *)source {
    source.alpha = 0.0;
    //self.lb.alpha = 1.0;
    [_counterLabel stop];
    NSLog(@"结束了  结束了%@结束了  结束了 结束了",_moreRun.djs);

    [self refresh:_moreRun];

    
//    _endTime();
}

- (void)refresh:(MoreRunLotteryObject *)object {
    
//    if (object.q_end_time.length > 5) {
//        NSString *str = [NSString stringWithFormat:@"%@",object.q_end_time];
//        NSString *time = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        self.timeLabel.text = [NSString stringWithFormat:@"揭晓时间:%@",[time substringWithRange:NSMakeRange(5,str.length - 5)]];
//    }
//    else
//    {
//    }
    self.timeLabel.text = [NSString stringWithFormat:@"揭晓时间:%@",object.q_end_time];

  
    if (object.q_user == nil) {
        object.q_user = @"";
    }
    if (![self isPureInt:object.q_user]||![self isPureFloat:object.q_user] || [object.q_user length] != 11) {
        self.userStr = object.q_user ;
//        if (self.userStr.length >4) {
//            self.userStr = [NSString stringWithFormat:@"%@...",[object.q_user substringToIndex:4]] ;
//        }
        
        
    }else {
        self.userStr = [object.q_user stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"中奖者: %@",self.userStr]];
    NSRange range1=[[hintString string]rangeOfString:self.userStr];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:150/255.0 blue:255/255.0 alpha:1] range:range1];
    self.userLabel.attributedText = hintString;
    
    if (object.gonumber  == nil) {
        self.renciLabel.text = @"本期夺宝:人次";
    }else {
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"本期夺宝:%@人次", object.gonumber]];
        NSRange range2 = [[hintString1 string]rangeOfString:object.gonumber];
        [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        self.renciLabel.attributedText = hintString1;
    }
    

    
    //    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",object.userphoto]] placeholderImage:[UIImage imageNamed:@"222"]];
    _counterLabel.hidden = YES;
    //self.userImage.hidden = NO;
    self.renciLabel.hidden = NO;
    self.userLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    self.luckyNumLabel.hidden = NO;
    //self.jiexiaoLabel.hidden = YES;
    
    
 
    
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.counterLabel setHidden:YES];
    self.counterLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.counterLabel.layer.borderWidth = 1;
    self.counterLabel.layer.cornerRadius = 5;
    
    [_counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
    [_counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
    [_counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
    
    self.timerLabel = [[MZTimerLabel alloc] initWithLabel:_counterLabel andTimerType:MZTimerLabelTypeTimer];
 
    
    
    // timerExample7.resetTimerAfterFinish = NO;
    self.timerLabel.timeFormat = @"mm:ss:SS";
    
    
    
    
    
    
    if(![self.timerLabel counting]){
        [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
            
    
        }];
    }
    
    
    
    
}
- (void)prepareForReuse {
  //  NSLog(@"MyCollection9999999%s --- %@", __func__, self);
    
    [super prepareForReuse];

}
- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
