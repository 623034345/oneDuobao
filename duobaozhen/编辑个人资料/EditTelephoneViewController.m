//
//  EditTelephoneViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/12.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "EditTelephoneViewController.h"

@interface EditTelephoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation EditTelephoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"联系电话";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    if ([self.dic[@"mobile"] isEqual:[NSNull null]]) {
        self.phoneTF.text = @"";
    }else {
        self.phoneTF.text = self.dic[@"mobile"];
    }
    
    
    
    
}
- (void)rightButtonOnClick {
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index/BaseInfoEdit", BASE_URL] delegate:self resultSelector:@selector(uploadNicknameRequest:) token:[NSString stringWithFormat:@"uid=%@&mobile=%@",[XXTool getUserID],self.phoneTF.text]];
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
            
            self.myBlock(self.phoneTF.text);
            NSLog(@"123%@",self.phoneTF.text);
            
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
