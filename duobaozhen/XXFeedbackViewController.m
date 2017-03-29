//
//  XXFeedbackViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/20.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXFeedbackViewController.h"

@interface XXFeedbackViewController ()

@end

@implementation XXFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"意见反馈";
    self.feedbackView.layer.borderWidth = 1.0;
    self.feedbackView.layer.borderColor = [UIColor grayColor].CGColor;
    self.feedbackButton.layer.cornerRadius = 4.0;
    self.view.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    [self.feedbackButton addTarget:self action:@selector(feedbackButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)feedbackButtonOnClick {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"uid":[XXTool getUserID], @"content":self.feedbackView.text};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/feedback", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {

        [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];

    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [XXTool displayAlert:@"提示" message:error.localizedDescription];
    }];
}

-(void)hidenKeyboard
{
    [self.feedbackView resignFirstResponder];
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
