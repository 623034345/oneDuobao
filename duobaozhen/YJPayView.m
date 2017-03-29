//
//  YJPayView.m
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/1.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import "YJPayView.h"

@implementation YJPayView
static UIView *backGroundView;
UITextField *TX_field;
UILabel *numLab;
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

        backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 330, WIDTH, 330)];
        backGroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backGroundView];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"夺宝有风险, 参与需谨慎";
        lab.textColor = UIColorHex(0x8f8f8f);
        lab.font = [UIFont systemFontOfSize:17.5];
        [backGroundView addSubview:lab];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorHex(0xdddddd);
        [backGroundView addSubview:lineView];
        
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.textColor = [UIColor blackColor];
        lab1.font = [UIFont systemFontOfSize:15];
        lab1.text = @"参与人次";
        [backGroundView addSubview:lab1];
        
        
        UIView *smallView = [[UIView alloc] init];
        smallView.layer.masksToBounds = YES;
        smallView.layer.cornerRadius = 3;
        [smallView.layer setBorderColor:[UIColor blackColor].CGColor];
        [smallView.layer setBorderWidth:0.6];
        [backGroundView addSubview:smallView];
        
        UIButton *jian_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [jian_btn setTitle:@"-" forState:UIControlStateNormal];
        [jian_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [jian_btn addTarget:self action:@selector(jian) forControlEvents:UIControlEventTouchUpInside];
        [smallView addSubview:jian_btn];
        
        UIButton *jia_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [jia_btn setTitle:@"+" forState:UIControlStateNormal];
        [jia_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        [jia_btn addTarget:self action:@selector(jia) forControlEvents:UIControlEventTouchUpInside];
        [smallView addSubview:jia_btn];
        
        
        UIButton *shanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [shanBtn setTitle:@"X" forState:UIControlStateNormal];
        [shanBtn addTarget:self action:@selector(shanBtn) forControlEvents:UIControlEventTouchUpInside];
        [backGroundView addSubview:shanBtn];
        
        TX_field = [[UITextField alloc] init];
        TX_field.keyboardType = UIKeyboardTypeDecimalPad;
        TX_field.textColor = UIColorHex(0xd93141);
        TX_field.font = [UIFont systemFontOfSize:15];
        TX_field.textAlignment = NSTextAlignmentCenter;
        [smallView addSubview:TX_field];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = UIColorHex(0xdddddd);
        [backGroundView addSubview:lineView1];
        
        UILabel *gLab = [[UILabel alloc] init];
        gLab.text = @"共";
        gLab.textColor = UIColorHex(0x898989);
        gLab.font = [UIFont systemFontOfSize:15];
        [backGroundView addSubview:gLab];
        
        numLab = [[UILabel alloc] init];
        numLab.textColor = UIColorHex(0xd93141);
        numLab.text = TX_field.text;
        numLab.font = [UIFont systemFontOfSize:15];
        [backGroundView addSubview:numLab];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = UIColorHex(0xdddddd);
        [backGroundView addSubview:lineView2];

        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setTitle:@"立即夺宝" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setBackgroundColor:UIColorHex(0xd93141)];
        submitBtn.layer.masksToBounds = YES;
        submitBtn.layer.cornerRadius = 3;
        [submitBtn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
        [backGroundView addSubview:submitBtn];
        
        UIView *shuView = [[UIView alloc] init];
        shuView.backgroundColor = UIColorHex(0xdddddd);
        [backGroundView addSubview:shuView];
        
        UIView *shuView1 = [[UIView alloc] init];
        shuView1.backgroundColor = UIColorHex(0xdddddd);
        [backGroundView addSubview:shuView1];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backGroundView.mas_left).offset(15);
            make.top.equalTo(backGroundView.mas_top).offset(16.5);
            make.width.equalTo(backGroundView.mas_width).multipliedBy(0.7);//设置宽度为self.view的一半，multipliedBy是倍数的意思，也就是，使宽度等于self.view宽度的0.5倍
            make.height.mas_equalTo(17);

        }];
        
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backGroundView.mas_left).offset(0);
            make.top.equalTo(backGroundView.mas_top).offset(50);
            make.width.equalTo(backGroundView.mas_width);
            make.height.mas_equalTo(0.5);
            
        }];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backGroundView);
            make.top.equalTo(lineView.mas_bottom).offset(32.5);
            make.height.mas_equalTo(15);
        }];
        
        [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backGroundView);
            make.top.equalTo(lab1.mas_bottom).offset(20);
            make.width.mas_equalTo(backGroundView.width * 0.8);
            make.height.mas_equalTo(40);
        }];
        
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backGroundView.mas_left).offset(0);
            make.top.equalTo(smallView.mas_bottom).offset(32.5);
            make.width.equalTo(backGroundView.mas_width);
            make.height.mas_equalTo(0.5);
        }];
        
        [gLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backGroundView).offset(-15);
            make.top.equalTo(lineView1.mas_bottom).offset(23);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gLab.mas_right).offset(2);
            make.top.equalTo(gLab.mas_top);
            make.height.equalTo(gLab.mas_height);
        }];
        
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backGroundView.mas_left).offset(0);
            make.top.equalTo(lineView1.mas_bottom).offset(62.5);
            make.width.equalTo(backGroundView.mas_width);
            make.height.mas_equalTo(0.5);
        }];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backGroundView);
            make.top.equalTo(lineView2.mas_top).offset(13.5);
            make.width.mas_equalTo(backGroundView.width * 0.95);
            make.height.mas_equalTo(50.5);
        }];
        
        
        [jian_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(smallView.mas_left).offset(5);
            make.top.equalTo(smallView.mas_top).offset(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [jia_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(smallView.mas_right).offset(-5);
            make.top.equalTo(smallView.mas_top).offset(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(smallView.mas_left).offset(45);
            make.top.equalTo(smallView.mas_top).offset(0);
            make.width.mas_equalTo(0.5);
            make.height.equalTo(smallView);
        }];
        
        [shuView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(smallView.mas_right).offset(-45);
            make.top.equalTo(smallView.mas_top).offset(0);
            make.width.mas_equalTo(0.5);
            make.height.equalTo(smallView);
        }];
        
        [TX_field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shuView.mas_right).offset(0);
            make.top.equalTo(smallView.mas_top).offset(0);
            make.right.equalTo(shuView1.mas_left).offset(0);
            make.height.equalTo(smallView);

        }];
        
        [shanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backGroundView.mas_right).offset(2);
            make.top.equalTo(backGroundView.mas_top).offset(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(50);
        }];
        
        numLab.text = @"50元";
 
        TX_field.text = @"50";
        [TX_field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        TX_field.delegate = self;

        
    }
    return self;
}
////--------------------------------
-(void)jian
{
    TX_field.font = [UIFont systemFontOfSize:18.0];
    [UIView animateWithDuration:0.8 animations:^{
        TX_field.font = [UIFont systemFontOfSize:15.0];
    }];
    if ([TX_field.text integerValue] > 1) {
        long a = [TX_field.text integerValue] - 1;
        TX_field.text = [NSString stringWithFormat:@"%ld",a];
        numLab.text = [NSString stringWithFormat:@"%ld元",a];

    }
}
//++++++++++++++++++++++++++++++++++++
-(void)jia
{
    TX_field.font = [UIFont systemFontOfSize:18.0];
    [UIView animateWithDuration:0.8 animations:^{
        TX_field.font = [UIFont systemFontOfSize:15.0];
    }];
    long a = [TX_field.text integerValue] + 1;
    TX_field.text = [NSString stringWithFormat:@"%ld",a];
    numLab.text = [NSString stringWithFormat:@"%ld元",a];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    numLab.text = [NSString stringWithFormat:@"%@元",TX_field.text];
}
///立即夺宝
-(void)go
{
    NSString *money = [numLab.text substringToIndex:[numLab.text length]-1];
    [_delegate YJPayViewWithPrice:money];
}
-(void)shanBtn
{
    self.frame = CGRectMake(0, HEIGHT, 0, 0);
    [self removeFromSuperview];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
