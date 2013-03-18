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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(iPhone5)
    {
        webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    }
    else
    {
        webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    }
    
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
