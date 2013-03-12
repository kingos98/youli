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

@property NSInteger friendID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *birthdayDate;
@property(nonatomic,strong)NSString *constellation;
@property(nonatomic,strong)NSString *localImageUrl;
@property(nonatomic,strong)NSString *profileUrl;
@property NSInteger type;
@property BOOL isAdd;

+ (void)loadFriend:(void (^)(NSArray *friends, NSError *error))block;
+ (NSMutableArray *)findByIsAdd;
- (void)save;

@end
