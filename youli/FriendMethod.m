//
//  FriendMethod.m
//  youli
//
//  Created by ufida on 13-1-31.
//
//

#import "FriendMethod.h"
#import "FMDatabaseOper.h"

@implementation FriendMethod

-(NSMutableArray *)getFriendList:(NSString *)FriendName
{
    NSMutableArray *friendBirthdayArray=[[NSMutableArray alloc]init];
    
    FMDatabaseOper *dbOper=[[FMDatabaseOper alloc]init];
    NSMutableArray *friendInDBArray=[dbOper getFriendList:FriendName];
    
    if(friendInDBArray.count>0)
    {
        NSCalendar *calendar=[NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *comp=[calendar components:unitFlags fromDate:[NSDate date]];
        
        NSArray *singleFriendInfo=nil;
        
        for (int i=0; i<friendInDBArray.count; i++) {
            singleFriendInfo=[[NSArray alloc] initWithObjects:[[friendInDBArray objectAtIndex:i]objectAtIndex:0],
                              [NSString stringWithFormat:@"%d%@",comp.year,[[friendInDBArray objectAtIndex:i]objectAtIndex:1]],
                              [[friendInDBArray objectAtIndex:i]objectAtIndex:2],
                              nil];
            [friendBirthdayArray addObject:singleFriendInfo];
        }
        
        for (int i=0; i<friendInDBArray.count; i++) {
            singleFriendInfo=[[NSArray alloc] initWithObjects:
                              [[friendInDBArray objectAtIndex:i]objectAtIndex:0],
                              [NSString stringWithFormat:@"%d%@",comp.year+1,[[friendInDBArray objectAtIndex:i]objectAtIndex:1]],
                              [[friendInDBArray objectAtIndex:i]objectAtIndex:2],
                              nil];
            [friendBirthdayArray addObject:singleFriendInfo];
        }
    }
    

    if(friendBirthdayArray.count>0)
    {
        NSCalendar *calendar=[NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *comp=[calendar components:unitFlags fromDate:[NSDate date]];
        NSString *strCurrentDate=[NSString stringWithFormat:@"%d%@%@",comp.year,[self updateDateFormat:comp.month],[self updateDateFormat:comp.day]];
    
        while (friendBirthdayArray.count>0) {
            if([[[friendBirthdayArray objectAtIndex:0]objectAtIndex:1] intValue]<[strCurrentDate intValue])
            {
                [friendBirthdayArray removeObjectAtIndex:0];
            }
            else
            {
                break;
            }
        }
    }
    return friendBirthdayArray;
}

-(NSString *)updateDateFormat:(NSInteger)MonthOrDay
{
    NSString *strMonthOrDay=[NSString stringWithFormat:@"%d",MonthOrDay];
    if(strMonthOrDay.length==1)
    {
        return [NSString stringWithFormat:@"0%@",strMonthOrDay];
    }
    else
    {
        return strMonthOrDay;
    }
}
@end
