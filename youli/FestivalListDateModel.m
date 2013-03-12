//
//  FestivalListDateModel.m
//  youli
//
//  Created by ufida on 13-3-12.
//
//
#define TABLEFESTIVALLISTDATE       @"FestivalListDate"
#define FESTIVALID                  @"FestivalID"
#define FESTIVALNAME                @"FestivalName"
#define FESTIVALDATE                @"FestivalDate"


#import "FestivalListDateModel.h"
#import "DbUtils.h"
#import "AppDelegate.h"

static FestivalListDateModel *instance=nil;

@implementation FestivalListDateModel

@synthesize festivalID;
@synthesize festivalName;
@synthesize festivalDate;

+ (FestivalListDateModel *)getInstance{
    if (instance == nil)
    {
        instance = [[FestivalListDateModel alloc] init];
    }
    return instance;
}

//获取节日信息
+ (NSMutableArray *)getFeFestivalInfo:(NSString *)Sql
{
    if(![[DbUtils getInstance].fmDatabase open])
    {
        return nil;
    }
    
    NSMutableArray *festivalArray=[[NSMutableArray alloc]init];
    FestivalListDateModel *festivalListDateModel;
    
    FMResultSet *rs = [[DbUtils getInstance].fmDatabase executeQuery:Sql];
    
    while ([rs next]) {
        festivalListDateModel=[FestivalListDateModel alloc];
        festivalListDateModel.festivalID=[rs intForColumn:FESTIVALID];
        festivalListDateModel.festivalName=[rs stringForColumn:FESTIVALNAME];
        festivalListDateModel.festivalDate=[rs stringForColumn:FESTIVALDATE];
        
        [festivalArray addObject: festivalListDateModel];
    }
    
    [[DbUtils getInstance].fmDatabase close];
    
    return  festivalArray;
}

//获取FestivalListDate里最大的GiftID
+ (NSInteger)getMaxFestivalIDFromFestivalListDate
{
    if(![[DbUtils getInstance].fmDatabase open])
    {
        return 0;
    }
    
    NSInteger maxFestivalID=0;
    
    NSString *strSql=[NSString stringWithFormat:@"select %@ from %@ order by %@ desc limit 1",FESTIVALID,TABLEFESTIVALLISTDATE,FESTIVALID];

    FMResultSet *rs = [[DbUtils getInstance].fmDatabase executeQuery:strSql];

    while ([rs next]) {
        maxFestivalID=[rs intForColumnIndex:0];
    }

    [[DbUtils getInstance].fmDatabase close];
    
    return  maxFestivalID;
}


+ (BOOL)checkIsExistFestivalIsYear:(NSInteger)SelectYear
{
    if(![[DbUtils getInstance].fmDatabase open])
    {
        return false;
    }
    
    NSInteger resultCount=0;
    NSString *strSql=[NSString stringWithFormat:@"select count(*) from %@ where %@ like '%d%%'",TABLEFESTIVALLISTDATE,FESTIVALDATE,SelectYear];
    FMResultSet *rs=[[DbUtils getInstance].fmDatabase executeQuery:strSql];
    
    while ([rs next]) {
        resultCount=[rs intForColumnIndex:0];
    }
    [[DbUtils getInstance].fmDatabase close];
    
    return resultCount>0?true:false;
}

//获取从当天起的6个节日信息
+ (NSMutableArray *)getFestivalList:(NSString *)FestivalName
{
    if(![[DbUtils getInstance].fmDatabase open])
    {
        return nil;
    }
    
    //把当日日期转换成NSDateComponents
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comp=[calendar components:unitFlags fromDate:[NSDate date]];
    NSString *strCurrentDate=[NSString stringWithFormat:@"%d%@%@",comp.year,[self updateDateFormat:comp.month],[self updateDateFormat:comp.day]];
    
    NSMutableArray *festivalArray=[[NSMutableArray alloc]init];
    NSArray *singleFestival=nil;
    NSString *strSql;
    if(FestivalName!=nil)
    {
        if(!iPhone5)
        {
            strSql=[NSString stringWithFormat:@"select * from %@ where %@>%@ and %@ like '%%%@%%' order by %@ limit 1,6",
                    TABLEFESTIVALLISTDATE,FESTIVALDATE,strCurrentDate,FESTIVALNAME,FestivalName,FESTIVALDATE];
        }
        else
        {
            strSql=[NSString stringWithFormat:@"select * from %@ where %@>%@ and %@ like '%%%@%%' order by %@ limit 1,7",
                    TABLEFESTIVALLISTDATE,FESTIVALDATE,strCurrentDate,FESTIVALNAME,FestivalName,FESTIVALDATE];
        }
    }
    else
    {
        if(!iPhone5)
        {
            strSql=[NSString stringWithFormat:@"select * from %@ where %@>%@ order by %@ limit 1,6",
                    TABLEFESTIVALLISTDATE,FESTIVALDATE,strCurrentDate,FESTIVALDATE];
        }
        else
        {
            strSql=[NSString stringWithFormat:@"select * from %@ where %@>%@ order by %@ limit 1,7",
                    TABLEFESTIVALLISTDATE,FESTIVALDATE,strCurrentDate,FESTIVALDATE];
        }
    }
    
    FMResultSet *rs=[[DbUtils getInstance].fmDatabase executeQuery:strSql];

    while ([rs next]) {
        singleFestival=[[NSArray alloc]initWithObjects:[rs stringForColumn:FESTIVALNAME],
                        [rs stringForColumn:FESTIVALDATE],
                        nil];
        
        [festivalArray addObject:singleFestival];
    }
    
    [[DbUtils getInstance].fmDatabase close];
    
    return  festivalArray;
}

+ (NSString *)updateDateFormat:(NSInteger)MonthOrDay
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
@end
