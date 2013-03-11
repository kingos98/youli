//
//  FriendMegController.m
//  youli
//
//  Created by sjun on 3/9/13.
//
//

#import "FriendMegController.h"
#import "FriendCell.h"
#import "SubTableCell.h"
#import "UIFolderTableView.h"
#import "Friend.h"
#import "AppDelegate.h"

@interface FriendMegController ()<UIFolderTableViewDelegate>

@end

@implementation FriendMegController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,548)];
    [mainBgView setImage:[UIImage imageNamed:@"bg.png"]];
    //返回导航条
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
    
    [Friend loadFriend:^(NSArray *friends, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            self.items = friends;
            [self.friendTable reloadData];
        }
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
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
    self.subTableCellView = [[SubTableCell alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
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

@end
