//
//  FestivalMethod.h
//  youli
//
//  Created by ufida on 13-1-23.
//
//

#import <Foundation/Foundation.h>

@interface FestivalMethod : NSObject

-(void)checkFestivalIsExist;
-(void)writeFestivalToDB:(NSInteger)Year;
-(NSMutableArray *)getTopSixFestivalList:(NSString *)FestivalName;
@end
