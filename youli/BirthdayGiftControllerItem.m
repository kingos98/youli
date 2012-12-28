//
//  BirthdayGiftControllerItem.m
//  gift
//
//  Created by ufida on 12-12-10.
//  Copyright (c) 2012年 ufida. All rights reserved.
//

#import "BirthdayGiftControllerItem.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface BirthdayGiftControllerItem ()
@end

@implementation BirthdayGiftControllerItem

@synthesize PhotoURL;
@synthesize items;
@synthesize photoURLItems;
//@synthesize iCount;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    
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
    
    [self.view addSubview:imgBackground];
    [self.view addSubview:imgGiftPhoto];
    [self.view addSubview:lblMoneySymbol];
    [self.view addSubview:lblGiftPrice];
    
    self.view.backgroundColor=[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
}

-(void)showPhoto
{
    [super viewDidLoad];
    
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
    
    [self.view addSubview:imgBackground];
    [self.view addSubview:imgGiftPhoto];
    [self.view addSubview:lblMoneySymbol];
    [self.view addSubview:lblGiftPrice];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
