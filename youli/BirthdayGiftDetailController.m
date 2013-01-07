//
//  BirthdayGiftDetail.m
//  youli
//
//  Created by ufida on 12-12-25.
//
//

#import "BirthdayGiftDetailController.h"

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
//    [self showTmpPic];
    [self showGiftListByGiftType:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initView
{
    dataOper=[[DatabaseOper alloc]init];
    
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];

    UIImageView *imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 415)];
    imgGiftScrollView.image=[UIImage imageNamed:@"bg.jpg"];
    
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
    [giftDetailScrollView setShowsHorizontalScrollIndicator:false];

    [mainView addSubview:imgTitle];
    [mainView addSubview:imgGiftScrollView];
    [mainView addSubview:lblGiftTypeTitle];
    [mainView addSubview:btnReturn];
    [mainView addSubview:btnShare];
    [mainView addSubview:giftDetailScrollView];
    
    //修改super组件位置
    CGRect r=super.tabBarLeftButton.frame;
    r.origin.y=422.0f;
    super.tabBarLeftButton.frame=r;
    
    r=super.tabBarRightButton.frame;
    r.origin.y=422.0f;
    super.tabBarRightButton.frame=r;
    
    r=super.tabBarBgImage.frame;
    r.origin.y=422.0f;
    super.tabBarBgImage.frame=r;
    
    r=super.tabBarBoxButton.frame;
    r.origin.y=414.0f;
    super.tabBarBoxButton.frame=r;
}

-(void)showTmpPic
{
    UIImageView *imgTmp;
    
    int iGiftScrollViewWidth=0;        //当前礼品scrollview的高度

    for(NSInteger i=0;i<10;i++)
    {
        imgTmp=[[UIImageView alloc]initWithFrame:CGRectMake(13+iGiftScrollViewWidth, 14, 276, 354)];
        [imgTmp setImage:[UIImage imageNamed:@"3.jpg"]];
        [self.giftDetailScrollView addSubview:imgTmp];
        
        iGiftScrollViewWidth=iGiftScrollViewWidth+276+13;
    }
    
    iGiftScrollViewWidth=iGiftScrollViewWidth+26;
    CGSize size = giftDetailScrollView.frame.size;
    [giftDetailScrollView setContentSize:CGSizeMake(iGiftScrollViewWidth, size.height)];
}

-(void)showGiftListByGiftType:(NSInteger)GiftType
{
    NSMutableArray *giftArray=[dataOper getGiftDetailList:GiftType];
    
    if(giftArray!=nil)
    {
        
//        NSLog(@"%d",giftArray.count);
        if(giftArray.count>0)
        {
            NSString *GiftID;
            NSString *strGiftTitle;
            NSString *strGiftDetail;
            NSString *strImageURL;
            NSString *strTaobaoURL;
            NSString *Price;
            
//            NSLog(@"%@",[giftArray objectAtIndex:0]);
//            NSLog(@"%@",[giftArray objectAtIndex:1]);
            
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
                
                birthdayGiftDetailItem.frame=CGRectMake(9 + i+iGiftScrollViewWidth, 14, 276, 354);
                
                [self.giftDetailScrollView addSubview:birthdayGiftDetailItem];
                
                iGiftScrollViewWidth=iGiftScrollViewWidth+276+13;
            }
            
            iGiftScrollViewWidth=iGiftScrollViewWidth+26;
            CGSize size = giftDetailScrollView.frame.size;
            [giftDetailScrollView setContentSize:CGSizeMake(iGiftScrollViewWidth, size.height)];
        }
    }
}

- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareClick
{

}

#pragma mark - Scrollview Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
