//
//  guideController.m
//  youli
//
//  Created by ufida on 13-4-3.
//
//

#import "GuideController.h"
#import "AppDelegate.h"

@interface GuideController ()
{
    UIScrollView *pageScroll;                       //引导页
    UIImageView *pageImage;                         //引导页包含的图片    
}


@end

@implementation GuideController


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *imgGiftScrollView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    imgGiftScrollView.image=[UIImage imageNamed:@"bg2_iphone5.png"];
    [self.view addSubview:imgGiftScrollView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self addGuiding];
}

//添加引导页
-(void)addGuiding
{
    pageScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, kHEIGHT-20)];
    [pageScroll setContentSize:CGSizeMake(4*320, kHEIGHT-20)];
    
    pageScroll.pagingEnabled = YES;
    pageScroll.delegate = self;
    [pageScroll setShowsHorizontalScrollIndicator:NO];
    [pageScroll setShowsVerticalScrollIndicator:NO];
    pageScroll.alwaysBounceVertical=NO;
    pageScroll.alwaysBounceHorizontal=YES;
    
    pageImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, kHEIGHT-20)];
    pageImage.image=[UIImage imageNamed:@"welcome1.png"];
    [pageScroll addSubview:pageImage];
    
    pageImage=[[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, kHEIGHT-20)];
    pageImage.image=[UIImage imageNamed:@"welcome2.png"];
    [pageScroll addSubview:pageImage];
    
    pageImage=[[UIImageView alloc]initWithFrame:CGRectMake(640, 0, 320, kHEIGHT-20)];
    pageImage.image=[UIImage imageNamed:@"welcome3.png"];
    [pageScroll addSubview:pageImage];
    
    [self.view addSubview:pageScroll];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x==3*320)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
