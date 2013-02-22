//
//  ViewController.m
//  youli
//
//  Created by jun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define BIRTHDAY_ALERT  @"BirthdayAlert"

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

@interface IndexController ()
{
    NSInteger birthdayGiftControllerHeight;         //记录当前birthdayGiftController高度
    NSInteger birthdayCurrentIndex;                 //记录当前birthday图片的序列，每load一次自动加7
}
@end

@implementation IndexController

@synthesize items;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //检查是否存在节日日期
    FestivalMethod *festivalMethod=[[FestivalMethod alloc]init];
    [festivalMethod checkFestivalIsExist];
    
    templateForIphone4 = [[NSArray alloc] initWithObjects:
    [NSArray arrayWithObjects:@"4",@"4",@"207",@"102",@"small",nil],
    [NSArray arrayWithObjects:@"214",@"4",@"102",@"102",@"small",nil],
    [NSArray arrayWithObjects:@"4",@"109",@"102",@"102",@"small",nil],
    [NSArray arrayWithObjects:@"109",@"109",@"207",@"207",@"big",nil],
    [NSArray arrayWithObjects:@"4",@"213",@"102",@"207",@"small",nil],
    [NSArray arrayWithObjects:@"109",@"317",@"102",@"102",@"small",nil],
    [NSArray arrayWithObjects:@"214",@"317",@"102",@"102",@"small",nil],nil];
    
    //类别view，可向右滑动，初始化时处于第一层，相当于被隐藏。
    categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 212, 460)];
    if (iPhone5) {
        categoryView.frame = CGRectMake(0, 0, 212, 548);
    }
    //添加分类页面
    categoryTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 212, 460)];
    if (iPhone5) {
        categoryTableView.frame = CGRectMake(0, 0, 212, 548);
    }
    categoryTableView.backgroundView=[self backgroundView];
    categoryTableView.backgroundColor=[UIColor clearColor];
    categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    categoryTableView.scrollEnabled=false;
    if(categoryTableView)
    {
        categoryTableView.dataSource=self;
        categoryTableView.delegate=self;
        category = [[Category alloc] init];
        [category loadData];                        //load分类列表
        giftTypeItems = category.items;
    }
    
    [categoryView addSubview:categoryTableView];
    
    if(!iPhone5)
    {
        mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 426)];
    }
    else
    {
        mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 512)];
    }

    if (iPhone5) {
        mainScrollView.frame = CGRectMake(0, 0, 320, 508);
    }
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    CGSize size = mainScrollView.frame.size;
//    [mainScrollView setContentSize:CGSizeMake(size.width, size.height * 2)];
    [mainScrollView setContentSize:CGSizeMake(size.width, 424 * 2)];
    
//    if(!iPhone5)
//    {
//        [mainScrollView setContentSize:CGSizeMake(size.width, 424 * 2)];
//    }
//    else
//    {
//        [mainScrollView setContentSize:CGSizeMake(size.width, 512 * 2)];
//    }

    for(int i=0;i<2;i++)
    {
        [self loadDataSource];
    }

    self.birthdayGiftController=[[BirthdayGiftController alloc]init];
    
    tabBarBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 422, 320, 38)];
    if (iPhone5) {
        tabBarBgView.frame = CGRectMake(0, 510, 320, 38);
    }
    [tabBarBgView setImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    
    tabBarLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarLeftImage = [[UIImage imageNamed:@"tabbar_left.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarLeftButton.frame = CGRectMake(0, 422, 78, 38);
    if (iPhone5) {
        tabBarLeftButton.frame = CGRectMake(0, 510, 78, 38);
    }
    [tabBarLeftButton setBackgroundImage:tabBarLeftImage forState:UIControlStateNormal];
    [tabBarLeftButton addTarget:self action:@selector(showCategoryViewPressed) forControlEvents:UIControlEventTouchUpInside];
    
    tabBarBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarBoxImage = [[UIImage imageNamed:@"tabbar_box.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarBoxButton.frame = CGRectMake(120, 414, 78, 45);
    if (iPhone5) {
        tabBarBoxButton.frame = CGRectMake(120, 503, 78, 45);
    }
    [tabBarBoxButton setBackgroundImage:tabBarBoxImage forState:UIControlStateNormal];
    [tabBarBoxButton addTarget:self action:@selector(birthdayButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    tabBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarRightImage = [[UIImage imageNamed:@"tabbar_right.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarRightButton.frame = CGRectMake(240, 422, 78, 38);
    if (iPhone5) {
        tabBarRightButton.frame = CGRectMake(240, 510, 78, 38);
    }
    [tabBarRightButton setBackgroundImage:tabBarRightImage forState:UIControlStateNormal];
    [tabBarRightButton addTarget:self action:@selector(personalButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //加到父view中的子view是按顺序加载的，需注意加载子view的顺序！
    [self.view addSubview:categoryView];
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
    
    self.delegate=[self birthdayGiftController];
    
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
    [self.navigationController pushViewController:personalController animated:NO];
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
            [imageView setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"3.jpg"]];
            [mainScrollView addSubview:imageView];

            imageView = nil; 
        }
        
//        [mainScrollView setContentSize:CGSizeMake(size.width, 420 * 2)];
        
        birthdayGiftControllerHeight+=424;      //每load一屏自动加420；
        
        if(mainScrollView.contentSize.height<birthdayGiftControllerHeight)
        {
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, birthdayGiftControllerHeight)];
        }

        birthdayCurrentIndex+=7;                //每load一屏自动加7；
        
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


#pragma mark - Table view data source

-(UIView *)backgroundView
{
    UIImageView *categoryBgImageTmp=[[UIImageView  alloc] initWithFrame:CGRectMake(0,0,212,548)];
    categoryBgImageTmp.image = [UIImage imageNamed:@"gifttypebg.png"];
    return categoryBgImageTmp;
}

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
        [self loadDataSource];      //当滚到最底时自动更新内容
    }
}

@end
