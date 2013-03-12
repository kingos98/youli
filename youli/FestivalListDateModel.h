//
//  FestivalListDateModel.h
//  youli
//
//  Created by ufida on 13-3-12.
//
//

#import <Foundation/Foundation.h>

@interface FestivalListDateModel : NSObject
@property NSInteger festivalID;
@property (nonatomic,strong) NSString *festivalName;
@property (nonatomic,strong) NSString *festivalDate;

+ (FestivalListDateModel *)getInstance;
+ (NSMutableArray *)getFeFestivalInfo:(NSString *)Sql;
+ (NSInteger)getMaxFestivalIDFromFestivalListDate;
+ (BOOL)checkIsExistFestivalIsYear:(NSInteger)SelectYear;
+ (NSMutableArray *)getFestivalList:(NSString *)FestivalName;
@end
