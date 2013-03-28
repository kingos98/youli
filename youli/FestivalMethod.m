//
//  FestivalMethod.m
//  youli
//
//  Created by ufida on 13-1-23.
//
//

#define TABLEFESTIVALLIST       @"FestivalList"
#define TABLEFESTIVALLISTDATE   @"FestivalListDate"
#define ISLUNAR                 @"Islunar"
#define FESTIVALID              @"FestivalID"
#define FESTIVALNAME            @"FestivalName"
#define FESTIVALDATE            @"FestivalDate"

#import "FestivalMethod.h"
#import "FMDatabaseOper.h"
#import "FestivalListDateModel.h"
#import "DbUtils.h"

@implementation FestivalMethod

-(void)checkFestivalIsExist
{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comp=[calendar components:unitFlags fromDate:[NSDate date]];
    
    if(![FestivalListDateModel checkIsExistFestivalIsYear:comp.year])
    {
        [self writeFestivalToDB:comp.year];
    }
    
    NSInteger nextYear=comp.year+1;
    if(![FestivalListDateModel checkIsExistFestivalIsYear:nextYear])
    {
        [self writeFestivalToDB:nextYear];
    }
}

-(void)writeFestivalToDB:(NSInteger)Year
{
//    FMDatabaseOper *dbOper=[[FMDatabaseOper alloc] init] ;
    NSMutableArray *festivalArray=[[NSMutableArray alloc]init];
    NSArray *singleFestival=nil;
    
    NSString *strSql=[NSString stringWithFormat: @"select * from %@ where %@=0",TABLEFESTIVALLIST,ISLUNAR];
    
//    NSMutableArray *GregorianArray=[dbOper getFeFestivalInfo:strSql];    //记录当年节日的信息
    NSMutableArray *GregorianArray=[FestivalListDateModel getFeFestivalInfo:strSql];
    
    if(GregorianArray!=nil)
    {
        if(GregorianArray.count>0)
        {
            for(int i=0;i<GregorianArray.count;i++)
            {
                FestivalListDateModel *festivalListDateModel=(FestivalListDateModel *)[GregorianArray objectAtIndex:i];
//                singleFestival=[[NSArray alloc] initWithObjects:[[GregorianArray objectAtIndex:i] objectAtIndex:0],
//                                                                [NSString stringWithFormat:@"%4d%@",Year, [[GregorianArray objectAtIndex:i] objectAtIndex:1]],
//                                                                nil];
                singleFestival=[[NSArray alloc]initWithObjects:festivalListDateModel.festivalName,
                                [NSString stringWithFormat:@"%4d%@",Year, festivalListDateModel.festivalDate],nil];

                [festivalArray addObject:singleFestival];
            }
        }
    }
    
    strSql=[NSString stringWithFormat:@"select * from %@ where %@=1",TABLEFESTIVALLIST,ISLUNAR];
//    NSMutableArray *LunarArray=[dbOper getFeFestivalInfo:strSql];       //农历节日数组
    NSMutableArray *LunarArray=[FestivalListDateModel getFeFestivalInfo:strSql];

    NSArray *SingleLunar=nil;
    
    //找出当年对应农历节日的日期
    NSCalendar *gregorian=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    //初始化日期 xxxx0101
    NSDateComponents *comp=[[NSDateComponents alloc]init];
    [comp setYear:Year];
    [comp setMonth:1];
    [comp setDay:1];
    NSDate *date=[gregorian dateFromComponents:comp];
    
    NSTimeInterval  interval = 24*60*60;
    
    //农历日期转新历日期临时变量
    NSString *dayLunarToGregorina;
    
    for (int i=1; i<365; i++)
    {
        NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
        
        for (int LunarCount=0 ; LunarCount<LunarArray.count; LunarCount++)
        {
            //判断当天是不是农历节日       参考getChineseCalendarWithDate
            dayLunarToGregorina=[NSString stringWithFormat:@"%@%@",[self updateDateFormat:localeComp.month],[self updateDateFormat:localeComp.day]];
            
            FestivalListDateModel *festivalListDateModel=(FestivalListDateModel *)[LunarArray objectAtIndex: LunarCount];
            
//            if([dayLunarToGregorina isEqualToString:[[LunarArray objectAtIndex:LunarCount] objectAtIndex:1]])
            if([dayLunarToGregorina isEqualToString:festivalListDateModel.festivalDate])
            {
                NSDateComponents *gregorianDay=[gregorian components:unitFlags fromDate:date];
                SingleLunar=[[NSArray alloc]  initWithObjects:festivalListDateModel.festivalName,
                                                                [NSString stringWithFormat:@"%4d%@%@",
                                                                 Year,
                                                                 [self updateDateFormat:gregorianDay.month],
                                                                 [self updateDateFormat:gregorianDay.day]],nil];
                [festivalArray addObject:SingleLunar];
            }
        }
        //日期自增1
        date=[NSDate dateWithTimeInterval:interval sinceDate:date];
    }
    
    //添加特别节日
    singleFestival=[[NSArray alloc] initWithObjects:@"母亲节",
                    [self findSpecialDate:Year Month:5 WeekDay:1 WhichWeek:2],
                    nil];
    [festivalArray addObject:singleFestival];
    
    singleFestival=[[NSArray alloc] initWithObjects:@"父亲节",
                    [self findSpecialDate:Year Month:6 WeekDay:1 WhichWeek:3],
                    nil];
    [festivalArray addObject:singleFestival];
    
    singleFestival=[[NSArray alloc] initWithObjects:@"感恩节",
                    [self findSpecialDate:Year Month:11 WeekDay:1 WhichWeek:4],
                    nil];
    [festivalArray addObject:singleFestival];
    
    singleFestival=[[NSArray alloc] initWithObjects:@"复活节",
                    [self getEasterDay:Year],
                    nil];
    [festivalArray addObject:singleFestival];

    NSInteger maxFestivalID=[FestivalListDateModel getMaxFestivalIDFromFestivalListDate];
    
    for (int i=0; i<festivalArray.count; i++) {
        strSql=[NSString stringWithFormat:
                @"insert into %@ (%@,%@,%@) values(%d,'%@','%@')",
                TABLEFESTIVALLISTDATE,FESTIVALID,FESTIVALNAME,FESTIVALDATE,
                i+maxFestivalID+1,[[festivalArray objectAtIndex:i]objectAtIndex:0],[[festivalArray objectAtIndex:i]objectAtIndex:1]
                ];
        
        [DbUtils ExecSql:strSql];
        
        maxFestivalID++;
    }
}

-(NSMutableArray *)getTopSixFestivalList:(NSString *)FestivalName
{
//    FMDatabaseOper *dbOper=[[FMDatabaseOper alloc]init];
//    return [dbOper getFestivalList:FestivalName];    
    return [FestivalListDateModel getFestivalList:FestivalName];
}

-(NSString *)updateDateFormat:(NSInteger)MonthOrDay
{
    NSString *strMonthOrDay=[NSString stringWithFormat:@"%d",MonthOrDay];
    if(strMonthOrDay.length==1)
    {
        return [NSString stringWithFormat:@"0%@",strMonthOrDay];
    }
    else
    {
        return strMonthOrDay;
    }
}

-(NSString *)findSpecialDate:(int)Year Month:(int)Month WeekDay:(int)WeekDay WhichWeek:(int)WhichWeek
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSDateComponents *weekdayComponents=[[NSDateComponents alloc]init];
    NSDateComponents *weekdayComponents;
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date;

    NSInteger i;
    for(i=1;i<=7;i++)
    {
        //日期初始化为 xxxx0501
        [comps setDay:i];
        [comps setMonth:Month];
        [comps setYear:Year];
        
        date=[calendar dateFromComponents:comps];
        weekdayComponents=[calendar components:NSWeekdayCalendarUnit fromDate:date];
        
        if(weekdayComponents.weekday==WeekDay)
        {
            break;
        }
    }
    
    return [NSString stringWithFormat:@"%4d%@%@",Year,[self updateDateFormat:Month],[self updateDateFormat:(i+7*(WhichWeek-1))]];
}

-(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    
    
    return chineseCal_str;
}

//获取复活节日期
-(NSString *)getEasterDay:(NSInteger)Year
{
//    NO.1 设要求的那一年是Y年，从Y减去1900，其差记为N；
//    NO.2 用19作除数去除N，余数记为A；
//    NO.3 用4作除数去除N，不管余数，把商记为Q；
//    NO.4 用19去除7A+1，把商记为B，不管余数；
//    NO.5 用29去除11A+4-B，余数记为M；
//    NO.6 用7去除N+Q+31-M，余数记为W；
//    NO.7 计算25-M-W。
//    得出答数即可定出复活节的日期。若为正数，月份为4月；如为负数，月份为3月；若为0，则为3月31日。
    
    NSInteger n = Year-1900;
    NSInteger a=fmod(n,19);
    NSInteger q = n/4;
    NSInteger b = (7*a+1)/19;
    NSInteger m = fmod(11*a+4-b,29);
    NSInteger w = fmod(n+q+31-m,7);
    NSInteger d = 25-m-w;
    
    NSString *strDate=nil;
    if(d>0)
    {
        strDate=[NSString stringWithFormat:@"%4d04%2d",Year,d];
    }
    else if(d<0)
    {
        strDate=[NSString stringWithFormat:@"%4d03%2d",Year,31+d];
    }
    else
    {
        strDate=[NSString stringWithFormat:@"%4d0331",Year];
    }
    
    return strDate;
}
@end
