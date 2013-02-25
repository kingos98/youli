//
//  Friend.m
//  youli
//
//  Created by apple on 12/6/12.
//
//

#import "Friend.h"
#import "FMDatabase.h"

#define DB_NAME       @"youli.sqlite"

@implementation Friend

@synthesize items;
@synthesize name;
@synthesize birthdayDate;
@synthesize profileUrl;

-(Boolean)openDB
{    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DB_NAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbPath]==NO)
    {
        NSString *dbPathApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
        [fileManager copyItemAtPath:dbPathApp toPath:dbPath error:nil];
    }
    db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        return false;
    }
    return true;
}

- (void)loadData{
    
}

@end
