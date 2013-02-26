//
//  CategoryTableView.m
//  youli
//
//  Created by apple on 11/27/12.
//
//

#import "CategoryTableView.h"
#import "CategoryCell.h"
#import "Category.h"
#import "GiftListController.h"
#import "AppDelegate.h"

@implementation CategoryTableView{
@private
    NSArray *items;
}

@synthesize category;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    //初始化事件
    self.backgroundView=[self backgroundView];
    self.backgroundColor=[UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scrollEnabled=false;

    if (self) {
        [self setDelegate:self];
        [self setDataSource:self];
        category = [[Category alloc] init];
        [category loadData];
        items = category.items;
    }
    return self;
}

#pragma mark - Table view data source

-(UIView *)backgroundView
{
    UIImageView *categoryBgImage=[[UIImageView  alloc] initWithFrame:CGRectMake(0,0,212,460)];

    if(iPhone5)
    {
        categoryBgImage.frame=CGRectMake(0, 0, 212, 548);
        categoryBgImage.image = [UIImage imageNamed:@"gifttypebg.png"];
    }
    else
    {
        categoryBgImage.image = [UIImage imageNamed:@"gifttypebg460.png"];
    }

    return categoryBgImage;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 41;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategoryCell *cell = [[CategoryCell alloc] initCell:CellIdentifier];
    cell.category =  [items objectAtIndex:indexPath.row];
    return cell;
}

//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CategoryCell *cell = (CategoryCell*)[self cellForRowAtIndexPath:indexPath];
//    cell.labelImage.image = [UIImage imageNamed:@"selected.png"];
//    cell.nextImage.image = [UIImage imageNamed:@"pointerselect.png"];    
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CategoryCell *cell = (CategoryCell*)[self cellForRowAtIndexPath:indexPath];
//    cell.labelImage.image = [UIImage imageNamed:@"unselected.png"];
//    cell.nextImage.image = [UIImage imageNamed:@"pointerunselect.png"];
//}

@end
