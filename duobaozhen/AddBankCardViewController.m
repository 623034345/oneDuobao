//
//  AddBankCardViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/23.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "MBProgressHUD.h"
#import "CheckBankCardViewController.h"
@interface AddBankCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numTF;

@property (nonatomic, strong)MBProgressHUD *hud;

@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加银行卡";
    
    
//    NSNumber *number = [NSNumber numberWithLongLong:(long)[self.numTF.text integerValue]];
//    
//    
//    NSNumberFormatter *formatter = [NSNumberFormatter new];
//    [formatter setUsesGroupingSeparator:YES];
//    [formatter setGroupingSize:4];
//    [formatter setGroupingSeparator:@" "];
//    
//    NSString *string = [formatter stringFromNumber:number];
   
    self.numTF.clearButtonMode = UITextFieldViewModeAlways;
    self.numTF.delegate =self;

    
  
 

}


- (BOOL) checkCardNo:(NSString*) cardNo{

    int oddsum = 0;     //奇数求和
int evensum = 0;    //偶数求和

int allsum = 0;

int cardNoLength = (int)[cardNo length];

int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];



cardNo = [cardNo substringToIndex:cardNoLength - 1];

for (int i = cardNoLength -1 ; i>=1;i--) {

    NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];

    int tmpVal = [tmpString intValue];

    if (cardNoLength % 2 ==1 ) {
     
        if((i % 2) == 0){
    
            tmpVal *= 2;
        
            if(tmpVal>=10)
             
                tmpVal -= 9;
   
            evensum += tmpVal;
         
        }else{
       
            oddsum += tmpVal;
          
        }
     
    }else{
       
        if((i % 2) == 1){
        
            tmpVal *= 2;
           
            if(tmpVal>=10)
             
                tmpVal -= 9;
         
            evensum += tmpVal;
      
        }else{
      
            oddsum += tmpVal;
        
        }
      
    }
    }



allsum = oddsum + evensum;

allsum += lastNum;

if((allsum % 10) == 0)

return YES;

else

return NO;

}
- (IBAction)nextClick:(id)sender {
    NSLog(@"ss%lu",self.numTF.text.length);
    if (self.numTF.text.length != 19 && self.numTF.text.length != 23) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
        hud.labelText = @"请输入完整的银行卡号";
        [hud hide:YES afterDelay:1.f];
    }
//    else {
//        BOOL isRight = [self checkCardNo:self.numTF.text];
//        if (!isRight) {
//            
//            
//            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeCustomView;
//            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
//            hud.labelText = @"银行卡输入错误";
//            [hud hide:YES afterDelay:1.f];
//            
//            
//            
//        }
        else{
            
            
             [self postData];
            

        }
    }
 
- (void)postData {
    
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/getBindBankname",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *strUrl = [self.numTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *dic = @{@"cardNo":strUrl};
    [manager POST:urlString2 parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"%@/%@",dic,responseObject[@"data"]);
        
        NSInteger integer = [responseObject[@"retcode"] intValue];
        
        if (integer == 2000) {
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
            hud.labelText = @"银行卡输入正确";
            [hud hide:YES afterDelay:1.f];
            CheckBankCardViewController *temp = [[CheckBankCardViewController alloc]init];
            temp.bankNum = self.numTF.text;
            temp.totalMoney = self.totalMoney;
            temp.md5Str = self.md5Str;
            temp.money = self.money;
            
            temp.flagStr = self.flagString;
            
            temp.dealIDArray = self.dealIDArray;
            
            temp.title = @"银行卡验证信息";
            [self.navigationController pushViewController:temp animated:YES];
            
        }else {
            
            
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            
        }
   
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField text];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length >= 24) {
        return NO;
    }
    
    [textField setText:newString];
    
    return NO;
    
    
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
