//
//  BirthdayGiftDetailItem.m
//  youli
//
//  Created by ufida on 12-12-25.
//
//

#import "BirthdayGiftDetailItem.h"
#import "UIImageView+WebCache.h"


@interface BirthdayGiftDetailItem ()

@end

@implementation BirthdayGiftDetailItem

@synthesize taobaoURL;
@synthesize arrGiftDetail;
@synthesize isCollect;
@synthesize currentGiftID;

-(id)initWithGiftID:(NSInteger)GiftID
{
    self=[super init];
    
    if(self)
    {
        [self initView];
        [self showGiftDetail:GiftID];
    }
    return self;
}

-(id)initWithGiftInfo:(NSString *)GiftID GiftTitle:(NSString *)GiftTitle GiftDetail:(NSString *)GiftDetail ImageURL:(NSString *)ImageURL TaobaoURL:(NSString *)TaobaoURL Price:(NSString *)Price
{
    self=[super init];
    
    if(self)
    {
        currentGiftID=[GiftID intValue];
        
        [self initView];
        
        lblTitle.tag= [GiftID intValue];
        
        lblTitle.text=GiftDetail;
        
        [imgPhoto setImageWithURL:[NSURL URLWithString:ImageURL] placeholderImage:[UIImage imageNamed:@"3.jpg"]];
        
        lblDetail.text= GiftTitle;
        
        lblPrice.text=[NSString stringWithFormat: @"%@", Price];
        
        taobaoURL=TaobaoURL;
    }
    
    return self;
}

-(void) initView
{
    imgBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 277, 353)];
    [imgBg setImage:[UIImage imageNamed:@"gift_detail_bg.png"]];
    
    lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(13, 14, 254, 21)];
    lblTitle.font=[UIFont systemFontOfSize:14];
    lblTitle.textColor=[UIColor colorWithRed:0.9 green:0.6 blue:0.17 alpha:1];
    lblTitle.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    imgPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(7, 37, 260, 203)];
    
    lblDetail=[[UILabel alloc] initWithFrame:CGRectMake(13, 258, 267, 55)];
    lblDetail.font=[UIFont systemFontOfSize:13];
    lblDetail.textColor=[UIColor colorWithRed:0.43 green:0.42 blue:0.42 alpha:1];
    lblDetail.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    lblDetail.lineBreakMode=UILineBreakModeWordWrap;
    lblDetail.numberOfLines=0;
        
    lblMoneySymbol=[[UILabel alloc] initWithFrame:CGRectMake(26, 314, 20, 21)];
    lblMoneySymbol.font=[UIFont systemFontOfSize:15];
    lblMoneySymbol.textColor=[UIColor redColor];
    lblMoneySymbol.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    lblMoneySymbol.text=@"￥";
    
    lblPrice=[[UILabel alloc] initWithFrame:CGRectMake(40, 314, 96, 21)];
    lblPrice.font=[UIFont systemFontOfSize:15];
    lblPrice.textColor=[UIColor redColor];
    lblPrice.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    UIImage *imgCollectButtonSelect;
    UIImage *imgCollectButtonUnSelect;
    if(![fmdataOper checkIsCollect:currentGiftID])
    {
        imgCollectButtonSelect=[[UIImage imageNamed:@"collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        imgCollectButtonUnSelect=[[UIImage imageNamed:@"collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        isCollect=false;
    }
    else
    {
        imgCollectButtonSelect=[[UIImage imageNamed:@"cancel_collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        imgCollectButtonUnSelect=[[UIImage imageNamed:@"cancel_collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        isCollect=true;
    }
    
//    UIImage *imgCollectButtonSelect=[[UIImage imageNamed:@"collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//    UIImage *imgCollectButtonUnSelect=[[UIImage imageNamed:@"collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    btnCollect=[[UIButton alloc] initWithFrame:CGRectMake(124, 312, 65, 25)];
    [btnCollect setBackgroundImage:imgCollectButtonUnSelect forState:UIControlStateNormal];
    [btnCollect setBackgroundImage:imgCollectButtonSelect forState:UIControlStateHighlighted];
    [btnCollect addTarget:self action:@selector(operGift) forControlEvents:UIControlEventTouchUpInside];


    UIImage *imgBuyButtonSelect=[[UIImage imageNamed:@"buy_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *imgBuyButtonUnSelect=[[UIImage imageNamed:@"buy_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    btnBuy=[[UIButton alloc]initWithFrame:CGRectMake(194, 312, 65, 25)];
    [btnBuy setBackgroundImage:imgBuyButtonUnSelect forState:UIControlStateNormal];
    [btnBuy setBackgroundImage:imgBuyButtonSelect forState:UIControlStateHighlighted];
    
    [self addSubview:imgBg];
    [self addSubview:lblTitle];
    [self addSubview:imgPhoto];
    [self addSubview:lblDetail];
    [self addSubview:lblMoneySymbol];
    [self addSubview:lblPrice];

    [self addSubview:btnCollect];
    [self addSubview:btnBuy];
}

-(void) showGiftDetail:(NSInteger)PhotoID
{
    fmdataOper=[[FMDatabaseOper alloc]init];

    arrGiftDetail=[fmdataOper getGiftDetail:PhotoID];
    
    
    if(arrGiftDetail!=nil)
    {
        lblTitle.tag=[arrGiftDetail objectAtIndex:0];
        lblTitle.text=[arrGiftDetail objectAtIndex:2];
        
        [imgPhoto setImageWithURL:[arrGiftDetail objectAtIndex:4] placeholderImage:[UIImage imageNamed:@"3.jpg"]];
        
        lblDetail.text= [arrGiftDetail objectAtIndex:3];
        
        lblPrice.text=[NSString stringWithFormat: @"%@", [arrGiftDetail objectAtIndex:6]];
        
        self.TaobaoURL=[arrGiftDetail objectAtIndex:5];
    }
    
    [fmdataOper release];
}

-(void)operGift
{
    UIImage *imgCollectButtonSelect;
    UIImage *imgCollectButtonUnSelect;

    fmdataOper=[[FMDatabaseOper alloc]init];
    
    if(!isCollect)
    {
        [fmdataOper operGiftToCollection:true GiftID:currentGiftID];
        imgCollectButtonSelect=[[UIImage imageNamed:@"cancel_collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        imgCollectButtonUnSelect=[[UIImage imageNamed:@"cancel_collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    }
    else
    {
        [fmdataOper operGiftToCollection:false GiftID:currentGiftID];
        imgCollectButtonSelect=[[UIImage imageNamed:@"collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        imgCollectButtonUnSelect=[[UIImage imageNamed:@"collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    }
    
    isCollect=!isCollect;
    
    [btnCollect setBackgroundImage:imgCollectButtonUnSelect forState:UIControlStateNormal];
    [btnCollect setBackgroundImage:imgCollectButtonSelect forState:UIControlStateHighlighted];
    
    [fmdataOper release];
}

@end
