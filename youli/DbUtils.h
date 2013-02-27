//
//  DbUtils.h
//  youli
//
//  Created by sjun on 2/27/13.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DbUtils : NSObject

@property(nonatomic,strong)FMDatabase *fmDatabase;

+ (DbUtils *)getInstance;

@end
