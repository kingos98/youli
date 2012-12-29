//
//  BirthdayGiftControllerItem.m
//  gift
//
//  Created by ufida on 12-12-10.
//  Copyright (c) 2012年 ufida. All rights reserved.
//

#import "BirthdayGiftItem.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface BirthdayGiftItem ()
@end

@implementation BirthdayGiftItem

@synthesize PhotoURL;
@synthesize items;
@synthesize photoURLItems;
//@synthesize iCount;

-(id)initWithUrl:(NSString *)PhotoURL
{
    self=[super init];
    if(self)
    {
        imgBackground=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 308, 270)];
        //    imgBackground.alpha=0;
        imgBackground.image=[UIImage imageNamed:@"gift_bg.png"];
        
        imgGiftPhoto=[[UIImageView alloc]initWithFrame:CGRectMake(11, 11, 281, 206)];
        //    NSLog(@"photo location %@",PhotoURL);
        NSURL *url=[NSURL URLWithString:PhotoURL];
        [imgGiftPhoto setImageWithURL:url placeholderImage:[UIImage imageNamed:@"3.jpg"]];
        [imgGiftPhoto.layer setBorderColor:[[UIColor colorWithRed:.84 green:.84 blue:.84 alpha:1] CGColor]];
        [imgGiftPhoto.layer setBorderWidth:1];
        
        
        lblMoneySymbol=[[UILabel alloc] initWithFrame:CGRectMake(254, 237, 20, 21)];
        lblMoneySymbol.text=@"￥";
        lblMoneySymbol.font=[UIFont systemFontOfSize:14];
        lblMoneySymbol.textColor=[UIColor whiteColor];
        lblMoneySymbol.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        
        lblGiftPrice=[[UILabel alloc] initWithFrame:CGRectMake(268, 237, 45, 21)];
        lblGiftPrice.text=@"99999";
        lblGiftPrice.font=[UIFont systemFontOfSize:14];
        lblGiftPrice.textColor=[UIColor whiteColor];
        lblGiftPrice.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        
        [self addSubview:imgBackground];
        [self addSubview:imgGiftPhoto];
        [self addSubview:lblMoneySymbol];
        [self addSubview:lblGiftPrice];
        
        self.backgroundColor=[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
    }
    
    return self;
}



-(void)showPhoto
{
    
    imgBackground=[[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 308, 270)];
    imgBackground.image=[UIImage imageNamed:@"gift_bg.png"];
    
    imgGiftPhoto=[[UIImageView alloc]initWithFrame:CGRectMake(17, 17, 282, 205)];
    //    NSLog(@"photo location %@",PhotoURL);
    NSURL *url=[NSURL URLWithString:PhotoURL];
    [imgGiftPhoto setImageWithURL:url placeholderImage:[UIImage imageNamed:@"3.jpg"]];
    
    
    lblMoneySymbol=[[UILabel alloc] initWithFrame:CGRectMake(254, 237, 20, 21)];
    lblMoneySymbol.text=@"￥";
    lblMoneySymbol.font=[UIFont systemFontOfSize:14];
    lblMoneySymbol.textColor=[UIColor whiteColor];
    lblMoneySymbol.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    lblGiftPrice=[[UILabel alloc] initWithFrame:CGRectMake(268, 237, 45, 21)];
    lblGiftPrice.text=@"99999";
    lblGiftPrice.font=[UIFont systemFontOfSize:14];
    lblGiftPrice.textColor=[UIColor whiteColor];
    lblGiftPrice.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    [self addSubview:imgBackground];
    [self addSubview:imgGiftPhoto];
    [self addSubview:lblMoneySymbol];
    [self addSubview:lblGiftPrice];
    
}

@end
