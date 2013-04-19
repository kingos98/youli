//
//  BirthdayGiftDetailItem.m
//  youli
//
//  Created by ufida on 12-12-25.
//
//

#import "BirthdayGiftDetailItem.h"
#import "UIImageView+WebCache.h"
#import "BirthdayGiftModel.h"
#import "CollectBirthdayGiftModel.h"
#import "AppDelegate.h"

@implementation BirthdayGiftDetailItem

@synthesize taobaoURL;
@synthesize arrGiftDetail;
@synthesize isCollect;
@synthesize currentGiftID;
@synthesize delegate;

-(id)initWithGiftInfo:(NSInteger)GiftID GiftTitle:(NSString *)GiftTitle GiftDetail:(NSString *)GiftDetail ImageURL:(NSString *)ImageURL TaobaoURL:(NSString *)TaobaoURL Price:(NSString *)Price Delegate:(id<BirthdayGiftDetailDelegate>) _delegate
{
    self=[super init];
    
    if(self)
    {
        currentGiftID=GiftID;

        [self initView];

        lblTitle.tag= GiftID;
        lblTitle.text=GiftTitle;        
        lblDetail.text= GiftTitle;
        lblPrice.text=[NSString stringWithFormat: @"%@", Price];
        taobaoURL=TaobaoURL;
        
        [imgPhoto setImageWithURL:[NSURL URLWithString:[ImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"3.jpg"]];
        imgPhoto.contentMode=UIViewContentModeScaleAspectFill;
        [imgPhoto setClipsToBounds:YES];
        
        self.delegate=_delegate;
    }
    
    return self;
}

-(void) initView
{
    imgBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 277, kHEIGHT - 127)];
    [imgBg setImage:[UIImage imageNamed:@"gift_detail_bg5.png"]];
    
    lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(13, 14, 254, 21)];
    lblTitle.font=[UIFont systemFontOfSize:14];
    lblTitle.textColor=[UIColor colorWithRed:229.0/255.0 green:154.0/255.0 blue:43.0/255.0 alpha:1];
    lblTitle.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
    
    if(!iPhone5)
    {
        imgPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(7, 37, 260, 203)];
    }
    else
    {
        imgPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(7, 37, 260, 291)];
    }

    
//    lblDetail=[[UILabel alloc] initWithFrame:CGRectMake(13, 258, 267, 55)];
    lblDetail=[[UILabel alloc] initWithFrame:CGRectMake(13, kHEIGHT-222, 267, 55)];
    lblDetail.font=[UIFont systemFontOfSize:13];
    lblDetail.textColor=[UIColor colorWithRed:0.43 green:0.42 blue:0.42 alpha:1];
    lblDetail.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    lblDetail.lineBreakMode=UILineBreakModeWordWrap;
    lblDetail.numberOfLines=0;
        
//    lblMoneySymbol=[[UILabel alloc] initWithFrame:CGRectMake(26, 314, 20, 21)];
    lblMoneySymbol=[[UILabel alloc] initWithFrame:CGRectMake(26, kHEIGHT-166, 20, 21)];
    lblMoneySymbol.font=[UIFont systemFontOfSize:15];
    lblMoneySymbol.textColor=[UIColor redColor];
    lblMoneySymbol.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    lblMoneySymbol.text=@"￥";
    
//    lblPrice=[[UILabel alloc] initWithFrame:CGRectMake(40, 314, 96, 21)];
    lblPrice=[[UILabel alloc] initWithFrame:CGRectMake(40, kHEIGHT-166, 96, 21)];
    lblPrice.font=[UIFont systemFontOfSize:15];
    lblPrice.textColor=[UIColor redColor];
    lblPrice.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    UIImage *imgCollectButtonSelect;
    UIImage *imgCollectButtonUnSelect;
    
    if(![CollectBirthdayGiftModel checkIsCollect:currentGiftID])
    {
        imgCollectButtonSelect=[[UIImage imageNamed:@"collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        imgCollectButtonUnSelect=[[UIImage imageNamed:@"collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        isCollect=NO;
    }
    else
    {
        imgCollectButtonSelect=[[UIImage imageNamed:@"cancel_collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        imgCollectButtonUnSelect=[[UIImage imageNamed:@"cancel_collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        isCollect=YES;
    }

    btnCollect=[[UIButton alloc] initWithFrame:CGRectMake(124, kHEIGHT-168, 65, 25)];
    [btnCollect setBackgroundImage:imgCollectButtonUnSelect forState:UIControlStateNormal];
    [btnCollect setBackgroundImage:imgCollectButtonSelect forState:UIControlStateHighlighted];
    [btnCollect addTarget:self action:@selector(operGift) forControlEvents:UIControlEventTouchUpInside];

    UIImage *imgBuyButtonSelect=[[UIImage imageNamed:@"buy_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *imgBuyButtonUnSelect=[[UIImage imageNamed:@"buy_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    btnBuy=[[UIButton alloc]initWithFrame:CGRectMake(194, kHEIGHT-168, 65, 25)];
    [btnBuy setBackgroundImage:imgBuyButtonUnSelect forState:UIControlStateNormal];
    [btnBuy setBackgroundImage:imgBuyButtonSelect forState:UIControlStateHighlighted];
    [btnBuy addTarget:self action:@selector(sendGiftWebUrl) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:imgBg];
    [self addSubview:lblTitle];
    [self addSubview:imgPhoto];
    [self addSubview:lblDetail];
    [self addSubview:lblMoneySymbol];
    [self addSubview:lblPrice];

    [self addSubview:btnCollect];
    [self addSubview:btnBuy];
}

//对礼物进行收藏操作
-(void)operGift
{
    UIImage *imgCollectButtonSelect;
    UIImage *imgCollectButtonUnSelect;
    
    if(!isCollect)
    {
        [CollectBirthdayGiftModel operGiftToCollection:YES GiftID:currentGiftID];
        imgCollectButtonSelect=[[UIImage imageNamed:@"cancel_collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        imgCollectButtonUnSelect=[[UIImage imageNamed:@"cancel_collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    }
    else
    {
        [CollectBirthdayGiftModel operGiftToCollection:NO GiftID:currentGiftID];
        imgCollectButtonSelect=[[UIImage imageNamed:@"collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        imgCollectButtonUnSelect=[[UIImage imageNamed:@"collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    }
    
    isCollect=!isCollect;
    
    [btnCollect setBackgroundImage:imgCollectButtonUnSelect forState:UIControlStateNormal];
    [btnCollect setBackgroundImage:imgCollectButtonSelect forState:UIControlStateHighlighted];
}


-(void)sendGiftWebUrl
{
    if ([delegate respondsToSelector:@selector(showGiftInWebview:)])
    {
        [delegate performSelector:@selector(showGiftInWebview:) withObject:taobaoURL];
    }
}
@end
