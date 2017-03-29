//
//  XXShoppingCartTableViewCell.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/29.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXShoppingCartTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface XXShoppingCartTableViewCell()<UIAlertViewDelegate>

@property (nonatomic ,strong)UILabel *label1;
@end

@implementation XXShoppingCartTableViewCell {
    NSDictionary *_dic;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [self.minusButton addTarget:self action:@selector(minus) forControlEvents:UIControlEventTouchUpInside];
    [self.allButton addTarget:self action:@selector(all:) forControlEvents:UIControlEventTouchUpInside];
    self.baoweiLabel.hidden = YES;


    
    
}


- (void)uploadViewWithDic:(NSDictionary *)dic {
    _dic = [NSDictionary dictionaryWithDictionary:dic];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"thumb"]] placeholderImage:[UIImage imageNamed:@"imageerror"]];
    self.countField.text = self.countStr;
    self.titleLabel.text = [dic[@"title"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    self.qishuLabel.text = [NSString stringWithFormat:@"第%@期", dic[@"qishu"]];
    self.totalLabel.text = [NSString stringWithFormat:@"总需%@", dic[@"zongrenshu"]];
    self.remainderLabel.text = [NSString stringWithFormat:@"剩余%@人次", dic[@"shenyurenshu"]];
    [XXTool setUILabel:self.remainderLabel Data:[self.remainderLabel.text substringFromIndex:2] SetData:[self.remainderLabel.text substringFromIndex:4] Color:[UIColor redColor] Font:16.0 Underline:NO];
    if ([self.countStr isEqualToString:dic[@"shenyurenshu"]]) {
        self.allButton.selected = YES;
    }
    [self.deleteButton addTarget:self action:@selector(deleteWith:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([dic[@"yunjiage"] isEqualToString:@"10.00"]) {
        //
        
        self.shiyuanImage.hidden = NO;
        
    }else {
        
        self.shiyuanImage.hidden = YES;
    }
    
    
}
#pragma mark -- alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //删除
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        
            NSDictionary *parameters = @{@"uid":[XXTool getUserID], @"gid":_dic[@"id"]};
            [manager POST:[NSString stringWithFormat:@"%@/apicore/index/deletecart", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                if (integer == 2000) {
                   // [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
                    self.deleteBlock();
                }else{
                    [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
                }
            } failure:^(NSURLSessionDataTask * task, NSError * error) {
                [XXTool displayAlert:@"提示" message:error.localizedDescription];
            }];
    }else {
        
        //取消
        
    }
    
}

- (void)deleteWith:(UIButton *)button {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定移除商品%@？",self.titleLabel.text] delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
 
    [alert show];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//   
//    
//    NSDictionary *parameters = @{@"uid":[XXTool getUserID], @"gid":_dic[@"id"]};
//    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/deletecart", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
//        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
//        if (integer == 2000) {
//           // [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
//            self.deleteBlock();
//        }else{
//            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
//        }
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        [XXTool displayAlert:@"提示" message:error.localizedDescription];
//    }];
}

- (void)add {
    self.addBlock(self.countField.text);
}

- (void)minus {
    self.minusBlock(self.countField.text);
}
static NSString *saveCountStr;
- (void)all:(UIButton *)button {
    
     saveCountStr = @"1";
    NSLog(@"gg%@",self.countField.text);
    if (button.selected == NO) {
        [button setSelected:YES];
       
        saveCountStr = self.countField.text;
        
        self.allBlock(self.countField.text);
    } else {
        
        self.allButton.selected = NO;
        self.allBlock1(saveCountStr);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
