//
//  XXShoppingCartViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/6/29.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXShoppingCartViewController.h"
#import "XXShoppingCartTableViewCell.h"
#import "XXSettlementViewController.h"
#import "MJRefresh.h"
#import "XXHomeViewController.h"
#import "DealsDetailsViewController.h"
#import "Masonry.h"

#define TEXTFIELDTAG 1000

@interface XXShoppingCartViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic ,strong)UIScrollView *bottomView;
@property (nonatomic ,strong)NSMutableArray *IDMutableArray;
@property (nonatomic ,strong)NSMutableArray *gidMutableArray;
@property (nonatomic ,strong)NSMutableArray *dicMutableArray;
@property (nonatomic ,copy)NSString *money;

@end

@implementation XXShoppingCartViewController {
    NSMutableArray *_copyCountArray;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"购物车";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self getData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    self.dataSource = nil;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[XXTool getUserID] isEqualToString:@"1"])
    {
        self.nextButton.hidden = YES;
    }
    self.bottomView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.bottomView.contentSize = CGSizeMake(WIDTH, HEIGHT + 10);
    self.bottomView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    [self.view addSubview:self.bottomView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
//                              WithFrame:CGRectMake(WIDTH/2 - 40, HEIGHT/2 - 250, 80, 100)];
    imageView.image = [UIImage imageNamed:@"NOShopping.png"];
    [_bottomView addSubview:imageView];
    
    UILabel *lab = [[UILabel alloc]init];
//                    WithFrame:CGRectMake(WIDTH/2 - 100, HEIGHT/2 - 250 + 120, 200, 40)];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = UITextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.text = @"你的购物车空着哦~\n来挑几件好货吧";
    lab.textColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    UIButton *btn = [[UIButton alloc] init];
//                     WithFrame:CGRectMake(WIDTH/2 - 100, HEIGHT/2 - 250 + 120 + 45, 200, 30)];
    btn.backgroundColor = [UIColor colorWithRed:217/255.0 green:49/255.0 blue:65/255.0 alpha:1.0];
    [btn setTitle:@"立即抢购" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:btn];
    [self.bottomView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView).offset(SCREEN_HEIGHT * -150);
        make.centerX.equalTo(self.bottomView);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(SCREEN_HEIGHT * 30);
        make.width.equalTo(lab).multipliedBy(0.8);
        make.height.mas_equalTo(SCREEN_HEIGHT * 80);
        make.centerX.equalTo(lab);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lab.mas_top).offset(SCREEN_HEIGHT * -30);
        make.centerX.equalTo(lab);
        make.width.mas_equalTo(SCREEN_WIDTH * 145);
        make.height.mas_equalTo(SCREEN_HEIGHT * 185);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh1)];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    self.bottomView.mj_header = header;
    
    self.countArray = [[NSMutableArray alloc] init];
    _copyCountArray = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    [self.nextButton addTarget:self action:@selector(nextButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //监听键盘的出现和消失
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark ---键盘出现

- (void)keyboardWillShow:(NSNotification *)note {
    
    
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    
}

#pragma mark ---键盘消失

- (void)keyboardWillHide:(NSNotification *)note {
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    
}


-(void)click {
   // XXHomeViewController *temp = [[XXHomeViewController alloc]init];

   // self.tabBarController.selectedIndex = 0;
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
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
           
            
            self.money = result[@"data"][0][@"money"];
            
            
        } else {
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}
- (void)nextButtonOnClick {
//    if ([[XXTool getUserID] isEqualToString:@"1"])
//    {
////        [self showAlertWithPoint:1
////                            text:@"本应用不支持购买"
////                           color:nil];
//        [XXTool displayAlert:@"提示" message:@"本应用不开放购买"];
//        return;
//    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0;  i < self.dataSource.count; i++) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.dataSource[i][@"id"], self.countArray[i]] forKeys:@[@"gid", @"num"]];
        [arr addObject:dic];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *str = [NSString stringWithFormat:@"%d", arc4random()];
    NSString *md5 = [XXTool md5:str];
    NSDictionary *parameters = @{@"uid":[XXTool getUserID], @"datajson":[XXTool dictionaryToJson:arr], @"tag":md5};
    NSLog(@"多多少多多少------------------------%@",parameters);
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/jscartgldb", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            
            
            
            XXSettlementViewController *temp = [[XXSettlementViewController alloc] init];
            int t = 0;
            for (int i = 0; i < self.countArray.count; i++) {
                //t += [self.countArray[i] integerValue];
                if (_dataSource.count == 0) {
                    return;
                }
                if ([self.dataSource[i][@"yunjiage"] isEqualToString:@"10.00"]) {
                    t += [self.countArray[i] integerValue]*10;
                }else {
                    t += [self.countArray[i] integerValue];
                    
                }
                
            }
            temp.amountPayableStr = [NSString stringWithFormat:@"%ld", (long)t];
//            NSLog(@"bb%@",temp.amountPayableStr);
            temp.MD5Str = md5;
            temp.goodsCountStr = [NSString stringWithFormat:@"%ld", self.dataSource.count];
            temp.hidesBottomBarWhenPushed = YES;
            
            temp.jsonArray = self.dicMutableArray;
            [self.navigationController pushViewController:temp animated:YES];
            
            
//            [self  getShengyuShuData:md5];

                   }else{
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [XXTool displayAlert:@"提示" message:error.localizedDescription];
    }];
}



- (void)getShengyuShuData:(NSString *)md5 {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *gidStr = [self.gidMutableArray componentsJoinedByString:@","];

    NSDictionary *parameters = @{@"gidinfo":self.dicMutableArray};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/get_goods_shengyushu", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
         
            
            NSLog(@"%@",parameters);


            
        }else{
           
        
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            
            
            
        }
     
    } failure:^(NSURLSessionDataTask * task, NSError * error) {


        
        
    }];

    
    
    
    
    
    
    
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"uid":[XXTool getUserID]};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/mycart", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            self.dataSource = responseObject[@"data"];
            self.nextButton.alpha = 1.0;
            self.goodsNumberLabel.text = [NSString stringWithFormat:@"共%ld件商品", (long)self.dataSource.count];
            [self createTabelView];
            self.bottomView.hidden = YES;
            self.tableView.hidden = NO;
            self.nextView.hidden = NO;
            self.IDMutableArray = [NSMutableArray array];
            self.gidMutableArray = [NSMutableArray array];
            self.dicMutableArray = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {
                //
                [self.IDMutableArray addObject:dic[@"id"]];
                [self.gidMutableArray addObject:dic[@"gid"]];

                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                [dictionary setValue:dic[@"gid"] forKey:@"gid"];
                [dictionary setValue:dic[@"num"] forKey:@"num"];
                NSData *data=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [self.dicMutableArray addObject:jsonStr];
              
            }
              NSLog(@"bbb%@",self.dicMutableArray);
        }else{
            self.dataSource = nil;
            self.nextButton.alpha = 0;
            self.goodsNumberLabel.text = [NSString stringWithFormat:@"共%ld件商品", (long)self.dataSource.count];
            self.nextView.hidden = YES;
            self.tabBarItem.badgeValue = nil;
            [self createTabelView];
            self.tableView.hidden = YES;
            self.bottomView.hidden = NO;
           // [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
        [self.bottomView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        self.dataSource = nil;
        self.nextButton.alpha = 0;
        [self createTabelView];
       // [XXTool displayAlert:@"提示" message:error.localizedDescription];
    }];
}

-(void)hidenKeyboard
{
    if ([self.firstTextField isFirstResponder]) {
        [self.firstTextField resignFirstResponder];
        [self.tableView reloadData];
        int t = 0;
        for (int i = 0; i < self.countArray.count; i++) {
//            t += [self.countArray[i] integerValue];
            if ([self.dataSource[i][@"yunjiage"] isEqualToString:@"10.00"]) {
                t += [self.countArray[i] integerValue]*10;
            }else {
                t += [self.countArray[i] integerValue];
                
            }
        }
        self.totalLabel.text = [NSString stringWithFormat:@"%ld夺宝币", (long)t];
        [XXTool setUILabel:self.totalLabel Data:@"夺宝币" SetData:@"夺宝币" Color:[UIColor whiteColor] Font:16.0 Underline:NO];
    }
}

- (void)createTabelView {
    [self.countArray removeAllObjects];
    for (int i = 0; i < self.dataSource.count; i++) {
        [self.countArray addObject:self.dataSource[i][@"num"]];
    }
    
    int t = 0;
    for (int i = 0; i < self.countArray.count; i++) {
       // t += [self.countArray[i] integerValue];
        if ([self.dataSource[i][@"yunjiage"] isEqualToString:@"10.00"]) {
            t += [self.countArray[i] integerValue]*10;
        }else {
            t += [self.countArray[i] integerValue];
            
        }
    
    }
    self.totalLabel.text = [NSString stringWithFormat:@"%ld夺宝币", (long)t];
    [XXTool setUILabel:self.totalLabel Data:@"夺宝币" SetData:@"夺宝币" Color:[UIColor whiteColor] Font:16.0 Underline:NO];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] init];
//                          WithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - SCREEN_HEIGHT * 260) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        self.tableView.mj_header = header;
        [self.view addSubview:self.tableView];
      [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.left.right.equalTo(self.view);
          make.bottom.equalTo(self.nextView.mas_top);
      }];
  
        
    } else {

        [self.tableView reloadData];
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)refresh {
    [self getData];
}

- (void)refresh1 {
    
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XXShoppingCartTableViewCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.countStr = self.countArray[indexPath.row];
    cell.countField.delegate = self;
    cell.countField.tag = TEXTFIELDTAG + indexPath.row;
    [cell uploadViewWithDic:self.dataSource[indexPath.row]];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
//    
//
//    [cell.goodsImageView addGestureRecognizer:tap];
    [cell.imgBtn addTarget:self action:@selector(imgClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.imgBtn.tag =  indexPath.row;
    cell.addBlock = ^(NSString *str) {
        if (str.integerValue >= [self.dataSource[indexPath.row][@"shenyurenshu"] integerValue]) {
            return;
        }
        [_countArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld", (long)str.integerValue + 1]];
        int t = 0;
        for (int i = 0; i < _countArray.count; i++) {
            //t += [_countArray[i] integerValue];
            if ([self.dataSource[i][@"yunjiage"] isEqualToString:@"10.00"]) {
                t += [self.countArray[i] integerValue]*10;
            }else {
                t += [self.countArray[i] integerValue];
                
            }
        
        }
        _totalLabel.text = [NSString stringWithFormat:@"%ld夺宝币", (long)t];
        [XXTool setUILabel:_totalLabel Data:@"夺宝币" SetData:@"夺宝币" Color:[UIColor whiteColor] Font:16.0 Underline:NO];
        [_tableView reloadData];
    };
    
    cell.minusBlock = ^(NSString *str) {
        if (str.integerValue <= 1) {
            return;
        }
        [_countArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld", (long)str.integerValue - 1]];
        int t = 0;
        for (int i = 0; i < _countArray.count; i++) {
        //    t += [_countArray[i] integerValue];
            if ([self.dataSource[i][@"yunjiage"] isEqualToString:@"10.00"]) {
                t += [self.countArray[i] integerValue]*10;
            }else {
                t += [self.countArray[i] integerValue];
                
            }
        }
        _totalLabel.text = [NSString stringWithFormat:@"%ld夺宝币", (long)t];
        [XXTool setUILabel:_totalLabel Data:@"夺宝币" SetData:@"夺宝币" Color:[UIColor whiteColor] Font:16.0 Underline:NO];
        [_tableView reloadData];
    };
    
//    __block XXShoppingCartTableViewCell *blockCell = cell;
    cell.allBlock = ^(NSString *str) {
         
//        _copyCountArray = _countArray;
        [_countArray replaceObjectAtIndex:indexPath.row withObject:self.dataSource[indexPath.row][@"shenyurenshu"]];
        int t = 0;
        for (int i = 0; i < _countArray.count; i++) {
        //    t += [_countArray[i] integerValue];
            if ([self.dataSource[i][@"yunjiage"] isEqualToString:@"10.00"]) {
                t += [self.countArray[i] integerValue]*10;
            }else {
                t += [self.countArray[i] integerValue];
                
            }
        }
        _totalLabel.text = [NSString stringWithFormat:@"%ld夺宝币", (long)t];
        [XXTool setUILabel:_totalLabel Data:@"夺宝币" SetData:@"夺宝币" Color:[UIColor whiteColor] Font:16.0 Underline:NO];
        [self.tableView reloadData];
        
    };
    
    cell.allBlock1 = ^(NSString *str) {
//        _countArray = _copyCountArray;
       
      NSLog(@"%@", str);

    [_countArray replaceObjectAtIndex:indexPath.row withObject:str];
    
    
  
        int t = 0;
        for (int i = 0; i < _countArray.count; i++) {
        //    t += [_countArray[i] integerValue];
            if ([self.dataSource[i][@"yunjiage"] isEqualToString:@"10.00"]) {
                t += [self.countArray[i] integerValue]*10;
            }else {
                t += [self.countArray[i] integerValue];
                
            }
        }
        _totalLabel.text = [NSString stringWithFormat:@"%ld夺宝币", (long)t];
        [XXTool setUILabel:_totalLabel Data:@"夺宝币" SetData:@"夺宝币" Color:[UIColor whiteColor] Font:16.0 Underline:NO];
        [self.tableView reloadData];
    };
    
    cell.deleteBlock = ^{
       
        
        if (self.dataSource.count - 1 == 0) {
            self.tabBarItem.badgeValue = nil;
     
        } else {
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataSource.count - 1];
        }
        [self getData];
    };
    
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (void)imgClick:(UIButton *)button {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealsDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DealsDetailsViewController"];
    vc.dealID = self.IDMutableArray[button.tag];
    vc.title = @"商品详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.firstTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.integerValue > [self.dataSource[textField.tag - TEXTFIELDTAG][@"shenyurenshu"] integerValue]) {
        textField.text = self.dataSource[textField.tag - TEXTFIELDTAG][@"shenyurenshu"];
    } else if ([textField.text isEqualToString:@""] || textField.text.integerValue == 0) {
        return;
    }
    [self.countArray replaceObjectAtIndex:textField.tag - TEXTFIELDTAG withObject:textField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) return YES;
        
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
    }
    
    return YES;
}
//设cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSDictionary *parameters = @{@"uid":[XXTool getUserID], @"gid":self.dataSource[indexPath.row][@"id"]};
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/deletecart", BASE_URL] parameters:parameters  success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            // [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
            [self getData];
        }else{
            [XXTool displayAlert:@"提示" message:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [XXTool displayAlert:@"提示" message:error.localizedDescription];
    }];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
