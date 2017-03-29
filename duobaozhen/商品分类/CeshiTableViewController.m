//
//  CeshiTableViewController.m
//  TopSliderBar
//
//  Created by Xiaoyue on 16/3/1.
//  Copyright © 2016年 李运洋. All rights reserved.
//

#import "CeshiTableViewController.h"

@interface CeshiTableViewController ()

@end

@implementation CeshiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    
    
//    [refresh addTarget:self action:@selector(ceshi) forControlEvents:UIControlEventValueChanged];
//    refresh.tintColor = [UIColor redColor];
//    
//    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"this is test!"];
//    
//    refresh.attributedTitle = attriString;
//    
//    [self.tableView addSubview:refresh];
    
}



-(void)ceshi
{
    NSLog(@"开始刷新");
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

    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    CGFloat coffset = fabs(scrollView.contentOffset.y/50);
//    
//    if (coffset == 1) {
//        UIEdgeInsets set = UIEdgeInsetsMake(50, 0, 0, 0);
//        
//        self.tableView.contentInset = set;
//    }
//    
//    
//}
//
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//     //scrollView.contentOffset = CGPointMake(0, -50);
//}
//
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    
//    
//}

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
