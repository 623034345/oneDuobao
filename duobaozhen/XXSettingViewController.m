//
//  XXSettingViewController.m
//  duobaozhen
//
//  Created by 肖旋 on 16/5/25.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "XXSettingViewController.h"
#import "XXLoginViewController.h"
#import "XXWebViewController.h"
#import "PublishViewController.h"
#import "XXFeedbackViewController.h"

@interface XXSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation XXSettingViewController {
    NSArray *_imageArr;
    UIButton *exitButton;
    NSArray *_urlArr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemOnClick)];
//        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}

- (void)rightItemOnClick {
    PublishViewController *temp = [[PublishViewController alloc] init];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationItem.title = @"设置";
    
    [self createButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabelView];
    
    
}

- (void)createButton {    
    exitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT - 40 - 64, WIDTH, 40)];
    exitButton.backgroundColor = [UIColor whiteColor];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
}

- (void)exit:(UIButton *)button {
    [XXTool setUserID:@"0"];
//    self.tabBarController.tabBar.hidden = NO;
    UINavigationController *temp = (UINavigationController *)self.tabBarController.viewControllers[3];
    temp.tabBarItem.badgeValue = nil;
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
//    XXLoginViewController *temp = [[XXLoginViewController alloc] init];
//    [self.navigationController pushViewController:temp animated:YES];
    
}

- (void)createTabelView {
    
    self.dataSource = [NSMutableArray arrayWithArray:@[@"心愿清单", @"帮助中心", @"意见反馈", @"服务协议", @"关于我们", @"夺宝认证体系", @"夺宝创业故事", @"商业推广联系", @"加入我们"]];
    
    _imageArr = @[@"设置_05", @"设置_11", @"设置_17", @"设置_23", @"设置_29", @"设置_35", @"设置_41", @"设置_47", @"设置_53"];
    
    _urlArr = @[[NSString stringWithFormat:@"%@/apicore/Wish/index/uid", BASE_URL], [NSString stringWithFormat:@"%@/help.html", BASE_URL], [NSString stringWithFormat:@"%@/apicore/index/help/cateid/21", BASE_URL], [NSString stringWithFormat:@"%@/apicore/index/help/cateid/21", BASE_URL], [NSString stringWithFormat:@"%@/apicore/index/help/cateid/22", BASE_URL], [NSString stringWithFormat:@"%@/apicore/index/help/cateid/23", BASE_URL], [NSString stringWithFormat:@"%@/apicore/index/help/cateid/24", BASE_URL], [NSString stringWithFormat:@"%@/apicore/index/help/cateid/26", BASE_URL], [NSString stringWithFormat:@"%@/apicore/index/help/cateid/27", BASE_URL]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 40 - 64) style:UITableViewStyleGrouped];
    
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
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXUserCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XXUserCenterTableViewCell" owner:self options:nil][0];
        
    };
    cell.iconLabel.text = self.dataSource[indexPath.row];
    cell.icon.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        XXFeedbackViewController *temp = [[XXFeedbackViewController alloc] init];
        temp.hidesBottomBarWhenPushed = YES;
//        NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
//        [array removeObject:self];
//        [array addObject:temp];
//        [self.navigationController setViewControllers:array animated:YES];
        [self.navigationController pushViewController:temp animated:YES];
    } else if (indexPath.row == 0) {
        XXWebViewController *temp = [[XXWebViewController alloc] initForWishList];
        temp.webViewTitleType = XXWebViewTitleTypeNative;
        temp.homeNum = 1;
        temp.type = 2;
        temp.hidesBottomBarWhenPushed = YES;
        temp.title1 = self.dataSource[indexPath.row];
        temp.url = _urlArr[indexPath.row];
        [self.navigationController pushViewController:temp animated:YES];
    } else {
        XXWebViewController *temp = [[XXWebViewController alloc] init];
        temp.webViewTitleType = XXWebViewTitleTypeNative;
        temp.homeNum = 1;
        temp.type = 4;
        temp.hidesBottomBarWhenPushed = YES;
        temp.title1 = self.dataSource[indexPath.row];
        temp.url = _urlArr[indexPath.row];
        [self.navigationController pushViewController:temp animated:YES];
    }
}

@end