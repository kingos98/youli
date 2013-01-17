//
//  FMDatabaseOper.m
//  youli
//
//  Created by ufida on 13-1-11.
//
//

#define DBNAME      @"youli.sqlite"


#import "FMDatabaseOper.h"
#import "FMDatabase.h"
@implementation FMDatabaseOper

-(Boolean)openDB
{
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:DBNAME];
    
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

-(NSArray *)getGiftDetail:(NSInteger) GiftID
{
    if(![self openDB])
    {
        return nil;
    }
    
    NSArray *GiftArray=nil;
    
    NSString *strSql= [NSString stringWithFormat:@"select * from birthdaygift where giftid=%d",GiftID];

    FMResultSet *rs = [db executeQuery:strSql];

    while ([rs next]) {
        int giftID=[rs intForColumn:@"giftID"];
        int giftType=[rs intForColumn:@"giftType"];
        NSString *giftTitle=[rs stringForColumn:@"giftTitle"];
        NSString *giftDetail=[rs stringForColumn:@"giftDetail"];
        NSString *imageURL=[rs stringForColumn:@"imageURL"];
        NSString *taobaoURL=[rs stringForColumn:@"taobaoURL"];
        double price=[rs doubleForColumn:@"price"];
         
        GiftArray=[[NSArray alloc]  initWithObjects:giftID,giftType,giftTitle,giftDetail,imageURL,taobaoURL, price,nil];
    }
    return GiftArray;
}

#pragma mark - BirthdayGiftMothed

//每次启动该APP就自动清空birthday list
-(void)cleanGiftList
{
    NSString *strSql=@"delete from birthdaygift";
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
    
    NSString *strSql= [NSString stringWithFormat:@"select * from birthdaygift where gifttype=%d",PhotoType];

    FMResultSet *rs=[db executeQuery:strSql];

    while ([rs next]) {
        NSString *giftID=[rs stringForColumn:@"giftid"];
        NSString *giftType=[rs stringForColumn:@"gifttype"];
        NSString *giftTitle=[rs stringForColumn:@"title"];
        NSString *giftDetail=[rs stringForColumn:@"detail"];
        NSString *imageURL=[rs stringForColumn:@"imageurl"];
        NSString *taobaoURL=[rs stringForColumn:@"taobaourl"];
        NSString *price=[rs stringForColumn:@"price"];

        GiftData=[[NSArray alloc]  initWithObjects:giftID,giftType,giftTitle,giftDetail,imageURL,taobaoURL, price,nil];

        [GiftArray addObject: GiftData];
    }
    
    [db close];
    return  GiftArray;
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
    FMResultSet *rs=[db executeQuery:@"select giftid from birthdaygift"];
    while ([rs next]) {
//        NSLog(@"dbgiftid:%d,giftid:%d",[rs intForColumn:@"giftid"],GiftID);
        if([rs intForColumn:@"giftid"]==GiftID)
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
    

    if(!find)
    {
        index=0;
    }
    
    return index;
}


//决断该礼物是否被收藏
-(Boolean)checkIsCollect:(NSInteger)GiftID
{
    Boolean find=false;
    NSString *strSql=[NSString stringWithFormat:@"select count(*) count from collectbirthdaygift where giftid=%d",GiftID];
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
        strSql=[NSString stringWithFormat:@"insert into collectbirthdaygift(giftid) values(%d)",GiftID];
    }
    else
    {
        strSql=[NSString stringWithFormat:@"delete from collectbirthdaygift where giftid=%d",GiftID];
    }
    [self ExecSql:strSql];
}


@end
