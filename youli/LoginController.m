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
#import "PersonalController.h"

@interface LoginController ()

@end

@implementation LoginController

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

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
    [returnButton addTarget:self action:@selector(returnButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,44,320,548)];
    webView.delegate = self;
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

- (void)returnButtonPressed
{
    if ([self isLoggedIn]) {

    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"url = %@", url);
    NSString *siteRedirectURI = [NSString stringWithFormat:@"%@%@", kSinaWeiboSDKOAuth2APIDomain, kAppRedirectURI];
    if ([url hasPrefix:kAppRedirectURI] || [url hasPrefix:siteRedirectURI])
    {
        NSString *error_code = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error_code"];
        if (error_code)
        {
            NSString *error = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error"];
            NSString *error_uri = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error_uri"];
            NSString *error_description = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error_description"];
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       error, @"error",
                                       error_uri, @"error_uri",
                                       error_code, @"error_code",
                                       error_description, @"error_description", nil];
            
        }
        else
        {
            NSString *code = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"code"];
            if (code)
            {
                [self requestAccessTokenWithAuthorizationCode:code];
            }
        }        
        return NO;
    }    
    return YES;
}

- (void)requestAccessTokenWithAuthorizationCode:(NSString *)code
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            kAppKey, @"client_id",
                            kAppSecret, @"client_secret",
                            @"authorization_code", @"grant_type",
                            kAppRedirectURI, @"redirect_uri",
                            code, @"code", nil];
    [weiboRequest disconnect];
    [weiboRequest release], weiboRequest = nil;
    weiboRequest = [[SinaWeiboRequest requestWithURL:kSinaWeiboWebAccessTokenURL
                                     httpMethod:@"POST"
                                         params:params
                                       delegate:self] retain];
    
    [weiboRequest connect];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [self logInDidFinishWithAuthInfo:result];
    PersonalController *personalController = [[PersonalController alloc] init];
    [self.navigationController pushViewController:personalController animated:NO];
}

- (void)logInDidFinishWithAuthInfo:(NSDictionary *)authInfo
{
    NSString *access_token = [authInfo objectForKey:@"access_token"];
    NSString *uid = [authInfo objectForKey:@"uid"];
    NSString *remind_in = [authInfo objectForKey:@"remind_in"];
    NSString *refresh_token = [authInfo objectForKey:@"refresh_token"];
    if (access_token && uid)
    {
        if (remind_in != nil)
        {
            int expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        
        self.accessToken = access_token;
        self.userID = uid;
        self.refreshToken = refresh_token;
        SinaWeibo *sinaweibo = [self sinaweibo];
        sinaweibo.userID = uid;
        sinaweibo.refreshToken = refresh_token;
        sinaweibo.accessToken = access_token;
    }
}

/**
 * @description 清空认证信息
 */
- (void)removeAuthData
{
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaweiboCookies = [cookies cookiesForURL:
                                 [NSURL URLWithString:@"https://open.weibo.cn"]];
    
    for (NSHTTPCookie* cookie in sinaweiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
}

/**
 * @description 判断是否登录
 * @return YES为已登录；NO为未登录
 */
- (BOOL)isLoggedIn
{
    return self.userID && self.accessToken && self.expirationDate;
}

/**
 * @description 判断登录是否过期
 * @return YES为已过期；NO为未为期
 */
- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:self.expirationDate] == NSOrderedDescending);
}


/**
 * @description 判断登录是否有效，当已登录并且登录未过期时为有效状态
 * @return YES为有效；NO为无效
 */
- (BOOL)isAuthValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

@end
