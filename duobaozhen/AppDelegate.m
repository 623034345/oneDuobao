//
//  AppDelegate.m
//  duobaozhen
//
//  Created by 肖旋 on 16/5/24.
//  Copyright (c) 2016年 xiaoxuan. All rights reserved.
//

#import "AppDelegate.h"
#import "XXLoginViewController.h"
#import "XXHomeViewController.h"
#import "XXWebViewController.h"
#import "XXShowListViewController.h"
#import "XXFindViewController.h"
#import "XXTool.h"
//#import "Pingpp.h"
#import "WXApi.h"
#import "XXShoppingCartViewController.h"
#import "SettingViewController.h"
#import "XXZuixinTableViewController.h"
#import "XXZuixin2TableViewController.h"
#import "XXAllProductViewController.h"
#import "WelcomeViewController.h"
#import "XXProductCatViewController.h"
#import "AdvertiseView.h"
#import "SPayClient.h"
#import "XXNewUserCenterViewController.h"
#import "SPayClientPayStateModel.h"
#import "SPayClientPaySuccessDetailModel.h"
#import "TopMenuSelectViewController.h"
#import "YYTopBarViewController.h"
#import "LZXViewController.h"
#import "BaseNavigationController.h"
#import "BaseTabBarController.h"
#import "YJHomeViewController.h"
#define UMenAPPKEY @"58abab36ae1bf811f0000ee7"
@interface AppDelegate ()<UITabBarControllerDelegate, WXApiDelegate>

@end

@implementation AppDelegate {
    BaseTabBarController *_tbc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    UMConfigInstance.appKey = UMenAPPKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setEncryptEnabled:YES];
    [MobClick setAppVersion:version];
    
    
  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    
    /**
     *  威富通集成
     */
    
    
//    SPayClientWechatConfigModel *wechatConfigModel = [[SPayClientWechatConfigModel alloc] init];
//    wechatConfigModel.appScheme = @"wxd3a1cdf74d0c41b3";
//    wechatConfigModel.wechatAppid = @"wxd3a1cdf74d0c41b3";
//    //配置微信APP支付
//    [[SPayClient sharedInstance] wechatpPayConfig:wechatConfigModel];
//
//    [WXApi registerApp:@"wx4db2f1c16c0860b1" withDescription:@"yiyuanduobao"];

    


    //-----
    
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; 
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    //[NSThread sleepForTimeInterval:1.0];
  //  [self createViewControllers];


    [self.window makeKeyAndVisible];

    [self createViewControllers];
    
//    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
//    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
//    
//    BOOL isExist = [self isFileExistWithFilePath:filePath];
//    if (isExist) {// 图片存在
//        
//        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
//        advertiseView.filePath = filePath;
//        [advertiseView show];
//        
//    }
//    
//    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
//    [self getAdvertisingImage];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    return YES;
}


//-------

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    
    // TODO 请求广告接口
    
    // 这里原本采用美团的广告接口，现在了一些固定的图片url代替
    NSArray *imageArray = @[@"http://img.52z.com/upload/201603/30/1459302603671906.jpg", @"http://img.25pp.com/uploadfile/soft/images/2015/0424/20150424010629962.jpg", @"http://www.mobile-dad.com/uploads/jietu/145406358060.png",@"http://www.appster.es/imgr?w=410&u=http://a3.mzstatic.com/eu/r30/Purple3/v4/3d/de/59/3dde5960-ef62-9010-65ea-a383c1257c9b/screen1136x1136.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        
    }
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}
//----

- (void)createViewControllers
{
    YJHomeViewController *vc1 = [[YJHomeViewController alloc] init];
//    XXHomeViewController * vc1 = [[XXHomeViewController alloc] init];
    //XXAllProductViewController * vc2 = [[XXAllProductViewController alloc] init];
    YYTopBarViewController * vc2 = [[YYTopBarViewController alloc] init];
  
   //vc2.title = @"分类";


    //XXWebViewController * vc3 = [[XXWebViewController alloc] init];
    XXShowListViewController *vc3 =[[XXShowListViewController alloc]init];

    XXShoppingCartViewController *vc4 = [[XXShoppingCartViewController alloc] init];
   // ShoppingCartViewController *vc4 = [[ShoppingCartViewController alloc]init];
//    NewShoppingCartViewController *vc4 = [[NewShoppingCartViewController alloc]init];
    vc4.title = @"购物车";
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     XXNewUserCenterViewController *vc5 = [storyboard instantiateViewControllerWithIdentifier:@"XXNewUserCenterViewController"];
    
    BaseNavigationController *nc1 = [[BaseNavigationController alloc] initWithRootViewController:vc1];
    BaseNavigationController *nc2 = [[BaseNavigationController alloc] initWithRootViewController:vc2];
    BaseNavigationController *nc3 = [[BaseNavigationController alloc] initWithRootViewController:vc3];
    BaseNavigationController *nc4 = [[BaseNavigationController alloc] initWithRootViewController:vc4];
    BaseNavigationController *nc5 = [[BaseNavigationController alloc] initWithRootViewController:vc5];
    
    _tbc = [[BaseTabBarController alloc] init];
    _tbc.viewControllers = @[nc1, nc2, nc3, nc4, nc5];

    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:215/255.0 green:21/255.0 blue:66/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"TrebuchetMS-Italic" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _tbc.tabBar.hidden = NO;
    _tbc.delegate = self;
    //_tbc.tabBar.tintColor = [UIColor redColor];
    _tbc.tabBar.translucent = NO;
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"homeBar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"homeBar_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:[[UIImage imageNamed:@"classfiyBar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"classfiyBar_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"晒单" image:[[UIImage imageNamed:@"sunListBar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"sunListBar_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车" image:[[UIImage imageNamed:@"scBar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"scBar_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc5.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"personalBar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"personalBar_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        //         WelcomeViewController *temp = [[WelcomeViewController alloc]init];
        //        self.window.rootViewController = temp;
        // 初始化引导页控制器
        LZXViewController *view = [[LZXViewController alloc]init];
        // 设置引导页图片
        view.dataArray = [NSArray arrayWithObjects:@"一元夺宝1.jpg",@"一元夺宝2.jpg",@"一元夺宝3.jpg", nil];
        // 设置跳转界面
        view.controller = _tbc;
        
        self.window.rootViewController = view;
    }else{
        
        NSLog(@"已经不是第一次启动了");
   
       self.window.rootViewController = _tbc;

        
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    XXLoginViewController *temp = [[XXLoginViewController alloc] init];
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
//    [[tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex] presentViewController:nc animated:YES completion:nil];
//    return NO;
    
    
    if(([viewController.tabBarItem.title isEqualToString:@"我的"] && [[XXTool getUserID] isEqualToString:@"0"]) || ([viewController.tabBarItem.title isEqualToString:@"购物车"] && [[XXTool getUserID] isEqualToString:@"0"]))
    {
   
        XXLoginViewController *temp = [[XXLoginViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:temp];
        [[tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex] presentViewController:nc animated:YES completion:nil];
        return NO;
    }
    if ([viewController.tabBarItem.title isEqualToString:@"我的"] ) {
        UINavigationController *temp = (UINavigationController *)_tbc.viewControllers[4];
        [temp popToRootViewControllerAnimated:NO];
    } else if ([viewController.tabBarItem.title isEqualToString:@"购物车"]) {
//        UINavigationController *temp = (UINavigationController *)_tbc.viewControllers[3];
//        temp.tabBarItem.badgeValue = nil;
    }
    return YES;
}

#pragma mark - 使用微信APP支付和支付宝APP支付，必须实现以下三个UIApplicationDelegate代理方法

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return  [[SPayClient sharedInstance] application:application handleOpenURL:url];
//}
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    [[SPayClient sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//    return YES;
//}
//
//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary<NSString *,id> *)options{
//    
//    [[SPayClient sharedInstance] application:app openURL:url options:options];
//    return YES;
//}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
//    [[SPayClient sharedInstance] applicationWillEnterForeground:application];
    
    [[NSNotificationCenter  defaultCenter]
     postNotificationName:@"check"  object:nil  userInfo:nil];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//-------------------------------
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (id)resp;
        if (resp.errCode == 0) {
            NSString *params = [NSString stringWithFormat:@"appid=wx4d2b498e978414cc&secret=e6843306bf51bcded50ab6c3b1f10ce5&code=%@&grant_type=authorization_code", temp.code];
            NSString *urlString = @"https://api.weixin.qq.com/sns/oauth2/access_token";
            RCHttpRequest *temp1 = [[RCHttpRequest alloc] init] ;
            [temp1 post:urlString delegate:self resultSelector:@selector(accessTokenRequest:) token:params];
            NSLog(@"123456789:%@", temp.code);
        } else {
            [XXTool displayAlert:@"提示" message:@"授权失败"];
        }
    } else {
        if (resp.errCode == 0) {
            [XXTool displayAlert:@"提示" message:@"分享成功"];
        } else {
            [XXTool displayAlert:@"提示" message:@"分享失败"];
        }
    }
}

- (void)accessTokenRequest:(NSString*)jsonString
{
    if(0 == [jsonString length]){
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"123123213213123213123123:%@", result);
        NSString *params = [NSString stringWithFormat:@"access_token=%@&openid=%@", result[@"access_token"], result[@"openid"]];
        NSString *urlString = [NSString stringWithFormat:@"%@/apicore/index/get_user_info", BASE_URL];
        RCHttpRequest *temp = [[RCHttpRequest alloc] init] ;
        [temp post:urlString delegate:self resultSelector:@selector(userInfoRequest:) token:params];
    }
}

- (void)userInfoRequest:(NSString*)jsonString
{
    if(0 == [jsonString length]){
        return;
    }
    NSDictionary* result = [XXTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"123123123%@", result[@"data"]);
        [XXTool setUserID:result[@"data"]];
        [XXTool displayAlert:@"提示" message:@"登陆成功"];
    }
}

@end
