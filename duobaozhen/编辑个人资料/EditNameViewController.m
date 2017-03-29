//
//  EditNameViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/12.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "EditNameViewController.h"

@interface EditNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIView *view1;

@end

@implementation EditNameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view1.layer.borderWidth = 1;
    self.view1.layer.borderColor = BASE_COLOR.CGColor;
    self.title = @"我的昵称";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
  
    
    self.nameTF.text = self.dic[@"username"];
    
    

}
- (void)rightButtonOnClick {
    if ([self.nameTF.text length] >8) {
        [XXTool displayAlert:@"提示" message:@"请输入8个字以内的昵称"];
    }else {
        //self.nameTF.text = self.dic[@"username"];
        RCHttpRequest *temp = [[RCHttpRequest alloc] init];
        [temp post:[NSString stringWithFormat:@"%@/apicore/index/BaseInfoEdit", BASE_URL] delegate:self resultSelector:@selector(uploadNicknameRequest:) token:[NSString stringWithFormat:@"uid=%@&username=%@",[XXTool getUserID],self.nameTF.text]];
        [self.navigationController popViewControllerAnimated:YES];
    }
 
    
}

- (void)uploadNicknameRequest:(NSString*)jsonString
{
    if(0 == [jsonString length]){
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {

            self.myBlock(self.nameTF.text);
            NSLog(@"123%@",self.nameTF.text);
       
        }
        //[XXTool displayAlert:@"提示" message:result[@"msg"]];
    }
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
