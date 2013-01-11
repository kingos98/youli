//
//  DatabaseOper.m
//  youli
//
//  Created by ufida on 12-12-28.
//
//

#define DBNAME      @"youli.sqlite"

#import "DatabaseOper.h"
#import "BirthdayGiftDetailItem.h"

@implementation DatabaseOper

@synthesize db;


-(BOOL)openDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *database_path = [[[NSBundle mainBundle] resourcePath]
                               stringByAppendingPathComponent:DBNAME];
    
//    NSLog(database_path); 
    BOOL success = [fileManager fileExistsAtPath:database_path];
    
    if (!success)
    {
        NSLog(@"Failed to find database file '%@'.", database_path);
        return false;
    }
    
    if (!(sqlite3_open([database_path UTF8String], &db) == SQLITE_OK))
    {
        NSLog(@"An error opening database, normally handle error here.");
        return false;
    }
    return true;
}

-(void)ExecSql:(NSString *)sql
{
    
    if(![self openDB])
    {
        return;
    }
    
    sqlite3_stmt *addStmt = nil;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &addStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error, failed to prepare statement, normally handle error here.");
    }
    
    sqlite3_bind_int(addStmt, 1, 10);
    sqlite3_step(addStmt);
    if(sqlite3_finalize(addStmt) != SQLITE_OK)
    {
        NSLog(@"Failed to finalize  data statement, normally error handling here.");
    }
    
    [self closeDB];
}


-(NSArray *)getGiftDetail:(NSInteger) GiftID
{
    if(![self openDB])
    {
        return nil;
    }

    NSArray *GiftArray=nil;
    
    NSString *strSql= [NSString stringWithFormat:@"select * from birthdaygift where giftid=%d",GiftID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [strSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            char *giftID = (char *) sqlite3_column_text(statement, 0);
            NSString *strGiftID = [[NSString alloc] initWithUTF8String: giftID];
            
            char *giftType = (char *) sqlite3_column_text(statement, 1);
            NSString *strGiftType = [[NSString alloc] initWithUTF8String: giftType];
            
            char *giftTitle = (char *) sqlite3_column_text(statement, 2);
            NSString *strGiftTitle = [[NSString alloc] initWithUTF8String: giftTitle];
            
            char *giftDetail = (char *) sqlite3_column_text(statement, 3);
            NSString *strGiftDetail = [[NSString alloc] initWithUTF8String: giftDetail];
            
            char *imageURL= (char *) sqlite3_column_text(statement, 4);
            NSString *strImageURL = [[NSString alloc] initWithUTF8String: imageURL];
            
            char *taobaoURL= (char *) sqlite3_column_text(statement, 5);
            NSString *strTaobaoURL = [[NSString alloc] initWithUTF8String: taobaoURL];
            
            char *price= (char *) sqlite3_column_text(statement, 6);
            NSString *strPrice = [[NSString alloc] initWithUTF8String: price];
            
            GiftArray=[[NSArray alloc]  initWithObjects:strGiftID,strGiftType,strGiftTitle,strGiftDetail,strImageURL,strTaobaoURL, strPrice,nil];
        }
    }
    
    [self closeDB];
    
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
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(db, [strSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            char *giftID = (char *) sqlite3_column_text(statement, 0);
            NSString *strGiftID = [[NSString alloc] initWithUTF8String: giftID];
            
            char *giftType = (char *) sqlite3_column_text(statement, 1);
            NSString *strGiftType = [[NSString alloc] initWithUTF8String: giftType];
            
            char *giftTitle = (char *) sqlite3_column_text(statement, 2);
            NSString *strGiftTitle = [[NSString alloc] initWithUTF8String: giftTitle];
            
            char *giftDetail = (char *) sqlite3_column_text(statement, 3);
            NSString *strGiftDetail = [[NSString alloc] initWithUTF8String: giftDetail];
            
            char *imageURL= (char *) sqlite3_column_text(statement, 4);
            NSString *strImageURL = [[NSString alloc] initWithUTF8String: imageURL];

            char *taobaoURL= (char *) sqlite3_column_text(statement, 5);
            NSString *strTaobaoURL = [[NSString alloc] initWithUTF8String: taobaoURL];
            
            char *price= (char *) sqlite3_column_text(statement, 6);
            NSString *strPrice = [[NSString alloc] initWithUTF8String: price];
            
            GiftData=[[NSArray alloc]  initWithObjects:strGiftID,strGiftType,strGiftTitle,strGiftDetail,strImageURL,strTaobaoURL, strPrice,nil];
            
            [GiftArray addObject: GiftData];
        }
    }
    
    [self closeDB];
    
    return GiftArray;
}

-(void)closeDB
{
    if (sqlite3_close(db) != SQLITE_OK)
    {
        NSLog(@"Failed to close database, normally error handling here.");
    }
}
@end
