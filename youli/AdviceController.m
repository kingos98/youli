//
//  AdviceController.m
//  youli
//
//  Created by ufida on 13-4-3.
//
//

#import "AdviceController.h"
#import <QuartzCore/QuartzCore.h> 
#import "PlaceHolderTextView.h"
@interface AdviceController ()
{
//    UITextView *txtAdvice;
    PlaceHolderTextView *txtAdvice;    
}
@end

@implementation AdviceController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    
    UIImageView *imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    imgGiftScrollView.image=[UIImage imageNamed:@"bg2_iphone5.png"];
    
    UIButton *btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn setImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [btnReturn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];

    
    UILabel *lblGiftTypeTitle=[[UILabel alloc] initWithFrame:CGRectMake(126, -8, 68, 61)];
    lblGiftTypeTitle.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    lblGiftTypeTitle.font=[UIFont fontWithName:@"System" size:17.0f];
    lblGiftTypeTitle.text=@"意见反馈";


    UIButton *btnSend=[[UIButton alloc]initWithFrame:CGRectMake(265, 7, 50, 30)];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"send_unclick.png"] forState:UIControlStateNormal];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"send_click.png"] forState:UIControlStateHighlighted];
    [btnSend addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    txtAdvice=[[PlaceHolderTextView alloc]initWithFrame:CGRectMake(10, 54, 300, 180)];
    txtAdvice.backgroundColor = [UIColor whiteColor];
    txtAdvice.showsVerticalScrollIndicator=YES;
    txtAdvice.showsHorizontalScrollIndicator=NO;
    txtAdvice.layer.cornerRadius=8;
    txtAdvice.placeholder=@"请输入您的宝贵意见";
    txtAdvice.placeholderColor=[UIColor grayColor];

//    txtAdvice.layer.cornerRadius = 8;
//    txtAdvice.scrollEnabled = YES;
    [txtAdvice becomeFirstResponder];

    [self.view addSubview:imgGiftScrollView];    
    [self.view addSubview:imgTitle];
    [self.view addSubview:btnReturn];
    [self.view addSubview:lblGiftTypeTitle];
    [self.view addSubview:btnSend];
    [self.view addSubview:txtAdvice];
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


- (void)sendClick
{
}


@end
