//
//  LocatedViewController.m
//  aixinsong
//
//  Created by a on 16/5/20.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LocatedViewController.h"
#import "AFNetworking.h"

@interface LocatedViewController (){

    NSMutableArray *_firstArray;
    UITableView *_firstTableView;
    NSString *_first;
    
    NSMutableArray *_secondArray;
    UITableView *_secondTableView;
    NSString *_second;
    
    NSMutableArray *_thirdArray;
    UITableView *_thirdTableView;
    NSString *_third;

}

@end

@implementation LocatedViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    _firstArray = [[NSMutableArray alloc] init];
    [self createCategoyData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品所在地选择";
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    [self createBackButton];
}

//创建一级城市菜单
-(void)createCategoyData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getCity", BASE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_firstArray addObject:responseObject[@"data"]];
        
        [self createFirstTableView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

//创建一级分类菜单tableView
-(void)createFirstTableView{
    
    _firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH/3, HEIGHT - 64) style:UITableViewStylePlain];
    
    _firstTableView.delegate = self;
    
    _firstTableView.dataSource = self;
    
    _firstTableView.rowHeight = 50;
    
    //为了让分割线从头开始
    if ([_firstTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_firstTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_firstTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_firstTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_firstTableView];
    
}

//创建二级tableview
-(void)createSecondTableView{
    
    _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH/3, 0, WIDTH/3, HEIGHT - 64) style:UITableViewStylePlain];
    
    _secondTableView.delegate = self;
    
    _secondTableView.dataSource = self;
    
    _secondTableView.rowHeight = 50;
    
    //为了让分割线从头开始
    if ([_secondTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_secondTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_secondTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_secondTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_secondTableView];
    
    
}

//创建三级tableview
-(void)createThirdTableView{
    
    _thirdTableView = [[UITableView alloc] initWithFrame:CGRectMake(2 * WIDTH/3, 0, WIDTH/3, HEIGHT - 64) style:UITableViewStylePlain];
    
    _thirdTableView.delegate = self;
    
    _thirdTableView.dataSource = self;
    
    _thirdTableView.rowHeight = 50;
    
    //为了让分割线从头开始
    if ([_thirdTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_thirdTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_thirdTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_thirdTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_thirdTableView];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _firstTableView) {
        
        return [_firstArray[section] count];
    }else if (tableView == _secondTableView){
    
        return [_secondArray[section] count];
    }
  
    return [_thirdArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _firstTableView) {
        
        UITableViewCell *cell = [_firstTableView dequeueReusableCellWithIdentifier:@"FIRST"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FIRST"];
        }
        
        cell.textLabel.text = _firstArray[indexPath.section][indexPath.row][@"region_name"];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
        
    }else if (tableView == _secondTableView){
    
        UITableViewCell *cell = [_secondTableView dequeueReusableCellWithIdentifier:@"SECOND"];
    
        if (cell == nil) {
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SECOND"];
        }
    
        cell.textLabel.text = _secondArray[indexPath.section][indexPath.row][@"region_name"];
    
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
        return cell;
    }
    
    UITableViewCell *cell = [_thirdTableView dequeueReusableCellWithIdentifier:@"THIRD"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"THIRD"];
    }
    
    cell.textLabel.text = _thirdArray[indexPath.section][indexPath.row][@"region_name"];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _firstTableView) {
        _thirdTableView.alpha = 0.0;
        [_thirdArray removeAllObjects];
        NSString *region = [NSString stringWithFormat:@"%@",_firstArray[indexPath.section][indexPath.row][@"region_id"]];
        
        _first = [NSString stringWithFormat:@"%@",_firstArray[indexPath.section][indexPath.row][@"region_name"]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *parameters = @{@"region_id":region};
        
        [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getCity", BASE_URL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            _secondArray = [[NSMutableArray alloc] init];
            
            [_secondArray addObject:responseObject[@"data"]];
            
            if (_secondTableView == nil) {
                [self createSecondTableView];
            } else {
                [_secondTableView reloadData];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
        
    }else if(tableView == _secondTableView){
        _thirdTableView.alpha = 1.0;
        _second = _secondArray[indexPath.section][indexPath.row][@"region_name"];
        
        NSString *region = [NSString stringWithFormat:@"%@",_secondArray[indexPath.section][indexPath.row][@"region_id"]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *parameters = @{@"region_id":region};
        
        [manager POST:[NSString stringWithFormat:@"%@/apicore/index/getCity", BASE_URL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            _thirdArray= [[NSMutableArray alloc] init];
            
            [_thirdArray addObject:responseObject[@"data"]];
            
            if (_thirdTableView == nil) {
                [self createThirdTableView];
            } else {
                [_thirdTableView reloadData];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
    }else{
    
        _third= _thirdArray[indexPath.section][indexPath.row][@"region_name"];
        
        NSString *intStr= _thirdArray[indexPath.section][indexPath.row][@"region_id"];
        
        NSString *str = [NSString stringWithFormat:@"%@-%@-%@",_first,_second,_third];
    
        self.block(str,intStr,_first,_second,_third);
        
        [self.navigationController popViewControllerAnimated:YES];

        
    }
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

-(void)createBackButton{
    
    //创建返回按钮
//    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
//    Button.frame = CGRectMake(0, 0, 20, 20);
//    [Button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
//    [Button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:Button];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
}

//返回按钮的点击事件
-(void)buttonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
