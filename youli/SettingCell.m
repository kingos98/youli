//
//  SettingCell.m
//  youli
//
//  Created by ufida on 13-3-19.
//
//

#import "SettingCell.h"
#import "SettingControler.h"
#import "Birthday.h"
#import "LocalNotificationsUtils.h"
#import "TTSwitch.h"

@implementation SettingCell
{
    @private
    SettingModel *_settingModel;
}


@synthesize settingModel=_settingModel;
@synthesize lblName;
@synthesize imgArrow;
@synthesize btnCleanCache;


- (id)initCell:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void)setSettingModel:(SettingModel *)settingModel
{
    if(settingModel.menuName==@"接收通知")
    {
        [self addNoficeMenu:settingModel];
    }
    else
    {
        [self addCommonMenu:settingModel];
    }
}

-(void)addNoficeMenu:(SettingModel *)menuItem
{
    lblName=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 200, 21)];
    lblName.text=menuItem.menuName;
    lblName.font = [UIFont fontWithName:@"Helvetica" size:17];
    lblName.textColor=[UIColor colorWithRed:87.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1];
    lblName.textAlignment = UITextAlignmentLeft;
    lblName.backgroundColor = [UIColor clearColor];

    TTSwitch *squareThumbSwitch = [[TTSwitch alloc] initWithFrame:CGRectMake(214, 8, 76, 28)];
    squareThumbSwitch.trackImage = [UIImage imageNamed:@"square-switch-track"];
    squareThumbSwitch.overlayImage = [UIImage imageNamed:@"square-switch-overlay"];
    squareThumbSwitch.thumbImage = [UIImage imageNamed:@"square-switch-thumb"];
    squareThumbSwitch.thumbHighlightImage = [UIImage imageNamed:@"square-switch-thumb-highlight"];
    squareThumbSwitch.trackMaskImage = [UIImage imageNamed:@"square-switch-mask"];
    squareThumbSwitch.thumbMaskImage = nil; // Set this to nil to override the UIAppearance setting
    squareThumbSwitch.thumbInsetX = -3.0f;
    squareThumbSwitch.thumbOffsetY = -3.0f; // Set this to -3 to compensate for shadow
    squareThumbSwitch.on=YES;
    [squareThumbSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
   
    [self.contentView addSubview:lblName];
    [self.contentView addSubview:squareThumbSwitch];
}

//switch切换选项
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn)
    {
        Birthday *birthday=[Birthday alloc];
        [birthday setBirthdayNotifications];
    }
    else
    {
        [LocalNotificationsUtils removeLocalNotificationWithActivityName:@"birthday"];
    }
}

-(void)addCommonMenu:(SettingModel *)menuItem
{
    lblName=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 200, 21)];
    lblName.text=menuItem.menuName;
    lblName.font = [UIFont fontWithName:@"Helvetica" size:17];
    lblName.textColor=[UIColor colorWithRed:87.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1];
    lblName.textAlignment = UITextAlignmentLeft;
    lblName.backgroundColor = [UIColor clearColor];
    
    imgArrow=[[UIImageView alloc]initWithFrame:CGRectMake(281, 15, 10, 17)];
    [imgArrow setImage:[UIImage imageNamed:@"setting_arrow.png"]];
    
    UIImageView *imgIcon;
    if(menuItem.menuName==@"新浪微博")
    {
        imgIcon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 24, 26)];
        imgIcon.image=[UIImage imageNamed:@"sina_on.png"];
        [self.contentView addSubview:imgIcon];
        [lblName setFrame:CGRectMake(44, 12, 200, 21)];
    }
    else if (menuItem.menuName==@"腾讯微博")
    {
        imgIcon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 24, 26)];
        imgIcon.image=[UIImage imageNamed:@"tencent_on.png"];
        [self.contentView addSubview:imgIcon];
        [lblName setFrame:CGRectMake(44, 12, 200, 21)];
    }
    else if(menuItem.menuName==@"人人网")
    {
        imgIcon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 24, 26)];
        imgIcon.image=[UIImage imageNamed:@"ren_on.png"];
        [self.contentView addSubview:imgIcon];
        [lblName setFrame:CGRectMake(44, 12, 200, 21)];
    }
    else if (menuItem.menuName==@"QQ空间")
    {
        imgIcon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 24, 26)];
        imgIcon.image=[UIImage imageNamed:@"zone_on.png"];
        [self.contentView addSubview:imgIcon];
        [lblName setFrame:CGRectMake(44, 12, 200, 21)];
    }
    
    [self.contentView addSubview:lblName];
    [self.contentView addSubview:imgArrow];
}
@end
