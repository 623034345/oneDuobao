//
//  PublishViewController.m
//  aixinsong
//
//  Created by a on 16/5/14.
//  Copyright © 2016年 a. All rights reserved.
//

#import "PublishViewController.h"
#import "LocatedViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "FinishShaidanViewController.h"
@interface PublishViewController ()

{

    UITextField *_nameField;
    UIButton *_categoryButton;
    UIButton *_shopArea;
    UITextView *_textView;
   
    UILabel *_locatedLabel;
    UILabel *_otherLabel;
    UIImageView *_iconView1;
    UIImageView *_iconView2;
    UIImageView *_iconView3;
    NSInteger _i;
    UIView *_allView;
    
    
    NSString *_urlString;
    NSMutableArray *_urlArray;
    NSString *_cateId;
    NSString *_pid;
    

}

@property (nonatomic ,strong)UITextField *headLineTF;
@property (nonatomic ,strong)UILabel *bottomLabel;
@end

@implementation PublishViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationItem.title = @"我要晒单";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _urlArray = [[NSMutableArray alloc] init];
   
    [self createUI];
    
    [self createButton];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    
    
    
}


- (void)backClick {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲，评价还未完成，您确定要离开?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:confirm];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (void)tapClick {
    
    [self.view endEditing:YES];
}
-(void)createUI{
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    
    [self.view addGestureRecognizer:tap];
//
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _allView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:_allView];
//
    //创建描述
    UIView *descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 250)];
    descriptionView.backgroundColor = [UIColor whiteColor];
    [_allView addSubview:descriptionView];
//
    _otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 40, 24, 40, 50)];
    _otherLabel.textColor = [UIColor redColor];
    _otherLabel.text = @"0/50";
    _otherLabel.font = [UIFont systemFontOfSize:12];
    [descriptionView addSubview:_otherLabel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 120, HEIGHT/10)];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [descriptionView addSubview:_textView];
    
    
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 5, WIDTH - 100, 20)];
    self.bottomLabel.textColor = [UIColor lightGrayColor];

    //self.bottomLabel.enabled = NO;
    self.bottomLabel.text = @"请输入您的评价~";
    self.bottomLabel.font = [UIFont systemFontOfSize:14];
    [descriptionView addSubview:self.bottomLabel];
    
    
    
    
//    UILabel *descreptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 80, 50)];
//    descreptionLabel.text = @"标题:";
//    descreptionLabel.font = [UIFont systemFontOfSize:17];
//    descreptionLabel.textAlignment = NSTextAlignmentCenter;
//    [descriptionView addSubview:descreptionLabel];
    
    
//    self.headLineTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 4, 240, 50)];
//    self.headLineTF.placeholder = @"请输入标题~";
//    [self.headLineTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
//    
//    [descriptionView addSubview:self.headLineTF];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT/10 + 20, WIDTH, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [descriptionView addSubview:line];
    
    UIImageView *goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 6, 60, 60)];
    
     [goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statics/uploads/%@",BASE_URL,self.thumb]] placeholderImage:[UIImage imageNamed:@"222"]];

    [descriptionView addSubview:goodsImageView];
    
 
   
    for (int i = 0; i < 3; i++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(20 + i*(10 + (WIDTH - 60)/3), 40 + 50, (WIDTH - 60)/3, HEIGHT/3 -20 - HEIGHT/9)];
        img.image = [UIImage imageNamed:@"tianjiatupian"];
        img.tag = 10 + i;
        [descriptionView addSubview:img];
        
        if (i ==1 || i ==2) {
            img.hidden = YES;
        }else{
            img.userInteractionEnabled = YES;
        }
        
        UIButton *pictureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (WIDTH - 60)/3, HEIGHT/3 -20 - HEIGHT/9)];
        pictureButton.tag = 30 + i;
        [pictureButton addTarget:self action:@selector(pictureClick:) forControlEvents:UIControlEventTouchUpInside];
        [img addSubview:pictureButton];
    }
    
    //创建确定发布
    UIButton *publishButton  = [[UIButton alloc] initWithFrame:CGRectMake(20, 360, WIDTH - 40, 40)];
    publishButton.tag = 23;
    [publishButton setTitle:@"晒单" forState:UIControlStateNormal];
    publishButton.backgroundColor = BASE_COLOR;
    publishButton.layer.cornerRadius = 4;
    publishButton.layer.masksToBounds = YES;
    [publishButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:publishButton];
//
}

#pragma mark  textView的代理方法
-(void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length == 0) {
        [self.bottomLabel setHidden:NO];
    }else{
        [self.bottomLabel setHidden:YES];
    }
    NSInteger number = [textView.text length];
    if (number > 50) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字数不能大于50" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:50];
        number = 50;
    }
    _otherLabel.text = [NSString stringWithFormat:@"%ld/50", number];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//点击上传图片
-(void)pictureClick:(UIButton *)button{

    if (button.tag == 30) {
        _i = button.tag;
        _iconView1 = (UIImageView *)[self.view viewWithTag:(_i - 20)];
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];//显示出来
        
    }else if(button.tag == 31){
    
        _i = button.tag;
        _iconView1 = (UIImageView *)[self.view viewWithTag:(_i - 20)];
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];//显示出来
    
    }else{
    
        _i = button.tag;
        _iconView1 = (UIImageView *)[self.view viewWithTag:(_i - 20)];
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];//显示出来
    }

}

#pragma mark  imagePicker的代理方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _iconView1.image = info[@"UIImagePickerControllerEditedImage"];
    
    NSData *imageData = UIImageJPEGRepresentation(_iconView1.image, 0.1);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
   
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/fileUpload", BASE_URL] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (_i == 30 ) {
           
            [_urlArray insertObject:responseObject[@"data"] atIndex:0];
            if (_urlArray.count >= 2) {
                [_urlArray removeObjectAtIndex:1];
            }
            
            
        }else if (_i == 31 ){
        
            [_urlArray insertObject:responseObject[@"data"] atIndex:1];
            
            if (_urlArray.count >= 3) {
                
                [_urlArray removeObjectAtIndex:2];
                
            }

        }else if (_i == 32 ){
            
            [_urlArray insertObject:responseObject[@"data"] atIndex:2];
            
            if (_urlArray.count == 4) {
                
                [_urlArray removeObjectAtIndex:3];
            
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传错误");
    }];
    
    
    if ((_i - 19) < 13 &&(_i - 19)>10) {
        
        _iconView2 = (UIImageView *)[self.view viewWithTag:(_i - 19)];
        _iconView2.userInteractionEnabled = YES;
        _iconView2.hidden = NO;

    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)createButton{
}

-(void)buttonClick:(UIButton *)button{
    
    if (button.tag == 10) {

        self.tabBarController.selectedIndex = 0;
        [_allView removeFromSuperview];
        [self createUI];
        self.tabBarController.tabBar.hidden = NO;

    }else if (button.tag == 11){
    
        
    
    }else if (button.tag == 20){
    
        
        
    
    }else if (button.tag == 22){
        
    }else if(button.tag == 23){
    
        if (_urlArray.count == 1) {
            _urlString = [NSString stringWithFormat:@"%@",_urlArray[0]];
        }else if(_urlArray.count == 2){
            _urlString = [NSString stringWithFormat:@"%@,%@",_urlArray[0],_urlArray[1]];
        }else if(_urlArray.count == 3){
            _urlString = [NSString stringWithFormat:@"%@,%@,%@",_urlArray[0],_urlArray[1],_urlArray[2]];
        }
        [self createData];
    }
}

-(void)createData{
    if (_textView.text.length == 0) {
        [XXTool displayAlert:@"提示" message:@"请填写描述"];
        return;
    }
    if (_urlArray.count == 0) {
        [XXTool displayAlert:@"提示" message:@"请添加图片"];
        return;
    }
    self.headLineTF.text = @"";//@"them":self.headLineTF.text,
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];

    NSDictionary *parameters = @{@"uid":[XXTool getUserID],@"title":_textView.text,@"pictures":_urlString,@"sid":self.sid,@"sd_title":self.title1};

    
    [manager POST:[NSString stringWithFormat:@"%@/apicore/index/addshaidan", BASE_URL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (integer != 2000) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            
            [XXTool displayAlert:@"提示" message:@"晒单成功"];
            //[self.navigationController popToRootViewControllerAnimated:YES];
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FinishShaidanViewController *temp = [storyboard instantiateViewControllerWithIdentifier:@"FinishShaidanViewController"];
            temp.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:temp animated:YES];
        
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
     [super viewWillDisappear:animated];
    
    if (![[self.navigationController viewControllers] containsObject:self])
    {
        NSLog(@"用户点击了返回按钮");
        NSLog(@"123");
        
        
  
    }
    
//    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
//        //
//        
//       
//        
//    }
//    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
