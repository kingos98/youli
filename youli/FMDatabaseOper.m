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


-(Boolean)closeDB
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

-(NSMutableArray *)getGiftDetailList:(NSInteger)PhotoType
{
    if(![self openDB])
    {
        return nil;
    }
    
    NSMutableArray *GiftArray=[[NSMutableArray alloc] init];
    NSArray *GiftData=nil;
    
    NSString *strSql= [NSString stringWithFormat:@"select * from birthdaygift where gifttype=1"];

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

@end
