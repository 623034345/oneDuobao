//
//  XXPublish2ViewController.m
//  duobaozhen
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "XXPublish2ViewController.h"
#import "CollectionViewCell.h"
#import "KevinPreViewController.h"
#import "AFNetworking.h"
#import "FinishShaidanViewController.h"
static NSMutableArray *currentImages;


@interface XXPublish2ViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placehoder;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *array;
@end

@implementation XXPublish2ViewController
- (IBAction)shaidanClick:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FinishShaidanViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FinishShaidanViewController"];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.array = [NSMutableArray array];
    self.textView.delegate = self;
    self.title = @"晒单";
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CellIdentifier"];
    if(currentImages ==nil)
    {
        currentImages=[[NSMutableArray alloc] init];
    }
   self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark ----UICollectionViewDataSource

//指定setion个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//指定section中的colletionviewCELL的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return currentImages.count==0?1:currentImages.count+1;
}
//配置section中的collectionviewcell的展示
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    //    cell.backgroundColor=[UIColor redColor];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/5-16, self.view.frame.size.width/5-10)];
    NSLog(@"currentImages.count %ld",currentImages.count);
    for(UIView *view in [cell.contentView subviews])
    {
        [view removeFromSuperview];
    }
    if(currentImages.count==0||indexPath.row==currentImages.count)
    {         // NSLog(@"我加载了设置加好图片");
        imageView.image=nil;
        //        [cell.contentView removeFromSuperview:imageView];
        imageView.image=[UIImage imageNamed:@"tianjia"];
    }
    else{
        NSLog(@"我加载了设置背景图片");
        
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        imageView.image=currentImages[indexPath.row];
    }
    
    //    imageView.contentMode=UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:imageView];
    return  cell;
   
    
}
//指定单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width/5-16, self.view.frame.size.width/5-10);
    
}



#pragma mark ----UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{    if (![text isEqualToString:@""])
    
{
    
    self.placehoder.hidden = YES;
    
}
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        self.placehoder.hidden = NO;
        
    }
    
    return YES;
    
}


#pragma mark 点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==currentImages.count)
    {
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从摄像头选取", @"从图片库选择",nil];
        [action showInView:self.view];
    }
    else
    {
        [KevinPreViewController setPreviewImage:currentImages[indexPath.row]];
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PreviewVC"] animated:YES];
    }
    
}


#pragma mark ---imagePicker的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSURL *url = info[UIImagePickerControllerReferenceURL];
    
    NSData* imageData=nil;
    NSString* uploadUrlStr=[NSString stringWithFormat:@"%@/apicore/index/fileUpload",BASE_URL];
    
    //    NSString* uploadUrlStr=@"http://www.jbserver.pw/apicore/index/fileUpload";
    
    UIImage* newImage=[self imageWithImageSimple:image scaledToSize:CGSizeMake(50, 50)];
    
    
    if(currentImages ==nil)
    {
        currentImages=[[NSMutableArray alloc] init];
    }
    [currentImages addObject:newImage];
    [self.collectionView reloadData];
    // [self saveImage:image withName:@""]
    
    //上传到服务器
    
    if ([[url description]hasSuffix:@"PNG"]) {
        
        imageData = UIImagePNGRepresentation(newImage);
        
        AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain" ,nil];
        
        [manager POST:uploadUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSDate* date=[NSDate date];
            
            NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"YYYYMMddHHmmss";
            NSString* dateStr=[formatter stringFromDate:date];
            
            NSString* fileName=[NSString stringWithFormat:@"%@%@",dateStr,@"headerImage.png"];
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
            //
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            //
            [self uploadImageName:responseObject[@"data"]];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
        } ];
        

     
        
    }else{
        imageData  = UIImageJPEGRepresentation(newImage, .5);
        
        AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
        
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain" ,nil];
        
        [manager POST:uploadUrlStr parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSDate* date=[NSDate date];
            
            NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"YYYYMMddHHmmss";
            NSString* dateStr=[formatter stringFromDate:date];
            
            NSString* fileName=[NSString stringWithFormat:@"%@%@",dateStr,@"headerImage.jpg"];
            
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg"];
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self uploadImageName:responseObject[@"data"]];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"error:---%@",error);
            
        }];

    }
 
}


-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

-(void)uploadImageName:(NSString*)imageName{
    NSString* url=[NSString stringWithFormat:@"%@/apicore/index/add_sell_pic", BASE_URL];
    
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain" ,nil];
    
    NSDictionary* params=@{@"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"],@"headimg":imageName};
    
    NSLog(@"%@",params);
    
    [_array  addObject: [NSString stringWithFormat:@"%@/apicore/%@",BASE_URL,params[@"headimg"]]];
    
    NSLog(@"ddsdddd%lu",(unsigned long)_array.count);
    
//    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSLog(@"头像修改结果:%@",responseObject[@"msg"]);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"头像修改结果-----error:%@",error.userInfo);
//    }];
    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        
    }];
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self openLibary];
            break;
        default:
            break;
    }
}
-(void)openCamera{
    //UIImagePickerControllerSourceType *type=UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}
-(void)openLibary{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
}
-(void) saveImage:(UIImage *)image withName:(NSString *)name
{
    NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:name];
    [imageData writeToFile:path atomically:YES];
    
}
+(void)deleteSelectedImage:(NSInteger)index
{
    if(currentImages!=nil)
        [currentImages removeObjectAtIndex:index];
}
+(void)deleteSelectedImageWithImage:(UIImage *)image{
    if(currentImages!=nil)
        [currentImages removeObject:image];
    
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
