//
//  BirthdayGift.m
//  youli
//
//  Created by ufida on 13-3-11.
//
//

#define TABLEBIRTHDAYGIFT           @"birthdaygift"
#define TABLEBIRTHDAYGIFTFROMINDEX  @"birthdaygiftfromindex"
#define TABLECOLLECTBIRTHDAYGIFT    @"collectbirthdaygift"
#define TABLEFESTIVALLISTDATE       @"FestivalListDate"
#define TABLEFRIENDINFO             @"FriendInfo"

#define GIFTID                      @"giftid"
#define GIFTTYPE                    @"giftType"
#define GIFTTITLE                   @"Title"
#define GIFTDETAIL                  @"Detail"
#define GIFTIMAGEURL                @"imageURL"
#define GIFTTAOBAOURL               @"taobaoURL"
#define GIFTPRICE                   @"price"


#import "BirthdayGiftModel.h"
#import "FMResultSet.h"
#import "DbUtils.h"
#import "FMDatabaseOper.h"

static BirthdayGiftModel *instance=nil;

@implementation BirthdayGiftModel

@synthesize giftid;
@synthesize gifttype;
@synthesize title;
@synthesize detail;
@synthesize imageurl;
@synthesize taobaourl;
@synthesize price;

+ (BirthdayGiftModel *)getInstance{
    if (instance == nil)
    {
        instance = [[BirthdayGiftModel alloc] init];
    }
    return instance;
}


#pragma mark - Data Oper
-(void)AddPhotoInfoToDB:(NSInteger)PhotoID tmpPhotoTitle:(NSString *)tmpPhotoTitle photodetail:(NSString*)tmpPhotoDetail photourl:(NSString *)tmpPhotoURL Price:(NSInteger)GiftPrice TaobaoUrl:(NSString *)TaobaoUrl IsFromIndexPage:(bool) isFromIndex
{
    
    NSString *sql;
    if(isFromIndex)
    {
        sql= [NSString stringWithFormat:
              @"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@) VALUES (%d,%d,'%@','%@','%@','%@',%d)",
              TABLEBIRTHDAYGIFTFROMINDEX,GIFTID, GIFTTYPE, GIFTTITLE, GIFTDETAIL,GIFTIMAGEURL,GIFTTAOBAOURL,GIFTPRICE ,PhotoID,1,
              tmpPhotoTitle, tmpPhotoDetail,tmpPhotoURL,TaobaoUrl,GiftPrice];
    }
    else
    {
        sql= [NSString stringWithFormat:
              @"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@) VALUES (%d,%d,'%@','%@','%@','%@',%d)",
              TABLEBIRTHDAYGIFT,GIFTID, GIFTTYPE, GIFTTITLE, GIFTDETAIL,GIFTIMAGEURL,GIFTTAOBAOURL,GIFTPRICE ,PhotoID,1,
              tmpPhotoTitle, tmpPhotoDetail,tmpPhotoURL,TaobaoUrl,GiftPrice];
    }
    
    [DbUtils ExecSql:sql];
}

- (BirthdayGiftModel *)getGiftDetail:(NSInteger) GiftID IsFromIndexPage:(bool) isFromIndex
{
    if([DbUtils getInstance].fmDatabase.open)
    {
        NSString *strSql;
        if(isFromIndex)
        {
            strSql= [NSString stringWithFormat:@"select * from %@ where %@=%d",TABLEBIRTHDAYGIFTFROMINDEX,GIFTID,GiftID];
        
        }
        else
        {
            strSql= [NSString stringWithFormat:@"select * from %@ where %@=%d",TABLEBIRTHDAYGIFT,GIFTID,GiftID];
        }
        
        
        FMResultSet *rs=[[DbUtils getInstance].fmDatabase executeQuery:strSql];
        
        BirthdayGiftModel *birthdayGift=nil;
        while ([rs next]) {
            birthdayGift=[BirthdayGiftModel alloc];
            birthdayGift.giftid=[rs intForColumn:GIFTID];
            birthdayGift.gifttype=[rs intForColumn:GIFTTYPE];
            birthdayGift.title=[rs stringForColumn:GIFTTITLE];
            birthdayGift.detail=[rs stringForColumn:GIFTDETAIL];
            birthdayGift.imageurl=[rs stringForColumn:GIFTIMAGEURL];
            birthdayGift.taobaourl=[rs stringForColumn:GIFTTAOBAOURL];
            birthdayGift.price=[rs doubleForColumn:GIFTPRICE];
            
            break;
        }
        
        [[DbUtils getInstance].fmDatabase close];
        return birthdayGift;
    }
    else
    {
        return nil;
    }
}

//每次启动该APP就自动清空birthday list
- (void)cleanGiftList:(bool) isFromIndex
{
    NSString *strSql;
    if (isFromIndex)
    {
        strSql=[NSString stringWithFormat:@"delete from %@",TABLEBIRTHDAYGIFTFROMINDEX];
    }
    else
    {
        strSql=[NSString stringWithFormat:@"delete from %@",TABLEBIRTHDAYGIFT];
    }
    [DbUtils ExecSql:strSql];
}

//获取礼物信息列表
- (NSMutableArray *)getGiftDetailList:(NSInteger)PhotoType IsFromIndexPage:(bool) isFromIndex
{
    if(![DbUtils getInstance].fmDatabase.open)
    {
        return nil;
    }
    
    NSMutableArray *GiftArray=[[NSMutableArray alloc] init];

    NSString *strSql;
    if(isFromIndex)
    {
        strSql=[NSString stringWithFormat:@"select * from %@ where %@=%d",TABLEBIRTHDAYGIFTFROMINDEX,GIFTTYPE,PhotoType];
    }
    else
    {
        strSql=[NSString stringWithFormat:@"select * from %@ where %@=%d",TABLEBIRTHDAYGIFT,GIFTTYPE,PhotoType];
    }

    
    FMResultSet *rs=[[DbUtils getInstance].fmDatabase executeQuery:strSql];

    while ([rs next]) {
        BirthdayGiftModel *birthdayGift=[BirthdayGiftModel alloc];
        birthdayGift.giftid=[rs intForColumn:GIFTID];
        birthdayGift.gifttype=[rs intForColumn:GIFTTYPE];
        birthdayGift.title=[rs stringForColumn:GIFTTITLE];
        birthdayGift.detail=[rs stringForColumn:GIFTDETAIL];
        birthdayGift.imageurl=[rs stringForColumn:GIFTIMAGEURL];
        birthdayGift.taobaourl=[rs stringForColumn:GIFTTAOBAOURL];
        birthdayGift.price=[rs doubleForColumn:GIFTPRICE];
        
        [GiftArray addObject: birthdayGift];
    }
    
    [[DbUtils getInstance].fmDatabase close];
    
    if(GiftArray.count>0)
        return  GiftArray;
    else
        return  nil;
}

//获取当前选中的礼物所在位置
- (NSInteger)getSelectedGiftIndex:(NSInteger)GiftID IsFromIndexPage:(bool) isFromIndex
{
    if(![[DbUtils getInstance].fmDatabase open])
    {
        return 0;
    }
    
    NSInteger index=0;
    
    FMResultSet *rs;
    if(isFromIndex)
    {
        rs=[[DbUtils getInstance].fmDatabase executeQuery:[NSString stringWithFormat: @"select %@ from %@",GIFTID,TABLEBIRTHDAYGIFTFROMINDEX]];
    }
    else
    {
        rs=[[DbUtils getInstance].fmDatabase executeQuery:[NSString stringWithFormat: @"select %@ from %@",GIFTID,TABLEBIRTHDAYGIFT]];
    }
    
    while ([rs next]) {
        if([rs intForColumn:GIFTID]==GiftID)
        {
            break;
        }
        else
        {
            index++;
        }
    }
    [[DbUtils getInstance].fmDatabase open];
    
    return index;
}

@end
