//
//  BirthdayGiftControllerNew.m
//  youli
//
//  Created by ufida on 12-12-21.
//
//

#define DBNAME      @"youli.sqlite"
#define TABLENAME   @"BIRTHDAYGIFT"
#define GIFTID      @"giftid"
#define GIFTTYPE    @"gifttype"
#define TITLE       @"title"
#define DETAIL      @"detail"
#define IMAGEURL    @"imageurl"
#define TAOBAOURL   @"taobaourl"
#define PRICE       @"price"

#import "BirthdayGiftController.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "BirthdayGiftItem.h"
#import "NMRangeSlider.h"
#import "BaseController.h"

@interface BirthdayGiftController ()
{
    @private
    int iGiftDisplayCount;            //当前显示的礼品数量
    int iGiftScrollViewHeight;        //当前礼品scrollview的高度
    
    __strong BirthdayGiftItem *birthdayGiftItem;
}
@end

@implementation BirthdayGiftController

@synthesize items;
@synthesize PhotoURL;
@synthesize photoURLItems;
@synthesize giftScrollView;
@synthesize constellationArrary;
@synthesize giftListTitle;
@synthesize constellationScrollView;
@synthesize constellationSelectView;
@synthesize btnConstellation;
@synthesize btnPrice;
@synthesize imgConstellation;
@synthesize imgPrice;
@synthesize lowerPrice;
@synthesize upperPrice;
@synthesize btnReturn;
@synthesize indicator;
@synthesize lblGiftTypeTitle;

@synthesize db;


#pragma mark -
#pragma mark Initial
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//
//    }
//    return self;
//}
//无法刷新内容

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    constellationArrary=[[NSArray alloc] initWithObjects:@"aries.png",
                         @"taurus.png",
                         @"gemini.png",
                         @"cancer.png",
                         @"leo.png",
                         @"virgo.png",
                         @"libra.png",
                         @"scorpio.png",
                         @"sagittarius.png",
                         @"capricorn.png",
                         @"aquarius.png",
                         @"pisces.png",
                         nil];
    
    [self initView];
    
    [self initConstellation];
    
    [self initPriceSlider];
    
    databaseOper=[[DatabaseOper alloc]init];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    [self loadDataSource];
    
    
    btnConstellation.tag=0;                 //tag为0表示没有被点击
    btnPrice.tag=0;                         //tag为0表示没有被点击
    
    [constellationScrollView setShowsHorizontalScrollIndicator:false];
    [giftScrollView setShowsVerticalScrollIndicator:false];
    
    
    //设置返回按钮点击时的图片
    [self.btnReturn setImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    
    giftScrollView.delegate=self;
    
//    [self execSql:sql1];
    
//    [self dbOpen];
}

//初始化view控件
-(void) initView
{
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    
    UIImageView *imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 89, 320, 370)];
    imgGiftScrollView.image=[UIImage imageNamed:@"bg.jpg"];
    
    UIImageView *imgSelectorBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 45)];
    imgSelectorBG.image=[UIImage imageNamed:@"birthday_gift_top.jpg"];
    
    self.lblGiftTypeTitle=[[UILabel alloc] initWithFrame:CGRectMake(126, -8, 68, 61)];
    self.lblGiftTypeTitle.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    self.lblGiftTypeTitle.font=[UIFont fontWithName:@"System" size:17.0f];
    self.lblGiftTypeTitle.text=@"生日礼物";
//    //获取选中的礼品分类名称(第一次运行BirthdayGiftController传递的GiftTypeTitle)
//    NSUserDefaults *mydefault = [NSUserDefaults standardUserDefaults];
//    self.lblGiftTypeTitle.text=[mydefault objectForKey:@"giftTypeTitle"];
    

    
    self.btnConstellation=[[UIButton alloc]initWithFrame:CGRectMake(92, 51, 62, 32)];
    [self.btnConstellation setBackgroundImage:[UIImage imageNamed:@"gift_btn_push_down.png"] forState:UIControlStateNormal];
    [self.btnConstellation addTarget:self action:@selector(showConstellation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btnPrice=[[UIButton alloc] initWithFrame:CGRectMake(245, 51, 62, 32)];
    [self.btnPrice setBackgroundImage:[UIImage imageNamed:@"gift_btn_push_down.png"] forState:UIControlStateNormal];
    [self.btnPrice addTarget:self action:@selector(showPrice:) forControlEvents:UIControlEventTouchUpInside];
    
    self.giftScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, 320, 370)];
    
    imgConstellation=[[UIImageView alloc] initWithFrame:CGRectMake(0, 81, 320, 61)];
    imgConstellation.image=[UIImage imageNamed:@"birthday_gift_constellation_select.png"];
    [imgConstellation setHidden:YES];
    
    self.constellationScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 89, 320, 48)];
    [self.constellationScrollView setHidden:YES];
    
    imgPrice=[[UIImageView alloc]initWithFrame:CGRectMake(0, 81, 320, 61)];
    imgPrice.image=[UIImage imageNamed:@"birthday_gift_price_select.png"];
    [imgPrice setHidden:YES];
    
    self.lowerPrice=[[UILabel alloc]initWithFrame:CGRectMake(8, 90, 42, 21)];
    self.lowerPrice.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    self.lowerPrice.font=[UIFont fontWithName:@"Helvetica" size:13.0f];
    self.lowerPrice.text=@"￥ 0";
    [self.lowerPrice setHidden:YES];
    
    self.upperPrice=[[UILabel alloc]initWithFrame:CGRectMake(269, 90, 52, 21)];
    self.upperPrice.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    self.upperPrice.font=[UIFont fontWithName:@"Helvetica" size:13.0f];
    self.upperPrice.text=@"￥ 500+";
    [self.upperPrice setHidden:YES];
    
    self.btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [self.btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [self.btnReturn addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(285, 10, 25, 25)];
    indicator.color=[UIColor scrollViewTexturedBackgroundColor];
    indicator.hidesWhenStopped=YES;
//    indicator.center = CGPointMake(32, 25);
    
    [mainView addSubview:imgTitle];
    [mainView addSubview:imgGiftScrollView];
    [mainView addSubview:imgSelectorBG];
    [mainView addSubview:lblGiftTypeTitle];
    [mainView addSubview:btnConstellation];
    [mainView addSubview:btnPrice];
    [mainView addSubview:giftScrollView];
    [mainView addSubview:imgConstellation];
    [mainView addSubview:constellationScrollView];
    [mainView addSubview:imgPrice];
    [mainView addSubview:lowerPrice];
    [mainView addSubview:upperPrice];
    [mainView addSubview:btnReturn];
    [mainView addSubview:indicator];
    
    
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


- (void)viewDidUnload {
    //    [self setLblGiftListTitle:nil];
    //    [self setBtnReturn:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//初始化价钱
-(void)initPriceSlider
{
    priceSlider=[[NMRangeSlider alloc] init];
    priceSlider.frame=CGRectMake(16, 106, 285, 35);
    
    UIImage* image = nil;
    image = [UIImage imageNamed:@"slider-yellow-track"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    priceSlider.trackImage=image;
    
    priceSlider.minimumValue=0;
    priceSlider.maximumValue=500;
    
    priceSlider.lowerValue=0;
    priceSlider.upperValue=500;
    
    priceSlider.minimumRange=100;
    
    [priceSlider addTarget:self action:@selector(priceSliderChange) forControlEvents:UIControlEventValueChanged];
    [priceSlider setHidden:YES];
    [mainView addSubview:priceSlider];
}


//初始化星座
-(void) initConstellation
{
    int iConstellationIndex=0;          //星座初始化索引

    if(iConstellationIndex<12)
    {
        [constellationScrollView setContentSize:CGSizeMake(12*94, 48)];
        
        while (iConstellationIndex<12) {
            UIImage *image=[[UIImage imageNamed:[constellationArrary objectAtIndex:iConstellationIndex]] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
            
            //        UIButton *btnConstellation=[[UIButton alloc] init];
            UIButton *btnConstellationImg=[UIButton buttonWithType:UIButtonTypeCustom];
            [btnConstellationImg setTag:iConstellationIndex];
            btnConstellationImg.adjustsImageWhenHighlighted = false;
            btnConstellationImg.frame = CGRectMake(0 + iConstellationIndex * 94, 0, 94, 47);
            [btnConstellationImg setBackgroundImage:image forState:UIControlStateNormal];
            [btnConstellationImg addTarget:self action:@selector(constellationButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self.constellationScrollView addSubview:btnConstellationImg];
            
            iConstellationIndex++;
        }
    }
}

- (void)loadDataSource{
    [indicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgur.com/gallery.json"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            self.items = [JSON objectForKey:@"data"];
                                                                                            for (int i=iGiftDisplayCount; i<iGiftDisplayCount+10; i++) {                                                                                                NSDictionary *item = [self.items objectAtIndex:i];
                                                                                                
                                                                                                birthdayGiftItem=[[BirthdayGiftItem alloc] initWithUrl:[NSString stringWithFormat:@"http://imgur.com/%@%@",[item objectForKey:@"hash"], [item objectForKey:@"ext"]]];
                                                                                                
                                                                                                birthdayGiftItem.frame=CGRectMake(8, iGiftScrollViewHeight, 308, 270);
                                                                                                
                                                                                                CGSize size = giftScrollView.frame.size;
                                                                                                [giftScrollView setContentSize:CGSizeMake(size.width, size.height +iGiftScrollViewHeight)];
                                                                                                [self.giftScrollView addSubview:birthdayGiftItem];
                                                                                                
                                                                                                iGiftScrollViewHeight+=284;
                                                                                                                              
                                                                                                [self AddPhotoInfoToDB:[item objectForKey:@"account_url"] photodetail:[item objectForKey:@"title"] photourl:birthdayGiftItem.PhotoURL];
                                                                                                
                                                                                                NSLog([item objectForKey:@"title"]);
                                                                                            }
                                                                                                                                                                                        [indicator stopAnimating];
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"error: %@", error);
                                                                                        }];
    [operation start];
    
    iGiftDisplayCount+=10;
}

#pragma mark -
#pragma mark Action
- (IBAction)constellationButtonClick:(UIButton *)sender
{
    //    NSLog(@"this button text is %d",sender.tag);
    
    for(UIView *view in [constellationScrollView subviews])
    {
        if([view isKindOfClass:[UIButton class]])
        {
            view.backgroundColor=[UIColor clearColor];
        }
    }
    
    [sender setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1]];
}


- (IBAction)showConstellation:(id)sender
{
    
    if(btnConstellation.tag==0)
    {
        if(btnPrice.tag==1)
        {
            [self showPrice:btnPrice];
        }
        
        [imgConstellation setHidden:NO];
        [constellationScrollView setHidden:NO];
        btnConstellation.tag=1;
    }
    else
    {
        [imgConstellation setHidden:YES];
        [constellationScrollView setHidden:YES];
        btnConstellation.tag=0;
    }
    
    [self setButtonState:sender:btnConstellation.tag];
}

- (IBAction)showPrice:(id)sender
{
    
    if(btnPrice.tag==0)
    {
        if(btnConstellation.tag==1)
        {
            [self showConstellation:btnConstellation];
        }
        
        [imgPrice setHidden:NO];
        [priceSlider setHidden:NO];
        
        [lowerPrice setHidden:NO];
        [upperPrice setHidden:NO];
        btnPrice.tag=1;
    }
    else
    {
        [imgPrice setHidden:YES];
        [priceSlider setHidden:YES];
        
        [lowerPrice setHidden:YES];
        [upperPrice setHidden:YES];
        
        btnPrice.tag=0;
    }
    [self setButtonState:sender:btnPrice.tag];
}

-(void)setButtonState:(UIButton *)btn:(int)state
{
    if(state==0)
    {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"gift_btn_push_down" ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    }
    else
    {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"gift_btn_push_up" ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    }
}

- (IBAction)returnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateSliderLabels
{
    NSString * strMoneySymble=@"￥ ";
    
    CGPoint lowerCenter;
    lowerCenter.x = (priceSlider.lowerCenter.x + priceSlider.frame.origin.x);
    lowerCenter.y = (priceSlider.center.y - 20.0f);
    self.lowerPrice.text = [strMoneySymble stringByAppendingString:[NSString stringWithFormat:@"%d", (int)priceSlider.lowerCenter.x]];
    
    CGPoint upperCenter;
    upperCenter.x = (priceSlider.upperCenter.x + priceSlider.frame.origin.x);
    upperCenter.y = (priceSlider.center.y - 20.0f);
    self.upperPrice.text = [strMoneySymble stringByAppendingString:[NSString stringWithFormat:@"%d", (int)priceSlider.upperValue]];
}

- (void)priceSliderChange
{
    [self updateSliderLabels];
}

//清空scrollview里面的内容
-(void)clearGiftScrollView
{
    for(UIView *view in giftScrollView.subviews)
    {
        [view removeFromSuperview];
    }
}

-(void) sendGiftTypeTitle:(NSString *)GiftTypeTitle
{
    self.lblGiftTypeTitle.text=GiftTypeTitle;
}

-(void)changeGiftListByType:(int)GiftType
{
    [self clearGiftScrollView];
}

#pragma mark - Scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    
    if(currentOffset==maximumOffset)
    {
        [self loadDataSource];      //load next group data when scroll the end
    }
}

#pragma mark - data oper
-(void)AddPhotoInfoToDB:(NSString *)tmpPhotoTitle photodetail:(NSString*)tmpPhotoDetail photourl:(NSString *)tmpPhotoURL
{
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@) VALUES (%d,%d,'%@','%@','%@','%@',%f)",
                     TABLENAME,GIFTID, GIFTTYPE, TITLE, DETAIL,IMAGEURL,TAOBAOURL,PRICE ,1,1,
                     tmpPhotoTitle, tmpPhotoDetail,tmpPhotoURL,tmpPhotoURL,999.0f];
    
    [databaseOper ExecSql:sql];
}
@end
