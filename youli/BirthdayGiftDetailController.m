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

@interface BirthdayGiftDetailController ()

@end

@implementation BirthdayGiftDetailController

@synthesize giftDetailScrollView;
@synthesize btnReturn;
@synthesize btnShare;
@synthesize lblGiftTypeTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    self.giftDetailScrollView.delegate=self;
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
    dataOper=[[DatabaseOper alloc]init];
    fmdataOper=[[FMDatabaseOper alloc]init];
    
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];

    UIImageView *imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 415)];


    imgGiftScrollView.image=[UIImage imageNamed:@"bg.png"];

    if(iPhone5)
    {
        imgGiftScrollView.frame=CGRectMake(0, 44, 320, 503);
    }
    
    self.lblGiftTypeTitle=[[UILabel alloc] initWithFrame:CGRectMake(126, -8, 68, 61)];
    self.lblGiftTypeTitle.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    self.lblGiftTypeTitle.font=[UIFont fontWithName:@"System" size:17.0f];
    self.lblGiftTypeTitle.text=@"礼品展示";
    
    self.btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [self.btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [self.btnReturn setBackgroundImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [self.btnReturn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];

    self.btnShare=[[UIButton alloc]initWithFrame:CGRectMake(265, 7, 50, 30)];
    [self.btnShare setBackgroundImage:[UIImage imageNamed:@"share_unclick.png"] forState:UIControlStateNormal];
    [self.btnShare setBackgroundImage:[UIImage imageNamed:@"share_click.png"] forState:UIControlStateHighlighted];
    [self.btnShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];

    

    giftDetailScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, 370)];
//    giftDetailScrollView.pagingEnabled=true;
    [giftDetailScrollView setShowsHorizontalScrollIndicator:false];

    
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
                
                [self.giftDetailScrollView addSubview:birthdayGiftDetailItem];
                
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
    
    k=k+(276+14)*index;
    [self.giftDetailScrollView setContentOffset:CGPointMake(k, 0) animated:YES];
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
@end
