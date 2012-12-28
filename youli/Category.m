//
//  Category.m
//  youli
//
//  Created by apple on 11/21/12.
//
//

#import "Category.h"

@implementation Category

@synthesize items;
@synthesize name;
@synthesize code;
@synthesize index;

- (void)loadData{
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSArray arrayWithObjects:@"生日礼物",@"1",nil],
                      [NSArray arrayWithObjects:@"纪念礼物",@"2",nil],
                      [NSArray arrayWithObjects:@"节日礼物",@"3",nil],
                      [NSArray arrayWithObjects:@"商务礼物",@"4",nil],
                      [NSArray arrayWithObjects:@"长辈送礼",@"5",nil],
                      nil];
    
    self.items = [NSMutableArray arrayWithCapacity:5];
    
    for (int i=0; i<5; i++) {
        Category *category = [Category alloc];
        category.name = [[array objectAtIndex:i] objectAtIndex:0];
        category.index=(int)[[array objectAtIndex:i] objectAtIndex:1];
        [self.items addObject:category];
    }
}

@end
