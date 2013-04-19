//
//  FriendMethod.m
//  youli
//
//  Created by ufida on 13-1-31.
//
//

#import "FriendMethod.h"
#import "FMDatabaseOper.h"
#import "Friend.h"

@implementation FriendMethod

-(NSMutableArray *)getFriendList:(NSString *)FriendName
{
    NSMutableArray *friendBirthdayArray=[[NSMutableArray alloc]init];
    
    FMDatabaseOper *dbOper=[[FMDatabaseOper alloc]init];
    NSMutableArray *friendInDBArray=[dbOper getFriendList:FriendName];
    
    Friend *friend;

    if(friendInDBArray.count>0)
    {
        NSCalendar *calendar=[NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *comp=[calendar components:unitFlags fromDate:[NSDate date]];
        
//        NSArray *singleFriendInfo=nil;
        
        for (int i=0; i<friendInDBArray.count; i++) {
            friend=[Friend alloc];
            
//            singleFriendInfo=[[NSArray alloc] initWithObjects:[[friendInDBArray objectAtIndex:i]objectAtIndex:0],
//                              [NSString stringWithFormat:@"%d%@",comp.year,[[friendInDBArray objectAtIndex:i]objectAtIndex:1]],
//                              [[friendInDBArray objectAtIndex:i]objectAtIndex:2],
//                              nil];
            friend.name=[[friendInDBArray objectAtIndex:i]objectAtIndex:0];
            friend.birthdayDate=[NSString stringWithFormat:@"%d%@",comp.year,[[friendInDBArray objectAtIndex:i]objectAtIndex:1]];
            friend.constellation=[[friendInDBArray objectAtIndex:i]objectAtIndex:2];
            
            [friendBirthdayArray addObject:friend];
        }
        
        for (int i=0; i<friendInDBArray.count; i++) {
//            singleFriendInfo=[[NSArray alloc] initWithObjects:
//                              [[friendInDBArray objectAtIndex:i]objectAtIndex:0],
//                              [NSString stringWithFormat:@"%d%@",comp.year+1,[[friendInDBArray objectAtIndex:i]objectAtIndex:1]],
//                              [[friendInDBArray objectAtIndex:i]objectAtIndex:2],
//                              nil];
//            [friendBirthdayArray addObject:singleFriendInfo];
        
            friend.name=[[friendInDBArray objectAtIndex:i]objectAtIndex:0];
            friend.birthdayDate=[NSString stringWithFormat:@"%d%@",comp.year+1,[[friendInDBArray objectAtIndex:i]objectAtIndex:1]];
            friend.constellation=[[friendInDBArray objectAtIndex:i]objectAtIndex:2];
            
            [friendBirthdayArray addObject:friend];
        }
    }
    
    if(friendBirthdayArray.count>0)
    {
        NSCalendar *calendar=[NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *comp=[calendar components:unitFlags fromDate:[NSDate date]];
        NSString *strCurrentDate=[NSString stringWithFormat:@"%d%@%@",comp.year,[self updateDateFormat:comp.month],[self updateDateFormat:comp.day]];
    
        while (friendBirthdayArray.count>0) {
//            if([[[friendBirthdayArray objectAtIndex:0]objectAtIndex:1] intValue]<[strCurrentDate intValue])
            friend=(Friend *)[friendBirthdayArray  objectAtIndex:0];

            if([friend.birthdayDate intValue]<[strCurrentDate intValue])
            {
                [friendBirthdayArray removeObjectAtIndex:0];
            }
            else
            {
                break;
            }
        }
    }
    
//    NSLog(@"friendBirthdayArray count : %d",friendBirthdayArray.count);
    
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
