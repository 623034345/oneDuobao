//
//  YJDropDownListView.h
//  duobaozhen
//
//  Created by Macintosh HD on 2017/3/7.
//  Copyright © 2017年 xiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardModel.h"
@protocol YJDropDownListViewDelegate<NSObject>
-(void)choosPrice:(NSString *)price ccId:(NSString *)ccId endPrice:(NSString *)endPrice;
@end
@interface YJDropDownListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) id<YJDropDownListViewDelegate> delegate;
@property (nonatomic, assign) NSInteger priceNum;
@property (nonatomic, assign) float heightTo;
-(void)creatTable;
-(instancetype)initWithFrame:(CGRect)frame WithArr:(NSMutableArray *)arr;
-(void)setheightTable:(float)heightTable;
@end
