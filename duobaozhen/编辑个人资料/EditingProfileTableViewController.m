//
//  EditingProfileTableViewController.m
//  duobaozhen
//
//  Created by administrator on 16/9/7.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "EditingProfileTableViewController.h"
#import "EditPhotoTableViewCell.h"
#import "EditNameViewController.h"
#import "EditRealNameViewController.h"
#import "EditTelephoneViewController.h"
#import "EditSignViewController.h"
#import "UIImageView+WebCache.h"
#import "EditPwdViewController.h"
#import "DatePickerView.h"
@interface EditingProfileTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) NSDictionary *dic;
@property (strong,nonatomic) DatePickerView *datePickerView;
@property (nonatomic ,strong)UIImageView *image;
@end

@implementation EditingProfileTableViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
  
//    NSString* params = [NSString stringWithFormat:@"uid=%@", [XXTool getUserID]];
//    NSString* urlString = [NSString stringWithFormat:@"%@/apicore/index.php/index/getUserInfo", BASE_URL];
//    RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
//    [temp post:urlString delegate:self resultSelector:@selector(finishedRegisterRequest:) token:params];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString* params = [NSString stringWithFormat:@"uid=%@", [XXTool getUserID]];
    NSString* urlString = [NSString stringWithFormat:@"%@/apicore/index.php/index/getUserInfo", BASE_URL];
    RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
        [temp post:urlString delegate:self resultSelector:@selector(finishedRegisterRequest:) token:params];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 140)];
    self.tableView.tableFooterView = bottomView;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 50, WIDTH - 40, 40)];
    
    button.backgroundColor = BASE_COLOR;
    [button setTitle:@"退出此账号" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:button];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    NSString* params = [NSString stringWithFormat:@"uid=%@", [XXTool getUserID]];
    NSString* urlString = [NSString stringWithFormat:@"%@/apicore/index.php/index/getUserInfo", BASE_URL];
    RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
    [temp post:urlString delegate:self resultSelector:@selector(finishedRegisterRequest:) token:params];
    self.navigationController.navigationBarHidden = NO;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0  blue:223/255.0  alpha:1.0];
    
    

    
}

- (void)quitClick {
    [XXTool setUserID:@"0"];
    //    self.tabBarController.tabBar.hidden = NO;
    UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
    temp.tabBarItem.badgeValue = nil;
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    
    
}
- (void)finishedRegisterRequest:(NSString*)jsonString
{
    if (jsonString.length == 0) {
        return;
    }
    
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            self.dic =result[@"data"][0];
            
            [self.tableView reloadData];

            NSLog(@"vvv%@",self.dic);
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 87;
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //
        EditPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        cell.accessoryType = 1;
   
        if (self.dic) {
            self.image = cell.photoImage;
            [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dic[@"img"]]] placeholderImage:[UIImage imageNamed:@"222"]];
            NSLog(@"ssss%@",self.dic);
        }

        return cell;
        
    }else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
       
  
            cell.detailTextLabel.text = @"修改";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"昵称:%@",self.dic[@"username"]];
          cell.accessoryType = 1;
        return cell;
    }else if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = @"修改账号密码";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.detailTextLabel.text = @"修改";
                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            
        }
        cell.accessoryType = 1;
            return cell;
        }else if (indexPath.row == 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
                
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"生日(只能设置一次)"];
                     NSRange range2=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",@"生日"]];
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                //获取要调整颜色的文字位置,调整颜色
                NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",@"(只能设置一次)"]];
                [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range1];
            [hintString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range1];
                cell.textLabel.attributedText = hintString;
                
        }
        cell.detailTextLabel.text = self.dic[@"birthday"];
         cell.accessoryType = 1;
        
      return cell;
        
    }
    // Configure the cell...
  
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        //
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIImagePickerController *vc = [[UIImagePickerController alloc]init];
        vc.delegate = self;
        // 允许编辑
        vc.allowsEditing = YES;
        [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *cameraAction =[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            
            [vc setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        
        
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            
            [vc setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [self presentViewController:vc animated:YES completion:nil];
            
        }];
        
        [alert addAction:cancle];
        [alert addAction:cameraAction];
        [alert addAction:albumAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if ( indexPath.row == 1) {
        //昵称
        EditNameViewController *temp = [[EditNameViewController alloc]init];
        temp.dic = self.dic;
        temp.myBlock = ^(NSString *name){
            
            NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = name;
            NSLog(@"234%@",name);
        };
        [self.tableView reloadData];
        [self.navigationController pushViewController:temp animated:YES];
        
        
    }else if (indexPath.row == 2){
        EditPwdViewController *temp = [[EditPwdViewController alloc]init];
        temp.title = @"我的账号";
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
//        EditRealNameViewController *temp = [[EditRealNameViewController alloc]init];
//        temp.dic = self.dic;
//        temp.myBlock = ^(NSString *name){
//            
//            NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.detailTextLabel.text = name;
//            
//        };
//        [self.tableView reloadData];
//        [self.navigationController pushViewController:temp animated:YES];
    
        
        
        
    }else if (indexPath.row == 3){
//        EditTelephoneViewController *temp = [[EditTelephoneViewController alloc]init];
//        temp.dic = self.dic;
//        temp.myBlock = ^(NSString *name){
//            
//            NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
           UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.detailTextLabel.text.length == 0) {
            //创建DatePickerView
            
            _datePickerView = [[DatePickerView alloc] initWithCustomeHeight:250];
            
            __weak typeof (_datePickerView) weakSelf = _datePickerView;
            __weak typeof (self) weakSelf1 = self;
            _datePickerView.confirmBlock = ^(NSString *choseDate, NSString *restDate) {
                
                //            weakSelf.birthDayTf.text = choseDate;//选择的生日
                //
                //            weakSelf.restDateLable.text = restDate;//计算出剩余的天数
                
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"YYYY-MM-dd"];
                NSDate *nowDate = [dateformatter dateFromString:choseDate];
                //转成时间戳
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
                
                NSString *TimeStr = [NSString stringWithFormat:@"生日设置:%@",choseDate];
                NSString *message = @"您的生日只能设置一次";
                
                
                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:message message:TimeStr preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    cell.detailTextLabel.text = choseDate;
                    
                    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
                    [temp post:[NSString stringWithFormat:@"%@/apicore/index/BaseInfoEdit", BASE_URL] delegate:weakSelf1 resultSelector:@selector(uploadNicknameRequest:) token:[NSString stringWithFormat:@"uid=%@&birthday=%@",[XXTool getUserID],timeSp]];
                    NSLog(@"nn%@-%@",choseDate,timeSp);
                    
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    cell.detailTextLabel.text = nil;
                }];
                
                UIColor *colorTitle = [UIColor colorWithRed:217.0/255.0 green:49.0/255.0 blue:65.0/255.0 alpha:1.0];
                
                if ([cancelAction valueForKey:@"titleTextColor"]) {
                    [cancelAction setValue:colorTitle forKey:@"titleTextColor"];
                }
                
                if ([doneAction valueForKey:@"titleTextColor"]) {
                    [doneAction setValue:colorTitle forKey:@"titleTextColor"];
                }
                
                [alertVC addAction:cancelAction];
                [alertVC addAction:doneAction];
                
                [weakSelf1.navigationController presentViewController:alertVC animated:true completion:nil];
            };
            
            _datePickerView.cannelBlock = ^(){
                
                // [weakSelf.view endEditing:YES];
                weakSelf.hidden = YES;
            };
            
            //设置textfield的键盘 替换为我们的自定义view
            // self.birthDayTf.inputView = _datePickerView;
            
            [self.view addSubview:_datePickerView];
            
            
        }
            else {
            [XXTool displayAlert:@"提示" message:@"生日只能设置一次"];
        }

//        };
//        [self.tableView reloadData];
//
//        [self.navigationController pushViewController:temp animated:YES];
        
 
        
        
        
       
        
        
        
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
            
            
            
        }
        //[XXTool displayAlert:@"提示" message:result[@"msg"]];
    }
}



#pragma mark -- UIImagePickDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //    返回一个编辑后的图片 UIImagePickerControllerOriginalImage
    UIImage *selectedImage = info[@"UIImagePickerControllerEditedImage"];
    //    UIImage *selectedImage = info[@"UIImagePickerControllerOriginalImage"];
    
    NSData *imageData = UIImageJPEGRepresentation(selectedImage, 0.001);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    // 参数
    //    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    //    parameter[@"token"] = @"param....";
    // 访问路径
    NSString *stringURL = [NSString stringWithFormat:@"%@/apicore/index/fileUpload", BASE_URL];
    
    [manager POST:stringURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *params = [NSString stringWithFormat:@"uid=%@&img=%@", [XXTool getUserID],responseObject[@"data"]];
        NSString *urlString = [NSString stringWithFormat:@"%@/apicore/index/BaseInfoEdit", BASE_URL];
        RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
        [temp post:urlString delegate:self resultSelector:@selector(uploadImageRequest:) token:params];
        NSLog(@"上传成功%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传错误");
    }];
    //
    self.image.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImageRequest:(NSString*)jsonString
{
    if(0 == [jsonString length]){
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        // [XXTool displayAlert:@"提示" message:result[@"msg"]];
    }
}

//



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
