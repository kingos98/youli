//
//  FMDatabaseOper.m
//  youli
//
//  Created by ufida on 13-1-11.
//
//

#define DBNAME                      @"youli.sqlite"
#define TABLEBIRTHDAYGIFT           @"birthdaygift"
#define TABLECOLLECTBIRTHDAYGIFT    @"collectbirthdaygift"
#define TABLEFESTIVALLISTDATE       @"FestivalListDate"
#define TABLEFRIENDINFO             @"FriendInfo"

#define GIFTID                      @"giftid"
#define GIFTTYPE                    @"giftType"
#define GIFTTITLE                   @"Title"
#define GIFTDETAIL                  @"Detail"
#define GIFTIMAGEURL                @"imageURL"
#define GIFTTAOBAOURL               @"taobaoURL"
#define GIFTPRICE                   @"price"

#define FESTIVALID                  @"FestivalID"
#define FESTIVALNAME                @"FestivalName"
#define FESTIVALDATE                @"FestivalDate"

#define FRIENDNAME                  @"FriendName"
#define FRIENDBIRTHDAY              @"FriendBirthday"
#define FRIENDCONSTELLATION         @"Constellation"
#define FRIENDID                    @"FriendID"

#import "FMDatabaseOper.h"
#import "FMDatabase.h"
#import "AppDelegate.h"
@implementation FMDatabaseOper

-(Boolean)openDB
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];

    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];

    NSFileManager *fm=NULL;

    fm=[NSFileManager defaultManager];

    if ([fm fileExistsAtPath:dbPath]==NO)
    {
        NSString *dbPathApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBNAME];
        [fm copyItemAtPath:dbPathApp toPath:dbPath error:nil];
    }
    
//    NSString *dbPath = [[[NSBundle mainBundle] resourcePath]
//                        stringByAppendingPathComponent:DBNAME];
    
//    NSLog(dbPath);
    db = [FMDatabase databaseWithPath:dbPath] ;
    
    if (![db open]) {
        NSLog(@"Cound not open db.");
        return false;
    }
    
    return true;
}

-(void)closeDB
{
    [db close];
}

-(void)ExecSql:(NSString *)Sql
{
    if([self openDB])
    {
        [db executeUpdate:Sql];
        [self closeDB];
    }
}

#pragma mark - Birthday Gift Mothed

-(NSArray *)getGiftDetail:(NSInteger) GiftID
{
    if(![self openDB])
    {
        return nil;
    }
    
    NSArray *GiftArray=nil;
    
//    NSString *strSql= [NSString stringWithFormat:@"select * from birthdaygift where giftid=%d",GiftID];
    NSString *strSql= [NSString stringWithFormat:@"select * from %@ where %@=%d",TABLEBIRTHDAYGIFT,GIFTID,GiftID];

    FMResultSet *rs = [db executeQuery:strSql];

    while ([rs next]) {
        NSString *giftID=[rs stringForColumn:GIFTID];
        NSString *giftType=[rs stringForColumn:GIFTTYPE];
        NSString *giftTitle=[rs stringForColumn:GIFTTITLE];
        NSString *giftDetail=[rs stringForColumn:GIFTDETAIL];
        NSString *imageURL=[rs stringForColumn:GIFTIMAGEURL];
        NSString *taobaoURL=[rs stringForColumn:GIFTTAOBAOURL];
        double price=[rs doubleForColumn:GIFTPRICE];
         
        GiftArray=[[NSArray alloc]  initWithObjects:giftID,giftType,giftTitle,giftDetail,imageURL,taobaoURL, price,nil];
    }
    
    [self closeDB];
    return GiftArray;
}

//每次启动该APP就自动清空birthday list
-(void)cleanGiftList
{
    NSString *strSql=[NSString stringWithFormat:@"delete from %@",TABLEBIRTHDAYGIFT];
    [self ExecSql:strSql];
}

//获取礼物信息列表
-(NSMutableArray *)getGiftDetailList:(NSInteger)PhotoType
{
    if(![self openDB])
    {
        return nil;
    }
    
    NSMutableArray *GiftArray=[[NSMutableArray alloc] init];
    NSArray *GiftData=nil;
    
//    NSString *strSql= [NSString stringWithFormat:@"select * from birthdaygift where gifttype=%d",PhotoType];
    NSString *strSql=[NSString stringWithFormat:@"select * from %@ where %@=%d",TABLEBIRTHDAYGIFT,GIFTTYPE,PhotoType];

    FMResultSet *rs=[db executeQuery:strSql];

    while ([rs next]) {
        NSString *giftID=[rs stringForColumn:GIFTID];
        NSString *giftType=[rs stringForColumn:GIFTTYPE];
        NSString *giftTitle=[rs stringForColumn:GIFTTITLE];
        NSString *giftDetail=[rs stringForColumn:GIFTDETAIL];
        NSString *imageURL=[rs stringForColumn:GIFTIMAGEURL];
        NSString *taobaoURL=[rs stringForColumn:GIFTTAOBAOURL];
        NSString *price=[rs stringForColumn:GIFTPRICE];

        GiftData=[[NSArray alloc]  initWithObjects:giftID,giftType,giftTitle,giftDetail,imageURL,taobaoURL, price,nil];

        [GiftArray addObject: GiftData];
    }
    
    [self closeDB];
    if(GiftArray.count>0)
        return  GiftArray;
    else
        return  nil;
}

//获取当前选中的礼物所在位置
-(NSInteger)getSelectedGiftIndex:(NSInteger)GiftID
{
    if(![self openDB])
    {
        return 0;
    }
    
    NSInteger index=0;
    Boolean find=false;
//    FMResultSet *rs=[db executeQuery:@"select giftid from birthdaygift"];
    FMResultSet *rs=[db executeQuery:[NSString stringWithFormat: @"select %@ from %@",GIFTID,TABLEBIRTHDAYGIFT]];

    while ([rs next]) {
        if([rs intForColumn:GIFTID]==GiftID)
        {
            find=true;
            break;
        }
        else
        {
            index++;
        }
    }
    [self closeDB];
    
    return index;
}


//决断该礼物是否被收藏
-(Boolean)checkIsCollect:(NSInteger)GiftID
{
    Boolean find=false;
//    NSString *strSql=[NSString stringWithFormat:@"select count(*) count from collectbirthdaygift where giftid=%d",GiftID];
    NSString *strSql=[NSString stringWithFormat:@"select count(*) count from %@ where %@=%d",TABLECOLLECTBIRTHDAYGIFT,GIFTID,GiftID];
    FMResultSet *rs=[db executeQuery:strSql];
    while ([rs next]) {
        if([rs intForColumn:@"count"]>0)
        {
            find=true;
            break;
        }
    }
    return  find;
}

//添加/删除礼物
-(void)operGiftToCollection:(Boolean)IsAdd GiftID:(NSInteger)GiftID
{
    NSString *strSql;
    if(IsAdd)
    {
//        strSql=[NSString stringWithFormat:@"insert into collectbirthdaygift(giftid) values(%d)",GiftID];
        strSql=[NSString stringWithFormat:@"insert into %@(%@) values(%d)",TABLECOLLECTBIRTHDAYGIFT,GIFTID,GiftID];
    }
    else
    {
//        strSql=[NSString stringWithFormat:@"delete from collectbirthdaygift where giftid=%d",GiftID];
        strSql=[NSString stringWithFormat:@"delete from %@ where %@=%d",TABLECOLLECTBIRTHDAYGIFT,GIFTID,GiftID];
    }
    [self ExecSql:strSql];
}


#pragma mark - Festival Info Method
//获取节日信息
-(NSMutableArray *)getFeFestivalInfo:(NSString *)Sql
{
    if(![self openDB])
    {
        return nil;
    }
    
    NSMutableArray *festivalArray=[[NSMutableArray alloc]init];
    NSArray *festivalData=nil;

    FMResultSet *rs = [db executeQuery:Sql];
    
    while ([rs next]) {
        festivalData=[[NSArray alloc]  initWithObjects:[rs stringForColumn:FESTIVALNAME],
                                                        [rs stringForColumn:FESTIVALDATE],
                                                        nil];
        [festivalArray addObject: festivalData];
    }
    
    [self closeDB];
    
    return  festivalArray;
}

//获取FestivalListDate里最大的GiftID
-(NSInteger)getMaxFestivalIDFromFestivalListDate
{
    if(![self openDB])
    {
        return 0;
    }
    
    NSInteger maxFestivalID=0;
    
    FMResultSet *rs=[db executeQuery:[NSString stringWithFormat: @"select %@ from %@ order by %@ desc limit 1",FESTIVALID,TABLEFESTIVALLISTDATE,FESTIVALID]];

    while ([rs next]) {
        maxFestivalID=[rs intForColumnIndex:0];
    }
    [self closeDB];
    
    return  maxFestivalID;
}


-(BOOL)checkIsExistFestivalIsYear:(NSInteger)SelectYear
{
    if(![self openDB])
    {
        return false;
    }
    NSInteger resultCount=0;
    NSString *strSql=[NSString stringWithFormat:@"select count(*) from %@ where %@ like '%d%%'",TABLEFESTIVALLISTDATE,FESTIVALDATE,SelectYear];
    FMResultSet *rs=[db executeQuery:strSql];
    while ([rs next]) {
        resultCount=[rs intForColumnIndex:0];
    }
    [self closeDB];
    
    return resultCount>0?true:false;
}

//获取从当天起的6个节日信息
-(NSMutableArray *)getFestivalList:(NSString *)FestivalName
{
    if(![self openDB])
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
    
    FMResultSet *rs=[db executeQuery:strSql];
    while ([rs next]) {
        singleFestival=[[NSArray alloc]initWithObjects:[rs stringForColumn:FESTIVALNAME],
                        [rs stringForColumn:FESTIVALDATE],
                         nil];
        
        [festivalArray addObject:singleFestival];
    }
    
    [self closeDB];
    
    return  festivalArray;
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
#pragma mark - Friend Info Method
-(NSMutableArray *)getFriendList:(NSString *)FriendName
{
    if(![self openDB])
    {
        return 0;
    }

    NSMutableArray *friendArray=[[NSMutableArray alloc]init];
    NSArray *friendData=nil;
    
    
    FMResultSet *rs=[[FMResultSet alloc] init];
    if(FriendName!=nil && FriendName.length>0)
    {
        rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ like ‘%%%@%%’ order by %@,%@",TABLEFRIENDINFO,FRIENDNAME,FriendName,FRIENDBIRTHDAY,FRIENDID]];
    }
    else
    {
        rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ order by %@,%@",TABLEFRIENDINFO,FRIENDBIRTHDAY,FRIENDID]];
    }

    
    while ([rs next]) {
        friendData=[[NSArray alloc]  initWithObjects:[rs stringForColumn:FRIENDNAME],
                    [rs stringForColumn:FRIENDBIRTHDAY],
                    [rs stringForColumn:FRIENDCONSTELLATION],
                    nil];
        [friendArray addObject: friendData];
    }
        
    [self closeDB];
    
    return friendArray;
}

@end
