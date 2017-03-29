//
//  ErweimaViewController.m
//  duobaozhen
//
//  Created by administrator on 16/12/12.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ErweimaViewController.h"
#import "XXPayResultViewController.h"
@interface ErweimaViewController ()<UIActionSheetDelegate>{
    NSTimer*_timer;
}
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *comBtn;
@property (nonatomic ,strong)NSString *orderNum;
@end

@implementation ErweimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self getOrderNum];
    self.comBtn.layer.cornerRadius = 3;
    self.comBtn.layer.masksToBounds = YES;
    self.moneyLabel.text = [NSString stringWithFormat:@"待支付:￥%@",self.money];
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self.navigationItem setHidesBackButton:YES];
    self.codeImage.userInteractionEnabled = YES;
    UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
    [self.codeImage addGestureRecognizer:longPress];
    

    self.saveBtn.layer.cornerRadius = 4;
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.saveBtn.layer.borderWidth = 1;
    
}

#pragma mark-> 长按识别二维码
-(void)dealLongPress:(UIGestureRecognizer*)gesture{
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        
        _timer.fireDate=[NSDate distantFuture];
    NSLog(@"123");
        UIImageView*tempImageView=(UIImageView*)gesture.view;
        if(tempImageView.image){
            //1. 初始化扫描仪，设置设别类型和识别质量
            CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
            //2. 扫描获取的特征组
            NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:tempImageView.image.CGImage]];
            //3. 获取扫描结果
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
//            if(features.count>0) {
//                CIQRCodeFeature *feature = [features objectAtIndex:0];
//                NSString *scannedResult = feature.messageString;
//                NSLog(@"扫描结果------%@",scannedResult);
//                UIActionSheet *ac = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送给朋友",@"收藏",@"保存图片",@"识别图中二维码", nil];
//                [ac showInView:self.view];
//            }else{
//                UIActionSheet *ac = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送给朋友",@"收藏",@"保存图片", nil];
//                [ac showInView:self.view];
//            }
        }else{
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果"message:@"您还没有生成二维码"delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil,nil];
            [alertView show];
        }
            
        
        
 }else if (gesture.state==UIGestureRecognizerStateEnded){
//        
//        
        _timer.fireDate=[NSDate distantPast];
    }
    
    
}


- (void)backClick {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/Qtpay/getscanorderstatus",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"merchantOrderId":self.orderNum};
    
    [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        
        if (integer == 2000) {
            //

             [XXTool displayAlert:@"提示" message:@"您已完成支付，请点击确认按钮"];
            
            
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲，支付还未完成，您确定要离开?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:confirm];
            [alert addAction:cancle];
            
            [self presentViewController:alert animated:YES completion:nil];
           
        }
        
        //
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
   
    
    
}


- (IBAction)complishClick:(UIButton *)sender {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/Qtpay/getscanorderstatus",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"merchantOrderId":self.orderNum};
    
    [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        
        if (integer == 2000) {
            //
            if ([self.flagStr isEqualToString:@"1"]) {

               // [self chongzhi:self.money];
            
                //[self.navigationController popViewControllerAnimated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else {
                
                if ([self.otherFlag isEqualToString:@"1"]) {
                  //判断当商品价格大于余额
                    
                    
                    [self chongzhi:self.money];
                    
                    XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
                    temp.navigationItem.hidesBackButton =YES;
                    temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL, self.restMoney,self.md5, [XXTool getUserID]];
                    [self.navigationController pushViewController:temp animated:YES];
                    
                    if ([self.redMoneyStr integerValue] == 0) {
                        //
                    }else {
                        
                      [self postRedPaperData:self.redMoneyStr];
                    }
      
                    
                }else {
                 //判断当商品价格小于余额
                    
                    [self chongzhi:self.money];
                    
                    XXPayResultViewController *temp = [[XXPayResultViewController alloc] init];
                    temp.navigationItem.hidesBackButton =YES;
                    temp.url = [NSString stringWithFormat:@"%@/mobile/cart/paysubmit/money/5/%@/197940/%@/%@", BASE_URL, self.money,self.md5, [XXTool getUserID]];
                    [self.navigationController pushViewController:temp animated:YES];
                    
                }
                

            }
            
            
          
            
        }else {
            
//            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲，支付还未完成，您确定要离开?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:confirm];
            [alert addAction:cancle];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        
        }
        
        //
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
    
}

- (void)getOrderNum {
    
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/createordersn",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString2 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        
        self.orderNum= responseObject[@"data"];
        [self postPayData:self.orderNum];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}

- (void)postPayData:(NSString *)orderNum {
    
    if ([self.flagStr isEqualToString:@"1"]) {
        //充值
        NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/Qtpay/scanOrderCharge",BASE_URL];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"type":@"4",@"uid":[XXTool getUserID],@"merchantOrderId":orderNum,@"merchantOrderAmt":[NSString stringWithFormat:@"%ld",[self.money integerValue]*100]};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            //
            NSInteger integer = [[responseObject objectForKey:@"retcode"]integerValue];
            
            if (integer == 2000) {
           
                [self getCodeData:responseObject[@"data"]];
            }else {
                
                //[XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            }
            
            
            NSLog(@"%@-----%@",parameters,responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
        }];
        
        
        
        
    }else {
        //购买商品
        NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/Qtpay/scanOrderCharge",BASE_URL];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSString *dealsIDStr = [self.dealIDArray componentsJoinedByString:@","];
        
        NSDictionary *parameters = @{@"type":@"3",@"uid":[XXTool getUserID],@"gid":dealsIDStr,@"merchantOrderId":orderNum,@"merchantOrderAmt":[NSString stringWithFormat:@"%ld",[self.money integerValue]*100]};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlString2 parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            //
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            NSLog(@"%@-----%@",parameters,responseObject);
            if (integer == 2000) {
                
                
                NSLog(@"购买商品成功");
                [self getCodeData:responseObject[@"data"]];
                
            }else {
                
                
              //  [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
        }];
    }
    
    
    
}



- (void)getCodeData:(NSString *)urlString {
    
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    //  NSString *dataString = @"http://www.baidu.com";
    
    NSString *dataString = urlString;
    NSLog(@"%@",dataString);
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //获取输出的二维码
    
    CIImage *outputImage = [filter outputImage];
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    
    // 5.显示二维码
    self.codeImage.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    
    
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)chongzhi:(NSString *)money {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    
    NSDictionary * paramters = @{@"uid":[XXTool getUserID],@"money":money};
    
    
    
    
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/chongzhi",BASE_URL] parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        
        NSLog(@"-----%@",responseObject);
        self.totalMoney =[ NSString  stringWithFormat:@"%ld", [self.totalMoney integerValue] + [paramters[@"money"] integerValue]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}
- (IBAction)savePicClick:(id)sender {


    
     [self saveImageToPhotos:self.codeImage.image];
    
    
    
    


}


- (void)saveImageToPhotos:(UIImage *)savedImage {
    
    
  UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
    
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    NSString *msg = nil;
    
    if (error != NULL) {
        msg = @"保存图片失败";
    }else {
        
        
        msg = @"保存图片成功";
        
    }
    
    [XXTool displayAlert:@"提示" message:msg];
    
    
}

- (void)postRedPaperData:(NSString *)money {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/pay_redpacket",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *dic = @{@"uid":[XXTool getUserID],@"red_amount":money};
    [manager POST:urlString2 parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"v%@",dic);
        NSInteger integer = [responseObject[@"retcode"] integerValue];
        if (integer == 2000) {
            //
            
            NSLog(@"支付成功");

            
        }
        //[XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
    
    
    
    
    
    
}




@end
