//
//  BirthdayGift.h
//  youli
//
//  Created by ufida on 13-3-11.
//
//

#import <Foundation/Foundation.h>

@interface BirthdayGiftModel : NSObject

@property NSInteger giftid;
@property NSInteger gifttype;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,strong) NSString *imageurl;
@property (nonatomic,strong) NSString *taobaourl;
@property NSInteger price;


+ (BirthdayGiftModel *)getInstance;
+ (BirthdayGiftModel *)getGiftDetail:(NSInteger) GiftID;
+ (void)cleanGiftList;
+ (NSMutableArray *)getGiftDetailList:(NSInteger)PhotoType;
+ (NSInteger)getSelectedGiftIndex:(NSInteger)GiftID;

@end
