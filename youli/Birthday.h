//
//  Birthday.h
//  youli
//
//  Created by ufida on 12-11-6.
//
//

#import <Foundation/Foundation.h>

@interface Birthday : NSObject

@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *date;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *countDown;
@property(nonatomic,retain)NSString *constellation;
-(void)setBirthdayNotifications;
-(void)loadData:(NSString *)SearchName;

@end
