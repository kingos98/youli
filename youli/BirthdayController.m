//
//  BirthdayController.m
//  youli
//
//  Created by jun on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BirthdayController.h"
#import "BirthdayCell.h"
#import "GiftListController.h"
#import "Birthday.h"

@implementation BirthdayController{
@private
    NSArray *items;
}

@synthesize birthdayTableView;
@synthesize birthday;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self iniView];
    
    self.birthdayGiftController=[[BirthdayGiftController alloc] init];
    self.delegate=self.birthdayGiftController;
    
    birthday = [[Birthday alloc] init];
    [birthday loadData];
    items = birthday.items;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)iniView
{ 
    UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    [mainBgView setImage:[UIImage imageNamed:@"bg.jpg"]];

    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    
    UIButton *btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,44,320,416)];
    [tableBgView setImage:[UIImage imageNamed:@"birthday_bg.png"]];
    
    birthdayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44,320,416)];
    [birthdayTableView setDelegate:self];
    [birthdayTableView setDataSource:self];
    [birthdayTableView setBackgroundColor:[UIColor clearColor]];
    [birthdayTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [birthdayTableView setBackgroundView:tableBgView];
    birthdayTableView.scrollEnabled=false;
    
    [self.view addSubview:mainBgView];
    [self.view addSubview:imgTitle];
    [self.view addSubview:btnReturn];
    [self.view addSubview:birthdayTableView];
}

- (IBAction)returnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BirthdayCell *cell = (BirthdayCell*)[self.birthdayTableView cellForRowAtIndexPath:indexPath];
    [self.delegate sendGiftTypeTitle:cell.nameLabel.text];
    [self.navigationController pushViewController:self.birthdayGiftController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 66;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    BirthdayCell *cell = [[BirthdayCell alloc] initCell:CellIdentifier];
    cell.birthday =  [items objectAtIndex:indexPath.row];
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
