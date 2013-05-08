//
//  AboutController.m
//  youli
//
//  Created by ufida on 13-4-25.
//
//

#import "AboutController.h"
#import "AppDelegate.h"
#import "AdviceController.h"

@interface AboutController ()

@end

@implementation AboutController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    
    UIButton *btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn setImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [btnReturn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imgBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, kHEIGHT-20-44)];
    if(iPhone5)
    {
        imgBG.image=[UIImage imageNamed:@"about568.png"];
    }
    else
    {
        imgBG.image=[UIImage imageNamed:@"about480.png"];
    }


    UILabel *lblAboutTitle=[[UILabel alloc] initWithFrame:CGRectMake(126, -8, 68, 61)];
    lblAboutTitle.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    lblAboutTitle.font=[UIFont fontWithName:@"System" size:17.0f];
    lblAboutTitle.text=@"关于友礼";
    
    UIButton *btnFeedback=[[UIButton alloc]initWithFrame:CGRectMake(68, 249, 188, 36)];
    if (iPhone5)
    {
        btnFeedback.frame=CGRectMake(68, 284, 188, 36);
    }
    [btnFeedback setBackgroundImage:[UIImage imageNamed:@"feedback_click.png"] forState:UIControlStateHighlighted];
    [btnFeedback setBackgroundImage:[UIImage imageNamed:@"feedback_unclick.png"] forState:UIControlStateNormal];
    [btnFeedback addTarget:self action:@selector(feedbackClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:imgTitle];
    [self.view addSubview:btnReturn];
    [self.view addSubview:imgBG];    
    [self.view addSubview:lblAboutTitle];
    [self.view addSubview:btnFeedback];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)feedbackClick
{
    AdviceController *adviceController=[AdviceController alloc];
    [self.navigationController pushViewController:adviceController animated:YES];
}

@end
