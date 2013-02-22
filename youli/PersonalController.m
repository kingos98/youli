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
    
    UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,548)];
    [mainBgView setImage:[UIImage imageNamed:@"bg.png"]];
    //导航条
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    UIButton *btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn setImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [btnReturn addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
    //个人信息
    UIImageView *personalInfoBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,53,300,69)];
    [personalInfoBgView setImage:[UIImage imageNamed:@"personal_info_bg.png"]];
    UIImageView *faceBgView = [[UIImageView alloc] initWithFrame:CGRectMake(16,59,57,59)];
    [faceBgView setImage:[UIImage imageNamed:@"face_bg.png"]];
    UIImageView *faceView = [[UIImageView alloc] initWithFrame:CGRectMake(19,61,51,52)];
    [faceView setImage:[UIImage imageNamed:@"icon.jpeg"]];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 66, 90, 22)];
    nameLabel.text = @"天空之城";
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    nameLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    UIImageView *constellationView = [[UIImageView alloc] initWithFrame:CGRectMake(87,92,16,17)];
    [constellationView setImage:[UIImage imageNamed:@"constellation.png"]];
    UILabel *constellationLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 90, 110, 22)];
    constellationLabel.text = @"摩羯座";
    constellationLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    constellationLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    constellationLabel.textAlignment = UITextAlignmentLeft;
    constellationLabel.backgroundColor = [UIColor clearColor];
    UIImageView *birthdayView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 65, 21, 22)];
    [birthdayView setImage:[UIImage imageNamed:@"birthday_unselect.png"]];
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(242, 90, 100, 22)];
    birthdayLabel.text = @"1月1日";
    birthdayLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    birthdayLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    birthdayLabel.textAlignment = UITextAlignmentLeft;
    birthdayLabel.backgroundColor = [UIColor clearColor];
    //3个tab
    self.friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *friendImage = [[UIImage imageNamed:@"friend_button_unselect.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    self.friendButton.frame = CGRectMake(10,122,99,40);
    [self.friendButton setBackgroundImage:friendImage forState:UIControlStateNormal];
    [self.friendButton setImage:[UIImage imageNamed:@"friend_button_select.png"] forState:UIControlStateSelected];
    [self.friendButton addTarget:self action:@selector(friendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.friendButton.selected = YES;
    
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *collectImage = [[UIImage imageNamed:@"collect_unselect.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    self.collectButton.frame = CGRectMake(110,122,100,40);
    [self.collectButton setBackgroundImage:collectImage forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"collect_select.png"] forState:UIControlStateSelected];
    [self.collectButton addTarget:self action:@selector(collectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cartImage = [[UIImage imageNamed:@"cart_unselect.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    self.cartButton.frame = CGRectMake(210,122,101,40);
    [self.cartButton setBackgroundImage:cartImage forState:UIControlStateNormal];
    [self.cartButton setImage:[UIImage imageNamed:@"cart_select.png"] forState:UIControlStateSelected];
    [self.cartButton addTarget:self action:@selector(cartButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *personalPromptBgView = [[UIImage imageNamed:@"add_friend.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    self.addButton.frame = CGRectMake(10,165,300,31);
    [self.addButton setBackgroundImage:personalPromptBgView forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.friendTable = [[UIFolderTableView alloc] initWithFrame:CGRectMake(10, 204, 300, 220)];
    if(iPhone5){
        self.friendTable.frame = CGRectMake(10, 204, 300, 308);
    }
    [self.friendTable setDelegate:self];
    [self.friendTable setDataSource:self];
    [self.friendTable setBackgroundColor:[UIColor whiteColor]];
    //收藏与已购两个tab的图片容器
    self.collectView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 154, 300, 344)];
    self.cartView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 154, 300, 344)];
    
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
    [mainView addSubview:self.friendButton];
    [mainView addSubview:self.collectButton];
    [mainView addSubview:self.cartButton];
    [mainView addSubview:self.addButton];
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
    self.friendButton.selected = YES;
    self.collectButton.selected = NO;
    self.cartButton.selected = NO;

    self.addButton.hidden = NO;
    self.friendTable.hidden = NO;
    self.collectView.hidden = YES;
    self.cartView.hidden = YES;
}

- (void)collectButtonPressed
{
    self.friendButton.selected = NO;
    self.collectButton.selected = YES;
    self.cartButton.selected = NO;
    
    self.addButton.hidden = YES;
    self.friendTable.hidden = YES;
    self.cartView.hidden = YES;
    self.collectView.hidden = NO;
    
    for (int i=0; i<1; i++) {
        UIImageView *collectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 99, 98)];
        collectView.image = [UIImage imageNamed:@"collect_bg.png"];
        UIImageView *giftView = [[UIImageView alloc] initWithFrame:CGRectMake(3.6f, 3.4f, 92, 92)];
        giftView.image = [UIImage imageNamed:@"3.jpg"];
        [collectView addSubview:giftView];
        [self.collectView addSubview:collectView];
    }
    [mainView addSubview:self.collectView];
}

- (void)cartButtonPressed
{
    self.friendButton.selected = NO;
    self.collectButton.selected = NO;
    self.cartButton.selected = YES;
    
    self.addButton.hidden = YES;
    self.friendTable.hidden = YES;
    self.collectView.hidden = YES;
    self.cartView.hidden = NO;
    
    for (int i=0; i<1; i++) {
        UIImageView *collectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 99, 98)];
        collectView.image = [UIImage imageNamed:@"collect_bg.png"];
        UIImageView *giftView = [[UIImageView alloc] initWithFrame:CGRectMake(3.6f, 3.4f, 92, 92)];
        giftView.image = [UIImage imageNamed:@"3.jpg"];
        [collectView addSubview:giftView];
        [self.cartView addSubview:collectView];
    }
    [mainView addSubview:self.cartView];}

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
