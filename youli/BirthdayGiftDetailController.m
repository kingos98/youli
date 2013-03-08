//
//  BirthdayGiftDetail.m
//  youli
//
//  Created by ufida on 12-12-25.
//
//

#import "BirthdayGiftDetailController.h"
#import "BlockAlertView.h"
#import "BlockActionSheet.h"
#import "BlockTextPromptAlertView.h"
#import "AppDelegate.h"
#import "DatabaseOper.h"
#import "FMDatabaseOper.h"
#import "BirthdayGiftDetailItem.h"
#import "BirthdayGiftController.h"
#import "CategoryTableView.h"
#import "CategoryCell.h"
#import "Category.h"
#import "YouliDelegate.h"

@interface BirthdayGiftDetailController ()
{
    @private
    FMDatabaseOper *fmdataOper;                                         //数据库操作类
    BirthdayGiftDetailItem *birthdayGiftDetailItem;                     //单个礼物组件
    CategoryTableView *categoryTableView;                               //分类组件
    NSMutableArray *giftTypeItems;                                      //记录分类内容的数组

    UIScrollView *giftDetailScrollView;                                 //礼物ScrollVie
    
    BirthdayGiftController *birthdayGiftController;                     //按分类展示的礼物ViewController

    id<YouliDelegate> delegate;                                         //指向BirthdayGiftController的委托
}

@end

@implementation BirthdayGiftDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    giftDetailScrollView.delegate=self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showGiftListByGiftType:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initView
{
    fmdataOper=[[FMDatabaseOper alloc]init];
    
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];

    UIImageView *imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 503)];

    imgGiftScrollView.image=[UIImage imageNamed:@"bg.png"];
    
    UILabel *lblGiftTypeTitle=[[UILabel alloc] initWithFrame:CGRectMake(126, -8, 68, 61)];
    lblGiftTypeTitle.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    lblGiftTypeTitle.font=[UIFont fontWithName:@"System" size:17.0f];
    lblGiftTypeTitle.text=@"礼品展示";
    
    UIButton *btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [btnReturn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btnShare=[[UIButton alloc]initWithFrame:CGRectMake(265, 7, 50, 30)];
    [btnShare setBackgroundImage:[UIImage imageNamed:@"share_unclick.png"] forState:UIControlStateNormal];
    [btnShare setBackgroundImage:[UIImage imageNamed:@"share_click.png"] forState:UIControlStateHighlighted];
    [btnShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];


    giftDetailScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, 370)];
//    giftDetailScrollView.pagingEnabled=true;
    [giftDetailScrollView setShowsHorizontalScrollIndicator:false];

    
    if(!iPhone5)
    {
        categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, 460)];
    }
    else
    {
        categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, 548)];
    }
    
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    Category *category = [[Category alloc] init];
    [category loadData];                        //load分类列表
    giftTypeItems = category.items;

    [self.view addSubview:categoryTableView];
    [mainView addSubview:imgTitle];
    [mainView addSubview:imgGiftScrollView];
    [mainView addSubview:lblGiftTypeTitle];
    [mainView addSubview:btnReturn];
    [mainView addSubview:btnShare];
    [mainView addSubview:giftDetailScrollView];
}

- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)shareClick
{
    [self showActionSheet];
}

- (void)showActionSheet
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"分享给朋友"];
    [sheet addButtonWithTitle:@"新浪微博" block:nil];
    [sheet addButtonWithTitle:@"腾讯微博" block:nil];
    [sheet addButtonWithTitle:@"人人网" block:nil];
    [sheet setCancelButtonWithTitle:@"取消" block:nil];

//    [sheet addButtonWithTitle:@"Show another alert" block:^{
//        [self showAlert:nil];
//    }];
    [sheet showInView:self.view];
}

#pragma mark - BirthdayGiftDetailControllerDelegate
-(void)showGiftListByGiftType:(NSInteger)GiftType
{
    NSMutableArray *giftArray=[fmdataOper getGiftDetailList:GiftType];
    
    if(giftArray!=nil)
    {
        if(giftArray.count>0)
        {
            NSString *GiftID;
            NSString *strGiftTitle;
            NSString *strGiftDetail;
            NSString *strImageURL;
            NSString *strTaobaoURL;
            NSString *Price;
            
            int iGiftScrollViewWidth=0;        //当前礼品scrollview的高度

            for(NSInteger i=0;i<giftArray.count;i++)
            {
                GiftID=[[giftArray objectAtIndex:i] objectAtIndex:0];
                strGiftTitle=[[giftArray objectAtIndex:i] objectAtIndex:2];
                strGiftDetail=[[giftArray objectAtIndex:i] objectAtIndex:3];
                strImageURL=[[giftArray objectAtIndex:i] objectAtIndex:4];
                strTaobaoURL=[[giftArray objectAtIndex:i] objectAtIndex:5];
                Price=[[giftArray objectAtIndex:i] objectAtIndex:6];
                
                birthdayGiftDetailItem=[[BirthdayGiftDetailItem alloc]initWithGiftInfo:GiftID GiftTitle:strGiftTitle GiftDetail:strGiftDetail ImageURL:strImageURL TaobaoURL:strTaobaoURL Price:Price];
                
                birthdayGiftDetailItem.frame=CGRectMake(21 + i+iGiftScrollViewWidth, 14, 277, 353);
                
                [giftDetailScrollView addSubview:birthdayGiftDetailItem];
                
                iGiftScrollViewWidth=iGiftScrollViewWidth+276+13;
            }
            
            iGiftScrollViewWidth=iGiftScrollViewWidth+26;
            CGSize size = giftDetailScrollView.frame.size;
            [giftDetailScrollView setContentSize:CGSizeMake(iGiftScrollViewWidth, size.height)];
        }
    }
}

-(void)sendGiftID:(NSInteger)GiftID
{
    NSInteger index=[fmdataOper getSelectedGiftIndex:GiftID];
    
//    k=k+(276+14)*index;
    k=(276+14)*index;
    [giftDetailScrollView setContentOffset:CGPointMake(k, 0) animated:YES];
}

#pragma mark - Scrollview Delegate
int start;

int end;

int k=0;        //giftDetailScrollView位移值

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    start = scrollView.contentOffset.x;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    end = scrollView.contentOffset.x;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    int diff = end-start;
    
    if (diff>0)
    {
        float tmp=giftDetailScrollView.contentSize.width-giftDetailScrollView.contentOffset.x;
        if(tmp>giftDetailScrollView.frame.size.width)
        {
            k=k+276+14;
            [scrollView setContentOffset:CGPointMake(k, 0) animated:YES];
        }
    }
    else {
        if(k>0)
        {
            k=k-276-14;
            [scrollView setContentOffset:CGPointMake(k, 0) animated:YES];
        }
    }
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
    birthdayGiftController=[[BirthdayGiftController alloc]init];
    delegate=birthdayGiftController;
    
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    [delegate sendGiftTypeTitle:cell.nameLabel.text];
    [self.navigationController pushViewController:birthdayGiftController animated:YES];

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
@end
