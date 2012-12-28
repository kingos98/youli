//
//  Birthday.m
//  youli
//
//  Created by ufida on 12-11-6.
//
//

#import "Birthday.h"

@implementation Birthday

@synthesize items;
@synthesize name;
@synthesize date;
@synthesize type;
@synthesize countDown;

- (void)loadData{
    NSArray *array = [[NSArray alloc] initWithObjects:
             [NSArray arrayWithObjects:@"圣诞节",@"2012年12月25日 星期一",@"节日",nil],
             [NSArray arrayWithObjects:@"元旦",@"2013年1月1日 星期二",@"节日",nil],
             [NSArray arrayWithObjects:@"春节",@"2013年2月1日 星期四",@"节日",nil],
             [NSArray arrayWithObjects:@"情人节",@"2013年2月14日 星期天",@"节日",nil],
             [NSArray arrayWithObjects:@"元宵",@"2013年2月15日 星期一",@"节日",nil],
             [NSArray arrayWithObjects:@"妇女节",@"2013年3月8日 星期五",@"节日",nil],
             [NSArray arrayWithObjects:@"白色情人节",@"2013年3月14日 星期六",@"节日",nil],
          nil];
    
    self.items = [NSMutableArray arrayWithCapacity:7];
    
    for (int i=0; i<7; i++) {
        Birthday *birthday = [Birthday alloc];
        birthday.name = [[array objectAtIndex:i] objectAtIndex:0];
        [self.items addObject:birthday];
    }
}

@end
