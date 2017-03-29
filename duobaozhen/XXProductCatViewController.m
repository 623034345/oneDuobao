//
//  XXProductCatViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/17.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXProductCatViewController.h"
#import "LXSegmentScrollView.h"
#import "XXWebViewController.h"
#import "UIImageView+WebCache.h"
#import "SettingViewController.h"
#import "MBProgressHUD.h"
#import "ProducetDetails2ViewController.h"
#import "DealsDetailsViewController.h"
#define HOTVIEWTAG 1000
#define QUICKLYVIEW 1100
#define NEWVIEW 1200
#define HIGHTVIEW 1300
#define LOWVIEW 1400

@interface XXProductCatViewController ()<UIGestureRecognizerDelegate>{
    
    LXSegmentScrollView *_scView;
    NSMutableArray *_hotArr;
    NSMutableArray *_quicklyArr;
    NSMutableArray *_newArr;
    NSMutableArray *_hightArr;
    NSMutableArray *_lowArr;
    
    UIView *_hotView;
    UIView *_quicklyView;
    UIView *_newView;
    UIView *_hightPriceView;
    UIView *_lowPriceView;



}
@property (weak, nonatomic) IBOutlet UIScrollView *backView;

@end

@implementation XXProductCatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商品";
    
    self.backView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    self.backView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    [self createSegmentView];
    [self postData];
    
//    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/fenlei/cateid/35",BASE_URL];
//    RCHttpRequest* temp2 = [[RCHttpRequest alloc] init];
//    [temp2 post:urlString2 delegate:self resultSelector:@selector(hotRequest:) token:nil];
//    
//    RCHttpRequest* temp3 = [[RCHttpRequest alloc] init];
//    [temp3 post:[NSString stringWithFormat:@"%@/apicore/index/fenlei/cateid/38",BASE_URL] delegate:self resultSelector:@selector(quicklyRequest:) token:nil];
//    
//    RCHttpRequest* temp4 = [[RCHttpRequest alloc] init];
//    [temp4 post:[NSString stringWithFormat:@"%@/apicore/index/fenlei/cateid/38",BASE_URL] delegate:self resultSelector:@selector(newRequest:) token:nil];
//    
//    RCHttpRequest* temp5 = [[RCHttpRequest alloc] init];
//    [temp5 post:[NSString stringWithFormat:@"%@/apicore/index/fenlei/cateid/38",BASE_URL] delegate:self resultSelector:@selector(hightRequest:) token:nil];
//    
//    RCHttpRequest* temp6 = [[RCHttpRequest alloc] init];
//    [temp6 post:[NSString stringWithFormat:@"%@/apicore/index/fenlei/cateid/38",BASE_URL] delegate:self resultSelector:@selector(lowRequest:) token:nil];

}

- (void)postData {
    
    
    
    
    
}

- (void)createSegmentView {
    
    if (_hotArr == nil) {
        _hotArr = [[NSMutableArray alloc] init];
        _quicklyArr = [[NSMutableArray alloc] init];
        _newArr = [[NSMutableArray alloc] init];
        _hightArr = [[NSMutableArray alloc] init];
        _lowArr = [[NSMutableArray alloc] init];
     
    }
    
    if (_hotView == nil) {
        _hotView = [[UIView alloc] init];
        _hotView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _quicklyView = [[UIView alloc] init];
        _quicklyView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _newView = [[UIView alloc] init];
        _newView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _hightPriceView = [[UIView alloc] init];
        _hightPriceView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _lowPriceView = [[UIView alloc] init];
        _lowPriceView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
    
    }
    _scView = [[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64) titleArray:@[@"全部商品",@"汽车", @"十元专区", @"手机/平板", @"电脑设备",@"家用电器",@"虚拟专区",@"其他商品"] contentViewArray:@[_hotView, _quicklyView, _newView, _hightPriceView, _lowPriceView]];
    [self.backView addSubview:_scView];
}

- (void)hotRequest:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            [_hotArr removeAllObjects];
            [_hotArr addObjectsFromArray:result[@"data"]];
            for (UIView *view in _hotView.subviews) {
                [view removeFromSuperview];
            }
            for (int i = 0; i < [result[@"data"] count]; i++) {
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  200 + 1, WIDTH / 2 - i % 2, 200)];
                v.backgroundColor = [UIColor whiteColor];
                //                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2,  i / 2 *  200 , WIDTH / 2 - i % 2, 1)];
                //                label.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
                //  [_hotView addSubview:label];
                v.tag = HOTVIEWTAG + i;
                [_hotView addSubview:v];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(v.frame.size.width / 2 - 50, 10, 100, 100)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, result[@"data"][i][@"thumb"]]]];
                [v addSubview:image];
                
                UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:14.0];
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [v addSubview:describeLabel];
                
                
                UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 173, v.frame.size.width - 50, 10)];
                float j = [result[@"data"][i][@"zongrenshu"] floatValue];
                float k = [result[@"data"][i][@"shenyurenshu"] floatValue];
                pro.progress = (j - k) / j;
                pro.tintColor = [UIColor orangeColor];
                pro.layer.cornerRadius = 4;
                pro.layer.masksToBounds = YES;
                //pro.trackTintColor = [UIColor lightGrayColor];
                pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                [v addSubview:pro];
                UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, v.frame.size.width - 20, 15)];
                proLabel.font = [UIFont systemFontOfSize:12.0];
                proLabel.textColor = [UIColor grayColor];
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ]];
                
                //    //获取要调整颜色的文字位置,调整颜色
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ];
                NSRange range2=[[hintString string]rangeOfString:@"揭晓进度"];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
                
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
                proLabel.attributedText = hintString;
                [v addSubview:proLabel];
                
                //                UILabel *leaveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, v.frame.size.width - 20, 15)];
                //                leaveLabel.font = [UIFont systemFontOfSize:12.0];
                //                leaveLabel.textColor = [UIColor lightGrayColor];
                //                leaveLabel.text = [NSString stringWithFormat:@"剩余:%@", result[@"data"][i][@"shenyurenshu"]];
                //                [v addSubview:leaveLabel];
                
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotViewOnTap:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [v addGestureRecognizer:singletap];
                
                UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
                [bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
                bt.tag = HOTVIEWTAG + i;
                [bt addTarget:self action:@selector(hotOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [v addSubview:bt];
            }
            self.backView.contentSize = CGSizeMake(WIDTH, 504 + ([result[@"data"] count] + 1 )  / 2 * 201);
            [_scView setHeight:([result[@"data"] count] + 1 ) / 2 * 201 + 44];
            _hotView.frame = CGRectMake(_hotView.frame.origin.x, _hotView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 )/ 2 * 201);
            
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)hotViewOnTap:(UITapGestureRecognizer *)tap {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = _hotArr[tap.view.tag - HOTVIEWTAG][@"id"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
      self.hidesBottomBarWhenPushed = NO;
}

- (void)hotOnClick:(UIButton *)button {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        SettingViewController *temp = [[SettingViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, _hotArr[button.tag - HOTVIEWTAG][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
}

- (void)qwe:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            // [XXTool displayAlert:@"提示" message:result[@"msg"]];
            MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
            hub.labelText = @"成功";
            [hub hide:YES afterDelay:1.f];
            
            UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
            temp.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", result[@"data"][@"sps"]];
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)quicklyRequest:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            for (UIView *view in _quicklyView.subviews) {
                [view removeFromSuperview];
            }
            [_quicklyArr removeAllObjects];
            [_quicklyArr addObjectsFromArray:result[@"data"]];
            for (int i = 0; i < [result[@"data"] count]; i++) {
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  201 + 1, WIDTH / 2 - i % 2, 200)];
                v.backgroundColor = [UIColor whiteColor];
                v.tag = QUICKLYVIEW + i;
                [_quicklyView addSubview:v];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(v.frame.size.width / 2 - 50, 10, 100, 100)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL,result[@"data"][i][@"thumb"]]]];
                [v addSubview:image];
                
                UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:14.0];
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [v addSubview:describeLabel];
                
                UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 173, v.frame.size.width - 50, 10)];
                float j = [result[@"data"][i][@"zongrenshu"] floatValue];
                float k = [result[@"data"][i][@"shenyurenshu"] floatValue];
                pro.progress = (j - k) / j;
                pro.tintColor = [UIColor orangeColor];
                pro.layer.cornerRadius = 4;
                pro.layer.masksToBounds = YES;
                //pro.trackTintColor = [UIColor lightGrayColor];
                pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                [v addSubview:pro];
                UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, v.frame.size.width - 20, 15)];
                proLabel.font = [UIFont systemFontOfSize:12.0];
                proLabel.textColor = [UIColor grayColor];
                
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ]];
                
                //    //获取要调整颜色的文字位置,调整颜色
                
                NSRange range2=[[hintString string]rangeOfString:@"揭晓进度" ];
                [hintString addAttribute:NSForegroundColorAttributeName value:BASE_COLOR range:range2];
                
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
                proLabel.attributedText = hintString;
                [v addSubview:proLabel];
                
                
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quicklyViewOnTap:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [v addGestureRecognizer:singletap];
                
                UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
                [bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
                bt.tag = QUICKLYVIEW + i;
                [bt addTarget:self action:@selector(quicklyOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [v addSubview:bt];
            }
            _quicklyView.frame = CGRectMake(_quicklyView.frame.origin.x, _quicklyView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 ) / 2 * 201);
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)quicklyViewOnTap:(UITapGestureRecognizer *)tap {
//    XXWebViewController *temp = [[XXWebViewController alloc] init];
//    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/item/%@", BASE_URL, _quicklyArr[tap.view.tag - QUICKLYVIEW][@"id"]];
//    temp.hidesBottomBarWhenPushed = YES;
//    temp.homeNum = 1;
//    [self.navigationController pushViewController:temp animated:YES];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = _quicklyArr[tap.view.tag - QUICKLYVIEW][@"id"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
  self.hidesBottomBarWhenPushed = NO;
}

- (void)quicklyOnClick:(UIButton *)button {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        SettingViewController *temp = [[SettingViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, _quicklyArr[button.tag - QUICKLYVIEW][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
}

- (void)newRequest:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            for (UIView *view in _newView.subviews) {
                [view removeFromSuperview];
            }
            [_newArr removeAllObjects];
            [_newArr addObjectsFromArray:result[@"data"]];
            for (int i = 0; i < [result[@"data"] count]; i++) {
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  201 + 1, WIDTH / 2 - i % 2, 200)];
                v.backgroundColor = [UIColor whiteColor];
                v.tag = NEWVIEW + i;
                [_newView addSubview:v];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(v.frame.size.width / 2 - 50, 10, 100, 100)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, result[@"data"][i][@"thumb"]]]];
                [v addSubview:image];
                
                UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:14.0];
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [v addSubview:describeLabel];
                
                UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 173, v.frame.size.width - 50, 10)];
                float j = [result[@"data"][i][@"zongrenshu"] floatValue];
                float k = [result[@"data"][i][@"shenyurenshu"] floatValue];
                pro.progress = (j - k) / j;
                pro.tintColor = [UIColor orangeColor];
                pro.layer.cornerRadius = 4;
                pro.layer.masksToBounds = YES;
                //pro.trackTintColor = [UIColor lightGrayColor];
                pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                [v addSubview:pro];
                UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, v.frame.size.width - 20, 15)];
                proLabel.font = [UIFont systemFontOfSize:12.0];
                proLabel.textColor = [UIColor grayColor];
                
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ]];
                
                //    //获取要调整颜色的文字位置,调整颜色
                NSRange range2=[[hintString string]rangeOfString:@"揭晓进度" ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range2];
                
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
                proLabel.attributedText = hintString;
                [v addSubview:proLabel];
                
                //------------
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newViewOnTap:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [v addGestureRecognizer:singletap];
                
                UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
                [bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
                bt.tag = NEWVIEW + i;
                [bt addTarget:self action:@selector(newOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [v addSubview:bt];
            }
            _newView.frame = CGRectMake(_newView.frame.origin.x, _newView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 ) / 2 * 201);
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)newViewOnTap:(UITapGestureRecognizer *)tap {
//    XXWebViewController *temp = [[XXWebViewController alloc] init];
//    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/item/%@", BASE_URL, _newArr[tap.view.tag - NEWVIEW][@"id"]];
//    temp.hidesBottomBarWhenPushed = YES;
//    temp.homeNum = 1;
//    [self.navigationController pushViewController:temp animated:YES];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = _newArr[tap.view.tag - NEWVIEW][@"id"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
  self.hidesBottomBarWhenPushed = NO;
}

- (void)newOnClick:(UIButton *)button {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        SettingViewController *temp = [[SettingViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, _newArr[button.tag - NEWVIEW][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
}

- (void)hightRequest:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            for (UIView *view in _hightPriceView.subviews) {
                [view removeFromSuperview];
            }
            [_hightArr removeAllObjects];
            [_hightArr addObjectsFromArray:result[@"data"]];
            for (int i = 0; i < [result[@"data"] count]; i++) {
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  201 + 1, WIDTH / 2 - i % 2, 200)];
                v.backgroundColor = [UIColor whiteColor];
                v.tag = HIGHTVIEW + i;
                [_hightPriceView addSubview:v];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(v.frame.size.width / 2 - 50, 10, 100, 100)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL,result[@"data"][i][@"thumb"]]]];
                [v addSubview:image];
                
                UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:14.0];
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [v addSubview:describeLabel];
                
                UIImageView *tenImage = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, 50, 50)];
                tenImage.image = [UIImage imageNamed:@"shiyuan.png"];
                [v addSubview:tenImage];
                
                UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 173, v.frame.size.width - 50, 10)];
                float j = [result[@"data"][i][@"zongrenshu"] floatValue];
                float k = [result[@"data"][i][@"shenyurenshu"] floatValue];
                pro.progress = (j - k) / j;
                pro.tintColor = [UIColor orangeColor];
                pro.layer.cornerRadius = 4;
                pro.layer.masksToBounds = YES;
                //pro.trackTintColor = [UIColor lightGrayColor];
                pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                [v addSubview:pro];
                UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, v.frame.size.width - 20, 15)];
                proLabel.font = [UIFont systemFontOfSize:12.0];
                proLabel.textColor = [UIColor grayColor];
                
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ]];
                
                //    //获取要调整颜色的文字位置,调整颜色
                
                NSRange range2=[[hintString string]rangeOfString:@"揭晓进度" ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range2];
                
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
                proLabel.attributedText = hintString;
                [v addSubview:proLabel];
                
                
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hightViewOnTap:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [v addGestureRecognizer:singletap];
                
                UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
                [bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
                bt.tag = HIGHTVIEW + i;
                [bt addTarget:self action:@selector(hightOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [v addSubview:bt];
            }
            _hightPriceView.frame = CGRectMake(_hightPriceView.frame.origin.x, _hightPriceView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 ) / 2 * 201);
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)hightViewOnTap:(UITapGestureRecognizer *)tap {
//    XXWebViewController *temp = [[XXWebViewController alloc] init];
//    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/item/%@", BASE_URL, _hightArr[tap.view.tag - HIGHTVIEW][@"id"]];
//    temp.hidesBottomBarWhenPushed = YES;
//    temp.homeNum = 1;
//    [self.navigationController pushViewController:temp animated:YES];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = _hightArr[tap.view.tag - HIGHTVIEW][@"id"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
  self.hidesBottomBarWhenPushed = NO;
}

- (void)hightOnClick:(UIButton *)button {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        SettingViewController *temp = [[SettingViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, _hightArr[button.tag - HIGHTVIEW][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
}

- (void)lowRequest:(NSString*)jsonString {
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            for (UIView *view in _lowPriceView.subviews) {
                [view removeFromSuperview];
            }
            [_lowArr removeAllObjects];
            [_lowArr addObjectsFromArray:result[@"data"]];
            for (int i = 0; i < [result[@"data"] count]; i++) {
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i % 2 * WIDTH / 2 + i % 2, i / 2 *  201 + 1, WIDTH / 2 - i % 2, 200)];
                v.backgroundColor = [UIColor whiteColor];
                v.tag = LOWVIEW + i;
                [_lowPriceView addSubview:v];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(v.frame.size.width / 2 - 50, 10, 100, 100)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@", BASE_URL, result[@"data"][i][@"thumb"]]]];
                [v addSubview:image];
                
                UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, v.frame.size.width - 20, 35)];
                describeLabel.font = [UIFont systemFontOfSize:14.0];
                describeLabel.numberOfLines = 0;
                describeLabel.text = [result[@"data"][i][@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [v addSubview:describeLabel];
                
                
                UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 173, v.frame.size.width - 50, 10)];
                float j = [result[@"data"][i][@"zongrenshu"] floatValue];
                float k = [result[@"data"][i][@"shenyurenshu"] floatValue];
                pro.progress = (j - k) / j;
                pro.tintColor = [UIColor orangeColor];
                pro.layer.cornerRadius = 4;
                pro.layer.masksToBounds = YES;
                //pro.trackTintColor = [UIColor lightGrayColor];
                pro.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                [v addSubview:pro];
                UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, v.frame.size.width - 20, 15)];
                proLabel.font = [UIFont systemFontOfSize:12.0];
                proLabel.textColor = [UIColor grayColor];
                
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度  %@", [NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ]];
                
                //    //获取要调整颜色的文字位置,调整颜色
                NSRange range2=[[hintString string]rangeOfString:@"揭晓进度" ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range2];
                
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%.f%%",((j - k) / j) *100] ];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:193/255.0 blue:255/255.0 alpha:1] range:range1];
                proLabel.attributedText = hintString;
                [v addSubview:proLabel];
                
                
                
                UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lowViewOnTap:)];
                [singletap setNumberOfTapsRequired:1];
                singletap.delegate = self;
                [v addGestureRecognizer:singletap];
                
                UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width - 35, 155, 30, 30)];
                [bt setBackgroundImage:[UIImage imageNamed:@"gwc.png"] forState:UIControlStateNormal];
                bt.tag = LOWVIEW + i;
                [bt addTarget:self action:@selector(lowOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [v addSubview:bt];
            }
            _lowPriceView.frame = CGRectMake(_lowPriceView.frame.origin.x, _lowPriceView.frame.origin.y, WIDTH, ([result[@"data"] count] + 1 ) / 2 * 201);
        } else {
            //            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)lowViewOnTap:(UITapGestureRecognizer *)tap {
//    XXWebViewController *temp = [[XXWebViewController alloc] init];
//    temp.url = [NSString stringWithFormat:@"%@/mobile/mobile/item/%@", BASE_URL, _lowArr[tap.view.tag - LOWVIEW][@"id"]];
//    temp.hidesBottomBarWhenPushed = YES;
//    temp.homeNum = 1;
//    [self.navigationController pushViewController:temp animated:YES];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = _lowArr[tap.view.tag - LOWVIEW][@"id"];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)lowOnClick:(UIButton *)button {
    if ([[XXTool getUserID] isEqualToString:@"0"]) {
        //[XXTool displayAlert:@"提示" message:@"请登录"];
        SettingViewController *temp = [[SettingViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/mobile/ajax/addgwc/gid/%@/uid/%@", BASE_URL, _lowArr[button.tag - LOWVIEW][@"id"], [XXTool getUserID]] delegate:self resultSelector:@selector(qwe:) token:nil];
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
