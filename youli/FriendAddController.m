//
//  FriendAddController.m
//  youli
//
//  Created by sjun on 1/23/13.
//
//

#import "FriendAddController.h"
#import "PersonalCell.h"
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
    [mainBgView setImage:[UIImage imageNamed:@"bg.jpg"]];
    
	self.friendTable = [[UIFolderTableView alloc] initWithFrame:CGRectMake(10, 0, 300, 480)];
    [self.friendTable setDelegate:self];
    [self.friendTable setDataSource:self];
    [self.friendTable setBackgroundColor:[UIColor whiteColor]];
    
    [mainView addSubview:mainBgView];
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
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    PersonalCell *cell = [[PersonalCell alloc] initCell:CellIdentifier];
    if (self.items.count>0) {
        cell.friend =  [self.items objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.folderTableView.scrollEnabled = NO;
    SubTableCellView *subTableCellView = [[SubTableCellView alloc] init];
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
//    [folderTableView setFrame:CGRectMake(10, 0, 300, 480)];
    [folderTableView openFolderAtIndexPath:indexPath
                                parentView: mainView
                           WithContentView:subTableCellView
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
    return 40;
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