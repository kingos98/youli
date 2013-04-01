//
//  BirthdayWebViewController.m
//  youli
//
//  Created by ufida on 13-3-15.
//
//

#import "BirthdayWebViewController.h"
#import "AppDelegate.h"

@interface BirthdayWebViewController ()
{
    UIWebView *webView;                                                 //浏览具体gift信息
}
@end

@implementation BirthdayWebViewController

@synthesize webUrl;
@synthesize isChangeUrl;

-(id)init:(NSString *)strUrl
{
    NSURL *url =[NSURL URLWithString:strUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];

    
    UIButton *btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn setImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [btnReturn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];

    
    if(iPhone5)
    {
        webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 504)];
    }
    else
    {
        webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
    }
    
    [self.view addSubview:imgTitle];
    [self.view addSubview:webView];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(isChangeUrl)
    {
        NSURL *url =[NSURL URLWithString:self.webUrl];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        
        isChangeUrl=NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UIWebView Delegate

@end
