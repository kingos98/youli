//
//  Friend.m
//  youli
//
//  Created by apple on 12/6/12.
//
//

#import "Friend.h"
#import "FMDatabase.h"

#define DB_NAME @"youli.sqlite"

@implementation Friend

@synthesize name;
@synthesize birthdayDate;
@synthesize profileUrl;

- (id)init
{
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DB_NAME];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:dbPath]==NO)
        {
            NSString *dbPathApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
            [fileManager copyItemAtPath:dbPathApp toPath:dbPath error:nil];
        }
        fmDatabase = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

- (NSMutableArray *)findAll{    
    NSMutableArray *friendArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [fmDatabase executeQuery:@"select * from %@ where =",@"dd"];
    while ([rs next]) {
        NSString *giftID = [rs stringForColumn:@"id"];
        NSString *giftType = [rs stringForColumn:@"id"];
        NSString *giftTitle = [rs stringForColumn:@"id"];
        NSString *giftDetail = [rs stringForColumn:@"id"];
        NSString *imageURL = [rs stringForColumn:@"id"];
        NSString *taobaoURL = [rs stringForColumn:@"id"];
        NSString *price = [rs stringForColumn:@"id"];
        NSArray *model = [[NSArray alloc]  initWithObjects:giftID,giftType,giftTitle,giftDetail,imageURL,taobaoURL, price,nil];
        [friendArray addObject: model];
    }
    return friendArray;
}

@end
