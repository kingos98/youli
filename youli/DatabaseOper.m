//
//  DatabaseOper.m
//  youli
//
//  Created by ufida on 12-12-28.
//
//

#define DBNAME      @"youli.sqlite"

#import "DatabaseOper.h"


@implementation DatabaseOper

@synthesize db;


-(BOOL)OpenDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *database_path = [[[NSBundle mainBundle] resourcePath]
                               stringByAppendingPathComponent:DBNAME];
    
    NSLog(database_path);
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
}

-(void)ExecSql:(NSString *)sql
{
    
    if(![self OpenDB])
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
    
    [self CloseDB];
}

-(void)CloseDB
{
    if (sqlite3_close(db) != SQLITE_OK)
    {
        NSLog(@"Failed to close database, normally error handling here.");
    }}
@end
