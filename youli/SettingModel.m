//
//  SettingModel.m
//  youli
//
//  Created by ufida on 13-3-19.
//
//

#import "SettingModel.h"

@implementation SettingModel

@synthesize items;
@synthesize keyItems;
@synthesize menuGroup;
@synthesize menuName;

- (void)loadData{
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSArray arrayWithObjects:@"分享设置",@"新浪微博",nil],
                      [NSArray arrayWithObjects:@"分享设置",@"腾讯微博",nil],
                      [NSArray arrayWithObjects:@"分享设置",@"人人网",nil],
                      [NSArray arrayWithObjects:@"分享设置",@"QQ空间",nil],
                      [NSArray arrayWithObjects:@"通知设置",@"接收通知",nil],
                      [NSArray arrayWithObjects:@"其它设置",@"应用推荐",nil],
                      [NSArray arrayWithObjects:@"其它设置",@"新手指引",nil],                      
                      [NSArray arrayWithObjects:@"其它设置",@"给我评分",nil],
                      [NSArray arrayWithObjects:@"其它设置",@"意见反馈",nil],
                      [NSArray arrayWithObjects:@"其它设置",@"新版本检测",nil],
                      [NSArray arrayWithObjects:@"其它设置",@"关于",nil],
                      [NSArray arrayWithObjects:@"清除缓存的数据和图片",@"清除缓存",nil],                      
                      nil];
    
    
    self.items = [NSMutableArray arrayWithCapacity:5];
    for (int i=0; i<array.count; i++)
    {   
        SettingModel *ettingModel = [SettingModel alloc];
        ettingModel.menuGroup = [[array objectAtIndex:i] objectAtIndex:0];
        ettingModel.menuName=[[array objectAtIndex:i] objectAtIndex:1];
        [self.items addObject:ettingModel];
    }
    
    self.keyItems=[[NSArray alloc] initWithObjects:@"分享设置",@"通知设置",@"其它设置",@"清除缓存的数据和图片",nil];

}
@end
