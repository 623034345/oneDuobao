//
//  MyTableViewCell.h
//  XiangCeCeShi
//
//  Created by 董德帅 on 16/7/8.
//  Copyright © 2016年 董德帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageV;
@property (nonatomic,copy)NSString * imageName;
@property (nonatomic,assign)double CellHeight;
@property (nonatomic,assign)double CellWeigh;
@property (nonatomic,assign)double BiLi;
@property (nonatomic,strong)NSMutableArray *arr;
- (void)setImageName:(NSString *)imageName;
@end
