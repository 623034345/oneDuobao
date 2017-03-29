//
//  AddressViewController.m
//  aixinsong
//
//  Created by a on 16/5/17.
//  Copyright © 2016年 a. All rights reserved.
//

#import "AddressViewController.h"
#import "AddAddressViewController.h"
#import "AddAddress2ViewController.h"
#import "EditViewController.h"
#import "Edit2ViewController.h"
#import "addressCell.h"
#import "AddressModel.h"
#import "AFNetworking.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "XXRechargeAccountViewController.h"
#import "XXEditRechargeAccountViewController.h"
#import "XXXuniChargeView.h"
@interface AddressViewController ()<UIAlertViewDelegate>{

    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_accountArray;
    
    NSString *_string;
}


@property (nonatomic ,strong)UIView *bottomView;
@property (nonatomic ,strong)UIButton *addButton;

@end

@implementation AddressViewController







-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self createHuoQuData];
  
//    if (_dataArray.count == 0 && _accountArray.count == 0) {
//                    self.bottomView.hidden = NO;
//                    _tableView.hidden = YES;
//                    self.addButton.hidden = YES;
//    }else {
//        self.bottomView.hidden = YES;
//        _tableView.hidden = NO;
//        self.addButton.hidden = NO;
//        
//    }

}



-(void)createHuoQuData{
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    __block NSInteger integer = 0;
    @weakify(self);
    NSDictionary *parameters = @{@"uid":[XXTool getUserID]};
    [[HttpCenter sharedInstance] post:[NSString stringWithFormat:@"%@/apicore/index/getAddr", BASE_URL] parameters:parameters success:^(id successObj) {
        {

            [_dataArray removeAllObjects];
            NSLog(@"rterrt%lu",(unsigned long)_dataArray.count);
            NSLog(@"---------%@",successObj[@"data"]);
            NSArray *arr = successObj[@"data"];
            integer = [[successObj objectForKey:@"retcode"] integerValue];

            if (arr.count == 0) {

//                _tableView.backgroundView = self.bottomView;

              
                for (XXXuniChargeView *view in _tableView.subviews) {
                    [view removeFromSuperview];
                }
                
                return;
            }
            [weak_self createTableView];
            UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
            imageView.backgroundColor = [UIColor whiteColor];
            _tableView.backgroundView = imageView;
            [_dataArray addObject:successObj[@"data"]];

            
            
            
//            if (integer != 2000) {
//                
//  
//                NSLog(@"----%@",[successObj objectForKey:@"msg"] );
//                //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
//                //
//                //            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
//                //                style:UIAlertActionStyleDefault  handler:nil];
//                //
//                //            [alert addAction:action];
//                //
//                //            [self presentViewController:alert animated:YES completion:nil];
//                //            UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//                //            imageView.image = [UIImage imageNamed:@"bbb.png"];
//                _tableView.backgroundView = self.bottomView;
//                
//                
//                
//                
//            }else{
//                
//                if (_tableView == nil) {
//                    [weak_self createTableView];
//                    
//                } else {
//                    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
//                    imageView.backgroundColor = [UIColor whiteColor];
//                    _tableView.backgroundView = imageView;
//                    
//                }
//                
//                
//                
//            }
//            
        
            //[_tableView reloadData];
            
            
        }
    } failure:^(NSString *failureStr) {
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak_self getDataWithindex:integer];

    });

    
//    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getAddr", BASE_URL]  parameters:parameters success:^(NSURLSessionDataTask * task, id  responseObject) {
//        [_dataArray removeAllObjects];
//        NSLog(@"rterrt%lu",(unsigned long)_dataArray.count);
//        NSLog(@"---------%@",responseObject[@"data"]);
//        
//        [self createTableView];
//   
//      
//        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
//        
//        if (integer != 2000) {
//            [_dataArray addObject:responseObject[@"data"]];
//
//         
////            _tableView.hidden = YES;
////            self.addButton.hidden = YES;
//            NSLog(@"----%@",[responseObject objectForKey:@"msg"] );
////            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
////            
////            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
////                style:UIAlertActionStyleDefault  handler:nil];
////            
////            [alert addAction:action];
////            
////            [self presentViewController:alert animated:YES completion:nil];
////            UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
////            imageView.image = [UIImage imageNamed:@"bbb.png"];
//            _tableView.backgroundView = self.bottomView;
//            
//          
//            
//            
//        }else{
//            
//            if (_tableView == nil) {
//                [self createTableView];
//                
//            } else {
//                UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
//                imageView.backgroundColor = [UIColor whiteColor];
//                _tableView.backgroundView = imageView;
//                
//                [_tableView reloadData];
//            }
//             
//            
//    
//        }
//
//        [XXTool getDataWithParameters:@{@"uid":[XXTool getUserID]} url:[NSString stringWithFormat:@"%@/apicore/index/getxAddr", BASE_URL] blockSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//            if ([responseObject[@"retcode"] intValue] == 2000) {
//                [_accountArray removeAllObjects];
//                [_accountArray addObject:responseObject[@"data"][0]];
//                NSLog(@"___%@",responseObject[@"data"][0]);
//                if (integer == 2000) {
//                    XXXuniChargeView *rav =[XXXuniChargeView  flagView];
//                    rav.frame = CGRectMake(0, [_dataArray[0] count] * 134, WIDTH, 121);
////                    [[XXRechargeAccountView alloc] initWithFrame:CGRectMake(0, [_dataArray[0] count] * 134, WIDTH, 121)];
//                    rav.phoneLabel.text = [NSString stringWithFormat:@"手机号码：%@", responseObject[@"data"][0][@"mobile"]];
//                    rav.qqLabel.text = [NSString stringWithFormat:@"QQ号码：%@", responseObject[@"data"][0][@"qq"]];
////                    rav.aliLabel.text = [NSString stringWithFormat:@"支付宝账号：%@", responseObject[@"data"][0][@"alipay"]];
//                    [rav.editButton addTarget:self action:@selector(editButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
//                    [_tableView addSubview:rav];
//                    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
//                    imageView.backgroundColor = [UIColor whiteColor];
//                    _tableView.backgroundView = imageView;
//                    
//                } else {
//                    XXXuniChargeView *rav =[XXXuniChargeView  flagView];
//                    rav.frame = CGRectMake(0, 4, WIDTH, 121);
//                    
//                   // XXRechargeAccountView *rav = [[XXRechargeAccountView alloc] initWithFrame:CGRectMake(0, 4, WIDTH, 121)];
//                    rav.phoneLabel.text = [NSString stringWithFormat:@"手机号码：%@", responseObject[@"data"][0][@"mobile"]];
//                    rav.qqLabel.text = [NSString stringWithFormat:@"QQ号码：%@", responseObject[@"data"][0][@"qq"]];
////                    rav.aliLabel.text = [NSString stringWithFormat:@"支付宝账号：%@", responseObject[@"data"][0][@"alipay"]];
//                    [rav.editButton addTarget:self action:@selector(editButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
//                    [_tableView addSubview:rav];
//                    
//                    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
//                    imageView.backgroundColor = [UIColor whiteColor];
//                    _tableView.backgroundView = imageView;
//                }
//                  //self.bottomView.hidden = YES;
//                
//            } else {
//                if (_dataArray.count == 0)
//                {
//                    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 100, 100)];
//                    imageView.image = [UIImage imageNamed:@"bbb.png"];
//                    _tableView.backgroundView = imageView;
//                }
//
//                
//                [_accountArray removeAllObjects];
//                
//               
//             
//                
//            }
//        } blockFailure:^(NSURLSessionDataTask *task, NSError *error) {
//            [_accountArray removeAllObjects];
//        }];
//        //[_tableView reloadData];
//        
//        
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {

        
//    }];
    
}
-(void)getDataWithindex:(NSInteger)integer
{
    @weakify(self);

    [XXTool getDataWithParameters:@{@"uid":[XXTool getUserID]} url:[NSString stringWithFormat:@"%@/apicore/index/getxAddr", BASE_URL] blockSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"retcode"] intValue] == 2000) {
            [_accountArray removeAllObjects];
            [_accountArray addObject:responseObject[@"data"][0]];
            NSLog(@"___%@",responseObject[@"data"][0]);
            if (integer == 2000) {
                XXXuniChargeView *rav =[XXXuniChargeView  flagView];
                rav.frame = CGRectMake(0, [_dataArray[0] count] * 134, WIDTH, 121);
                //                    [[XXRechargeAccountView alloc] initWithFrame:CGRectMake(0, [_dataArray[0] count] * 134, WIDTH, 121)];
                rav.phoneLabel.text = [NSString stringWithFormat:@"手机号码：%@", responseObject[@"data"][0][@"mobile"]];
                rav.qqLabel.text = [NSString stringWithFormat:@"QQ号码：%@", responseObject[@"data"][0][@"qq"]];
                //                    rav.aliLabel.text = [NSString stringWithFormat:@"支付宝账号：%@", responseObject[@"data"][0][@"alipay"]];
                [rav.editButton addTarget:weak_self action:@selector(editButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
                [_tableView addSubview:rav];
                UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
                imageView.backgroundColor = [UIColor whiteColor];
                _tableView.backgroundView = imageView;

                
            } else {
                XXXuniChargeView *rav =[XXXuniChargeView  flagView];
                rav.frame = CGRectMake(0, 4, WIDTH, 121);
                
                // XXRechargeAccountView *rav = [[XXRechargeAccountView alloc] initWithFrame:CGRectMake(0, 4, WIDTH, 121)];
                rav.phoneLabel.text = [NSString stringWithFormat:@"手机号码：%@", responseObject[@"data"][0][@"mobile"]];
                rav.qqLabel.text = [NSString stringWithFormat:@"QQ号码：%@", responseObject[@"data"][0][@"qq"]];
                //                    rav.aliLabel.text = [NSString stringWithFormat:@"支付宝账号：%@", responseObject[@"data"][0][@"alipay"]];
                [rav.editButton addTarget:weak_self action:@selector(editButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
                [_tableView addSubview:rav];
                
                UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
                imageView.backgroundColor = [UIColor whiteColor];
                _tableView.backgroundView = imageView;
            }

            //self.bottomView.hidden = YES;
            
        } else {
            if (_dataArray.count == 0)
            {
//                UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2 - 120, HEIGHT/2 - 250, 80, 100)];
//                imageView.image = [UIImage imageNamed:@"ppadd.png"];
                _tableView.backgroundView = _bottomView;
            }
            
            
            [_accountArray removeAllObjects];
            
            
            
            
        }
        [_tableView reloadData];

    } blockFailure:^(NSURLSessionDataTask *task, NSError *error) {
        [_accountArray removeAllObjects];
    }];
}
- (void)editButtonOnClick {
    XXEditRechargeAccountViewController *temp = [[XXEditRechargeAccountViewController alloc] initWithType:1];
    temp.phone = _accountArray[0][@"mobile"];
    temp.QQ = _accountArray[0][@"qq"];
//    if (_accountArray[0][@"alipay"] == nil) {
//        _accountArray[0][@"alipay"] = @"";
//        temp.ali = _accountArray[0][@"alipay"];
//    }
  
    
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
//
//    XXEditRechargeAccountViewController *temp = [[XXEditRechargeAccountViewController alloc] initWithType:1];
//    temp.phone = [self.phoneLabel.text substringFromIndex:5];
//    temp.QQ = [self.QQLabel.text substringFromIndex:5];
//    temp.ali = [self.aliLabel.text substringFromIndex:6];
//    temp.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:temp animated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [[NSMutableArray alloc] init];
    _accountArray = [[NSMutableArray alloc] init];
    
    
    self.view.backgroundColor = [UIColor greenColor];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:self.bottomView];
    //self.bottomView.backgroundColor = [UIColor orangeColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2 - 120, HEIGHT/2 - 250, 80, 100)];
    imageView.image = [UIImage imageNamed:@"ppadd.png"];
    [_bottomView addSubview:imageView];

    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2 - 120 + 90, HEIGHT/2 - 230, 200, 40)];
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = @"您尚未添加任何地址哦~";
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2 - 120 + 90, HEIGHT/2 - 230 + 20, 200, 40)];
    lab1.font = [UIFont systemFontOfSize:12];
    lab1.text = @"点击右上角按钮及时添加~";
    lab1.textColor = [UIColor lightGrayColor];
    [self.bottomView addSubview:lab1];
  
    [self.bottomView addSubview:lab];
    
    
    if (self.type == 1) {
        self.navigationItem.title = @"选择收货地址";
    } else {
        self.navigationItem.title = @"管理收货地址";
    }
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAddress)];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self createTableView];

}



- (NSArray *) titles {
    return @[@"添加实物收货地址",
             @"添加充值账号"];
}

- (NSArray *) images {
    return @[@"right_menu_QR@3x",
             @"right_menu_addFri@3x"];
}


- (void)addAddress {
    
    NSLog(@"a111");
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = [self images][i];
        info.title = [self titles][i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:150 item:obj
    action:^(NSInteger index) {
            NSLog(@"index:%ld",(long)index);
        if (index == 0) {
           
            AddAddress2ViewController *addAddressButton = [[AddAddress2ViewController alloc] init];
            addAddressButton.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addAddressButton animated:YES];
            //addAddressButton.hidesBottomBarWhenPushed = NO;
            
        }else if (index == 1){
            
            XXEditRechargeAccountViewController *temp = [[XXEditRechargeAccountViewController alloc] initWithType:0];
            temp.type = 1;
            temp.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:temp animated:YES];
            
        }
    }];
    
    [self.navigationController.view addSubview:[WBPopMenuSingleton shareManager].popMenuView];
}





-(void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 ) style:UITableViewStyleGrouped];
    //_tableView.backgroundColor = [UIColor blueColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.rowHeight = 134;

    //为了让分割线从头开始
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    _tableView.separatorInset = UIEdgeInsetsZero;

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_tableView];
    
    
    //[self createButton];

}

#pragma mark tableView的代理方法

//设置有几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

//设置每组cell的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}

//设置cell上的数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    addressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"addressCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AddressModel *model = [[AddressModel alloc] init];
    
    [model setValuesForKeysWithDictionary:_dataArray[indexPath.section][indexPath.row]];
    
    cell.model = model;
    
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.defaultButton addTarget:self action:@selector(defaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if([_dataArray[indexPath.section][indexPath.row][@"isdefault"] isEqualToString:@"Y"]){
        
        [cell.defaultButton setImage:[UIImage imageNamed:@"duigou.jpg"] forState:UIControlStateNormal];
        
    }else{
        
        
        [cell.defaultButton setImage:[UIImage imageNamed:@"hongkuang.jpg"] forState:UIControlStateNormal];
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否选择此地址？"
                                                   delegate: self
                                          cancelButtonTitle: @"取消"
                                          otherButtonTitles: @"确定",nil];
    alert.tag = indexPath.row;
    [alert show];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 200;
//    
//}
#pragma mark - alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *parameters = @{@"zjid":self.winID, @"dzid":_dataArray[0][alertView.tag][@"addr_id"]};
        [manager POST:[NSString stringWithFormat:@"%@/apicore/index/qrswdz", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id responseObject) {
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            if (integer == 2000) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            [XXTool displayAlert:@"提示" message:error.localizedDescription];
        }];
    }
}

-(void)deleteButtonClick:(UIButton *)button{
    
    UIAlertAction *goTo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                           {
        
        UITableViewCell *cell = (UITableViewCell *)[[button superview] superview];
        
        NSIndexPath *path = [_tableView indexPathForCell:cell];
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *parameters = @{@"addr_id":_dataArray[path.section][path.row][@"addr_id"]};
        
        
        [manager POST:[NSString stringWithFormat:@"%@/apicore/index/delAddr", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            if (integer != 2000) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
                                                                  style:UIAlertActionStyleDefault  handler:nil];
                
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                //[XXTool displayAlert:@"提示" message:@"删除成功"];
                [self createHuoQuData];
            }
            
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            
            
        }];
    }];
 
    
    [self alertControllerQue:goTo prompt:@"提示" msg:@"你确定要删除吗?"];

    

}

-(void)defaultButtonClick:(UIButton *)button{
    
//    UITableViewCell *cell = (UITableViewCell *)[[button superview] superview];
//    
//    NSIndexPath *path = [_tableView indexPathForCell:cell];
//    
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//
//    NSDictionary *parameters = @{@"addr_id":_dataArray[path.section][path.row][@"addr_id"],@"default":_dataArray[path.section][path.row][@"isdefault"],@"uid":[XXTool getUserID]};
//    
//    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/updatedefault", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id responseObject) {
//        
//        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
//       
//        if (integer != 2000) {
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
//                style:UIAlertActionStyleDefault  handler:nil];
//            
//            [alert addAction:action];
//            
//            [self presentViewController:alert animated:YES completion:nil];
//            
//        }else{
//            
//
//            if ([_dataArray[path.section][path.row][@"isdefault"] isEqualToString:@"N"]) {
//                
//                [button setImage:[UIImage imageNamed:@"hongkuang.jpg"] forState:UIControlStateNormal];
//            }else{
//                
//                [button setImage:[UIImage imageNamed:@"duigou.jpg"] forState:UIControlStateNormal];            }
//
//        }
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        
//        
//    }];

}

-(void)editButtonClick:(UIButton *)button{
    
    UITableViewCell *cell = (UITableViewCell *)[[button superview] superview];
    
    NSIndexPath *path = [_tableView indexPathForCell:cell];

    Edit2ViewController *evc = [[Edit2ViewController alloc] init];
    
    AddressModel *model = [[AddressModel alloc] init];
    
    [model setValuesForKeysWithDictionary:_dataArray[path.section][path.row]];
    evc.addModel = model;
    
    evc.str = _dataArray[path.section][path.row][@"addr_id"];
    
    [self.navigationController pushViewController:evc animated:YES];

}

//设置上间隙大小
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

//为了让分割线从头开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
/*
-(void)createButton{
    
    //创建新地址按钮
    self.addButton  = [[UIButton alloc] initWithFrame:CGRectMake(30, HEIGHT - 134, WIDTH - 60, 50)];
    _addButton.tag = 10;
    _addButton.backgroundColor = [UIColor colorWithRed:215/255.0 green:21/255.0 blue:66/255.0 alpha:1.0];
    _addButton.layer.cornerRadius = 10.0;
    [self.addButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];
    
    //创建返回按钮
//    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
//    Button.frame = CGRectMake(0, 0, 20, 20);
//    Button.tag = 11;
//    [Button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
//    [Button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:Button];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
}
 */

////返回按钮的点击事件
//-(void)buttonClick:(UIButton *)button{
//    
//    if (button.tag == 10) {
//        
//        AddAddressViewController *addAddressButton = [[AddAddressViewController alloc] init];
//        [self.navigationController pushViewController:addAddressButton animated:YES];
//        
//    }else{
//        
//        self.navigationController.navigationBarHidden = NO;
//        
//        self.tabBarController.tabBar.hidden = YES;
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//}


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
