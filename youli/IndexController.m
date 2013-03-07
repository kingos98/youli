//
//  ViewController.m
//  youli
//
//  Created by jun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define BIRTHDAY_ALERT  @"BirthdayAlert"

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

#import "DbUtils.h"

@interface IndexController ()
{
    NSInteger birthdayGiftControllerHeight;         //记录当前birthdayGiftController高度
    NSInteger birthdayCurrentIndex;                 //记录当前birthday图片的序列，每load一次自动加7
}
@end

@implementation IndexController

@synthesize giftTypeItems;
@synthesize templateForIphone4;
@synthesize category;
@synthesize birthdayGiftController;
@synthesize delegate;
@synthesize tabBarBgView;
@synthesize tabBarBoxButton;
@synthesize tabBarLeftButton;
@synthesize tabBarRightButton;
@synthesize personalController;
@synthesize birthdayController;

@synthesize textPull, textLoading, refreshFooterView, refreshLabel, refreshSpinner;

static bool isFirstLoad=YES;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //检查是否存在节日日期
    FestivalMethod *festivalMethod=[[FestivalMethod alloc]init];
    [festivalMethod checkFestivalIsExist];
    
    templateForIphone4 = [[NSArray alloc] initWithObjects:
    [NSArray arrayWithObjects:@"4",@"4",@"205",@"100",@"small",nil],
    [NSArray arrayWithObjects:@"214",@"4",@"100",@"100",@"small",nil],
    [NSArray arrayWithObjects:@"4",@"109",@"100",@"100",@"small",nil],
    [NSArray arrayWithObjects:@"109",@"109",@"205",@"205",@"big",nil],
    [NSArray arrayWithObjects:@"4",@"213",@"100",@"205",@"small",nil],
    [NSArray arrayWithObjects:@"109",@"317",@"100",@"100",@"small",nil],
    [NSArray arrayWithObjects:@"214",@"317",@"100",@"100",@"small",nil],nil];

    //用iphone5尺寸,如果是iphone4会隐藏下面多余的部分
    imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, 548)];

    imgGiftScrollView.image=[UIImage imageNamed:@"bg2_iphone5.png"];
    
//    //类别view，可向右滑动，初始化时处于第一层，相当于被隐藏,用iphone5尺寸
//    if(!iPhone5)
//    {
//        categoryView = isFirstLoad?[[UIView alloc] initWithFrame:CGRectMake(320, 0, 212, 460)]:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 212, 460)];
//    }
//    else
//    {
//        categoryView = isFirstLoad?[[UIView alloc] initWithFrame:CGRectMake(320, 0, 212, 548)]:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 212, 548)];
//    }

    //添加分类页面
    if(!iPhone5)
    {
        categoryTableView = isFirstLoad?[[CategoryTableView alloc] initWithFrame:CGRectMake(320, 0, 212, 460)]:[[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, 460)];
    }
    else
    {
        categoryTableView = isFirstLoad?[[CategoryTableView alloc] initWithFrame:CGRectMake(320, 0, 212, 548)]:[[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, 548)];
    }
    
    if(categoryTableView)
    {
        categoryTableView.dataSource=self;
        categoryTableView.delegate=self;
        category = [[Category alloc] init];
        [category loadData];                        //load分类列表
        giftTypeItems = category.items;
    }
    
//    [categoryView addSubview:categoryTableView];
    
    if(!iPhone5)
    {
        mainScrollView = isFirstLoad?
        [[UIScrollView alloc] initWithFrame:CGRectMake(320, 0, 320, 426)]:
        [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 426)];
        
    }
    else
    {
        mainScrollView = isFirstLoad?
        [[UIScrollView alloc] initWithFrame:CGRectMake(320, 0, 320, 512)]:
        [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 512)];
    }

    mainScrollView.showsVerticalScrollIndicator = NO;
    CGSize size = mainScrollView.frame.size;
//    [mainScrollView setContentSize:CGSizeMake(size.width, size.height * 2)];
//    [mainScrollView setContentSize:CGSizeMake(size.width, 418 * 2)];
    if(!iPhone5)
    {
        [mainScrollView setContentSize:CGSizeMake(size.width, 460)];
    }
    else
    {
        [mainScrollView setContentSize:CGSizeMake(size.width, 548)];
    }
    
    isLoading = YES;
    for(int i=0;i<2;i++)
    {
        [self loadDataSource];
    }

    self.birthdayGiftController=[[BirthdayGiftController alloc]init];
    
    tabBarBgView = isFirstLoad?
    [[UIImageView alloc] initWithFrame:CGRectMake(320, 422, 320, 38)]:
    [[UIImageView alloc] initWithFrame:CGRectMake(0, 422, 320, 38)];
    
    if (iPhone5) {
        tabBarBgView.frame =isFirstLoad?CGRectMake(320, 510, 320, 38):CGRectMake(0, 510, 320, 38);
    }
    [tabBarBgView setImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    
    tabBarLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarLeftImage = [[UIImage imageNamed:@"tabbar_left.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarLeftButton.frame =isFirstLoad?CGRectMake(320, 422, 78, 38):CGRectMake(0, 422, 78, 38);
    
    if (iPhone5) {
        tabBarLeftButton.frame =isFirstLoad?CGRectMake(320, 510, 78, 38):CGRectMake(0, 510, 78, 38);
    }
    [tabBarLeftButton setBackgroundImage:tabBarLeftImage forState:UIControlStateNormal];
    [tabBarLeftButton addTarget:self action:@selector(showCategoryViewPressed) forControlEvents:UIControlEventTouchUpInside];
    
    tabBarBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarBoxImage = [[UIImage imageNamed:@"tabbar_box.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarBoxButton.frame = isFirstLoad?CGRectMake(440, 414, 78, 45):CGRectMake(120, 414, 78, 45);
    if (iPhone5) {
        tabBarBoxButton.frame = isFirstLoad?CGRectMake(440, 503, 78, 45):CGRectMake(120, 503, 78, 45);
    }
    [tabBarBoxButton setBackgroundImage:tabBarBoxImage forState:UIControlStateNormal];
    [tabBarBoxButton addTarget:self action:@selector(birthdayButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    tabBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarRightImage = [[UIImage imageNamed:@"tabbar_right.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarRightButton.frame =isFirstLoad? CGRectMake(560, 422, 78, 38):CGRectMake(240, 422, 78, 38);
    if (iPhone5) {
        tabBarRightButton.frame = isFirstLoad? CGRectMake(560, 510, 78, 38): CGRectMake(240, 510, 78, 38);
    }
    [tabBarRightButton setBackgroundImage:tabBarRightImage forState:UIControlStateNormal];
    [tabBarRightButton addTarget:self action:@selector(personalButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //加到父view中的子view是按顺序加载的，需注意加载子view的顺序！
    //添加欢迎页面，首页的所有组件右移320
    [self.view addSubview:categoryTableView];
    [self.view addSubview:imgGiftScrollView];
    [self.view addSubview:mainScrollView];
    [self.view addSubview:tabBarBgView];
    [self.view addSubview:tabBarLeftButton];
    [self.view addSubview:tabBarBoxButton];
    [self.view addSubview:tabBarRightButton];    
    
    //为mainScrollView添加手势操作
    UIPanGestureRecognizer *mainViewPan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleMainPan:)];
    [self.view addGestureRecognizer: mainViewPan];
    
    personalController=[[PersonalController alloc] init];
    birthdayController=[[BirthdayController alloc] init];
    self.loginController = [[LoginController alloc] init];
    
    self.delegate=[self birthdayGiftController];
    
    categoryTableView.delegate=self;

    mainScrollView.delegate=self;
    
    //添加通知
//    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
//    NSDateComponents *comp = [[NSDateComponents alloc] init];
//    [comp setYear:2013];
//    [comp setMonth:2];
//    [comp setDay:18];
//    [comp setHour:15];
//    [comp setMinute:12];
//    [comp setSecond:0];
//    
//    NSDate *pickerDate=[calendar dateFromComponents:comp];

//    NSDate *pickerDate=[[NSDate date] addTimeInterval:5];
//    LocalNotificationsUtils *localNotificationsUtils=[LocalNotificationsUtils alloc];
//    [localNotificationsUtils addLocalNotificationWithFireDate:pickerDate activityId:BIRTHDAY_ALERT activityTitle:@"notice test"];
//    UIApplication *application=[UIApplication sharedApplication];

    if(![LocalNotificationsUtils checkIsExistLocalNotificationWithActivityName:@"birthday"])
    {
        Birthday *birthday=[[Birthday alloc]init];
        [birthday setBirthdayNotifications];
    }
    
    //每次启动APP将提醒数目清空
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    notification.applicationIconBadgeNumber=0;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [notification release];

    
    //添加欢迎页面
    //把欢迎页面从AppDelegate移到IndexController
    if(!iPhone5)
    {
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        splashView.image = [UIImage imageNamed:@"loading480.png"];
    }
    else
    {
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        splashView.image = [UIImage imageNamed:@"loading568.png"];
    }
    [self.view insertSubview:splashView atIndex:0];

    //添加定时器，2秒后把首页移入屏幕
    if(isFirstLoad)
    {
        NSTimer *timer;
        timer = [NSTimer scheduledTimerWithTimeInterval: 2
                                                 target: self
                                               selector: @selector(handleTimer:)
                                               userInfo: nil
                                                repeats: YES];
    }
    
    //添加下拉loading提示
    [self setupStrings];
    [self addPullToRefreshFooter];
}

- (void)setupStrings{
    textPull    = @"上拉刷新...";
    textLoading = @"正在加载...";
}

- (void) handleTimer: (NSTimer *) timer
{
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:1];
    
    CGPoint pointCategoryTableView=categoryTableView.center;
    CGPoint pointCategoryView=categoryView.center;
    CGPoint pointImgGiftScrollView=imgGiftScrollView.center;
    CGPoint point=mainScrollView.center;
    CGPoint pointBgView=tabBarBgView.center;
    CGPoint pointLeftButton=tabBarLeftButton.center;
    CGPoint pointBoxButton=tabBarBoxButton.center;
    CGPoint pointRightButton=tabBarRightButton.center;
    
    categoryTableView.center=CGPointMake(pointCategoryTableView.x-320, pointCategoryTableView.y);
    categoryView.center=CGPointMake(pointCategoryView.x-320, pointCategoryView.y);
    imgGiftScrollView.center=CGPointMake(pointImgGiftScrollView.x-320, pointImgGiftScrollView.y);
    mainScrollView.center=CGPointMake(point.x-320,point.y);
    tabBarBgView.center=CGPointMake(pointBgView.x-320,pointBgView.y);
    tabBarLeftButton.center=CGPointMake(pointLeftButton.x-320,pointLeftButton.y);
    tabBarBoxButton.center=CGPointMake(pointBoxButton.x-320,pointBoxButton.y);
    tabBarRightButton.center=CGPointMake(pointRightButton.x-320,pointRightButton.y);
    
    [timer invalidate];
    
    [UIView commitAnimations];
    
    isLoading=NO;
}

- (void)showCategoryViewPressed
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];    
    if(isPopCategoryView)
    {
        [self indexHideCategoryView];
    }
    else
    {
        [self showCategoryView];
    }
    
    [UIView commitAnimations];
}

-(void)indexHideCategoryView
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

-(void)showCategoryView
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
<<<<<<< HEAD
    [self.navigationController pushViewController:personalController animated:NO];

=======
    [self.navigationController pushViewController:self.loginController animated:NO];
>>>>>>> 更换登陆方式，逐步替换官方sdk
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)loadDataSource
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgur.com/gallery.json"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.items = [JSON objectForKey:@"data"];
        for (int i=0; i<7; i++) {
            NSDictionary *item = [self.items objectAtIndex:i+birthdayCurrentIndex];
            
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/%@%@",[item objectForKey:@"hash"], [item objectForKey:@"ext"]]];
            
            NSString *x = [[templateForIphone4 objectAtIndex:i] objectAtIndex:0];
            NSString *y = [[templateForIphone4 objectAtIndex:i] objectAtIndex:1];
            NSString *width = [[templateForIphone4 objectAtIndex:i] objectAtIndex:2];
            NSString *height = [[templateForIphone4 objectAtIndex:i] objectAtIndex:3];
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
        
        birthdayGiftControllerHeight+=418;      //每load一屏自动加418；
        
        if(mainScrollView.contentSize.height<birthdayGiftControllerHeight)
        {
            //mainScrollView的高度应包括loading块
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, birthdayGiftControllerHeight+REFRESH_HEADER_HEIGHT)];
        }

        birthdayCurrentIndex+=7;                //每load一屏自动加7；
        
        [self stopLoading];
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
         NSLog(@"error: %@", error);
    }];
    [operation start];
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
                [self indexHideCategoryView];
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
    //    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    mainScrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
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
    
    refreshLabel.text = self.textPull;
    
//    NSLog(@"refreshFooterView:height:%f",(mainScrollView.contentSize.height-REFRESH_HEADER_HEIGHT));
    
    [refreshFooterView setFrame:CGRectMake(0, mainScrollView.contentSize.height-REFRESH_HEADER_HEIGHT, 320, 0)];
    
    [refreshSpinner stopAnimating];
}

-(void)addPullToRefreshFooter{
    refreshFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 418, 320, REFRESH_HEADER_HEIGHT)];
    refreshFooterView.backgroundColor = [UIColor clearColor];
    
    //    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel=[[UILabel alloc]initWithFrame:CGRectMake(148, 0, 172, REFRESH_HEADER_HEIGHT)];
    refreshLabel.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.35 alpha:1];
    refreshLabel.shadowColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    refreshLabel.shadowOffset=CGSizeMake(0, 1);
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:13.0];
    //    refreshLabel.textAlignment = UITextAlignmentCenter;
    refreshLabel.text = self.textLoading;
    
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
    
    [self.delegate sendGiftTypeTitle:cell.nameLabel.text];
    
    [self.navigationController pushViewController:[self birthdayGiftController] animated:YES];
    
    cell.labelImage.image = [UIImage imageNamed:@"selected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerselect.png"];
    
    [self indexHideCategoryView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    cell.labelImage.image = [UIImage imageNamed:@"unselected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerunselect.png"];
}

#pragma mark - Scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
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

@end
