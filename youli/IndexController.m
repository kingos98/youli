//
//  ViewController.m
//  youli
//
//  Created by jun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "IndexController.h"
#import "BirthdayController.h"
#import "PersonalController.h"
#import "CategoryCell.h"
#import "BirthdayGiftController.h"

#import "FestivalMethod.h"

@interface IndexController ()

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
    
    //添加分类页面
    categoryTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 212, 460)];
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
        
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    CGSize size = mainScrollView.frame.size;
    [mainScrollView setContentSize:CGSizeMake(size.width, size.height * 2)];
    
//    for(int i=0;i<2;i++)
//    {
//        [self loadDataSource];
//    }

    
    self.birthdayGiftController=[[BirthdayGiftController alloc]init];
    
    tabBarBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 422, 320, 38)];
    [tabBarBgView setImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    
    tabBarLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarLeftImage = [[UIImage imageNamed:@"tabbar_left.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarLeftButton.frame = CGRectMake(0, 422, 78, 38);
    [tabBarLeftButton setBackgroundImage:tabBarLeftImage forState:UIControlStateNormal];
    [tabBarLeftButton addTarget:self action:@selector(showCategoryViewPressed) forControlEvents:UIControlEventTouchUpInside];
    
    tabBarBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarBoxImage = [[UIImage imageNamed:@"tabbar_box.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarBoxButton.frame = CGRectMake(120, 414, 78, 45);
    [tabBarBoxButton setBackgroundImage:tabBarBoxImage forState:UIControlStateNormal];
    [tabBarBoxButton addTarget:self action:@selector(birthdayButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    tabBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarRightImage = [[UIImage imageNamed:@"tabbar_right.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    tabBarRightButton.frame = CGRectMake(240, 422, 78, 38);
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
}


- (void)showCategoryViewPressed
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
//    CGPoint point = mainScrollView.center;
    
    if(isPopCategoryView)
    {
        [self hideCategoryView];
    }
    else
    {
        [self showCategoryView];
    }
    
    [UIView commitAnimations];
}

-(void)hideCategoryView
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
    
    
//    FestivalMethod *festivalMethod=[[FestivalMethod alloc]init];
//    [festivalMethod writeFestivalToDB:2013];
    
//    NSDate *date=[NSDate date];
//    NSLog(@"chinese date:%@",[self getChineseCalendarWithDate:date]);
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)loadDataSource{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgur.com/gallery.json"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.items = [JSON objectForKey:@"data"];
        for (int i=0; i<7; i++) {
            NSDictionary *item = [self.items objectAtIndex:i];                                                
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/%@%@",[item objectForKey:@"hash"], [item objectForKey:@"ext"]]];
            NSString *x = [[templateForIphone4 objectAtIndex:i] objectAtIndex:0];
            NSString *y = [[templateForIphone4 objectAtIndex:i] objectAtIndex:1];
            NSString *width = [[templateForIphone4 objectAtIndex:i] objectAtIndex:2];
            NSString *height = [[templateForIphone4 objectAtIndex:i] objectAtIndex:3];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([x intValue],
                                                                                   [y intValue],
                                                                                   [width intValue],
                                                                                   [height intValue])];                                                 
            [imageView setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"3.jpg"]];
            [mainScrollView addSubview:imageView];

            imageView = nil; 
        }
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
                [self hideCategoryView];
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
    UIImageView *categoryBgImageTmp=[[UIImageView  alloc] initWithFrame:CGRectMake(0,0,212,460)];
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
    
    [self hideCategoryView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    cell.labelImage.image = [UIImage imageNamed:@"unselected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerunselect.png"];
}

-(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    
    [localeCalendar release];
    
    return chineseCal_str;  
}
@end
