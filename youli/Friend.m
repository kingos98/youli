//
//  Friend.m
//  youli
//
//  Created by apple on 12/6/12.
//
//

#define TABLEFRIENDINFO             @"FriendInfo"

#import "Friend.h"
#import "FMDatabase.h"
#import "DbUtils.h"
#import "AFJSONRequestOperation.h"
#import "AFWeiboAPIClient.h"
#import "Account.h"

@implementation Friend

@synthesize friendID;
@synthesize webId;
@synthesize name;
@synthesize birthdayDate;
@synthesize constellation;
@synthesize localImageUrl;
@synthesize profileUrl;
@synthesize type;
@synthesize isAdd;
@synthesize lastUpdateTime;

static Friend *instance=nil;

+ (Friend *)getInstance{
    if (instance == nil)
    {
        instance = [[Friend alloc] init];
    }
    return instance;
}

- (void)loadFriend:(void (^)(NSArray *friends, NSError *error))block {
    NSString *URL = @"friendships/friends/bilateral.json";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [Account getInstance].userID, @"uid",
                           [Account getInstance].accessToken, @"access_token",
                           nil];
    [[AFWeiboAPIClient getInstance] getPath:URL parameters:param success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary *usersDict = [JSON objectForKey:@"users"];
        NSMutableArray *mutableFriend = [NSMutableArray arrayWithCapacity:[usersDict count]];
        
        for (NSDictionary *user in usersDict) {
            Friend *friend = [Friend alloc];
            friend.webId=[user objectForKey:@"id"];
            friend.name = [user objectForKey:@"screen_name"];
            friend.profileUrl = [user objectForKey:@"profile_image_url"];
            
            [mutableFriend addObject:friend];
            
            [self checkIsAdd:friend];
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

- (NSMutableArray *)findByIsAdd{
    if(![[DbUtils getInstance].fmDatabase open])
    {
        return nil;
    }
    
    NSMutableArray *friendArray = [[NSMutableArray alloc] init];

    NSString *strSql=[NSString stringWithFormat:@"select * from %@ where isAdd=true",TABLEFRIENDINFO];
    FMResultSet *rs=[[DbUtils getInstance].fmDatabase executeQuery:strSql];
    while ([rs next]) {
        Friend *friend = [Friend alloc];
        friend.friendID=[rs intForColumn:@"friendID"];
        friend.webId=[rs stringForColumn:@"webId"];
        friend.name = [rs stringForColumn:@"name"];;
        friend.birthdayDate=[rs stringForColumn:@"birthdayDate"];
        friend.constellation=[rs stringForColumn:@"constellation"];
        friend.localImageUrl=[rs stringForColumn:@"localImageUrl"];
        friend.profileUrl = [rs stringForColumn:@"profileUrl"];;
        friend.type=[rs intForColumn:@"type"];
        friend.isAdd=[rs boolForColumn:@"isAdd"];
        friend.lastUpdateTime=[rs dateForColumn:@"lastUpdateTime"];
        [friendArray addObject: friend];
    }
    return friendArray;
}

//决断是否已经添加该朋友
-(void)checkIsAdd:(Friend *)friend
{
    Boolean find=false;
    NSString *strSql=[NSString stringWithFormat:@"select count(*) count from %@ where webid=%@",TABLEFRIENDINFO,friend.webId];
    FMResultSet *rs=[[DbUtils getInstance].fmDatabase executeQuery:strSql];
    while ([rs next]) {
        if([rs intForColumn:@"count"]>0)
        {
            find=true;
            break;
        }
    }
    
    if(find)
    {
        [self updateFriend:friend];
    }
    else
    {
        [self addFriend:friend];
    }
    
}

-(void)updateFriend:(Friend *)friend
{
    NSString *strSql=[NSString stringWithFormat:@"update %@ set name=%@,lastUpdateTime=date('now') where webId=%@",
                      TABLEFRIENDINFO,
                      friend.name,
                      friend.webId];
    
    [[DbUtils getInstance].fmDatabase executeUpdate:strSql];    
}

- (void)addFriend:(Friend *)friend
{
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    NSString *strSql;    
    strSql= [NSString stringWithFormat:
             @"INSERT INTO %@ (name,birthdayDate,constellation,localImageUrl,profileUrl,type,isAdd,webId,lastUpdateTime) VALUES ('%@','%@','%@','%@','%@',%d,%d,%@,'%@')",
             TABLEFRIENDINFO,
             friend.name,
             friend.birthdayDate==NULL?@" ":friend.birthdayDate,
             friend.constellation==NULL?@" ":friend.constellation,
             friend.profileUrl,
             friend.profileUrl,
             friend.type,
             0,
             friend.webId,
             currentDate];

    
    NSLog(@"strSql:%@",strSql);
    
    [DbUtils ExecSql:strSql];
}

-(NSInteger)getMaxFriendID
{
    NSInteger maxFriendID;
    NSString *strSql=@"select friendid from FriendInfo order by friendid desc LIMIT 1";
    FMResultSet *rs=[[DbUtils getInstance].fmDatabase executeQuery:strSql];
    while ([rs next])
    {
        maxFriendID=[rs intForColumn:@"friendid"];
    }
    return maxFriendID;
}

@end
