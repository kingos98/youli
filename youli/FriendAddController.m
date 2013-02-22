//
//  FriendAddController.m
//  youli
//
//  Created by sjun on 1/23/13.
//
//

#import "FriendAddController.h"
#import "FriendCell.h"
#import "SubTableCellView.h"
#import "UIFolderTableView.h"
#import "Friend.h"
#import "AppDelegate.h"

@interface FriendAddController ()<UIFolderTableViewDelegate>

@end

@implementation FriendAddController

@synthesize folderTableView =_folderTableView;
@synthesize friendTable = _friendTable;

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    [mainBgView setImage:[UIImage imageNamed:@"bg.png"]];
    
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    
    UIButton *btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn setImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [btnReturn addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
    
	self.friendTable = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 44, 320, 380)];
    if(iPhone5){
        self.friendTable.frame = CGRectMake(0, 44, 320, 468);
    }
    [self.friendTable setDelegate:self];
    [self.friendTable setDataSource:self];
    [self.friendTable setBackgroundColor:[UIColor whiteColor]];
    
    [mainView addSubview:mainBgView];
    [mainView addSubview:imgTitle];
    [mainView addSubview:btnReturn];
    [mainView addSubview:self.friendTable];
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"friendships/friends/bilateral.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    [self.friendTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    sinaweibo.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)returnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    FriendCell *cell = [[FriendCell alloc] initCell:CellIdentifier];
    if (self.items.count>0) {
        cell.friend =  [self.items objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.folderTableView.scrollEnabled = NO;
    self.subTableCellView = [[SubTableCellView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    [folderTableView openFolderAtIndexPath:indexPath
                           WithContentView:self.subTableCellView
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     
                                 }
                           completionBlock:^{
                                      self.folderTableView.scrollEnabled = YES;
                                 }];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 37;
}

-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [self.friendTable reloadData];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *usersDict = [[result objectForKey:@"users"] retain];
    self.items = [NSMutableArray arrayWithCapacity:24];
    int count = 0;
    for (NSDictionary *user in usersDict) {
        Friend *friend = [Friend alloc];
        friend.name = [user objectForKey:@"screen_name"];
        friend.profileUrl = [user objectForKey:@"profile_image_url"];
        [self.items addObject:friend];
        count++;
        if (count > 40) {
            break;
        }
    }
    [self.friendTable reloadData];
}

@end
