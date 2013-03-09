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
    return self;
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

@end
