//
//  PersonalController.m
//  youli
//
//  Created by jun on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonalController.h"
#import "PersonalCell.h"
#import "BirthdayController.h"
#import "PersonalController.h"
#import "FriendInfoController.h"
#import "Friend.h"
#import "AppDelegate.h"
#import "SubTableCellView.h"
#import "UIFolderTableView.h"
#import "FriendAddController.h"

@interface PersonalController ()
@end

@implementation PersonalController

@synthesize friendTable = _friendTable;

NSMutableArray *items ;

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
    
    UIImageView *personalInfoBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,53,300,69)];
    [personalInfoBgView setImage:[UIImage imageNamed:@"personal_info_bg.png"]];
    
    UIImageView *faceBgView = [[UIImageView alloc] initWithFrame:CGRectMake(16,59,57,59)];
    [faceBgView setImage:[UIImage imageNamed:@"face_bg.png"]];
    
    UIImageView *faceView = [[UIImageView alloc] initWithFrame:CGRectMake(19,61,51,52)];
    [faceView setImage:[UIImage imageNamed:@"icon.jpeg"]];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 68, 90, 22)];
    nameLabel.text = @"天空之城";
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    nameLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *constellationView = [[UIImageView alloc] initWithFrame:CGRectMake(87,92,16,17)];
    [constellationView setImage:[UIImage imageNamed:@"constellation.png"]];
    
    UILabel *constellationLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 90, 110, 22)];
    constellationLabel.text = @"请选择星座";
    constellationLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    constellationLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    constellationLabel.textAlignment = UITextAlignmentLeft;
    constellationLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *birthdayView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 65, 21, 22)];
    [birthdayView setImage:[UIImage imageNamed:@"birthday_unselect.png"]];
    
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 90, 100, 22)];
    birthdayLabel.text = @"请填写生日";
    birthdayLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    birthdayLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    birthdayLabel.textAlignment = UITextAlignmentLeft;
    birthdayLabel.backgroundColor = [UIColor clearColor];
    
    UIButton *friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *friendImage = [[UIImage imageNamed:@"friend_button_select.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    friendButton.frame = CGRectMake(10,122,99,41);
    [friendButton setBackgroundImage:friendImage forState:UIControlStateNormal];
    [friendButton addTarget:self action:@selector(friendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *collectImage = [[UIImage imageNamed:@"collect_unselect.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    collectButton.frame = CGRectMake(110,122,100,41);
    [collectButton setBackgroundImage:collectImage forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cartImage = [[UIImage imageNamed:@"cart_unselect.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    cartButton.frame = CGRectMake(210,122,101,41);
    [cartButton setBackgroundImage:cartImage forState:UIControlStateNormal];
    [cartButton addTarget:self action:@selector(cartButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *personalPromptBgView = [[UIImage imageNamed:@"add_friend.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    addButton.frame = CGRectMake(10,165,300,31);
    [addButton setBackgroundImage:personalPromptBgView forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.friendTable = [[UIFolderTableView alloc] initWithFrame:CGRectMake(10, 204, 300, 220)];
    if(iPhone5){
        self.friendTable.frame = CGRectMake(10, 204, 300, 308);
    }
    [self.friendTable setDelegate:self];
    [self.friendTable setDataSource:self];
    [self.friendTable setBackgroundColor:[UIColor whiteColor]];
    
    [mainView addSubview:mainBgView];
    [mainView addSubview:imgTitle];
    [mainView addSubview:btnReturn];
    [mainView addSubview:personalInfoBgView];
    [mainView addSubview:faceBgView];
    [mainView addSubview:faceView];
    [mainView addSubview:nameLabel];
    [mainView addSubview:constellationView];
    [mainView addSubview:constellationLabel];
    [mainView addSubview:birthdayView];
    [mainView addSubview:birthdayLabel];
    [mainView addSubview:friendButton];
    [mainView addSubview:collectButton];
    [mainView addSubview:cartButton];
    [mainView addSubview:addButton];
    [mainView addSubview:self.friendTable];
    
    self.items = [NSMutableArray arrayWithCapacity:24];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
    sinaweibo.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)friendButtonPressed
{
    
}

- (void)collectButtonPressed
{
    
}

- (void)cartButtonPressed
{
    
}

- (void)addButtonPressed
{
    FriendAddController *friendAddController = [[FriendAddController alloc] init];
    [self.navigationController pushViewController:friendAddController animated:NO];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 37;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.friendInfoController == nil) {
        self.friendInfoController = [[FriendInfoController alloc] init];
    }
    [self.navigationController pushViewController:self.friendInfoController animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
