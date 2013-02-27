//
//  Friend.m
//  youli
//
//  Created by apple on 12/6/12.
//
//

#import "Friend.h"
#import "FMDatabase.h"
#import "DbUtils.h"

@implementation Friend

@synthesize name;
@synthesize birthdayDate;
@synthesize profileUrl;

- (NSMutableArray *)findAll{    
    NSMutableArray *friendArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [[DbUtils getInstance].fmDatabase executeQuery:@"select * from %@ where =",@"dd"];
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
