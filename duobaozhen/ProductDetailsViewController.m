//
//  ProductDetailsViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/22.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "XXSettlementViewController.h"
@interface ProductDetailsViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong) UIView *shareView;
@property(nonatomic,strong) UIView *shareShadowView;
@end

@implementation ProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];

    [self createShareView];
    self.shareView.hidden = YES;

}
- (IBAction)ImmediateClick:(id)sender {
  
    [MobClick event:@"点击购买"];

    self.shareView.hidden = NO;
    
}
- (void)createShareView {
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.shareView.alpha = 1;
    self.shareView.backgroundColor = [UIColor clearColor];
    [self.tabBarController.view addSubview:self.shareView];
    
    self.shareShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.shareShadowView.alpha = 0.5;
    self.shareShadowView.backgroundColor = [UIColor blackColor];
    [self.shareView addSubview:self.shareShadowView];
    
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleShare)];
    [singletap setNumberOfTapsRequired:1];
    singletap.delegate = self;
    [self.shareShadowView addGestureRecognizer:singletap];
    
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT  - 180, WIDTH , 180)];
    temp.backgroundColor = [UIColor whiteColor];
    //temp.layer.cornerRadius = 5.0;
    [self.shareView addSubview:temp];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    imageview.image = [UIImage imageNamed:@"1.jpg"];
    
    [temp addSubview:imageview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, temp.frame.size.width - 120 - 30, 40)];
    label.text = @"但如果特瑞特让他热特人官方的官方得到的规范大哥";
    //    label.textColor = [UIColor colorWithRed:31/255.0 green:172/255.0 blue:240/255.0 alpha:1.0];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(120, 60, 20, 20)];
    button1.backgroundColor = [UIColor redColor];
    [temp addSubview:button1];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(140, 60, 50, 20)];
    textField.backgroundColor = [UIColor lightGrayColor];
    [temp addSubview:textField];
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(190, 60, 20, 20)];
    button2.backgroundColor = [UIColor redColor];
    [temp addSubview:button2];
    UILabel *renlabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 60, 40, 20)];
    renlabel.text = @"人次";
    renlabel.font = [UIFont systemFontOfSize:12];
    [temp addSubview:renlabel];
    [temp addSubview:label];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(120, 90, 70, 20)];

    label3.font =[ UIFont systemFontOfSize:12];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString: @"总需200人"];
    //    //获取要调整颜色的文字位置,调整颜色
    
    NSRange range2=[[hintString string]rangeOfString:@"200"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range2];
   label3.attributedText = hintString;
    [temp addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(200, 90, 70, 20)];
    
    label4.font =[ UIFont systemFontOfSize:12];
    NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString: @"剩余20人"];
    //    //获取要调整颜色的文字位置,调整颜色
    
    NSRange range3=[[hintString1 string]rangeOfString:@"20"];
    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range3];
    label4.attributedText = hintString1;
    [temp addSubview:label4];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, temp.frame.size.height - 50, WIDTH, 20)];
    label2.textAlignment =  NSTextAlignmentCenter;
    label2.text = @"中奖概率10%";
    [temp addSubview:label2];
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, temp.frame.size.height - 30, WIDTH, 30)];
    [cancleBtn addTarget:self action:@selector(duobaoClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"立刻夺宝" forState:UIControlStateNormal];
    cancleBtn.backgroundColor = [UIColor redColor];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //    cancleBtn.backgroundColor = [UIColor redColor];
    [temp addSubview:cancleBtn];
    UIButton *baoweiBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 100, 60, 60, 30)];
    [baoweiBtn setTitle:@"包尾" forState:UIControlStateNormal];
    [baoweiBtn  setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    baoweiBtn.layer.borderWidth = 1;
    baoweiBtn.layer.borderColor = [UIColor redColor].CGColor;
    baoweiBtn.layer.cornerRadius = 5;
    [temp addSubview:baoweiBtn];
    
}
- (void)cancleShare {
    self.shareView.hidden = YES;
}

- (void)duobaoClick {
    XXSettlementViewController *temp = [[XXSettlementViewController alloc]init];
    
    [self.navigationController pushViewController:temp animated:YES];
    self.shareView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
