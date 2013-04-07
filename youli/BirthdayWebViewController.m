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
    UIActivityIndicatorView *activityIndicator;                         //loading
}
@end

@implementation BirthdayWebViewController

@synthesize webUrl;
@synthesize isChangeUrl;

-(id)init:(NSString *)strUrl
{
    NSURL *url =[NSURL URLWithString:strUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
//    webView.scrollView.pagingEnabled=YES;
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

    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 44, 320, kHEIGHT-64)];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setDelegate:self];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(285, 10, 25, 25)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    UIPanGestureRecognizer *webViewPan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleMainPan:)];
    [webView addGestureRecognizer: webViewPan];
    
    [self.view addSubview:imgTitle];
    [self.view addSubview:btnReturn];
    
    [self.view addSubview:activityIndicator];
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

- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIWebView Delegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
}

#pragma mark - GestureRecognizer
-(void) handleMainPan:(UIPanGestureRecognizer *) gestureRecognizer{
    
    if([gestureRecognizer state]==UIGestureRecognizerStateBegan||[gestureRecognizer state]==UIGestureRecognizerStateChanged)
    {
        CGPoint cgpoint=[gestureRecognizer translationInView:self.view];
        //滑动超过一定距离才招待滑动操作，避免与原来的操作手势冲突
        
        NSLog(@"cgpoint.y:%f",cgpoint.y);
        if(cgpoint.y<-3)
        {
            NSLog(@"1");
        }
        else if(cgpoint.y>3)
        {
            NSLog(@"2");
        }
    }
}
@end
