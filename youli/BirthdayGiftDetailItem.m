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
        [self initView];
        
        lblTitle.tag= [GiftID intValue];
        
        lblTitle.text=GiftDetail;
        
        [imgPhoto setImageWithURL:[NSURL URLWithString:ImageURL] placeholderImage:[UIImage imageNamed:@"3.jpg"]];
        
        lblDetail.text= GiftTitle;
        
        lblPrice.text=[NSString stringWithFormat: @"%@", Price];
        
        taobaoURL=TaobaoURL;
        
        self.backgroundColor=[UIColor whiteColor];
    }
    
    return self;
}

-(void) initView
{
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
        
    lblMoneySymbol=[[UILabel alloc] initWithFrame:CGRectMake(26, 318, 20, 21)];
    lblMoneySymbol.font=[UIFont systemFontOfSize:14];
    lblMoneySymbol.textColor=[UIColor redColor];
    lblMoneySymbol.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    lblMoneySymbol.text=@"￥";
    
    lblPrice=[[UILabel alloc] initWithFrame:CGRectMake(40, 318, 96, 21)];
    lblPrice.font=[UIFont systemFontOfSize:14];
    lblPrice.textColor=[UIColor redColor];
    lblPrice.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    UIImage *imgCollectButtonSelect=[[UIImage imageNamed:@"collect_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *imgCollectButtonUnSelect=[[UIImage imageNamed:@"collect_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    btnCollect=[[UIButton alloc] initWithFrame:CGRectMake(124, 312, 65, 25)];
    [btnCollect setBackgroundImage:imgCollectButtonUnSelect forState:UIControlStateNormal];
    [btnCollect setBackgroundImage:imgCollectButtonSelect forState:UIControlStateHighlighted];

    UIImage *imgBuyButtonSelect=[[UIImage imageNamed:@"buy_click.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *imgBuyButtonUnSelect=[[UIImage imageNamed:@"buy_unclick.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    btnBuy=[[UIButton alloc]initWithFrame:CGRectMake(194, 312, 65, 25)];
    [btnBuy setBackgroundImage:imgBuyButtonUnSelect forState:UIControlStateNormal];
    [btnBuy setBackgroundImage:imgBuyButtonSelect forState:UIControlStateHighlighted];
    
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
    dataOper=[[DatabaseOper alloc]init];

    arrGiftDetail=[dataOper getGiftDetail:PhotoID];
    
    if(arrGiftDetail!=nil)
    {
        lblTitle.tag=[arrGiftDetail objectAtIndex:0];
        lblTitle.text=[arrGiftDetail objectAtIndex:2];
        
        [imgPhoto setImageWithURL:[arrGiftDetail objectAtIndex:4] placeholderImage:[UIImage imageNamed:@"3.jpg"]];
        
        lblDetail.text= [arrGiftDetail objectAtIndex:3];
        
        lblPrice.text=[NSString stringWithFormat: @"%f", [arrGiftDetail objectAtIndex:6]];
        
        self.TaobaoURL=[arrGiftDetail objectAtIndex:5];
    }
}
@end
