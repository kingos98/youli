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

@interface BirthdayController ()

@end

@implementation BirthdayController{
@private
    NSArray *items;
}

@synthesize birthday;

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
    
    UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    [mainBgView setImage:[UIImage imageNamed:@"bg.jpg"]];
    
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,416)];
    [tableBgView setImage:[UIImage imageNamed:@"birthday_bg.png"]];
    
    UITableView *birthdayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,416)];
    [birthdayTableView setDelegate:self];
    [birthdayTableView setDataSource:self];
    [birthdayTableView setBackgroundColor:[UIColor clearColor]];
    [birthdayTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [birthdayTableView setBackgroundView:tableBgView];
    
    [self.view addSubview:mainBgView];
    [self.view addSubview:birthdayTableView];
    
    birthday = [[Birthday alloc] init];
    [birthday loadData];
    items = birthday.items;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GiftListController *giftListController = [[GiftListController alloc] init];
    [self.navigationController pushViewController:giftListController animated:NO];
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
