//
//  CollectBirthdayGiftModel.m
//  youli
//
//  Created by ufida on 13-3-11.
//
//
#define TABLECOLLECTBIRTHDAYGIFT    @"collectbirthdaygift"
#define GIFTID                      @"giftid"

#import "CollectBirthdayGiftModel.h"
#import "DbUtils.h"

static CollectBirthdayGiftModel *instance=nil;

@implementation CollectBirthdayGiftModel

@synthesize giftid;
@synthesize gifttype;

+ (CollectBirthdayGiftModel *)getInstance{
    if (instance == nil)
    {
        instance = [[CollectBirthdayGiftModel alloc] init];
    }
    return instance;
}


//决断该礼物是否被收藏
+(Boolean)checkIsCollect:(NSInteger)GiftID
{
    if(![[DbUtils getInstance].fmDatabase open])
    {
        return false;
    }
    
    Boolean find=false;
    NSString *strSql=[NSString stringWithFormat:@"select count(*) count from %@ where %@=%d",TABLECOLLECTBIRTHDAYGIFT,GIFTID,GiftID];
    FMResultSet *rs=[[DbUtils getInstance].fmDatabase executeQuery:strSql];
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
+(void)operGiftToCollection:(Boolean)IsAdd GiftID:(NSInteger)GiftID
{
    NSString *strSql;
    if(IsAdd)
    {
        strSql=[NSString stringWithFormat:@"insert into %@(%@) values(%d)",TABLECOLLECTBIRTHDAYGIFT,GIFTID,GiftID];
    }
    else
    {
        strSql=[NSString stringWithFormat:@"delete from %@ where %@=%d",TABLECOLLECTBIRTHDAYGIFT,GIFTID,GiftID];
    }
    [DbUtils ExecSql:strSql];
}

@end
