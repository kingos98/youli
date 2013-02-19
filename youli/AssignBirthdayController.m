//
//  AssignBirthdayController.m
//  youli
//
//  Created by ufida on 13-2-4.
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

#import "AssignBirthdayController.h"
#import "BirthdayGiftController.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "BirthdayGiftItem.h"
#import "NMRangeSlider.h"

@interface AssignBirthdayController ()
{
    @private
    int iGiftDisplayCount;            //当前显示的礼品数量
    int iGiftScrollViewHeight;        //当前礼品scrollview的高度
    
    NSString *strOldGiftType;
    NSString *strNewGiftType;

    __strong BirthdayGiftItem *birthdayGiftItem;
}
@end

@implementation AssignBirthdayController

@synthesize items;
@synthesize PhotoURL;
@synthesize photoURLItems;
@synthesize giftScrollView;
@synthesize giftListTitle;
@synthesize imgPrice;
@synthesize lowerPrice;
@synthesize upperPrice;
@synthesize btnReturn;
@synthesize indicator;
@synthesize lblGiftTypeTitle;
@synthesize birthdayGiftDetailController;
@synthesize birthdayGiftDetailControllerDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self=[super init];
    
    if (self) {
        [self initView];
        [self initPriceSlider];
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    fmdataOper=[[FMDatabaseOper alloc]init];
    [fmdataOper cleanGiftList];
    
    birthdayGiftDetailController=[[BirthdayGiftDetailController alloc]init];
    self.BirthdayGiftDetailControllerDelegate=birthdayGiftDetailController;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [giftScrollView setShowsVerticalScrollIndicator:false];
    
    giftScrollView.delegate=self;
}


//初始化view控件
-(void) initView
{
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    
    UIImageView *imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 320, 370)];
    imgGiftScrollView.image=[UIImage imageNamed:@"bg.jpg"];
    
    self.lblGiftTypeTitle=[[UILabel alloc] initWithFrame:CGRectMake(75, -12, 170, 61)];
    self.lblGiftTypeTitle.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    self.lblGiftTypeTitle.font=[UIFont fontWithName:@"System" size:17.0f];
    [self.lblGiftTypeTitle setTextAlignment:NSTextAlignmentCenter];
    self.lblGiftTypeTitle.text=@"生日礼物";
    
    self.giftScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 95, 320, 350)];
    
    imgPrice=[[UIImageView alloc]initWithFrame:CGRectMake(0, 37, 320, 61)];
    imgPrice.image=[UIImage imageNamed:@"birthday_gift_select.png"];    
    
    self.lowerPrice=[[UILabel alloc]initWithFrame:CGRectMake(8, 42, 42, 21)];
    self.lowerPrice.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    self.lowerPrice.font=[UIFont fontWithName:@"Helvetica" size:13.0f];
    self.lowerPrice.text=@"￥ 0";
    
    self.upperPrice=[[UILabel alloc]initWithFrame:CGRectMake(269, 42, 52, 21)];
    self.upperPrice.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    self.upperPrice.font=[UIFont fontWithName:@"Helvetica" size:13.0f];
    self.upperPrice.text=@"￥ 500+";
    
    self.btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 4, 50, 30)];
    [self.btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [self.btnReturn setImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [self.btnReturn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(285, 10, 25, 25)];
    indicator.color=[UIColor scrollViewTexturedBackgroundColor];
    indicator.hidesWhenStopped=YES;
    
    [self.view addSubview:imgTitle];
    [self.view addSubview:imgGiftScrollView];
    [self.view addSubview:lblGiftTypeTitle];
    [self.view addSubview:giftScrollView];
    [self.view addSubview:imgPrice];
    [self.view addSubview:lowerPrice];
    [self.view addSubview:upperPrice];
    [self.view addSubview:btnReturn];
    [self.view addSubview:indicator];
    
    strOldGiftType=nil;
    strNewGiftType=nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化价钱
-(void)initPriceSlider
{
    priceSlider=[[NMRangeSlider alloc] init];
    priceSlider.frame=CGRectMake(16, 58, 285, 35);
    
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

    [self.view addSubview:priceSlider];
}


- (void)loadDataSource{
    [indicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgur.com/gallery.json"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            self.items = [JSON objectForKey:@"data"];
                                                                                            for (int i=iGiftDisplayCount; i<iGiftDisplayCount+10; i++) {                                                                                                NSDictionary *item = [self.items objectAtIndex:i];
                                                                                                
                                                                                                NSString *strPhotoURL=[NSString stringWithFormat:@"http://imgur.com/%@%@",[item objectForKey:@"hash"], [item objectForKey:@"ext"]];
                                                                                                
                                                                                                birthdayGiftItem=[[BirthdayGiftItem alloc]initWithUrl:strPhotoURL GiftTitle:[item objectForKey:@"title"]];
                                                                                                
                                                                                                birthdayGiftItem.tag=[[item objectForKey:@"size"] intValue];
                                                                                                
                                                                                                UITapGestureRecognizer *photoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
                                                                                                [birthdayGiftItem setUserInteractionEnabled:YES];
                                                                                                [birthdayGiftItem addGestureRecognizer:photoTap];
                                                                                                
                                                                                                
                                                                                                birthdayGiftItem.frame=CGRectMake(8, iGiftScrollViewHeight, 308, 270);
                                                                                                
                                                                                                CGSize size = giftScrollView.frame.size;
//                                                                                                [giftScrollView setContentSize:CGSizeMake(size.width, size.height +iGiftScrollViewHeight)];
                                                                                                [giftScrollView setContentSize:CGSizeMake(size.width, iGiftScrollViewHeight+284)];
                                                                                                
                                                                                                [self.giftScrollView addSubview:birthdayGiftItem];
                                                                                                
                                                                                                iGiftScrollViewHeight+=284;

                                                                                                //把搜索的数据保存到sqlite
                                                                                                [self AddPhotoInfoToDB:[[item objectForKey:@"size"] intValue] tmpPhotoTitle:[item objectForKey:@"title"] photodetail:[item objectForKey:@"title"] photourl:strPhotoURL];
                                                                                                
                                                                                                //                                                                                                NSLog([item objectForKey:@"title"]);
                                                                                            }
                                                                                            [indicator stopAnimating];
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"error: %@", error);
                                                                                        }];
    [operation start];
    
    iGiftDisplayCount+=10;
}

- (void)priceSliderChange
{
    [self updateSliderLabels];
}

- (void) updateSliderLabels
{
    NSString * strMoneySymble=@"￥ ";
    
    CGPoint lowerCenter;
    lowerCenter.x = (priceSlider.lowerCenter.x + priceSlider.frame.origin.x);
    lowerCenter.y = (priceSlider.center.y - 20.0f);
    self.lowerPrice.text = [strMoneySymble stringByAppendingString:[NSString stringWithFormat:@"%d", (int)priceSlider.lowerValue]];
    
    CGPoint upperCenter;
    upperCenter.x = (priceSlider.upperCenter.x + priceSlider.frame.origin.x);
    upperCenter.y = (priceSlider.center.y - 20.0f);
    self.upperPrice.text = [strMoneySymble stringByAppendingString:[NSString stringWithFormat:@"%d", (int)priceSlider.upperValue]];
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
    
    strNewGiftType=GiftTypeTitle;
    
    if(strOldGiftType!=strNewGiftType)
    {
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
        [self loadDataSource];      //当滚到最底时自动更新内容
    }
}

#pragma mark - Data Oper
-(void)AddPhotoInfoToDB:(NSInteger)PhotoID tmpPhotoTitle:(NSString *)tmpPhotoTitle photodetail:(NSString*)tmpPhotoDetail photourl:(NSString *)tmpPhotoURL
{
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@) VALUES (%d,%d,'%@','%@','%@','%@',%f)",
                     TABLENAME,GIFTID, GIFTTYPE, TITLE, DETAIL,IMAGEURL,TAOBAOURL,PRICE ,PhotoID,1,
                     tmpPhotoTitle, tmpPhotoDetail,tmpPhotoURL,tmpPhotoURL,999.0f];
    
    [fmdataOper ExecSql:sql];
}

#pragma mark - GestureRecognizer
-(void) tapPhoto:(UITapGestureRecognizer*) sender
{
    //    NSLog([NSString stringWithFormat:@"%d",[(UIGestureRecognizer *)sender view].tag]);
    [self.birthdayGiftDetailController sendGiftID:[(UIGestureRecognizer *)sender view].tag];
    [self.navigationController pushViewController:birthdayGiftDetailController animated:YES];
    
}
@end
