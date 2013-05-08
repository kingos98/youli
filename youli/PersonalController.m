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
#import "BirthdayGiftController.h"
#import "FriendInfoController.h"
#import "Friend.h"
#import "AppDelegate.h"
#import "SubTableCell.h"
#import "UIFolderTableView.h"
#import "FriendAddController.h"
#import "CategoryCell.h"

@interface PersonalController ()
{
    @private
    UITableView *friendTable;                       //朋友列表
    UITableView *strangerTable;                     //陌生人列表
    CategoryTableView *categoryTableView;
    Category *category;
    NSMutableArray *giftTypeItems;                  //礼物分类数组
    
    NSMutableArray *friendItems;                    //朋友数组
    
    UILabel *birthdayLabel;
    UILabel *constellationLabel;
    
    BirthdayGiftController *birthdayGiftController;
    id<YouliDelegate> delegate;
}
@end

@implementation PersonalController

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
    UIButton *homeButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 7, 50, 30)];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"home_click.png"] forState:UIControlStateHighlighted];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"home_unclick.png"] forState:UIControlStateNormal];    
    [homeButton addTarget:self action:@selector(homeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIButton *addButton=[[UIButton alloc]initWithFrame:CGRectMake(250, 7, 60, 30)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_friend_1.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //个人信息
    UIImageView *personalInfoBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,53,300,69)];
    [personalInfoBgView setImage:[UIImage imageNamed:@"personal_info_bg.png"]];
    personalInfoBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveClick)];
    [personalInfoBgView addGestureRecognizer:singleTap];
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
    constellationLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 90, 110, 22)];
    constellationLabel.text = @"摩羯座";
    constellationLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    constellationLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    constellationLabel.textAlignment = UITextAlignmentLeft;
    constellationLabel.backgroundColor = [UIColor clearColor];
    UIImageView *birthdayView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 65, 21, 22)];
    [birthdayView setImage:[UIImage imageNamed:@"birthday_unselect.png"]];
    birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(242, 90, 100, 22)];
    birthdayLabel.text = @"1月1日";
    birthdayLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    birthdayLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    birthdayLabel.textAlignment = UITextAlignmentLeft;
    birthdayLabel.backgroundColor = [UIColor clearColor];
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(211, 55, 99, 69)];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"edit_button.png"] forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"edit_button.png"] forState:UIControlStateHighlighted];
    [self.editButton addTarget:self action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.subTableCell = [[SubTableCell alloc] initWithFrame:CGRectMake(10,122,300,200)];
    self.subTableCell.hidden = YES;
    
    //3个tab
    self.friendButton = [[UIButton alloc] initWithFrame:CGRectMake(10,122,99,40)];
    [self.friendButton setBackgroundImage:[UIImage imageNamed:@"friend_button_unselect.png"] forState:UIControlStateNormal];
    [self.friendButton setImage:[UIImage imageNamed:@"friend_button_select.png"] forState:UIControlStateSelected];
    [self.friendButton addTarget:self action:@selector(friendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.friendButton.selected = YES;    
    self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(110,122,100,40)];
    [self.collectButton setBackgroundImage:[UIImage imageNamed:@"collect_unselect.png"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"collect_select.png"] forState:UIControlStateSelected];
    [self.collectButton addTarget:self action:@selector(collectButtonPressed) forControlEvents:UIControlEventTouchUpInside];    
    self.strangerButton = [[UIButton alloc] initWithFrame:CGRectMake(210,122,100,40)];
    [self.strangerButton setBackgroundImage:[UIImage imageNamed:@"sms_unclick.png"] forState:UIControlStateNormal];
    [self.strangerButton setImage:[UIImage imageNamed:@"sms_click.png"] forState:UIControlStateSelected];
    [self.strangerButton addTarget:self action:@selector(strangerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    //朋友添加信息提示条
//    self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *personalPromptBgView = [[UIImage imageNamed:@"personal_prompt_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//    self.messageButton.frame = CGRectMake(10,165,300,31);
//    [self.messageButton setBackgroundImage:personalPromptBgView forState:UIControlStateNormal];
//    [self.messageButton addTarget:self action:@selector(messageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    if (self.messageArray.count>0) {
//        for (Friend *friend in self.messageArray) {
//            
//        }
//    }    
    
    friendTable=[[UIFolderTableView alloc] initWithFrame:CGRectMake(10, 165, 300, kHEIGHT-221)];
    
    //没新消息时遮盖住提示条
//    if (self.messageArray.count==0) {
//        self.friendTable.frame = CGRectMake(10, 204-38, 300, 308);
//    }
    [friendTable setDelegate:self];
    [friendTable setDataSource:self];
    [friendTable setBackgroundColor:[UIColor whiteColor]];
    

    //收藏与已购两个tab的图片容器
//    self.collectView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 154, 300, 344)];
    self.collectView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 154, 300, kHEIGHT-136)];
//    self.cartView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 154, 300, 344)];

    strangerTable=[[UIFolderTableView alloc] initWithFrame:CGRectMake(10, 165, 300, kHEIGHT-221)];
    [strangerTable setDelegate:self];
    [strangerTable setDataSource:self];
    [strangerTable setBackgroundColor:[UIColor whiteColor]];
    
    categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, kHEIGHT-20)];
    
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    category = [[Category alloc] init];
    [category loadData];                        //load分类列表
    giftTypeItems = category.items;

    friendItems=[self loadFriend];
    
    birthdayGiftController=[[BirthdayGiftController alloc]init];
    delegate=birthdayGiftController;
    
    [self.view addSubview:categoryTableView];
    [mainView addSubview:mainBgView];
    [mainView addSubview:imgTitle];
    [mainView addSubview:homeButton];
    [mainView addSubview:addButton];
    [mainView addSubview:personalInfoBgView];
    [mainView addSubview:faceBgView];
    [mainView addSubview:faceView];
    [mainView addSubview:nameLabel];
    [mainView addSubview:constellationView];
    [mainView addSubview:constellationLabel];
    [mainView addSubview:birthdayView];
    [mainView addSubview:birthdayLabel];
    [mainView addSubview:self.editButton]; 
    [mainView addSubview:self.friendButton];
    [mainView addSubview:self.collectButton];
    [mainView addSubview:self.strangerButton];
    [mainView addSubview:friendTable];
    [mainView addSubview:self.subTableCell];
}

- (NSMutableArray*)loadFriend
{
    return [[Friend getInstance] findByIsAdd];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==friendTable)
    {
//        return 24;
        return friendItems.count;
    }
    else
    {
        return giftTypeItems.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==friendTable)
    {
    	return 37;
    }
    else
    {
        return 41;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==friendTable) {
        static NSString *CellIdentifier = @"CellIdentifier";
        PersonalCell *cell = [[PersonalCell alloc] initCell:CellIdentifier];
//        if (self.items.count>0) {
//            cell.friend =  [self.items objectAtIndex:indexPath.row];
//        }
        if(friendItems.count>0)
        {
            cell.friend=[friendItems objectAtIndex:indexPath.row];
        }
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        CategoryCell *cell = [[CategoryCell alloc] initCell:CellIdentifier];
        cell.category =  [giftTypeItems objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==friendTable)
    {
        if (self.friendInfoController == nil) {
            self.friendInfoController = [[FriendInfoController alloc] init];
        }
        [self.navigationController pushViewController:self.friendInfoController animated:YES];
    }
    else
    {
        CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];

        [delegate sendGiftTypeTitle:cell.nameLabel.text IsFromIndexPage:NO];
        
        [self.navigationController pushViewController:birthdayGiftController animated:YES];
        
        cell.labelImage.image = [UIImage imageNamed:@"selected.png"];
        cell.nextImage.image = [UIImage imageNamed:@"pointerselect.png"];
        
        [self hideCategoryView];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==categoryTableView)
    {
        CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
        cell.labelImage.image = [UIImage imageNamed:@"unselected.png"];
        cell.nextImage.image = [UIImage imageNamed:@"pointerunselect.png"];
    }
}

- (void)homeButtonPressed
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)addButtonPressed
{
    FriendAddController *friendAddController = [[FriendAddController alloc] init];
    [self.navigationController pushViewController:friendAddController animated:NO];
}

- (void)editButtonPressed
{
    if(!self.subTableCell.hidden)
    {
        [self saveClick];
    }
    else
    {
        self.subTableCell.hidden = NO;
    }
}

- (void)saveClick
{
    birthdayLabel.text=[NSString stringWithFormat:@"%@%@",self.subTableCell.selectedMonth,self.subTableCell.selectedDay];
    constellationLabel.text=[NSString stringWithFormat:@"%@座",self.subTableCell.selectedConstellation];
    self.subTableCell.hidden = YES;
}

- (void)friendButtonPressed
{
    self.friendButton.selected = YES;
    self.collectButton.selected = NO;
    self.strangerButton.selected = NO;
    
    friendTable.hidden = NO;
    self.collectView.hidden = YES;
    strangerTable.hidden = YES;
}

- (void)collectButtonPressed
{
    self.friendButton.selected = NO;
    self.collectButton.selected = YES;
    self.strangerButton.selected = NO;
    
    friendTable.hidden = YES;
    strangerTable.hidden = YES;
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

- (void)strangerButtonPressed
{
    self.friendButton.selected = NO;
    self.collectButton.selected = NO;
    self.strangerButton.selected = YES;

    friendTable.hidden = YES;
    self.collectView.hidden = YES;
    strangerTable.hidden = NO;
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
