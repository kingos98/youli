//
//  LoginController.m
//  youli
//
//  Created by sjun on 3/4/13.
//
//

#import "LoginController.h"
#import "SinaWeiboAuthorizeView.h"
#import "SinaWeiboRequest.h"
#import "SinaWeiboConstants.h"
#import "AppDelegate.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,548)];
    [mainBgView setImage:[UIImage imageNamed:@"bg.png"]];
    //导航条
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    UIButton *returnButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 7, 50, 30)];
    [returnButton setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(indexButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,548)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            kAppKey, @"client_id",
                            @"code", @"response_type",
                            kAppRedirectURI, @"redirect_uri",
                            @"mobile", @"display", nil];
    NSString *authPagePath = [SinaWeiboRequest serializeURL:kSinaWeiboWebAuthURL
                                                     params:params httpMethod:@"GET"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authPagePath]]];
  
    [mainView addSubview:mainBgView];
    [mainView addSubview:imgTitle];
    [mainView addSubview:returnButton];
    [mainView addSubview:webView];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
