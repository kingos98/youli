//
//  Birthday.m
//  youli
//
//  Created by ufida on 12-11-6.
//
//

#import "Birthday.h"
#import "FestivalMethod.h"
#import "FriendMethod.h"
#import "LocalNotificationsUtils.h"

@implementation Birthday

@synthesize items;
@synthesize name;
@synthesize date;
@synthesize type;
@synthesize countDown;


- (void)loadData:(NSString *)SearchName
{
//    NSArray *array = [[NSArray alloc] initWithObjects:
//             [NSArray arrayWithObjects:@"圣诞节",@"2012年12月25日 星期一",@"节日",nil],
//             [NSArray arrayWithObjects:@"元旦",@"2013年1月1日 星期二",@"节日",nil],
//             [NSArray arrayWithObjects:@"春节",@"2013年2月1日 星期四",@"节日",nil],
//             [NSArray arrayWithObjects:@"情人节",@"2013年2月14日 星期天",@"节日",nil],
//             [NSArray arrayWithObjects:@"元宵",@"2013年2月15日 星期一",@"节日",nil],
//             [NSArray arrayWithObjects:@"妇女节",@"2013年3月8日 星期五",@"节日",nil],
//             [NSArray arrayWithObjects:@"白色情人节",@"2013年3月14日 星期六",@"节日",nil],
//          nil];
//    
//    self.items = [NSMutableArray arrayWithCapacity:7];
//    
//    for (int i=0; i<7; i++) {
//        Birthday *birthday = [Birthday alloc];
//        birthday.name = [[array objectAtIndex:i] objectAtIndex:0];
//        [self.items addObject:birthday];
//    }
    self.items=[[NSMutableArray alloc]init];
    
    FriendMethod *friendMethod=[[FriendMethod alloc]init];
    NSMutableArray *friendArray=[friendMethod getFriendList:SearchName];

    FestivalMethod *festivalMethod=[[FestivalMethod alloc]init];
    NSMutableArray *festivalArray=[festivalMethod getTopSixFestivalList:SearchName];

    Birthday *birthday;
    
    if(friendArray.count>0)
    {
        NSInteger iCount=0;
        NSString *strCompareDate;
        
        if([[[friendArray objectAtIndex:0]objectAtIndex:1] intValue] <=[[[festivalArray objectAtIndex:0]objectAtIndex:1] intValue])
        {
            strCompareDate=[[friendArray objectAtIndex:0]objectAtIndex:1];
        }
        else
        {
            strCompareDate=[[festivalArray objectAtIndex:0]objectAtIndex:1];
        }
        
        //朋友数组记数
        NSInteger friendIndex=0;
        //节日数组记数
        NSInteger festivalIndex=0;
        
        //获取最近的生日或节日
        if([[[friendArray objectAtIndex:iCount]objectAtIndex:1] intValue]<=[[[festivalArray objectAtIndex:iCount]objectAtIndex:1]intValue])
        {
            birthday=[Birthday alloc];
            birthday.name=[[friendArray objectAtIndex:iCount]objectAtIndex:0];
            birthday.date=[self getDataFromString:[[friendArray objectAtIndex:iCount]objectAtIndex:1]];
            birthday.type=@"生日";
            birthday.countDown=[self getCountDownDayFromNow:[[friendArray objectAtIndex:iCount]objectAtIndex:1]];
            friendIndex++;
        }
        else
        {
            birthday=[Birthday alloc];
            birthday.name=[[festivalArray objectAtIndex:iCount]objectAtIndex:0];
            birthday.date=[self getDataFromString:[[festivalArray objectAtIndex:iCount]objectAtIndex:1]];
            birthday.type=@"节日";
            birthday.countDown=[self getCountDownDayFromNow:[[festivalArray objectAtIndex:iCount]objectAtIndex:1]];
            festivalIndex++;
        }
        [self.items addObject:birthday];
        iCount++;
        
        while (iCount<6) {
            if(friendArray.count>friendIndex)
            {
                if([[[friendArray objectAtIndex:friendIndex]objectAtIndex:1] intValue]<=[[[festivalArray objectAtIndex:festivalIndex]objectAtIndex:1]intValue])
                {
                    birthday=[Birthday alloc];
                    birthday.name=[[friendArray objectAtIndex:friendIndex]objectAtIndex:0];
                    birthday.date=[self getDataFromString:[[friendArray objectAtIndex:friendIndex]objectAtIndex:1]];
                    birthday.type=@"生日";
                    birthday.countDown=[self getCountDownDayFromNow:[[friendArray objectAtIndex:friendIndex]objectAtIndex:1]];
                    friendIndex++;
                }
                else
                {
                    birthday=[Birthday alloc];
                    birthday.name=[[festivalArray objectAtIndex:festivalIndex]objectAtIndex:0];
                    birthday.date=[self getDataFromString:[[festivalArray objectAtIndex:festivalIndex]objectAtIndex:1]];
                    birthday.type=@"节日";
                    birthday.countDown=[self getCountDownDayFromNow:[[festivalArray objectAtIndex:festivalIndex]objectAtIndex:1]];
                    festivalIndex++;
                }
            }
            else
            {
                birthday=[Birthday alloc];
                birthday.name=[[festivalArray objectAtIndex:festivalIndex]objectAtIndex:0];
                birthday.date=[self getDataFromString:[[festivalArray objectAtIndex:festivalIndex]objectAtIndex:1]];
                birthday.type=@"节日";
                birthday.countDown=[self getCountDownDayFromNow:[[festivalArray objectAtIndex:festivalIndex]objectAtIndex:1]];
                festivalIndex++;
            }
            
            [self.items addObject:birthday];
            iCount++;
        }
    }
    else
    {
        for (int i=0; i<festivalArray.count; i++) {
            Birthday *birthday=[Birthday alloc];
            birthday.name=[[festivalArray objectAtIndex:i]objectAtIndex:0];
            birthday.date=[self getDataFromString:[[festivalArray objectAtIndex:i]objectAtIndex:1]];
            birthday.type=@"节日";
            birthday.countDown=[self getCountDownDayFromNow:[[festivalArray objectAtIndex:i]objectAtIndex:1]];
            [self.items addObject:birthday];
        }
    }
}

-(NSString *)getDataFromString:(NSString *)FestivalDate
{
    NSRange rng = NSMakeRange(0, 4);
    NSString *strYear=[FestivalDate substringWithRange:rng];
    
    rng=NSMakeRange(4, 2);
    NSString *strMonth=[FestivalDate substringWithRange:rng];
    
    rng=NSMakeRange(6, 2);
    NSString *strDay=[FestivalDate substringWithRange:rng];
    
    
    NSDateComponents *comp=[[NSDateComponents alloc]init];
    NSDateComponents *weekdayComponents=[[NSDateComponents alloc]init];
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    [comp setYear:[strYear intValue]];
    [comp setMonth:[strMonth intValue]];
    [comp setDay:[strDay intValue]];
    
    NSDate *tmpDate=[calendar dateFromComponents:comp];
    weekdayComponents=[calendar components:NSWeekdayCalendarUnit fromDate:tmpDate];
    
    NSString *strWeekDay;
    switch (weekdayComponents.weekday) {
        case 1:
            strWeekDay=@"星期日";
            break;
        case 2:
            strWeekDay=@"星期一";
            break;
        case 3:
            strWeekDay=@"星期二";
            break;
        case 4:
            strWeekDay=@"星期三";
            break;
        case 5:
            strWeekDay=@"星期四";
            break;
        case 6:
            strWeekDay=@"星期五";
            break;
        case 7:
            strWeekDay=@"星期六";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@年%d月%d日 %@",strYear,[strMonth intValue],[strDay intValue],strWeekDay];
}

-(NSString *)getCountDownDayFromNow:(NSString *)FestivalDate
{
    NSRange rng = NSMakeRange(0, 4);
    NSString *strYear=[FestivalDate substringWithRange:rng];
    
    rng=NSMakeRange(4, 2);
    NSString *strMonth=[FestivalDate substringWithRange:rng];
    
    rng=NSMakeRange(6, 2);
    NSString *strDay=[FestivalDate substringWithRange:rng];
    
    NSDateComponents *comp=[[NSDateComponents alloc]init];
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [comp setYear:[strYear intValue]];
    [comp setMonth:[strMonth intValue]];
    [comp setDay:[strDay intValue]];
    
    NSDate *tmpDate=[calendar dateFromComponents:comp];
    
    comp=[calendar components:NSDayCalendarUnit fromDate:[NSDate date] toDate:tmpDate options:0];
    
    NSString *strReturnDay=[NSString stringWithFormat:@"%d",comp.day];
    return  strReturnDay;
}

-(void)setBirthdayNotifications
{
    FriendMethod *friendMethod=[[FriendMethod alloc]init];
    NSMutableArray *friendArray=[friendMethod getFriendList:nil];
    if(friendArray.count>0)
    {
        NSString *strname;
        NSDate *datebirthday;
        NSDate *dateseven;
        NSDate *datethree;
        NSDateComponents *comp;
        NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

        NSTimeInterval sevenDayAgo=0-7*24*60*60;
        NSTimeInterval threeDayAgo=0-3*24*60*60;
        
        for (int i=0; i<friendArray.count; i++)
        {    
            strname=[[friendArray objectAtIndex:i] objectAtIndex:0];
            datebirthday=[self changeDatetimeFromString:[[friendArray objectAtIndex:i] objectAtIndex:1]];

            //设置7天后通知提示
            comp=[calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[datebirthday dateByAddingTimeInterval:sevenDayAgo]];
            [comp setHour:8];
            [comp setMinute:0];
            [comp setSecond:0];
            dateseven=[calendar dateFromComponents:comp];
            [LocalNotificationsUtils addLocalNotificationWithFireDate:dateseven activityId:@"birthday" activityTitle:[NSString stringWithFormat:@"您的朋友[%@]将于7天后生日，赶紧选份礼物送给TA吧！",strname]];
            
            //设置3天后通知提示
            comp=[calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[datebirthday dateByAddingTimeInterval:threeDayAgo]];
            [comp setHour:8];
            [comp setMinute:0];
            [comp setSecond:0];
            datethree=[calendar dateFromComponents:comp];
            [LocalNotificationsUtils addLocalNotificationWithFireDate:datethree activityId:@"birthday" activityTitle:[NSString stringWithFormat:@"您的朋友[%@]将于3天后生日，赶紧选份礼物送给TA吧！",strname]];
        }
    }
}

-(NSDate *)changeDatetimeFromString:(NSString *)strFriendBirthday
{
    NSRange rng = NSMakeRange(0, 4);
    NSString *strYear=[strFriendBirthday substringWithRange:rng];
    
    rng=NSMakeRange(4, 2);
    NSString *strMonth=[strFriendBirthday substringWithRange:rng];
    
    rng=NSMakeRange(6, 2);  
    NSString *strDay=[strFriendBirthday substringWithRange:rng];

    NSDateComponents *comp=[[NSDateComponents alloc]init];
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [comp setYear:[strYear intValue]];
    [comp setMonth:[strMonth intValue]];
    [comp setDay:[strDay intValue]];
    
    NSDate *dateFriendBirthday=[calendar dateFromComponents:comp];

    return dateFriendBirthday;
}

@end
