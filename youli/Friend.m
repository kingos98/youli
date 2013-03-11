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
#import "AFJSONRequestOperation.h"
#import "AFWeiboAPIClient.h"
#import "Account.h"

@implementation Friend

@synthesize name;
@synthesize birthdayDate;
@synthesize profileUrl;

+ (void)loadFriend:(void (^)(NSArray *friends, NSError *error))block {
    NSString *URL = @"friendships/friends/bilateral.json";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[Account getInstance].userID, @"uid",[Account getInstance].accessToken, @"access_token", nil];
    [[AFWeiboAPIClient getInstance] getPath:URL parameters:param success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary *usersDict = [JSON objectForKey:@"users"];
        NSMutableArray *mutableFriend = [NSMutableArray arrayWithCapacity:[usersDict count]];
        for (NSDictionary *user in usersDict) {
            Friend *friend = [Friend alloc];
            friend.name = [user objectForKey:@"screen_name"];
            friend.profileUrl = [user objectForKey:@"profile_image_url"];
            [mutableFriend addObject:friend];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableFriend], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

+ (NSMutableArray *)findByIsAdd{
    NSMutableArray *friendArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [[DbUtils getInstance].fmDatabase executeQuery:@"select * from %@ where =",@"dd"];
    while ([rs next]) {
        Friend *friend = [Friend alloc];
        friend.name = [rs stringForColumn:@"id"];;
        friend.profileUrl = [rs stringForColumn:@"id"];;
        [friendArray addObject: friend];
    }
    return friendArray;
}

- (void)save{
    [[DbUtils getInstance].fmDatabase executeUpdate:@"insert into %@(%@) values(%d)"];
}

@end
