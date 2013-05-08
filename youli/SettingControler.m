//
//  SettingControler.m
//  youli
//
//  Created by sjun on 2/22/13.
//
//

#import "AppDelegate.h"
#import "SettingControler.h"
#import "SettingModel.h"
#import "SettingCell.h"
#import "QuartzCore/CALayer.h"
#import "LoginController.h"
#import "GuideController.h"
#import "AdviceController.h"
#import "Account.h"
#import "AboutController.h"


@interface SettingControler ()
{
    UITableView *settingTableView;
    
    NSMutableArray *settingMenuItem;
    NSArray *settingKey;
}
@end

@implementation SettingControler

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    
    UIImageView *imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    imgGiftScrollView.image=[UIImage imageNamed:@"bg2_iphone5.png"];
    
    UILabel *lblGiftTypeTitle=[[UILabel alloc] initWithFrame:CGRectMake(140, -8, 68, 61)];
    lblGiftTypeTitle.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    lblGiftTypeTitle.font=[UIFont fontWithName:@"System" size:17.0f];
    lblGiftTypeTitle.text=@"设置";
    
    UIButton *btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [btnReturn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];

    
    settingTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, kHEIGHT-64) style:UITableViewStyleGrouped];
    settingTableView.delegate=self;
    settingTableView.dataSource=self;
    
    settingTableView.backgroundColor=[UIColor clearColor];

    SettingModel *setttingModel = [SettingModel alloc];
    [setttingModel loadData];                        //load分类列表
    settingMenuItem = setttingModel.items;
    settingKey=setttingModel.keyItems;
    
    [self.view addSubview:imgGiftScrollView];
    [self.view addSubview:imgTitle];
    [self.view addSubview: lblGiftTypeTitle];
    [self.view addSubview:btnReturn];
    [self.view addSubview:settingTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) btnCleanCacheClick:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:diskCachePath error:nil];
}

- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
#pragma mark Table View Group
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return 43;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回（向系统发送）分区个数,在这里有多少键就会有多少分区。
    return settingKey.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取当前分区所对应的键(key)。在这里键就是分区的标示。
    NSString *key=[settingKey objectAtIndex:section];
    
    //获取键所对应的值（数组）。
    NSMutableArray *nameSec = [NSMutableArray arrayWithCapacity:1];

    for(SettingModel *model in settingMenuItem)
    {
        if(model.menuGroup==key)
        {
            [nameSec addObject:model.menuName];
        }
    }
    
    return  [nameSec count];
}

//设置分组头部样式
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 34)];
    titleLabel.text = sectionTitle;
    titleLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:116.0/255.0 blue:110.0/255.0 alpha:1];
    titleLabel.backgroundColor = [UIColor clearColor];
    [customTitleView addSubview:titleLabel];
    return customTitleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得所在分区的行数
    NSInteger row=[indexPath row];
    //获得分区值
    NSInteger section=[indexPath section];
    //利用分区获得键值
    NSString *key=[settingKey objectAtIndex:section];
    //获取键所对应的值（数组）。
    NSMutableArray *nameSec=[NSMutableArray arrayWithCapacity:1];
    for(SettingModel *model in settingMenuItem)
    {
        if(model.menuGroup==key)
        {
            [nameSec addObject:model];
        }
    }
    
    SettingModel *tmpModel=((SettingModel *)[nameSec objectAtIndex:row]);
    if(tmpModel.menuName!=@"清除缓存")
    {
        NSString *CellIdentifier = @"Cell";
        SettingCell *cell = [[SettingCell alloc] initCell:CellIdentifier];
        
        //判断该用户是否有登录新浪微博

        if((tmpModel.menuName==@"新浪微博") && [[Account getInstance] isLoggedIn])
        {
            tmpModel.menuName=@"退出新浪微博";
        }

        cell.settingModel=tmpModel;
        
        UILongPressGestureRecognizer *longPressGR=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongTap:)];
        longPressGR.minimumPressDuration = 0.1;
        [cell setUserInteractionEnabled:YES];
        [cell addGestureRecognizer:longPressGR];
        [longPressGR setCancelsTouchesInView:NO];
        
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTap:)];
        [cell setUserInteractionEnabled:YES];
        [cell addGestureRecognizer:tapGR];
        [tapGR setCancelsTouchesInView:NO];
        
        [cell setBackgroundColor:[UIColor colorWithRed:(253.0/255.0) green:(253.0/255.0) blue:(251.0/255.0) alpha:1]];

        return  cell;
    }
    else
    {
        //把清除缓存操作放到controller实现
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        
        UIButton *btnCleanCache=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 302, 45)];
//        [btnCleanCache setBackgroundImage:[UIImage imageNamed:@"cleancache_unclick"] forState:UIControlStateNormal];
        [btnCleanCache setImage:[UIImage imageNamed:@"cleancache_unclick"] forState:UIControlStateNormal];
        [btnCleanCache setImage:[UIImage imageNamed:@"cleancache_click"] forState:UIControlStateHighlighted];
        [btnCleanCache addTarget:self action:@selector(btnCleanCacheClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnCleanCache];
        
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key=[settingKey objectAtIndex:section];
    return key;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell=(SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor colorWithRed:(253.0/255.0) green:(253.0/255.0) blue:(251.0/255.0) alpha:1]];
    
    if(cell.lblName.text==@"新浪微博")
    {
        LoginController *loginController = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];

//        cell.lblName.text=@"退出新浪微博";
        return;
    }
    else if (cell.lblName.text==@"退出新浪微博")
    {
        [[Account getInstance] removeAuthData];
        cell.lblName.text=@"新浪微博";
        return;
    }
    
    if(cell.lblName.text==@"新手指引")
    {
        GuideController *guideController=[GuideController alloc];
        [self.navigationController pushViewController:guideController animated:YES];
        return;
    }

    if(cell.lblName.text==@"关于有礼")
    {
        AboutController *aboutController=[AboutController alloc];
        [self.navigationController pushViewController:aboutController animated:YES];
        return;        
    }
    
    if(cell.lblName.text==@"给我评分")
    {
//       [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=477935039"]];
    }
  }

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell=(SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:(253.0/255.0) green:(253.0/255.0) blue:(251.0/255.0) alpha:1]];
    
//在后台执行一个线程
//    [self performSelectorInBackground:(SEL) withObject:(id)]
}


//添加右边索引
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return settingKey;
//}

#pragma mark - 添加自定义点击手势 替换 didSelectRowAtIndexPath

-(void) cellTap:(UITapGestureRecognizer*) sender
{   
    SettingCell *cell=(SettingCell *)[(UIGestureRecognizer *)sender view];
    if(cell.lblName.text!=@"接收通知")
    {
        [cell setBackgroundColor:[UIColor colorWithRed:(233.0/255.0) green:(232.0/255.0) blue:(231.0/255.0) alpha:1]];
    }
}

-(void) cellLongTap:(UILongPressGestureRecognizer*) sender
{
    SettingCell *cell=(SettingCell *)[(UIGestureRecognizer *)sender view];
    if(cell.lblName.text!=@"接收通知")
    {
        [cell setBackgroundColor:[UIColor colorWithRed:(233.0/255.0) green:(232.0/255.0) blue:(231.0/255.0) alpha:1]];
    }
}

@end
