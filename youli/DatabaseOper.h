//
//  DatabaseOper.h
//  youli
//
//  Created by ufida on 12-12-28.
//
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseOper : NSObject

@property sqlite3 *db;

-(void)ExecSql:(NSString *)sql;
-(NSArray *)getGiftDetail:(NSInteger) PhotoID;
-(NSMutableArray *)getGiftDetailList:(NSInteger)PhotoType;
@end
