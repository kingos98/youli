//
//  ConstellationSelector.m
//  youli
//
//  Created by sjun on 2/6/13.
//
//

#import "ConstellationSelector.h"

@interface ConstellationSelector (){
    CGRect selectionRect;
}

@end

@implementation ConstellationSelector

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.values  = [[NSArray alloc] initWithObjects:@"",@"",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座",@"",@"",nil];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.scrollEnabled=NO;
    }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else
    {
        UIView *contentSubV = [cell.contentView.subviews objectAtIndex:0];
        [contentSubV removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -11, self.frame.size.width, 33)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    label.textColor = [UIColor whiteColor];
    label.textAlignment =  NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"%@",[self.values objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
//}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    
//}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}

- (void)scrollToTheSelectedCell
{
    for (NSString *value in self.values)
    {
        if (value.length>1) {
            if ([value hasPrefix:self.selectedValue])
            {
                NSUInteger index = [self.values indexOfObject:value];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:index+2 inSection:0];            
                
                [self scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                break;
            }
        }
    }
}

@end
