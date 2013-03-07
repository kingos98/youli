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
#import "CategoryTableView.h"
#import "CategoryCell.h"
#import "BirthdayController.h"
#import "Account.h"

@interface LoginController (){
@private
    UITableView *friendTable;
    CategoryTableView *categoryTableView;
    Category *category;
    NSMutableArray *giftTypeItems;
    id<YouliDelegate> delegate;
    BirthdayGiftController *birthdayGiftController;
}

@end

@implementation LoginController

- (SinaWeibo *)sinaweibo
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.sinaweibo;
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
    //加左边的类别tableview
    categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, 460)];
    if(iPhone5)
    {
        categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, 548)];
    }
    categoryTableView.dataSource = self;
    categoryTableView.delegate = self;
    category = [[Category alloc] init];
    [category loadData];                        //load分类列表
    giftTypeItems = category.items;
    birthdayGiftController = [[BirthdayGiftController alloc]init];
    delegate = birthdayGiftController;
  
    [self.view addSubview:categoryTableView];
    [mainView addSubview:mainBgView];
    [mainView addSubview:imgTitle];
    [mainView addSubview:returnButton];
    [mainView addSubview:webView];
}

- (void)returnButtonPressed
{
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
//                self.expirationDate = [NSDate distantFuture];
            }
            else
            {
//                self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        SinaWeibo *sinaweibo = [self sinaweibo];
        sinaweibo.userID = uid;
        sinaweibo.refreshToken = refresh_token;
        sinaweibo.accessToken = access_token;
        [Account getInstance].userID = uid;
        [Account getInstance].accessToken = access_token;
        [Account getInstance].refreshToken = refresh_token;
    }
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return giftTypeItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategoryCell *cell = [[CategoryCell alloc] initCell:CellIdentifier];
    cell.category =  [giftTypeItems objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    [delegate sendGiftTypeTitle:cell.nameLabel.text];
    [self.navigationController pushViewController:birthdayGiftController animated:YES];
    cell.labelImage.image = [UIImage imageNamed:@"selected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerselect.png"];
    [self hideCategoryView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    cell.labelImage.image = [UIImage imageNamed:@"unselected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerunselect.png"];
}

@end
