//
//  DbUtils.m
//  youli
//
//  Created by sjun on 2/27/13.
//
//

#import "DbUtils.h"

#define DB_NAME @"youli.sqlite"

static DbUtils *instance = nil;

@implementation DbUtils

- (id)init
{
    if ((self = [super init])){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DB_NAME];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:dbPath]==NO)
        {
            NSString *dbPathApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
            [fileManager copyItemAtPath:dbPathApp toPath:dbPath error:nil];
        }
        self.fmDatabase = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

+ (DbUtils *)getInstance{
    if (instance == nil)
    {
        instance = [[DbUtils alloc] init];
    }
    return instance;
}

@end
