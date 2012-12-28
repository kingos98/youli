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

@interface PersonalController ()

@end

@implementation PersonalController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    [mainBgView setImage:[UIImage imageNamed:@"bg.jpg"]];
    
    UIImageView *personalInfoBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,9,300,69)];
    [personalInfoBgView setImage:[UIImage imageNamed:@"personal_info_bg.png"]];
    
    UIImageView *faceBgView = [[UIImageView alloc] initWithFrame:CGRectMake(16,15,57,59)];
    [faceBgView setImage:[UIImage imageNamed:@"face_bg.png"]];
    
    UIImageView *faceView = [[UIImageView alloc] initWithFrame:CGRectMake(19,17,51,52)];
    [faceView setImage:[UIImage imageNamed:@"icon.jpeg"]];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 24, 90, 22)];
    nameLabel.text = @"天空之城";
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    nameLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *constellationView = [[UIImageView alloc] initWithFrame:CGRectMake(87,48,16,17)];
    [constellationView setImage:[UIImage imageNamed:@"constellation.png"]];
    
    UILabel *constellationLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 46, 110, 22)];
    constellationLabel.text = @"请选择星座";
    constellationLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    constellationLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    constellationLabel.textAlignment = UITextAlignmentLeft;
    constellationLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *birthdayView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 21, 21, 22)];
    [birthdayView setImage:[UIImage imageNamed:@"birthday_unselect.png"]];
    
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 46, 100, 22)];
    birthdayLabel.text = @"请填写生日";
    birthdayLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    birthdayLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    birthdayLabel.textAlignment = UITextAlignmentLeft;
    birthdayLabel.backgroundColor = [UIColor clearColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarLeftImageTmp = [[UIImage imageNamed:@"collect_unselect.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    leftButton.frame = CGRectMake(10,78,100,41);
    [leftButton setBackgroundImage:tabBarLeftImageTmp forState:UIControlStateNormal];
    
    UIButton *middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarMiddleImage = [[UIImage imageNamed:@"cart_unselect.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    middleButton.frame = CGRectMake(110,78,100,41);
    [middleButton setBackgroundImage:tabBarMiddleImage forState:UIControlStateNormal];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *tabBarRightImageTmp = [[UIImage imageNamed:@"friend_button_select.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    rightButton.frame = CGRectMake(210,78,100,41);
    [rightButton setBackgroundImage:tabBarRightImageTmp forState:UIControlStateNormal];
    
    UIImageView *personalPromptBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,121,300,31)];
    [personalPromptBgView setImage:[UIImage imageNamed:@"personal_prompt_bg.png"]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 160, 300, 220)];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    
    [mainView addSubview:mainBgView];
    [mainView addSubview:personalInfoBgView];
    [mainView addSubview:faceBgView];
    [mainView addSubview:faceView];
    [mainView addSubview:nameLabel];
    [mainView addSubview:constellationView];
    [mainView addSubview:constellationLabel];
    [mainView addSubview:birthdayView];
    [mainView addSubview:birthdayLabel];
    [mainView addSubview:leftButton];
    [mainView addSubview:middleButton];
    [mainView addSubview:rightButton];
    [mainView addSubview:personalPromptBgView];
    [mainView addSubview:tableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfoController *friendInfoController = [[FriendInfoController alloc] init];
    [self.navigationController pushViewController:friendInfoController animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 37;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[PersonalCell alloc] init];
    return cell;
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
