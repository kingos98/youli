//
//  BirthdayController.m
//  youli
//
//  Created by jun on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BirthdayController.h"
#import "BirthdayCell.h"
#import "BirthdayCellNew.h"
#import "GiftListController.h"
#import "Birthday.h"

@implementation BirthdayController{
@private
    NSArray *items;
}

@synthesize birthday;
@synthesize delegate;
@synthesize birthdayTableView;
@synthesize assignBirthdayController;


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
    
    [self iniView];
    
    birthday = [[Birthday alloc] init];
    [birthday loadData:nil];
    items = birthday.items;

    self.assignBirthdayController=[[AssignBirthdayController alloc]init];
    self.delegate=self.assignBirthdayController;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)iniView
{ 
    UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,548)];
    [mainBgView setImage:[UIImage imageNamed:@"bg.png"]];

    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgTitle.image = [UIImage imageNamed:@"head.jpg"];
    
    UIButton *btnReturn=[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"return_unclick.png"] forState:UIControlStateNormal];
    [btnReturn setImage:[UIImage imageNamed:@"return_click.png"] forState:UIControlStateHighlighted];
    [btnReturn addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(60, 0, 260, 44)];
    searchBar.tintColor=[UIColor whiteColor];
    searchBar.delegate=self;
    //把键盘里的Search转成Done
    UITextField *searchField = [[searchBar subviews] lastObject];
    [searchField setReturnKeyType:UIReturnKeyDone];

    //<---背景图片
    UIView *segment = [searchBar.subviews objectAtIndex:0];
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 270, 44)];
    [bgImage setImage:[UIImage imageNamed:@"head.jpg"]];
    [segment addSubview: bgImage];
    //--->背景图片
    
//    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,44,320,416)];
//    [tableBgView setImage:[UIImage imageNamed:@"birthday_bg@2x.png"]];
    
    birthdayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44,320,416)];
    [birthdayTableView setDelegate:self];
    [birthdayTableView setDataSource:self];
    [birthdayTableView setBackgroundColor:[UIColor clearColor]];
    [birthdayTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [birthdayTableView setBackgroundView:tableBgView];
//    birthdayTableView.scrollEnabled=false;
    
    [self.view addSubview:mainBgView];
    [self.view addSubview:imgTitle];
    [self.view addSubview:btnReturn];
    [self.view addSubview:searchBar];
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
    [self.navigationController pushViewController:self.assignBirthdayController animated:YES];
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
//    BirthdayCell *cell = [[BirthdayCell alloc] initCell:CellIdentifier];
    BirthdayCellNew *cell=[[BirthdayCellNew alloc] initCell: CellIdentifier];
    if(items.count>0)
    {
        cell.birthday =  [items objectAtIndex:indexPath.row];
    }
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self dismissKeyboard:searchBar];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissKeyboard:searchBar];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    birthday = [[Birthday alloc] init];
    [birthday loadData:searchBar.text];
    items = birthday.items;
    [birthdayTableView reloadData];
}

-(void)dismissKeyboard:(UISearchBar *)sender
{
    [sender resignFirstResponder];
    [sender setShowsCancelButton:false animated:true];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:true animated:true];

    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *sbtn = (UIButton *)cc;
            [sbtn setTitle:@"" forState:UIControlStateNormal];
            [sbtn setBackgroundImage:[UIImage imageNamed:@"cancel_unclick.png"] forState:UIControlStateNormal];
            [sbtn setBackgroundImage:[UIImage imageNamed:@"cancel_click.png"] forState:UIControlStateHighlighted];
            [sbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}
@end
