//
//  ViewController.m
//  youli
//
//  Created by jun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#define BIRTHDAY_ALERT  @"BirthdayAlert"

#define REFRESH_HEADER_HEIGHT 52.0f

#import "AppDelegate.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "IndexController.h"
#import "BirthdayController.h"
#import "PersonalController.h"
#import "CategoryCell.h"
#import "BirthdayGiftController.h"
#import "FestivalMethod.h"
#import "LocalNotificationsUtils.h"
#import "Birthday.h"
#import "QuartzCore/CALayer.h"
#import "Category.h"
#import "LoginController.h"
#import "Account.h"
#import "SettingControler.h"

@interface IndexController ()
{
    @private
    bool isPopCategoryView;                         //是否打开分类列表
    BOOL isTopLoading;                              //上拉是否正在加载图片
    BOOL isLoading;                                 //是否正在加载图片

    NSInteger birthdayGiftControllerHeight;         //记录当前birthdayGiftController高度
    NSInteger birthdayCurrentIndex;                 //记录当前birthday图片的序列，每load一次自动加7
    NSMutableArray *items;                          //加载图片使用的临时数组
    NSMutableArray *giftTypeItems;                  //记录分类内容的数组
    
    NSArray *templateForIphone4;                    //mainScrollView显示矩阵数组
    
    UIScrollView *mainScrollView;                   //主图片加载ScrollView
    UIImageView *imgGiftScrollView;                 //mainScrollView底图
    
    UIImageView *tabBarBgView;                      //下方导航条底图
    UIButton *tabBarLeftButton;                     //分类按钮
    UIButton *tabBarBoxButton;                      //最近生日的朋友/节日按钮
    UIButton *tabBarRightButton;                    //好友按钮

    UIView *refreshTopView;                         //上拉动态加载图片等待通知视图
    UIActivityIndicatorView *refreshTopSpinner;     //上拉等待图标
    
    UIView *refreshFooterView;                      //动态加载图片等待通知视图
    UILabel *refreshLabel;                          //等待提示标签
    UIActivityIndicatorView *refreshSpinner;        //等待图标
    NSString *textPull;                             //下拉加载前提示
    NSString *textLoading;                          //下拉加载时提示

    BirthdayGiftController *birthdayGiftController; //按分类展示的礼物ViewController
    PersonalController *personalController;         //好友ViewController
    LoginController *loginController;               //微博登录ViewController
    BirthdayController *birthdayController;         //最近生日的朋友/节日ViewController    
    CategoryTableView *categoryTableView;           //分类组件
    SettingControler *settingControler;             //系统设置
    
    UIScrollView *pageScroll;                       //引导页
    UIImageView *pageImage;                         //引导页包含的图片
    
    id<YouliDelegate> delegate;                     //指向BirthdayGiftController的委托
    
	CGPoint downPoint;                              //上拉
    
    NSInteger currentTemplateIndex;                 //当前使用的显示模板序号
}
@end

@implementation IndexController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //检查是否存在节日日期
    FestivalMethod *festivalMethod=[[FestivalMethod alloc]init];
    [festivalMethod checkFestivalIsExist];
    
    currentTemplateIndex=0;
    
    templateForIphone4=[[NSArray alloc]initWithObjects:
                        [[NSArray alloc] initWithObjects:
                         [NSArray arrayWithObjects:@"4",@"4",@"205",@"100",@"heng",nil],
                         [NSArray arrayWithObjects:@"214",@"4",@"100",@"100",@"small",nil],
                         [NSArray arrayWithObjects:@"4",@"109",@"100",@"100",@"small",nil],
                         [NSArray arrayWithObjects:@"109",@"109",@"205",@"205",@"big",nil],
                         [NSArray arrayWithObjects:@"4",@"213",@"100",@"205",@"shu",nil],
                         [NSArray arrayWithObjects:@"109",@"317",@"100",@"100",@"small",nil],
                         [NSArray arrayWithObjects:@"214",@"317",@"100",@"100",@"small",nil],nil],
                        
                        [[NSArray alloc] initWithObjects:
                         [NSArray arrayWithObjects:@"4",@"4",@"100",@"100",@"small",nil],
                         [NSArray arrayWithObjects:@"109",@"4",@"205",@"100",@"heng",nil],
                         [NSArray arrayWithObjects:@"4",@"109",@"205",@"205",@"small",nil],
                         [NSArray arrayWithObjects:@"216",@"109",@"100",@"100",@"big",nil],
                         [NSArray arrayWithObjects:@"216",@"213",@"100",@"100",@"small",nil],
                         [NSArray arrayWithObjects:@"4",@"317",@"100",@"100",@"small",nil],
                         [NSArray arrayWithObjects:@"109",@"317",@"205",@"100",@"heng",nil],nil],
                        
                        [[NSArray alloc] initWithObjects:
                         [NSArray arrayWithObjects:@"4",@"4",@"100",@"205",@"shu",nil],
                         [NSArray arrayWithObjects:@"109",@"4",@"205",@"205",@"small",nil],
                         [NSArray arrayWithObjects:@"4",@"214",@"205",@"100",@"heng",nil],
                         [NSArray arrayWithObjects:@"214",@"214",@"100",@"100",@"big",nil],
                         [NSArray arrayWithObjects:@"4",@"317",@"100",@"100",@"small",nil],
                         [NSArray arrayWithObjects:@"109",@"317",@"100",@"100",@"small",nil],
                         [NSArray arrayWithObjects:@"214",@"317",@"100",@"100",@"small",nil],nil],

                        nil
                        ];

    //用iphone5尺寸,如果是iphone4会隐藏下面多余的部分
    imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    imgGiftScrollView.image=[UIImage imageNamed:@"bg2_iphone5.png"];
    
    //添加分类页面
    categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, kHEIGHT-20)];
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    Category *category = [[Category alloc] init];
    [category loadData];                        //load分类列表
    giftTypeItems = category.items;
    
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, kHEIGHT-54)];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate=self;
    
    //添加设置图片按钮
    UIImageView *imgSetting=[[UIImageView alloc] initWithFrame:CGRectMake(0, kHEIGHT-54, 213, 34)];
    imgSetting.userInteractionEnabled=YES;
    imgSetting.image=[UIImage imageNamed:@"setting.png"];
    UITapGestureRecognizer *photoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setttingClick:)];
    [imgSetting addGestureRecognizer:photoTap];

    
    CGSize size = mainScrollView.frame.size;
    [mainScrollView setContentSize:CGSizeMake(size.width, kHEIGHT-20)];

    isLoading = YES;
    for(int i=0;i<2;i++)
    {
        [self loadDataSource];
    }
    
    tabBarBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHEIGHT-58, 320, 38)];
    [tabBarBgView setImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    
    tabBarLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarLeftImage = [[UIImage imageNamed:@"tabbar_left.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarLeftButton.frame = CGRectMake(0, kHEIGHT-58, 78, 38);
    
    [tabBarLeftButton setBackgroundImage:tabBarLeftImage forState:UIControlStateNormal];
    [tabBarLeftButton addTarget:self action:@selector(showCategoryViewPressed) forControlEvents:UIControlEventTouchUpInside];
    
    tabBarBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarBoxImage = [[UIImage imageNamed:@"tabbar_box.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarBoxButton.frame = CGRectMake(120, kHEIGHT-66, 78, 45);
    [tabBarBoxButton setBackgroundImage:tabBarBoxImage forState:UIControlStateNormal];
    [tabBarBoxButton addTarget:self action:@selector(birthdayButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    tabBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarRightImage = [[UIImage imageNamed:@"tabbar_right.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarRightButton.frame = CGRectMake(240, kHEIGHT-58, 78, 38);
    [tabBarRightButton setBackgroundImage:tabBarRightImage forState:UIControlStateNormal];
    [tabBarRightButton addTarget:self action:@selector(personalButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //加到父view中的子view是按顺序加载的，需注意加载子view的顺序！
    //添加欢迎页面，首页的所有组件右移320
    [self.view addSubview:categoryTableView];
    [self.view addSubview:imgSetting];
    [self.view addSubview:imgGiftScrollView];
    
    [self addPullToRefreshHeader];                  //添加上拉loading
    
    [self.view addSubview:mainScrollView];
    [self.view addSubview:tabBarBgView];
    [self.view addSubview:tabBarLeftButton];
    [self.view addSubview:tabBarBoxButton];
    [self.view addSubview:tabBarRightButton];    
    
    //为mainScrollView添加手势操作
    UIPanGestureRecognizer *mainViewPan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleMainPan:)];
    [self.view addGestureRecognizer: mainViewPan];
    
    birthdayGiftController=[[BirthdayGiftController alloc]init];
    personalController=[[PersonalController alloc] init];
    birthdayController=[[BirthdayController alloc] init];
    
    delegate=birthdayGiftController;
    
    if(![LocalNotificationsUtils checkIsExistLocalNotificationWithActivityName:@"birthday"])
    {
        Birthday *birthday=[[Birthday alloc]init];
        [birthday setBirthdayNotifications];
    }
    
    //每次启动APP将提醒数目清空
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    notification.applicationIconBadgeNumber=0;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

    [LocalNotificationsUtils removeAllLocalNotification];
        
    //添加下拉loading提示
    [self setupStrings];
    [self addPullToRefreshFooter];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    //判断是否首次启动
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [self addFirstLaunch];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];

    }
}

//首次登录添加引导页
-(void)addFirstLaunch
{
    pageScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, kHEIGHT-20)];
    [pageScroll setContentSize:CGSizeMake(4*320, kHEIGHT-20)];
    
    pageScroll.pagingEnabled = YES;
    pageScroll.delegate = self;
    [pageScroll setShowsHorizontalScrollIndicator:NO];
    [pageScroll setShowsVerticalScrollIndicator:NO];
    pageScroll.alwaysBounceVertical=NO;
    pageScroll.alwaysBounceHorizontal=YES;
    
    pageImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, kHEIGHT-20)];
    pageImage.image=[UIImage imageNamed:@"welcome1.png"];
    [pageScroll addSubview:pageImage];
    
    pageImage=[[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, kHEIGHT-20)];
    pageImage.image=[UIImage imageNamed:@"welcome2.png"];
    [pageScroll addSubview:pageImage];

    pageImage=[[UIImageView alloc]initWithFrame:CGRectMake(640, 0, 320, kHEIGHT-20)];
    pageImage.image=[UIImage imageNamed:@"welcome3.png"];
    [pageScroll addSubview:pageImage];

    [self.view addSubview:pageScroll];
}

- (void)setupStrings
{
    textPull    = @"上拉刷新...";
    textLoading = @"正在加载...";
}

- (void)showCategoryViewPressed
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];    
    if(isPopCategoryView)
    {
        [self hideIndexCategoryView];
    }
    else
    {
        [self showIndexCategoryView];
    }
    
    [UIView commitAnimations];
}

-(void)hideIndexCategoryView
{
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3];
    
    CGPoint point=mainScrollView.center;
    CGPoint pointBgView=tabBarBgView.center;
    CGPoint pointLeftButton=tabBarLeftButton.center;
    CGPoint pointBoxButton=tabBarBoxButton.center;
    CGPoint pointRightButton=tabBarRightButton.center;
    
    mainScrollView.center=CGPointMake(point.x-212,point.y);
    imgGiftScrollView.center=CGPointMake(point.x-212,point.y);
    tabBarBgView.center=CGPointMake(pointBgView.x-212,pointBgView.y);
    tabBarLeftButton.center=CGPointMake(pointLeftButton.x-212,pointLeftButton.y);
    tabBarBoxButton.center=CGPointMake(pointBoxButton.x-212,pointBoxButton.y);
    tabBarRightButton.center=CGPointMake(pointRightButton.x-212,pointRightButton.y);

    isPopCategoryView = false;
    
    [UIView commitAnimations];
}

-(void)showIndexCategoryView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGPoint point=mainScrollView.center;
    CGPoint pointBgView=tabBarBgView.center;
    CGPoint pointLeftButton=tabBarLeftButton.center;
    CGPoint pointBoxButton=tabBarBoxButton.center;
    CGPoint pointRightButton=tabBarRightButton.center;
    
    mainScrollView.center=CGPointMake(point.x+212,point.y);
    imgGiftScrollView.center=CGPointMake(point.x+212,point.y);
    tabBarBgView.center=CGPointMake(pointBgView.x+212,pointBgView.y);
    tabBarLeftButton.center=CGPointMake(pointLeftButton.x+212,pointLeftButton.y);
    tabBarBoxButton.center=CGPointMake(pointBoxButton.x+212,pointBoxButton.y);
    tabBarRightButton.center=CGPointMake(pointRightButton.x+212,pointRightButton.y);
    
    isPopCategoryView = true;
    
    [UIView commitAnimations];
}

- (void)birthdayButtonPressed
{
    [self.navigationController pushViewController:birthdayController animated:NO];
}

- (void)personalButtonPressed
{
    if ([[Account getInstance] isLoggedIn]) {
        [self.navigationController pushViewController:personalController animated:NO];
    }else{
        loginController = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

//上拉加载数据
- (void)loadTopDataSource
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgur.com/gallery.json"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                items = [JSON objectForKey:@"data"];
                
                //先把mainScrollView里面的所有uiView高度 + 418
                [self putAllUIViewDownMove:418];
                
                for (int i=0; i<7; i++) {
                    NSDictionary *item = [items objectAtIndex:i+birthdayCurrentIndex];
                                                                                                
                    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/%@%@",[item objectForKey:@"hash"], [item objectForKey:@"ext"]]];
                                                                                                
                    NSString *x = [[[templateForIphone4 objectAtIndex:currentTemplateIndex] objectAtIndex:i] objectAtIndex:0];
                    NSString *y = [[[templateForIphone4 objectAtIndex:currentTemplateIndex] objectAtIndex:i] objectAtIndex:1];
                    NSString *width = [[[templateForIphone4 objectAtIndex:currentTemplateIndex] objectAtIndex:i] objectAtIndex:2];
                    NSString *height = [[[templateForIphone4 objectAtIndex:currentTemplateIndex] objectAtIndex:i] objectAtIndex:3];

                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([x intValue],[y intValue]+REFRESH_HEADER_HEIGHT,[width intValue],[height intValue])];
                    imageView.layer.shadowColor=[UIColor colorWithRed:0.27 green:0.2 blue:0.05 alpha:.6].CGColor;
                    imageView.layer.shadowOffset = CGSizeMake(2, 2);
                    imageView.layer.borderColor=[UIColor whiteColor].CGColor;
                    imageView.layer.borderWidth=2;
                    imageView.layer.shadowOpacity=1;
                    imageView.layer.shadowRadius=.6;
                                                                                                
                    [imageView setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"3.jpg"]];
                                                                                                
                    [mainScrollView addSubview:imageView];
                                                                                                
                    imageView = nil;
                }
                                                                                            
                birthdayGiftControllerHeight+=418;      //每load一屏自动加418；
                
                if(mainScrollView.contentSize.height<birthdayGiftControllerHeight)
                {
                    //mainScrollView的高度应包括loading块
                    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, birthdayGiftControllerHeight+REFRESH_HEADER_HEIGHT)];
                }
                
                //加载完把mainScrollView恢复原位置
                [UIView beginAnimations:nil context:NULL];
                [refreshTopView removeFromSuperview];
                [UIView setAnimationDuration:0.3];
                [self putAllUIViewUpMove:REFRESH_HEADER_HEIGHT];
                [UIView commitAnimations];
                
                isTopLoading=NO;
                birthdayCurrentIndex+=7;                //每load一屏自动加7；
                
                
                //每加载一次,currentTemplateIndex自加1,目前只有3组模板，当currentTemplateIndex加到第3组时，将currentTemplateIndex设为0
                currentTemplateIndex++;
                if(currentTemplateIndex==3)
                {
                    currentTemplateIndex=0;
                }
                    
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
    }];
    [operation start];
}

//下拉加载数据
- (void)loadDataSource
{
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgur.com/gallery.json"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://yourgift.sinaapp.com/"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        items = [JSON objectForKey:@"data"];
        items = [JSON objectForKey:@"items"];
        
        for (int i=0; i<7; i++) {
            if(items.count>i+birthdayCurrentIndex)
            {
                NSDictionary *item = [items objectAtIndex:i+birthdayCurrentIndex];
                
                //            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/%@%@",[item objectForKey:@"hash"], [item objectForKey:@"ext"]]];
                
                NSString *strTempImageName=[item objectForKey:@"imageUrl"];
                NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://yourgift.sinaapp.com/media/img/gift/%@",
                                                   [strTempImageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                
                NSString *x = [[[templateForIphone4 objectAtIndex:currentTemplateIndex] objectAtIndex:i] objectAtIndex:0];
                NSString *y = [[[templateForIphone4 objectAtIndex:currentTemplateIndex] objectAtIndex:i] objectAtIndex:1];
                NSString *width = [[[templateForIphone4 objectAtIndex:currentTemplateIndex] objectAtIndex:i] objectAtIndex:2];
                NSString *height = [[[templateForIphone4 objectAtIndex:currentTemplateIndex] objectAtIndex:i] objectAtIndex:3];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([x intValue],
                                                                                       [y intValue] + birthdayGiftControllerHeight,
                                                                                       [width intValue],
                                                                                       [height intValue])];
                
                imageView.layer.shadowColor=[UIColor colorWithRed:0.27 green:0.2 blue:0.05 alpha:.6].CGColor;
                imageView.layer.shadowOffset = CGSizeMake(2, 2);
                imageView.layer.borderColor=[UIColor whiteColor].CGColor;
                imageView.layer.borderWidth=2;
                imageView.layer.shadowOpacity=1;
                imageView.layer.shadowRadius=.6;
                
                [imageView setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"3.jpg"]];
                
                [mainScrollView addSubview:imageView];
                
                imageView = nil;
            }
            else
            {
                NSLog(@"Max Count!");
                return ;
            }
        }
        
        birthdayGiftControllerHeight+=418;      //每load一屏自动加418；
        
        if(mainScrollView.contentSize.height<birthdayGiftControllerHeight)
        {
            //mainScrollView的高度应包括loading块
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, birthdayGiftControllerHeight+REFRESH_HEADER_HEIGHT)];
        }

        birthdayCurrentIndex+=7;                //每load一屏自动加7；
        
        [self stopLoading];
        

        //每加载一次,currentTemplateIndex自加1,目前只有3组模板，当currentTemplateIndex加到第3组时，将currentTemplateIndex设为0
        currentTemplateIndex++;
        if(currentTemplateIndex==3)
        {
            currentTemplateIndex=0;
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
         NSLog(@"error: %@", error);
    }];
    [operation start];
}


-(void)putAllUIViewDownMove:(NSInteger)height
{
    for(UIView *subView in mainScrollView.subviews)
    {
        subView.center=CGPointMake(subView.center.x,subView.center.y+height);
    }
}

-(void)putAllUIViewUpMove:(NSInteger)height
{
    for(UIView *subView in mainScrollView.subviews)
    {
        subView.center=CGPointMake(subView.center.x,subView.center.y-height);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void) handleMainPan:(UIPanGestureRecognizer *) gestureRecognizer{
    if([gestureRecognizer state]==UIGestureRecognizerStateBegan||[gestureRecognizer state]==UIGestureRecognizerStateChanged)
    {
        CGPoint cgpoint=[gestureRecognizer translationInView:self.view];
        if(cgpoint.x<0)
        {
            if(isPopCategoryView)
            {
                [self hideIndexCategoryView];
            }
        }
        else
        {
            if(!isPopCategoryView)
            {
                [self showCategoryViewPressed];
            }
        }
    }
}

#pragma mark - Scroll View Loading
- (void)startLoading {
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
//    mainScrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = textLoading;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    mainScrollView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = mainScrollView.contentInset;
    tableContentInset.top = 0.0;
    mainScrollView.contentInset = tableContentInset;
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    refreshLabel.text = textPull;
    
    [refreshFooterView setFrame:CGRectMake(0, mainScrollView.contentSize.height-REFRESH_HEADER_HEIGHT, 320, 0)];
    
    [refreshSpinner stopAnimating];
}

-(void)addPullToRefreshHeader
{
    refreshTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshTopView.backgroundColor=[UIColor clearColor];
    refreshTopSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshTopSpinner.frame = CGRectMake(148, 20, 24, 14);
    [refreshTopView addSubview:refreshTopSpinner];
    
    [refreshTopView setHidden:NO];
//    [self.view addSubview:refreshTopView];
    [mainScrollView addSubview:refreshTopView];
}

-(void)addPullToRefreshFooter
{
    refreshFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 418, 320, REFRESH_HEADER_HEIGHT)];
    refreshFooterView.backgroundColor = [UIColor clearColor];
    
    //    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel=[[UILabel alloc]initWithFrame:CGRectMake(148, 0, 172, REFRESH_HEADER_HEIGHT)];
    refreshLabel.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.35 alpha:1];
    refreshLabel.shadowColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    refreshLabel.shadowOffset=CGSizeMake(0, 1);
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:13.0];
    refreshLabel.text = textLoading;
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(110, 20, 24, 14);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshFooterView addSubview:refreshLabel];
    [refreshFooterView addSubview:refreshSpinner];
    [mainScrollView addSubview:refreshFooterView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return giftTypeItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 41;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategoryCell *cell = [[CategoryCell alloc] initCell:CellIdentifier];
    cell.category =  [giftTypeItems objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    
    //第一次运行BirthdayGiftController传递的GiftTypeTitle
    //    NSUserDefaults *mydefault = [NSUserDefaults standardUserDefaults];
    //    [mydefault setObject:cell.nameLabel.text forKey:@"giftTypeTitle"];
    
    [delegate sendGiftTypeTitle:cell.nameLabel.text];
    
    [self.navigationController pushViewController:birthdayGiftController animated:YES];
    
    cell.labelImage.image = [UIImage imageNamed:@"selected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerselect.png"];
    
    [self hideIndexCategoryView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    cell.labelImage.image = [UIImage imageNamed:@"unselected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerunselect.png"];
}

#pragma mark - Scroll view delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    downPoint =scrollView.contentOffset;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(isTopLoading)
    {
        return;
    }
    
    CGPoint pt =scrollView.contentOffset;

    if(downPoint.y==0)
    {
        if (downPoint.y > pt.y)
        {
            [self putAllUIViewDownMove:REFRESH_HEADER_HEIGHT];
            
            [self addPullToRefreshHeader];
            
            [UIView beginAnimations:nil context:NULL];
            
            [UIView setAnimationDuration:0.3];

            [UIView commitAnimations];

            [refreshTopSpinner startAnimating];
            
            isTopLoading=YES;
            
            [self loadTopDataSource];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView==pageScroll)
    {
        if(scrollView.contentOffset.x==3*320)
        {
            [scrollView setHidden:YES];
        }
    }
    else if(scrollView==mainScrollView)
    {
        CGPoint offset = mainScrollView.contentOffset;
        CGRect bounds = mainScrollView.bounds;
        CGSize size = mainScrollView.contentSize;
        UIEdgeInsets inset = mainScrollView.contentInset;
        CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
        CGFloat maximumOffset = size.height;
        
        if(currentOffset==maximumOffset)
        {
            if(!isLoading)
            {
                isLoading=YES;
                [self startLoading];
                [self loadDataSource];      //当滚到最底时自动更新内容
            }
        }
    }
}

#pragma mark - Setting GestureRecognizer
-(void) setttingClick:(UITapGestureRecognizer*) sender
{
    settingControler=[[SettingControler alloc]init];
    [self.navigationController pushViewController:settingControler animated:YES];
}

@end
