//
//  KevinPreViewController.m
//  KevinPicture
//
//  Created by Kevin Sun on 15/12/16.
//  Copyright © 2015年 Kevin Sun. All rights reserved.
//
//#import "KevinTableViewController.h"

#import "KevinPreViewController.h"
#import "TOCropView.h"
#import "PictureGestureView.h"
#import "XXPublish2ViewController.h"
static UIImage *currentImage;
@interface KevinPreViewController ()

- (IBAction)deleteSelectedImage:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;


@end

@implementation KevinPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor=[UIColor blackColor];
    PictureGestureView *imgview = [[PictureGestureView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height - 110)];

    imgview.contentMode = UIViewContentModeScaleAspectFit;
    imgview.clipsToBounds = YES;
    imgview.userInteractionEnabled = YES;
    [imgview.imageView setImage:currentImage];
    
    [self.view addSubview:imgview];

    
    

   //    _previewImageView.contentMode =  UIViewContentModeCenter;
    // Do any additional setup after loading the view.
}
- (IBAction)deleteClick:(id)sender {
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"要删除这张照片吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [action showInView:self.view];
    
    
}

- (IBAction)deleteSelectedImage:(id)sender {

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==actionSheet.cancelButtonIndex)
    {
        return;
    }
    else
    {
        [XXPublish2ViewController deleteSelectedImageWithImage:currentImage];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
+(void)setPreviewImage:(UIImage *)image{
    currentImage=image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    double delayInseconds=2.0;
//    dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW, delayInseconds *NSEC_PER_SEC);
//    dispatch_after(poptime, dispatch_get_main_queue(), ^{
//        NSLog(@"")
//    });
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
