//
//  Friend.h
//  youli
//
//  Created by apple on 12/6/12.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Friend : NSObject{
    FMDatabase *db;
}

@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *birthdayDate;
@property(nonatomic,retain)NSString *profileUrl;

- (void)loadData;

@end
