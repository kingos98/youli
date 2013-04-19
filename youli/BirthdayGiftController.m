//
//  BirthdayGiftControllerNew.m
//  youli
//
//  Created by ufida on 12-12-21.
//
//

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
#import "AppDelegate.h"
#import "CategoryCell.h"
#import "BirthdayGiftModel.h"
#import "DbUtils.h"
#import "SettingControler.h"

@interface BirthdayGiftController ()
{
    @private
    int iPageCount;                                                                     //当前分页数，默认为1
    int iGiftDisplayCount;                                                              //当前显示的礼品数量
    int iGiftScrollViewHeight;                                                          //当前礼品scrollview的高度
    
    NSString *strOldGiftType;                                                           //记录上一次选中的分类名称
    NSString *strNewGiftType;                                                           //记录当前选中的分类名称
    NSMutableArray *items;                                                              //加载图片使用的临时数组
    NSMutableArray *giftTypeItems;                                                      //记录分类内容的数组
    
    NSArray *constellationArrary;                                                       //星座列表

    CategoryTableView *categoryTableView;                                               //分类组件
    BirthdayGiftItem *birthdayGiftItem;                                                 //单个礼物组件
    NMRangeSlider *priceSlider;                                                         //价钱区间组件
    
    id<BirthdayGiftDetailControllerDelegate> birthdayDelegate;                          //指向BirthdayGiftController的委托
    
    UIScrollView *giftScrollView;                                                       //礼物ScrollVie
    UIScrollView *constellationScrollView;                                              //星座ScrollVie
    
    UIImageView *imgConstellation;                                                      //星座ScrollVie底图
    UIImageView *imgPrice;                                                              //价钱ScrollVie底图

    UIButton *btnReturn;                                                                //返回上一页按钮
    UIButton *btnConstellation;                                                         //展开/关闭星座ScrollVie按钮
    UIButton *btnPrice;                                                                 //展开/关闭价钱ScrollVie按钮
    
    UILabel *lowerPrice;                                                                //价格区间标签
    UILabel *upperPrice;                                                                //价格区间标签
    UIButton *btnPriceConfirm;                                                          //按价格查询确认按钮
    UILabel *lblGiftTypeTitle;                                                          //礼物种类标签
    
    
    UIActivityIndicatorView *indicator;                                                 //等待图标
    
    BirthdayGiftDetailController *birthdayGiftDetailController;                         //礼物详细信息ViewController
    
    NSInteger searchType;                                                               //当前查询的类型 1:全部  2:星座  3:价格
    NSString *currentSelectConstellation;                                               //当前选中的星座
    NSInteger lowPrice;                                                                 //选中的最低价格
    NSInteger highPrice;                                                                //选中的最高价格
}

@end

@implementation BirthdayGiftController

#pragma mark -
#pragma mark Initial
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

    birthdayGiftDetailController=[[BirthdayGiftDetailController alloc]init];
    birthdayDelegate=birthdayGiftDetailController;
    
    [self initView];
    [self initConstellation];
    [self initPriceSlider];
    
    strOldGiftType=nil;
    strNewGiftType=nil;
    
    lowPrice=0;
    highPrice=10000;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    btnConstellation.tag=0;                 //tag为0表示没有被点击
    btnPrice.tag=0;                         //tag为0表示没有被点击
    
    [constellationScrollView setShowsHorizontalScrollIndicator:false];
    [giftScrollView setShowsVerticalScrollIndicator:false];
    
    giftScrollView.delegate=self;
}

//初始化view控件
-(void) initView
{
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    
    UIImageView *imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 89, 320, 370)];
    if(iPhone5)
    {
        imgGiftScrollView.frame=CGRectMake(0, 89, 320, 458);
    }
    
    imgGiftScrollView.image=[UIImage imageNamed:@"bg.png"];
    
    UIImageView *imgSelectorBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 45)];
    imgSelectorBG.image=[UIImage imageNamed:@"birthday_gift_top.jpg"];
    
    lblGiftTypeTitle=[[UILabel alloc] initWithFrame:CGRectMake(75, -8, 170, 61)];
    lblGiftTypeTitle.backgroundColor=[UIColor clearColor];
    lblGiftTypeTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:19.0f];
    lblGiftTypeTitle.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    lblGiftTypeTitle.shadowColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    lblGiftTypeTitle.shadowOffset=CGSizeMake(0, 1);
    lblGiftTypeTitle.text=@"生日礼物";
    lblGiftTypeTitle.textAlignment=NSTextAlignmentCenter;
    
//    //获取选中的礼品分类名称(第一次运行BirthdayGiftController传递的GiftTypeTitle)
//    NSUserDefaults *mydefault = [NSUserDefaults standardUserDefaults];
//    self.lblGiftTypeTitle.text=[mydefault objectForKey:@"giftTypeTitle"];
    
    btnConstellation=[[UIButton alloc]initWithFrame:CGRectMake(100, 50, 60, 35)];
    [btnConstellation setBackgroundImage:[UIImage imageNamed:@"gift_btn_push_down.png"] forState:UIControlStateNormal];
    [btnConstellation addTarget:self action:@selector(showConstellation:) forControlEvents:UIControlEventTouchUpInside];
    
    btnPrice=[[UIButton alloc] initWithFrame:CGRectMake(260, 50, 60, 35)];
    [btnPrice setBackgroundImage:[UIImage imageNamed:@"gift_btn_push_down.png"] forState:UIControlStateNormal];
    [btnPrice addTarget:self action:@selector(showPrice:) forControlEvents:UIControlEventTouchUpInside];

    giftScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, 320, kHEIGHT-130)];

    imgConstellation=[[UIImageView alloc] initWithFrame:CGRectMake(0, 81, 320, 61)];
    imgConstellation.image=[UIImage imageNamed:@"birthday_gift_constellation_select.png"];
    [imgConstellation setHidden:YES];
    
    constellationScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 89, 320, 48)];
    [constellationScrollView setHidden:YES];
    
    imgPrice=[[UIImageView alloc]initWithFrame:CGRectMake(0, 81, 320, 61)];
    imgPrice.image=[UIImage imageNamed:@"birthday_gift_price_select.png"];
    [imgPrice setHidden:YES];
    
    lowerPrice=[[UILabel alloc]initWithFrame:CGRectMake(8, 90, 42, 21)];
    lowerPrice.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    lowerPrice.font=[UIFont fontWithName:@"Helvetica" size:13.0f];
    lowerPrice.text=@"￥ 0";
    [lowerPrice setHidden:YES];
    
//    upperPrice=[[UILabel alloc]initWithFrame:CGRectMake(269, 90, 52, 21)];
    upperPrice=[[UILabel alloc]initWithFrame:CGRectMake(229, 90, 52, 21)];
    upperPrice.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    upperPrice.font=[UIFont fontWithName:@"Helvetica" size:13.0f];
    upperPrice.text=@"￥ 500+";
    [upperPrice setHidden:YES];
    
    btnPriceConfirm=[[UIButton alloc]initWithFrame:CGRectMake(281, 89, 40, 43)];
    [btnPriceConfirm setBackgroundImage:[UIImage imageNamed:@"price_confirm.png"] forState:UIControlStateNormal];
    [btnPriceConfirm setBackgroundImage:[UIImage imageNamed:@"price_confirm.png"] forState:UIControlStateHighlighted];
    [btnPriceConfirm addTarget:self action:@selector(priceConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [btnPriceConfirm setHidden:YES];

    btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn setImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [btnReturn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];

    categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, kHEIGHT-20)];
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    UITapGestureRecognizer *photoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setttingClick:)];
    [categoryTableView.imgSetting addGestureRecognizer:photoTap];

    Category *category = [[Category alloc] init];
    [category loadData];                        //load分类列表
    giftTypeItems = category.items;

    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(285, 10, 25, 25)];
    indicator.color=[UIColor scrollViewTexturedBackgroundColor];
    indicator.hidesWhenStopped=YES;

    
    [self.view addSubview:categoryTableView];
//    [self.view addSubview:imgSetting];
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
    [mainView addSubview:btnPriceConfirm];
    [mainView addSubview:btnReturn];
    [mainView addSubview:indicator];

    //添加左右滑动手势
    UIPanGestureRecognizer *mainViewPan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleMainPan:)];
    [giftScrollView addGestureRecognizer: mainViewPan];
    
    //避免UIScrollView原有手势与新添加的手势冲突
    [mainViewPan requireGestureRecognizerToFail:giftScrollView.panGestureRecognizer];
}

- (void)viewDidUnload {
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
//    priceSlider.frame=CGRectMake(16, 106, 285, 35);
    priceSlider.frame=CGRectMake(16, 106, 245, 35);
    
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
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
            
            [constellationScrollView addSubview:btnConstellationImg];
            
            iConstellationIndex++;
        }
    }
}

- (void)loadDataSource{
    [indicator startAnimating];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgur.com/gallery.json"]];
    
    NSURLRequest *request;
    if(strNewGiftType!=@"")
    {
        //参数带有中文，需要转换成utf-8解释
        NSString *strUrl=[[NSString stringWithFormat:@"http://yourgift.sinaapp.com/type/%@/%d",[strNewGiftType substringToIndex:2],iPageCount] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        iPageCount++;
    }
    else
    {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://yourgift.sinaapp.com/"]];
    }

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        items = [JSON objectForKey:@"items"];
        
        for (int i=0; i<items.count; i++)
        {
            
            NSDictionary *item = [items objectAtIndex:i];
            
            NSString *strPhotoURL=[NSString stringWithFormat:@"http://yourgift.sinaapp.com/media/img/gift/%@",[item objectForKey:@"imageUrl"]];
            
            birthdayGiftItem=[[BirthdayGiftItem alloc]initWithUrl:strPhotoURL GiftTitle:[item objectForKey:@"name"] Price:[[item objectForKey:@"price"] intValue]];
            
            birthdayGiftItem.tag=[[item objectForKey:@"id"] intValue];
            
            UITapGestureRecognizer *photoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
            [birthdayGiftItem setUserInteractionEnabled:YES];
            [birthdayGiftItem addGestureRecognizer:photoTap];
            
            birthdayGiftItem.frame=CGRectMake(8, iGiftScrollViewHeight, 308, 270);
            
            CGSize size = giftScrollView.frame.size;
            
            [giftScrollView setContentSize:CGSizeMake(size.width, iGiftScrollViewHeight+284)];
            
            [giftScrollView addSubview:birthdayGiftItem];
            
            iGiftScrollViewHeight+=284;
            
            //把搜索的数据保存到sqlite
            [[BirthdayGiftModel getInstance]  AddPhotoInfoToDB:[[item objectForKey:@"id"] intValue] tmpPhotoTitle:[item objectForKey:@"name"] photodetail:[item objectForKey:@"name"] photourl:strPhotoURL Price:[[item objectForKey:@"price"] intValue] TaobaoUrl:[item objectForKey:@"url"] IsFromIndexPage:NO];
        }
        [indicator stopAnimating];
        
        iGiftDisplayCount+=10;
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
    }];
    [operation start];
}


- (void)loadDataSourceByConstellation:(NSString *)constellationName
{
    currentSelectConstellation=constellationName;
    
    [indicator startAnimating];
    
    NSURLRequest *request;

    //参数带有中文，需要转换成utf-8解释
    NSString *strUrl=[[NSString stringWithFormat:@"http://yourgift.sinaapp.com/tag/%@/%d",constellationName,iPageCount] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    iPageCount++;

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        items = [JSON objectForKey:@"items"];
        for (int i=0; i<items.count; i++)
        {
            NSDictionary *item = [items objectAtIndex:i];
            
            NSString *strPhotoURL=[NSString stringWithFormat:@"http://yourgift.sinaapp.com/media/img/gift/%@",[item objectForKey:@"imageUrl"]];
            
            birthdayGiftItem=[[BirthdayGiftItem alloc]initWithUrl:strPhotoURL GiftTitle:[item objectForKey:@"name"] Price:[[item objectForKey:@"price"] intValue]];
            
            birthdayGiftItem.tag=[[item objectForKey:@"id"] intValue];
            
            UITapGestureRecognizer *photoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
            [birthdayGiftItem setUserInteractionEnabled:YES];
            [birthdayGiftItem addGestureRecognizer:photoTap];
            
            birthdayGiftItem.frame=CGRectMake(8, iGiftScrollViewHeight, 308, 270);
            
            CGSize size = giftScrollView.frame.size;
            
            [giftScrollView setContentSize:CGSizeMake(size.width, iGiftScrollViewHeight+284)];
            
            [giftScrollView addSubview:birthdayGiftItem];
            
            iGiftScrollViewHeight+=284;
            
            //把搜索的数据保存到sqlite
            [[BirthdayGiftModel getInstance]  AddPhotoInfoToDB:[[item objectForKey:@"id"] intValue] tmpPhotoTitle:[item objectForKey:@"name"] photodetail:[item objectForKey:@"name"] photourl:strPhotoURL Price:[[item objectForKey:@"price"] intValue] TaobaoUrl:[item objectForKey:@"url"] IsFromIndexPage:NO];
        }
        [indicator stopAnimating];
        
        iGiftDisplayCount+=10;
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
    }];
    [operation start];
}

- (void)loadDataSourceByPrice
{
    
    [indicator startAnimating];
    
    NSURLRequest *request;
    
    //参数带有中文，需要转换成utf-8解释
    NSString *strUrl=[NSString stringWithFormat:@"http://yourgift.sinaapp.com/price/%d/%d/%d/",lowPrice,highPrice,iPageCount];
    NSLog(@"price url:%@",strUrl);
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    iPageCount++;
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             items = [JSON objectForKey:@"items"];
                                             for (int i=0; i<items.count; i++)
                                             {
                                                 NSDictionary *item = [items objectAtIndex:i];
                                                 
                                                 NSString *strPhotoURL=[NSString stringWithFormat:@"http://yourgift.sinaapp.com/media/img/gift/%@",[item objectForKey:@"imageUrl"]];
                                                 
                                                 birthdayGiftItem=[[BirthdayGiftItem alloc]initWithUrl:strPhotoURL GiftTitle:[item objectForKey:@"name"] Price:[[item objectForKey:@"price"] intValue]];
                                                 
                                                 birthdayGiftItem.tag=[[item objectForKey:@"id"] intValue];
                                                 
                                                 UITapGestureRecognizer *photoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
                                                 [birthdayGiftItem setUserInteractionEnabled:YES];
                                                 [birthdayGiftItem addGestureRecognizer:photoTap];
                                                 
                                                 birthdayGiftItem.frame=CGRectMake(8, iGiftScrollViewHeight, 308, 270);
                                                 
                                                 CGSize size = giftScrollView.frame.size;
                                                 
                                                 [giftScrollView setContentSize:CGSizeMake(size.width, iGiftScrollViewHeight+284)];
                                                 
                                                 [giftScrollView addSubview:birthdayGiftItem];
                                                 
                                                 iGiftScrollViewHeight+=284;
                                                 
                                                 //把搜索的数据保存到sqlite
                                                 [[BirthdayGiftModel getInstance]  AddPhotoInfoToDB:[[item objectForKey:@"id"] intValue] tmpPhotoTitle:[item objectForKey:@"name"] photodetail:[item objectForKey:@"name"] photourl:strPhotoURL Price:[[item objectForKey:@"price"] intValue] TaobaoUrl:[item objectForKey:@"url"] IsFromIndexPage:NO];
                                             }
                                             [indicator stopAnimating];
                                             
                                             iGiftDisplayCount+=10;
                                         }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"error: %@", error);
                                         }];
    [operation start];
}

#pragma mark -
#pragma mark Action
- (IBAction)constellationButtonClick:(UIButton *)sender
{
    for(UIView *view in [constellationScrollView subviews])
    {
        if([view isKindOfClass:[UIButton class]])
        {
            view.backgroundColor=[UIColor clearColor];
        }
    }
    
    [sender setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1]];

    searchType=2;
    
    [self clearGiftScrollView];
    switch (sender.tag) {
        case 0:
            [self loadDataSourceByConstellation:@"白羊"];
            break;
        case 1:
            [self loadDataSourceByConstellation:@"多牛"];
            break;
        case 2:
            [self loadDataSourceByConstellation:@"双子"];
            break;
        case 3:
            [self loadDataSourceByConstellation:@"巨蟹"];
            break;
        case 4:
            [self loadDataSourceByConstellation:@"狮子"];
            break;
        case 5:
            [self loadDataSourceByConstellation:@"处女"];
            break;
        case 6:
            [self loadDataSourceByConstellation:@"天秤"];
            break;
        case 7:
            [self loadDataSourceByConstellation:@"天蝎"];
            break;
        case 8:
            [self loadDataSourceByConstellation:@"射手"];
            break;
        case 9:
            [self loadDataSourceByConstellation:@"魔蝎"];
            break;
        case 10:
            [self loadDataSourceByConstellation:@"水瓶"];
            break;
        case 11:
            [self loadDataSourceByConstellation:@"双鱼"];
            break;
        default:
            break;
    }
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
        [btnPriceConfirm setHidden:NO];
        btnPrice.tag=1;
    }
    else
    {
        [imgPrice setHidden:YES];
        [priceSlider setHidden:YES];
        
        [lowerPrice setHidden:YES];
        [upperPrice setHidden:YES];
        [btnPriceConfirm setHidden:YES];
        
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

- (void)returnClick
{ 
    if(self.isPopCategoryView)
    {
        [self hideCategoryView];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)priceConfirmClick
{
    searchType=3;

    [self clearGiftScrollView];
    [self loadDataSourceByPrice];
    
    [self showPrice:btnPrice];
}

- (void)priceSliderChange
{
    NSString * strMoneySymble=@"￥ ";
    
    CGPoint lowerCenter;
    lowerCenter.x = (priceSlider.lowerCenter.x + priceSlider.frame.origin.x);
    lowerCenter.y = (priceSlider.center.y - 20.0f);
    lowerPrice.text = [strMoneySymble stringByAppendingString:[NSString stringWithFormat:@"%d", (int)priceSlider.lowerValue]];
    lowPrice=(int)priceSlider.lowerValue;
    
    CGPoint upperCenter;
    upperCenter.x = (priceSlider.upperCenter.x + priceSlider.frame.origin.x);
    upperCenter.y = (priceSlider.center.y - 20.0f);
    upperPrice.text = [strMoneySymble stringByAppendingString:[NSString stringWithFormat:@"%d", (int)priceSlider.upperValue]];
    highPrice=(int)priceSlider.upperValue;

    if((int)priceSlider.upperValue==500)
    {
        upperPrice.text =[upperPrice.text stringByAppendingString:@"+"];
        highPrice=10000;
    }
}

//清空scrollview里面的内容
-(void)clearGiftScrollView
{
    for(UIView *view in giftScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    iPageCount=1;
    iGiftDisplayCount=0;
    iGiftScrollViewHeight=0;
    [[BirthdayGiftModel getInstance] cleanGiftList:NO];
    
    giftScrollView.frame=CGRectMake(0, 90, 320, kHEIGHT-130);
    [giftScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void) sendGiftTypeTitle:(NSString *)GiftTypeTitle
{
    searchType=1;
    strNewGiftType=GiftTypeTitle;
    lblGiftTypeTitle.text=GiftTypeTitle;
    
    if(strOldGiftType!=strNewGiftType)
    {
        [self clearGiftScrollView];
        [self loadDataSource];
        
        strOldGiftType=strNewGiftType;
    }
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
        switch (searchType) {
            case 1:
                [self loadDataSource];
                break;
            case 2:
                [self loadDataSourceByConstellation:currentSelectConstellation];
                break;
            case 3:
                [self loadDataSourceByPrice];
                break;
            default:
                break;
        }
//        [self loadDataSource];      //当滚到最底时自动更新内容
    }
}

#pragma mark - Data Oper
-(void)AddPhotoInfoToDB:(NSInteger)PhotoID tmpPhotoTitle:(NSString *)tmpPhotoTitle photodetail:(NSString*)tmpPhotoDetail photourl:(NSString *)tmpPhotoURL Price:(NSInteger)GiftPrice TaobaoUrl:(NSString *)TaobaoUrl
{
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@) VALUES (%d,%d,'%@','%@','%@','%@',%d)",
                     TABLENAME,GIFTID, GIFTTYPE, TITLE, DETAIL,IMAGEURL,TAOBAOURL,PRICE ,PhotoID,1,
                     tmpPhotoTitle, tmpPhotoDetail,tmpPhotoURL,TaobaoUrl,GiftPrice];
    
    [DbUtils ExecSql:sql];
}

#pragma mark - GestureRecognizer
-(void) tapPhoto:(UITapGestureRecognizer*) sender
{        
//    birthdayGiftDetailController=[[BirthdayGiftDetailController alloc] init];
//    [birthdayGiftDetailController showGiftListByGiftType:1 IsFromIndexPage:YES];
    
    if ([birthdayDelegate respondsToSelector:@selector(showGiftListByGiftType:IsFromIndexPage:)])
    {
        [birthdayDelegate showGiftListByGiftType:1 IsFromIndexPage:NO];
    }

//    [birthdayGiftDetailController sendGiftID:[(UIGestureRecognizer *)sender view].tag IsFromIndexPage:NO];
    
    if([birthdayDelegate respondsToSelector:@selector(sendGiftID: IsFromIndexPage:)])
    {
        [birthdayDelegate sendGiftID:[(UIGestureRecognizer *)sender view].tag IsFromIndexPage:NO];
    }

    [self.navigationController pushViewController:birthdayGiftDetailController animated:YES];
}

-(void) handleMainPan:(UIPanGestureRecognizer *) gestureRecognizer{
    
    if([gestureRecognizer state]==UIGestureRecognizerStateBegan||[gestureRecognizer state]==UIGestureRecognizerStateChanged)
    {
        CGPoint cgpoint=[gestureRecognizer translationInView:self.view];
        //滑动超过一定距离才招待滑动操作，避免与原来的操作手势冲突
        if(cgpoint.x<-3)
        {
            [self hideCategoryView];
        }
        else if(cgpoint.x>3)
        {
            [self showCategoryView];
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
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    [self sendGiftTypeTitle:cell.nameLabel.text];
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

#pragma mark - Setting GestureRecognizer
-(void) setttingClick:(UITapGestureRecognizer*) sender
{
    [self hideCategoryView];
    SettingControler *settingControler=[[SettingControler alloc]init];
    [self.navigationController pushViewController:settingControler animated:YES];
}
@end
