//
//  FMDatabaseOper.h
//  youli
//
//  Created by ufida on 13-1-11.
//
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

@interface FMDatabaseOper : NSObject
{
    FMDatabase *db;
}


-(void)ExecSql:(NSString *)sql;
-(NSArray *)getGiftDetail:(NSInteger) PhotoID;
-(NSMutableArray *)getGiftDetailList:(NSInteger)PhotoType;
@end
