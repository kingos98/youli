//
//  CategoryController.m
//  youli
//
//  Created by ufida on 13-3-6.
//
//

#import "CategoryController.h"
#import "AppDelegate.h"
#import "CategoryCell.h"

@interface CategoryController ()

@end

@implementation CategoryController
{
    @private
    NSArray *items;
}

@synthesize category;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView addObserver:self
                     forKeyPath:@"revealSideInset"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
    
    
    
    //初始化事件
    self.tableView.backgroundView=[self backgroundView];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled=false;
    
    category = [[Category alloc] init];
    [category loadData];
    items = category.items;
}

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//UIView *backgroundView

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategoryCell *cell = [[CategoryCell alloc] initCell:CellIdentifier];
    cell.category =  [items objectAtIndex:indexPath.row];
    return cell;
    

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.labelImage.image = [UIImage imageNamed:@"selected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerselect.png"];
}

@end
