//
//  ShaidanRecordViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/18.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "ShaidanRecordViewController.h"
#import "shaidanRecordTableViewCell.h"
#import "MJRefresh.h"
#import "XXWebViewController.h"
#import "ShowDetailsViewController.h"
@interface ShaidanRecordViewController ()<shareDelegate,UIGestureRecognizerDelegate>
{
    NSInteger page;
}
@property(nonatomic,strong) UIView *shareView;
@property(nonatomic,strong) UIView *shareShadowView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dealIDArr;
@property (nonatomic, strong) NSMutableArray *dataIDArr;
@property (nonatomic, strong) NSMutableArray *numArray;
@property (nonatomic ,strong) NSMutableArray *sidMutableArray;


@end

@implementation ShaidanRecordViewController
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"晒单记录";
    self.navigationController.navigationBarHidden = NO;
    page = 1;

    [self.tableView registerNib:[UINib nibWithNibName:@"shaidanRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
      [self createShareView];
      self.shareView.hidden = YES;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //        header.stateLabel.textColor = [UIColor whiteColor];
    //        header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self requestData];
    }];

     [self requestData];
}

- (void)refresh {
    page = 1;
    [self requestData];
}

- (void)requestData {
    RCHttpRequest *temp = [[RCHttpRequest alloc] init];
    [temp post:[NSString stringWithFormat:@"%@/apicore/index/getmyshaidans", BASE_URL] delegate:self resultSelector:@selector(showlistRequest:) token:[NSString stringWithFormat:@"uid=%@&page=%ld", [XXTool getUserID],page]];
}

- (void)showlistRequest:(NSString*)jsonString {
    [self.tableView.mj_header endRefreshing];
    if (jsonString.length == 0) {
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString *str = result[@"retcode"];
        if (str.integerValue == 2000) {
            [self.dataArr addObjectsFromArray:result[@"data"]];
            if (page == 1) {
                [self.dataArr removeAllObjects];
                self.dealIDArr = [NSMutableArray array];
                self.dataIDArr = [NSMutableArray array];
                self.numArray = [NSMutableArray array];
                self.sidMutableArray = [NSMutableArray array];
            }
     
            for (NSDictionary *dic in result[@"data"]) {
                [self.dealIDArr addObject:dic[@"sd_shopid"]];
                [self.dataIDArr addObject:dic[@"sd_id"]];
                [self.numArray addObject:dic[@"gonumber"]];
                [self.sidMutableArray addObject:dic[@"sid"]];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];

        } else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [XXTool displayAlert:@"提示" message:result[@"msg"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)shareClick:(UIButton *)button {

    self.shareView.hidden = NO;
    
    
}
- (void)createShareView {
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.shareView.alpha = 1;
    self.shareView.backgroundColor = [UIColor clearColor];
    [self.tabBarController.view addSubview:self.shareView];
    
    self.shareShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.shareShadowView.alpha = 0.5;
    self.shareShadowView.backgroundColor = [UIColor blackColor];
    [self.shareView addSubview:self.shareShadowView];
    
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleShare)];
    [singletap setNumberOfTapsRequired:1];
    singletap.delegate = self;
    [self.shareShadowView addGestureRecognizer:singletap];
    
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT  - 180, WIDTH , 180)];
    temp.backgroundColor = [UIColor whiteColor];
    //temp.layer.cornerRadius = 5.0;
    [self.shareView addSubview:temp];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2 -80, 20, 160, 20)];
    label.text = @"分享即领一元红包";
//    label.textColor = [UIColor colorWithRed:31/255.0 green:172/255.0 blue:240/255.0 alpha:1.0];
    
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, label.frame.origin.x - 20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 20, 30, label.frame.origin.x - 20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [temp addSubview:line2];
    [temp addSubview:line1];
  
    
    [temp addSubview:label];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(temp.frame.size.width / 6 - 30, 50, 60, 60)];
    [button1 setImage:[UIImage imageNamed:@"fenxiang_weixin"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1OnClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(temp.frame.size.width/6 - 30, 110, 60, 10)];
    label1.text = @"微信好友";
    label1.font = [UIFont systemFontOfSize:13];
    [temp addSubview:label1];
    [temp addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(temp.frame.size.width / 2 - 30, 50, 60, 60)];
    [button2 setImage:[UIImage imageNamed:@"fenxiang_pengyouquan"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2OnClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(temp.frame.size.width/2 - 30, 110, 80, 10)];
    label2.text = @"微信朋友圈";
    label2.font = [UIFont systemFontOfSize:13];
    [temp addSubview:label2];
    [temp addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(temp.frame.size.width *5 / 6 - 30, 50, 60, 60)];
    [button3 setImage:[UIImage imageNamed:@"fenxiang_qq"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3OnClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(temp.frame.size.width * 5/6-30 , 110, 60, 10)];
    label3.text = @"QQ好友";
    label3.font = [UIFont systemFontOfSize:13];
    [temp addSubview:label3];
    
    [temp addSubview:button3];
    
    
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, WIDTH, 1)];
     line3.backgroundColor = [UIColor lightGrayColor];
    [temp addSubview:line3];
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, WIDTH, 20)];
    [cancleBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    cancleBtn.backgroundColor = [UIColor redColor];
    [temp addSubview:cancleBtn];
    
}
- (void)cancleShare {
    self.shareView.hidden = YES;
}
- (void)cancelClick {
    
    self.shareView.hidden = YES;

}

- (void)button1OnClick {
    
    
    
}

- (void)button2OnClick {
    
    
    
}

- (void)button3OnClick {
    
    
    
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    shaidanRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell uploadViewWithDic:self.dataArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 276;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowDetailsViewController"];
    vc.sd_id = self.dataIDArr[indexPath.row];
    vc.num = self.numArray[indexPath.row];
    vc.shopid  =self.sidMutableArray[indexPath.row];
    NSLog(@"bb%@",vc.shopid);
    vc.title = @"晒单详情";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
    
    
    
    
    
}
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
