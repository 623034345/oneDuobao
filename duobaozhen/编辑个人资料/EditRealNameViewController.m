//
//  EditRealNameViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/12.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "EditRealNameViewController.h"

@interface EditRealNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;

@end

@implementation EditRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"真实姓名";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    if ([self.dic[@"realname"] isEqual:[NSNull null]]) {
           self.realNameTF.text = @"";
    }else {
           self.realNameTF.text = self.dic[@"realname"];
    }
 
    
    
    
}
- (void)rightButtonOnClick {
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index/BaseInfoEdit", BASE_URL] delegate:self resultSelector:@selector(uploadNicknameRequest:) token:[NSString stringWithFormat:@"uid=%@&realname=%@",[XXTool getUserID],self.realNameTF.text]];
    [self.navigationController popViewControllerAnimated:YES];
    
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
            
            self.myBlock(self.realNameTF.text);
            NSLog(@"123%@",self.realNameTF.text);
            
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
