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
    FMDatabase *fmDatabase;
}

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *birthdayDate;
@property(nonatomic,strong)NSString *profileUrl;

+ (void)loadFriend:(void (^)(NSArray *friends, NSError *error))block;
+ (NSMutableArray *)findByIsAdd;
- (void)save;

@end
