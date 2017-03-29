//
//  RedPaperTaskViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "RedPaperTaskViewController.h"
#import "RedPaperTaskTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
@interface RedPaperTaskViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong) UIView *shareView;
@property(nonatomic,strong) UIView *shareShadowView;

@property (nonatomic ,strong)NSMutableArray *taskMutableArray;
@property (nonatomic ,strong)NSMutableArray *taskLinkArray;
@property (nonatomic ,strong)NSMutableArray *taskIDArray;
@end

@implementation RedPaperTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包任务";
    [self.tableView registerNib:[UINib nibWithNibName:@"RedPaperTaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self createShareView];
    self.shareView.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    [self postTaskData];
}
- (void)postTaskData {
    NSString* urlString2 = [NSString stringWithFormat:@"%@/apicore/index/get_download",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:urlString2 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSArray *dataArray = responseObject[@"data"];
        self.taskMutableArray = [NSMutableArray array];
        self.taskLinkArray = [NSMutableArray array];
        self.taskIDArray = [NSMutableArray array];
        //self.moneyArray = [NSMutableArray array];
        for (NSDictionary *dataDic in dataArray) {
            //
            TaskObject *cateObject = [TaskObject mj_objectWithKeyValues:dataDic];
            [self.taskMutableArray addObject:cateObject];
            [self.taskLinkArray addObject:cateObject.link];
            [self.taskIDArray addObject:cateObject.id];
          //  [self.moneyArray addObject:cateObject.money];
        }
        
        
        [self.tableView reloadData];
        
        // [self.rightTableView2.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
    
    
}

-(void)createShareView{
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
    
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT / 2 - 60, WIDTH - 40, 125)];
    temp.backgroundColor = [UIColor whiteColor];
    //temp.layer.cornerRadius = 5.0;
    [self.shareView addSubview:temp];
    
  
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(temp.frame.size.width - 50, 0, 40, 20)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [temp addSubview:button];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, temp.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [temp addSubview:line];
    
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(temp.frame.size.width/2 - 40, 0, 80, 40)];
    label.text = @"任务详情";
    //    label.textColor = [UIColor colorWithRed:31/255.0 green:172/255.0 blue:240/255.0 alpha:1.0];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;

    [temp addSubview:label];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, temp.frame.size.width - 40, 40)];
    label1.text = @"下载APP并注册成功，体验5分钟即可获得5元红包";
    label1.numberOfLines = 0;
    label1.font = [UIFont systemFontOfSize:13];
    [temp addSubview:label1];
    
    

  
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, temp.frame.size.height - 40, temp.frame.size.width - 40, 30)];
    [cancleBtn addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"立马下载" forState:UIControlStateNormal];
    cancleBtn.backgroundColor = [UIColor redColor];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //    cancleBtn.backgroundColor = [UIColor redColor];
    [temp addSubview:cancleBtn];

    
}
- (void)close {
    
        self.shareView.hidden = YES;
    
    
}
- (void)cancleShare {
    self.shareView.hidden = YES;
}
- (void)downloadClick {
    
    [self openAppaleShop];
    
}


- (void)openAppaleShop
{
    NSString *appleID = @"949346638";
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] == 7.0) {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else {
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.taskMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedPaperTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.taskObject = self.taskMutableArray[indexPath.row];
    //        cell.delegate = self;
    //        cell.btn.tag = indexPath.row;
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 78;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
      self.shareView.hidden = NO;
    
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
