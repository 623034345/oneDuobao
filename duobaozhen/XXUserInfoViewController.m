//
//  XXUserInfoViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/6.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXUserInfoViewController.h"
#import "XXWebViewController.h"
#import "XXUserInfoTableViewCell.h"
#import "AFNetworking.h"
#import "ASBirthSelectSheet.h"
#import "XXMyMoneyViewController.h"

#define ALERTVIEWTAG 1000

@interface XXUserInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@end

@implementation XXUserInfoViewController {
    NSMutableArray *_detailArray;
    NSString *_nickName;
    NSString *_birthday;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = @"个人中心";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self createTabelView];
}

- (void)createTabelView {
    self.dataSource = [NSMutableArray arrayWithArray:@[@[@"头像", @"昵称", @"性别", @"生日"], @[@"修改密码", @"我的夺宝币", @"等级"]]];
    if (_detailArray == nil) {
        NSMutableArray *_detailArray1 = [NSMutableArray arrayWithArray:@[@"", self.dic[@"username"], self.dic[@"sex"], self.dic[@"birthday"]]];
        _detailArray = [NSMutableArray arrayWithArray:@[_detailArray1, @[@"", self.dic[@"money"], self.dic[@"level"]]]];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.accessoryType = 1;
    
    cell.detailTextLabel.text = _detailArray[indexPath.section][indexPath.row];

    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        // 允许编辑
        imagePicker.allowsEditing = YES;
        [imagePicker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
//        _nicknameView.alpha = 1.0;
//        [_textField becomeFirstResponder];
        UIAlertView *nickView = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"请输入新昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        nickView.tag = ALERTVIEWTAG;
        nickView.alertViewStyle = UIAlertViewStylePlainTextInput;
        nickView.delegate = self;
        [nickView show];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        UIAlertView *sex = [[UIAlertView alloc] initWithTitle:@"修改性别" message:@"请选择性别" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男", @"女",nil];
        sex.tag = ALERTVIEWTAG + 1;
        sex.delegate = self;
        [sex show];
    } else if (indexPath.section == 0 && indexPath.row == 3) {
        ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT                                                                 )];
        datesheet.selectDate = @"2015-12-08";
        datesheet.GetSelectDate = ^(NSString *dateStr) {
            RCHttpRequest *temp = [[RCHttpRequest alloc] init];
            [temp post:[NSString stringWithFormat:@"%@/apicore/index/baseinfoedit", BASE_URL] delegate:self resultSelector:@selector(uploadBirthdayRequest:) token:[NSString stringWithFormat:@"uid=%@&birthday=%@", [XXTool getUserID],dateStr]];
            _birthday = dateStr;
        };
        [self.navigationController.view addSubview:datesheet];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        XXWebViewController *temp = [[XXWebViewController alloc] init];
        temp.url = [NSString stringWithFormat:@"%@/mobile/user/password", BASE_URL];
        temp.title1 = @"修改密码";
        temp.type = 2;
        temp.homeNum = 1;
        [self.navigationController pushViewController:temp animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        XXMyMoneyViewController *temp = [[XXMyMoneyViewController alloc] init];
        temp.money = self.dic[@"money"];
        [self.navigationController pushViewController:temp animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        XXWebViewController *temp = [[XXWebViewController alloc] init];
        temp.url = [NSString stringWithFormat:@"%@/mobile/home/userlevel/uid/%@", BASE_URL, [XXTool getUserID]];
        temp.homeNum = 1;
        temp.type = 4;
        temp.title1 = @"我的等级";
        [self.navigationController pushViewController:temp animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == ALERTVIEWTAG) {
        if (buttonIndex == 1) {
            RCHttpRequest *temp = [[RCHttpRequest alloc] init];
            [temp post:[NSString stringWithFormat:@"%@/apicore/index/baseinfoedit", BASE_URL] delegate:self resultSelector:@selector(uploadNicknameRequest:) token:[NSString stringWithFormat:@"uid=%@&username=%@", [XXTool getUserID],[[alertView textFieldAtIndex:0] text]]];
            _nickName = [[alertView textFieldAtIndex:0] text];
        }
    } else {
        if (buttonIndex == 1) {
            RCHttpRequest *temp = [[RCHttpRequest alloc] init];
            [temp post:[NSString stringWithFormat:@"%@/apicore/index/baseinfoedit", BASE_URL] delegate:self resultSelector:@selector(uploadManRequest:) token:[NSString stringWithFormat:@"uid=%@&sex=男", [XXTool getUserID]]];
        } else if (buttonIndex == 2) {
            RCHttpRequest *temp = [[RCHttpRequest alloc] init];
            [temp post:[NSString stringWithFormat:@"%@/apicore/index/baseinfoedit", BASE_URL] delegate:self resultSelector:@selector(uploadWomanRequest:) token:[NSString stringWithFormat:@"uid=%@&sex=女", [XXTool getUserID]]];
        }
    }
    
}

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
        NSString *urlString = [NSString stringWithFormat:@"%@/apicore/index/baseinfoedit", BASE_URL];
        RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
        [temp post:urlString delegate:self resultSelector:@selector(uploadImageRequest:) token:params];
        NSLog(@"上传成功%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传错误");
    }];
    
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

#pragma mark - textFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField.text.length == 0) {
//        return NO;
//    }
//    [textField resignFirstResponder];
//    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
//    [temp post:[NSString stringWithFormat:@"%@/apicore/index/baseinfoedit", BASE_URL] delegate:self resultSelector:@selector(uploadNicknameRequest:) token:[NSString stringWithFormat:@"uid=%@&username=%@", [XXTool getUserID],textField.text]];
//    return YES;
//}

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
            [_detailArray[0] replaceObjectAtIndex:1 withObject:_nickName];
            [self.tableView reloadData];
        }
        //[XXTool displayAlert:@"提示" message:result[@"msg"]];
    }
}

- (void)uploadManRequest:(NSString*)jsonString
{
    if(0 == [jsonString length]){
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            [_detailArray[0] replaceObjectAtIndex:2 withObject:@"男"];
            [self.tableView reloadData];
        }
       // [XXTool displayAlert:@"提示" message:result[@"msg"]];
    }
}

- (void)uploadWomanRequest:(NSString*)jsonString
{
    if(0 == [jsonString length]){
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            [_detailArray[0] replaceObjectAtIndex:2 withObject:@"女"];
            [self.tableView reloadData];
        }
       // [XXTool displayAlert:@"提示" message:result[@"msg"]];
    }
}

- (void)uploadBirthdayRequest:(NSString*)jsonString
{
    if(0 == [jsonString length]){
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            [_detailArray[0] replaceObjectAtIndex:3 withObject:_birthday];
            [self.tableView reloadData];
        }
       // [XXTool displayAlert:@"提示" message:result[@"msg"]];
    }
}

@end
